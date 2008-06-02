Return-Path: <linux-kernel-owner+w=401wt.eu-S1755310AbYFBJct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310AbYFBJct (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 05:32:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751231AbYFBJcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 05:32:42 -0400
Received: from proxy3.bredband.net ([195.54.101.73]:43093 "EHLO
	proxy3.bredband.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbYFBJcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 05:32:41 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvssALJaQ0hV5CFwPGdsb2JhbACBVYlDhl8BAQEBLZos
Date: Mon, 2 Jun 2008 11:32:37 +0200
From: Martin Samuelsson <sam.linux.kernel@gmail.com>
To: Ben Dooks <ben@fluff.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       i2c@lm-sensors.org, linux-dvb@linuxtv.org
Subject: Re: Multiple Zoran MJPEG cards and i2c misattachments
Message-Id: <20080602113237.e6094cfd.sam.linux.kernel@gmail.com>
In-Reply-To: <20080601212837.GA10699@fluff.org.uk>
References: <5a8e970805311139r1355cfccy6933605f7b6441b6@mail.gmail.com>
	<20080601212837.GA10699@fluff.org.uk>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Jun 2008 22:28:37 +0100
Ben Dooks <ben@fluff.org> wrote:

> On Sat, May 31, 2008 at 08:39:25PM +0200, Martin Samuelsson wrote:
> > Hello,
> > 
> > I'm working on avs6eyes improvements in the current kernel. As I've
> > equipped my machine with no less than three MJPEG-cards; Buz, 6 Eyes
> > and DC10+, I happened to run into a bit of a snag:
> > 
> > saa7185, the video encoder of the Buz, and bt866, video encoder of the
> > 6 Eyes, share the same i2c address, 0x88. This should not be a
> > problem, because they are connected to different i2c buses, and are
> > initialized separately. However, zoran_card.c, via i2c_bit_add_bus(),
> > creates one i2c bus for each card in the detection loop, and makes
> > them available system-wide. This means that the saa7185 driver, as the
> > cards are detected in Buz, 6 Eyes, DC10+ order in my computer, is
> > being requested by the zoran driver and initializes itself (not very
> > much to do, as there is not yet any i2c bus). The zoran driver then
> > creates bus 0, and initializes the saa7185 driver once again, it finds
> > bus 0 and a chip at 0x88, which it attaches to.
> > 
> > Now, that bus is visible to the system. The 6 Eyes is being
> > initialized, the bt866 driver loaded, and it initializes itself.
> > Here's the problem: At load, the drivers automatically searches the
> > system for available buses. bt866 finds bus 0, belonging to Buz, and a
> > chip at 0x88, which it promptly attaches to, marking itself as in use.
> 
> Do each of the devices creating the i2c busses know what devices are
> on the i2c bus at time of creation? If so then the use of the new
> style driver addition and device binding would be far more appropriate
> to this, as the i2c devices will be bound depending on the device list
> registered at bus creation time.

I'd say yes, they do. zoran_card.c contain lists detailing chips, and those are available for reference at bus creation time. Would you know of any driver I can look at to see how this new style stuff works? The "new style" i2c things I've encountered so far is the 2.6 i2c subsystem as used when 2.4 style drivers are converted with a minimum amount of work involved.

> > What would be a working approach to fix this situation? I'm woefully
> > unaware of the i2c intricacies in the kernel, and know no immediate
> > fix.
> > 
> > Is it possible to register i2c buses that are not visible to drivers
> > you modprobe? That would prevent the initial scan of the buses, and
> > the misattachments. zoran_card.c explicitly initialize the correct
> > drivers after bus creation anyway.
> 
> See above, i've not had time to go through and read all the drivers
> outside of drivers/i2c yet
> 
> PS, this should have probably gone to the i2c list as well, and
> probably the linux-dvb list too.

Then they'll at least get this, and an URL to my original mail for reference:
http://www.gossamer-threads.com/lists/linux/kernel/927965

Registering a device list at bus creation time does sound like the right thing to do. Thanks!

Regards,
/Sam

> 
> -- 
> Ben (ben@fluff.org, http://www.fluff.org/)
> 
>   'a smiley only costs 4 bytes'


-- 
Martin Samuelsson (formerly known as sam@home.se)
