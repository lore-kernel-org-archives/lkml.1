Return-Path: <linux-kernel-owner+w=401wt.eu-S1758103AbYHZUxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758103AbYHZUxp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 16:53:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752643AbYHZUxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 16:53:36 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:46011 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751807AbYHZUxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 16:53:34 -0400
Date: Tue, 26 Aug 2008 16:53:33 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Frans Pop <elendil@planet.nl>
cc: linux-kernel@vger.kernel.org,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       <linux-usb@vger.kernel.org>
Subject: Re: [regression] usb: sometimes dead keyboard after boot (was: new
 errors during device detection)
In-Reply-To: <200808262103.50984.elendil@planet.nl>
Message-ID: <Pine.LNX.4.44L0.0808261626140.2139-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Aug 2008, Frans Pop wrote:

> Thanks a lot for the explanation Alan. I get the general idea and it all 
> sounds somewhat logical if you accept the fact that EHCI can be loaded at 
> any random time after [UO]HCI as a given, but _that_ still seems to me 
> (admittedly a relative outsider and not hindered by any actual technical 
> knowledge ;-) like something that is fundamentally broken in this 
> sequence.

The arrangement certainly isn't perfect.  Partly it's an historical
artifact, arising from the way USB 2.0 controller hardware was
"designed" to work with existing USB 1.1 devices.  (I put "designed" in
quotes because that's just what they didn't do -- they came up with a 
separate chip to handle the high-speed connections and left the 
full/low-speed connections to be handled by the old hardware.)

> It also seems to be fragile in practice. I have now had two occasions 
> since your last mail where my system would come up with a dead USB 
> keyboard and it looks like this issue is the root cause.

It isn't any more fragile than unplugging the USB cable and then
plugging it back in.  If your system can't handle that sort of thing
then something else is wrong.  I.e., you've run across a bug, not a 
design flaw.

> Attached a full diff between dmesg from two consecutive boots: first 
> without keyboard; after reboot the keyboard is detected. The actual 
> difference is fairly small and clearly shows that usb 3-1 is not handed 
> off correctly, probably due to a small difference in timing.
> 
> Note that I've never seen this problem with earlier kernels.

I can't tell exactly what's going on because your usbcore module wasn't 
built with CONFIG_USB_DEBUG enabled.

Have you experimented with unloading and reloading uhci-hcd and
ehci-hcd by hand (over the network if your only keyboard is USB)?  If
you remove both and then load uhci-hcd first followed by ehci-hcd, does 
the same thing happen?

> I still feel it should not be up to individual users to need to "force" 
> something like this by manually messing with their initramfs or
> /etc/modules. If loading EHCI first is the right thing to do (and it seems 
> to me like it is) then the kernel itself should ensure that that's what 
> happens.

The kernel has very little control over the order in which modules are
loaded, partly because loading is carried out by programs like udev
running in userspace and partly because there can be multiple threads
sending out device-discovery messages in parallel.

With UHCI and EHCI things are made even worse by the fact that UHCI is 
always discovered first.  The EHCI spec requires that the companion
controllers have the lowest PCI function numbers and the EHCI 
controller has the highest.  You can see this in your log, where 1d.0 
through 1d.3 are UHCI devices and 1d.7 is EHCI.  Since PCI devices are 
probed in order of function number, the natural result is that uhci-hcd 
will be loaded before ehci-hcd.

> From an end-user PoV (which basically I am) I personally actually don't 
> think it is reasonable to have _any_ error messages in situations that 
> are expected and part of a "normal" boot sequence. For me, error messages 
> always indicate that something is wrong or broken and needs to be fixed 
> and followed up on. So, if this driver hand-off is really necessary, 
> expected and safe, it should be done with only informational messages, 
> not errors.
> 
> Even in the case where ehci-hcd is loaded much later I don't think error 
> messages would be right. At least, assuming that the kernel can guarantee 
> that the driver hand-off can be done cleanly (without risk of damaging 
> interruptions in the working of already connected devices). And if it 
> cannot guarantee that, then maybe it should just refuse to load ehci-hcd 
> at all!

Well, that's a problem.  The kernel _can't_ make that guarantee, not
once some USB devices have been set up.  So according to your
reasoning, ehci-hcd shouldn't be allowed to load if uhci-hcd is already 
loaded!

Can you suggest a reasonable method for suppressing the unwanted error
messages?  Maybe I'm too close to the problem, but nothing occurs to
me.  Part of the problem is that these errors could occur at any point
during the life cycle of a USB device: during detection, during
enumeration, during configuration, or during normal operation.  It
doesn't seem reasonable to have a flag to suppress _every_ error
message generated by the USB subsystem.

One possible approach would be to have uhci-hcd and ohci-hcd not 
initialize themselves until ehci-hcd is loaded.  But what if ehci-hcd 
never does get loaded?  Or what if ehci-hcd is unloaded and then 
reloaded?

> Side note.
> Both as a Debian Developer and kernel tester I probably pay more attention 
> than most users to my console and logs, but in principle I try to follow 
> up on any message that does not seem to belong, especially ones that 
> are "new".
> I boot kernels with 'quiet', so any error during boot is immediately 
> visible (and disturbing). I also run logcheck on all my systems, so I see 
> any unexpected log messages during normal operation. As boot logs are 
> noisy by definition, I finally do diffs between old and new boot time 
> dmesg after most new (rc) kernel builds.
> 
> Call it my contribution to quality assurance.

Kernel developers appreciate such keen oversight.  Thank you.

Alan Stern

