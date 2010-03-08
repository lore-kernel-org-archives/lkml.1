Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302Ab0CHHvq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 02:51:46 -0500
Received: from ernst.netinsight.se ([194.16.221.21]:28737 "HELO
	ernst.netinsight.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751162Ab0CHHvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 02:51:44 -0500
Date: Mon, 8 Mar 2010 08:51:33 +0100
From: Simon Kagstrom <simon.kagstrom@netinsight.net>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-kernel@vger.kernel.org, seth.heasley@intel.com
Subject: Re: [PATCH] iTCO_wdt: Don't stop on shutdown with nowayout
Message-ID: <20100308085133.70b19f60@marrow.netinsight.se>
In-Reply-To: <20100307151656.GX7459@infomag.iguana.be>
References: <20100223164019.60a6de1a@marrow.netinsight.se>
	<20100307151656.GX7459@infomag.iguana.be>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 7 Mar 2010 16:16:56 +0100
Wim Van Sebroeck <wim@iguana.be> wrote:

> > Currently, the watchdog is turned off when the system shuts down or the
> > module is unloaded. If nowayout has been selected, this makes no sense
> > and fails to restart the system if it hangs during reboot, so make it
> > conditional.
> 
> the nowayout option is there to make sure that the watchdog keeps running
> as long as the system is running. If you however do a system shutdown (which
> means that you are going to reboot your server in a controlled fasion and thus
> not as result of a crash or hang-situation), then either the shutdown function
> of your platform_driver or the reboot_notifier call will be executed.
> In the case of a watchdog device idriver we will then stop the watchdog to
> prevent reboot's during the fsck that might happen after reboot.
> If you run into a reboot operation during an fsck then chances a very big that
> after the reboot your system will again be rebooted during the next fsck.
> To prevent this fsck-reboot-loop issue we turn of the watchdog when rebooting.

At least on the system I run on, the watchdog is turned off by the
reboot itself, so it won't trigger on the next start anyway. But from
Padraigs mail earlier I understand that this isn't the case everywhere,
so it's a valid concern.

However, I still think it would be nice to have this option avaiable
for those that need it. Perhaps some option like "noshutdown" to keep
it running during reboots.

> > We have a system which has such a hang, and therefore want the watchdog
> > to be on until the bitter end.
> 
> Hmm, the correct question here should be: why do we have a hang in a clean boot.
> Do you have more info on what exactly happens? This might be an initialization problem.

Sorry, I should have been more clear here: The system hangs during
shutdown (for reboot), not during the next bootup (when it's turned off
anyway). So what my patch was trying to protect for is a hang before
restart.


You are of course right - the core issue is the hang itself. The hang
occurs very rarely, and I don't have a way to reproduce it. We've seen
it on both an old 2.6.23 kernel and 2.6.31 (what we use currently).
I've manually inspected all shutdown calls and reboot notifiers which
gets called on reboot, but not seen any obvious places where the system
can hang. I'm suspecting some interaction with an interrupt handler or
similar, but I can't really tell.

The patch I sent provides protection against this hang, and it's
something we really need until we've found the real issue.


Unfortunately, iTCO_wdt is the first driver the shutdown() call is made
to, so the hang could be in any of the other shutdown() calls. I could
perhaps also go with a solution where the watchdog was guaranteed to be
turned off last right before reboot.

// Simon
