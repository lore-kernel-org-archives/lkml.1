Return-Path: <linux-kernel-owner+w=401wt.eu-S1754421AbZDZGyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421AbZDZGyY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 02:54:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752219AbZDZGyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 02:54:15 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:13178 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117AbZDZGyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 02:54:14 -0400
Date: Sun, 26 Apr 2009 08:54:01 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Kay Sievers <kay.sievers@vrfy.org>,
       Michael E Brown <Michael_E_Brown@dell.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: Class device namespaces
Message-ID: <20090426085401.3788fc9c@hyperion.delvare>
In-Reply-To: <ac3eb2510903300424s2604d027h653a3f77163e0242@mail.gmail.com>
References: <20090329174836.6de797d6@hyperion.delvare>
 <ac3eb2510903290936tc80e904o2266108bd6c04cf2@mail.gmail.com>
 <20090330104952.26f03c13@hyperion.delvare>
 <ac3eb2510903300424s2604d027h653a3f77163e0242@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kay,

Sorry, completely overlooked your reply... Ah, now I remember, I was
waiting for Michael to show up and comment on this. Michael, ping? As
long as we don't know the exact requirements and constraints of the
dell firmware tool, we're somewhat stuck.

Matt, maybe you can help? Could you please point us to the source code
of the dell firmware tool which relies on the dell_rbu driver?

On Mon, 30 Mar 2009 13:24:59 +0200, Kay Sievers wrote:
> On Mon, Mar 30, 2009 at 10:49, Jean Delvare <khali@linux-fr.org> wrote:
> > No, there's a single firmware request which collides with an i2c-dev
> > class device name. The firmware request happens to use the parent
> > device's name as its class device name, and it happens that both the
> > i2c-adapter class and the i2c-dev class name their class devices the
> > same way (which makes sense as they refer to the same thing,
> > i2c-adapter for the kernel-space access and i2c-dev for the user-space
> > access), and the latter is a child of the former. So when an
> > i2c-adapter class device is used as the parent for a firmware request,
> > and the i2c-dev driver is loaded, you get a collision.
> 
> Ah, I see. If you have a single firmware request, how about using the
> bus parent device of your i2c device to request the file, instead of
> the class parent device? Then you should get the glue directory, and
> all should work.

I did propose this already. I received the objection that some devices
were USB and some were PCI and some were neither. I don't think this is
really a problem, the i2c adapter should have a valid parent either way.

So I do think this is a valid workaround, although not trivial: all
affected drivers must be investigated and fixed individually.

> If that does not work for some reason, we can make the firmware class
> to add the "firmware-%s" prefix, like your patch did, only if the
> parent is a class device, not a bus device. That should prevent the
> breakage of tools making these wrong assumptions.

Given that the dell firmware device is a platform device, yes, that
would work around the breakage. This approach is quite hackish though,
adding an inconsistency.

> > Now that we have a use case which would justify that a class device
> > child of another class device gets its own namespace, is there a chance
> > to see it happen?
> 
> Maybe we could do that, and do it only in the case of a class device
> uses a class device of a different class as a parent. We need to make
> sure, that we don't insert "block" between the disk and the partition,
> and the like. It would be kind of inconsistent though, because we

Ah, yeah, I didn't have that case in mind at first. Glad I asked you
for your opinion :)

> don't do the same thing for any bus devices.

Well, we already have an exception for the case where the parent is a
bus device and the child is a class device. Extending it to the case
where the parent and child are class devices of different classes
doesn't sound too illogical to me. I think this approach has my
preference. Could you please propose a patch doing this? You are way
more familiar with the driver core code than I am, so I'm sure you'll
be much quicker than me to implement this.

> It's very uncommon that class devices want to parent with a class
> device of a different class. In most cases, the parent device class
> should be converted to a bus, and also use proper device binding
> logic. If device binding is not needed, then one of the classes may be
> just not needed. Having inter-dependencies between different classes
> of the same subsystem, and use each other as a parent sounds rather
> strange to me, and I would need to be convinced, that the driver core
> would need to work around such issues, and not the subsystem itself.
> :)

For i2c-dev it seems to be the right thing to do, as the i2c-dev class
device is an extension of the underlying i2c-adapter class device. You
can't have an i2c-dev without its i2c-adapter, so it seems OK that the
former is a child of the latter.

The i2c-adapter class device implements kernel-space access to an I2C
bus. The i2c-dev class device adds user-space access to the same I2C
bus. I have been thinking of a way to clean this up, but as far as I
can see we would have to merge i2c-dev into i2c-adapter, that is, make
user-space access support mandatory while it is optional today. While
i2c-dev isn't too big, I'm still not sure if everyone will enjoy this.
If anyone has an idea how to improve the situation, I'm all ears. But
anyway, this isn't going to happen quickly, and I still believe we
should solve the namespace problem I reported.

For firmware, it doesn't seem as legitimate, I can't really think of a
good reason to use the i2c-adapter as the parent for the firmware
device.

-- 
Jean Delvare
