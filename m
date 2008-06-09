Return-Path: <linux-kernel-owner+w=401wt.eu-S1756878AbYFIGwG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878AbYFIGwG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 02:52:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754407AbYFIGvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 02:51:55 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:25038 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982AbYFIGvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 02:51:54 -0400
Date: Mon, 9 Jun 2008 08:51:10 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Martin Samuelsson <sam.linux.kernel@gmail.com>
Cc: Ben Dooks <ben@fluff.org>, linux-dvb@linuxtv.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       i2c@lm-sensors.org
Subject: Re: Multiple Zoran MJPEG cards and i2c misattachments
Message-ID: <20080609085110.65de75ae@hyperion.delvare>
In-Reply-To: <20080602113237.e6094cfd.sam.linux.kernel@gmail.com>
References: <5a8e970805311139r1355cfccy6933605f7b6441b6@mail.gmail.com>
	<20080601212837.GA10699@fluff.org.uk>
	<20080602113237.e6094cfd.sam.linux.kernel@gmail.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam,

On Mon, 2 Jun 2008 11:32:37 +0200, Martin Samuelsson wrote:
> On Sun, 1 Jun 2008 22:28:37 +0100, Ben Dooks wrote:
> > On Sat, May 31, 2008 at 08:39:25PM +0200, Martin Samuelsson wrote:
> > > I'm working on avs6eyes improvements in the current kernel. As I've
> > > equipped my machine with no less than three MJPEG-cards; Buz, 6 Eyes
> > > and DC10+, I happened to run into a bit of a snag:
> > > 
> > > saa7185, the video encoder of the Buz, and bt866, video encoder of the
> > > 6 Eyes, share the same i2c address, 0x88. This should not be a
> > > problem, because they are connected to different i2c buses, and are
> > > initialized separately. However, zoran_card.c, via i2c_bit_add_bus(),
> > > creates one i2c bus for each card in the detection loop, and makes
> > > them available system-wide. This means that the saa7185 driver, as the
> > > cards are detected in Buz, 6 Eyes, DC10+ order in my computer, is
> > > being requested by the zoran driver and initializes itself (not very
> > > much to do, as there is not yet any i2c bus). The zoran driver then
> > > creates bus 0, and initializes the saa7185 driver once again, it finds
> > > bus 0 and a chip at 0x88, which it attaches to.
> > > 
> > > Now, that bus is visible to the system. The 6 Eyes is being
> > > initialized, the bt866 driver loaded, and it initializes itself.
> > > Here's the problem: At load, the drivers automatically searches the
> > > system for available buses. bt866 finds bus 0, belonging to Buz, and a
> > > chip at 0x88, which it promptly attaches to, marking itself as in use.
> > 
> > Do each of the devices creating the i2c busses know what devices are
> > on the i2c bus at time of creation? If so then the use of the new
> > style driver addition and device binding would be far more appropriate
> > to this, as the i2c devices will be bound depending on the device list
> > registered at bus creation time.
> 
> I'd say yes, they do. zoran_card.c contain lists detailing chips, and those
> are available for reference at bus creation time. Would you know of any
> driver I can look at to see how this new style stuff works? The "new style"
> i2c things I've encountered so far is the 2.6 i2c subsystem as used when 2.4
> style drivers are converted with a minimum amount of work involved.

"New-style" i2c drivers are drivers which follow the device driver
model and do not create their own devices (i2c_client). As opposed to
"legacy" i2c drivers in 2.4 kernels and early 2.6 kernels (and still a
lot of drivers in the current 2.6 kernel) which create their own
i2c_client.

Ben wrote a guide about converting legacy drivers to new-style drivers:
  http://marc.info/?l=i2c&m=121250094017709&w=2
It's not finalized yet. Ben, any chance you could send an updated
version of the document in the form of a patch, so that I can push it
upstream?

If you want to go that route for the zoran driver, you'll have to
convert some of the chip drivers (at least bt866 and saa7185 if they
are the ones causing trouble), and also modify the main zoran driver to
create these devices (using i2c_new_device or i2c_new_probed_device) and
remove them (using i2c_unregister_device) as needed.

One problem may be if some of the chip drivers are shared with other
V4L adapters (apparently the bt866 driver is zoran-only, but I'm not
sure about the saa7185 driver). In that case you can't just convert
them to new-style, or you would break the other adapters which expect
the legacy drivers. So you'd have to make hybrid chip drivers, keeping
the legacy driver (for other adapters) and adding a new-style driver
(for zoran.)

In that case, you probably want to look at what Hans Verkuil did for
the ivtv and cx18 adapters, and maybe talk to him. He wrote helper
wrappers to write such hybrid chip drivers easily.

I am working on merging the legacy driver behavior into new-style
drivers to make that kind of migration easier, but that's still work in
progress.

> > > What would be a working approach to fix this situation? I'm woefully
> > > unaware of the i2c intricacies in the kernel, and know no immediate
> > > fix.
> > > 
> > > Is it possible to register i2c buses that are not visible to drivers
> > > you modprobe? That would prevent the initial scan of the buses, and
> > > the misattachments. zoran_card.c explicitly initialize the correct
> > > drivers after bus creation anyway.

That's not possible with legacy drivers. All legacy chip drivers "see"
all i2c buses, by design. New-style drivers only "see" what they are
told to, that's a major difference.

Note that I have a DC10+ somewhere in a drawer, so if you're going to
convert the zoran drivers to the new-style model, I can help you with
testing. And if you have questions in the process, feel free to ask.
I'll be happy to review your patches.

P.S.: I don't know how much energy you are going to put in the zoran
driver, but I have a number of patches for it, which never made it
upstream, if you're interested.

-- 
Jean Delvare
