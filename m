Return-Path: <linux-kernel-owner+w=401wt.eu-S1755215AbZEITHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215AbZEITHy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 15:07:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752367AbZEITHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 15:07:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:42270 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921AbZEITHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 15:07:45 -0400
Date: Sat, 9 May 2009 12:09:39 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Greg KH <gregkh@suse.de>
Cc: Fabio Comolli <fabio.comolli@gmail.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 00/13] devtmpfs patches
Message-ID: <20090509120939.553b81cc@infradead.org>
In-Reply-To: <20090509161923.GA942@suse.de>
References: <20090509143742.GA27663@kroah.com>
	<b637ec0b0905090810t188e39e3w92d9f4eff04011f1@mail.gmail.com>
	<20090509150853.GA32394@suse.de>
	<20090509082233.32cbb8e4@infradead.org>
	<20090509161923.GA942@suse.de>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 May 2009 09:19:23 -0700
Greg KH <gregkh@suse.de> wrote:

 
> I have bootchart graphics somewhere around here that also shows this.
> 
> > The only argument I've heard is "oh but it's hard". No it's not.
> 
> No, it's not "hard", it's just reality :)

it's not hard indeed. 

> 
> > The other argument is "but for more partitions we get other device
> > numbers"... you know what, that's easy to fix. Just make the 32 bit
> > dev number consistent. Few lines of code I bet, and it is benefit
> > for everyone to do that....
> 
> Huh?  We need to be able to support large number of partitions at boot
> time. 

yes and ? Of course we do. I fail to see the problem you're trying to
point out.

> We also need to support an initrd, and not a static /dev/ tree

sure. Your /dev tree has 2 parts; a part that IS static if you want to
or not (and this includes /dev/null, /dev/sda2 etc) and there is a
dynamic component. Udev is cheap if you prepopulate the part with
preassigned numbers. Really. We do it. 
udev *is* expensive if you configure it to do the parts that exposes
uuids in /dev as files as well as labels. Don't do that. But your scheme
doesn't change that so it's an invariant. 
(if you insist on having that it'd be not that hard to have udev first
put down the dynamic part of the device nodes that you're complaining
about and in a second, asynchronous step, do the label thing).


> at boot time, as that is what the world requires from a flexible Linux
> distro that runs on multiple types of hardware configurations.

I'm not arguing against that. Just like the same flexible linux distro
detects that it doesn't need an initramfs and skips that to avoid that
penalty.

> 
> Sure, if you can ensure your hardware platform isn't going to change,
> and is relativly limited (as Moblin currently does), then you don't
> need an initrd and you can get away with a static /dev and save a few
> hundred's of a second. 

There's nothing fundamental here in your statement. Moblin currently
does not use an initrd for netbooks because it assumes you're not going
to use a screwdriver to manually add a disk (there's not even space for
a second disk). A minimal initrd for mount-by-label isn't all that hard
or expensive, especially if you do it so that your store where the
partition was with the label, and try there first, and we're obviously
going to do that for non-netbooks.

Moblin obviously does NOT use a static /dev, of course not. A modern
desktop linux just cannot have that.


> But the distros can't do that, they are stuck
> supporting users with tens of partitions and other "wierd"
> configurations.

tens of partitions is NOT a big deal; it is in fact a very false
argument to this discussion. Just make the static devices nodes and be
done with it. Nobody cares if there's a few files in /dev that represent
partitions that you have not made yet. Especially if later on udev
removes them (as it does somewhat by accident in some cases ;-)


Alan wants data, fine, no big deal, I've uploaded a typical moblin
bootchart
(I've tried to cut off the part past X start because that's just not
relevant for this discussion and would confuse things due to the async
nature of getting that started)

it's at
http://www.kernel.org/pub/linux/kernel/people/arjan/bootcharts/bootchart.svg
(done on an Asus EEEpc 901 which obviously doesn't have the fastest cpu
in the world)

while you can see that udev takes about 0.75 seconds there, the
synchronous part of udev (where all the device nodes get made and
drivers modprobed) takes a lot less than that, more like 0.2 or so,
if that.
(before people point out the inefficiencies of using gdm; yes we know
and are working on that)
X is done init at roughly 2.5 seconds into the total boot, (when
gdm-session-worker starts).

If your udev takes longer then I would suggest taking a good look at
your udev setup... 


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
