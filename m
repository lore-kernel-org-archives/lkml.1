Return-Path: <linux-kernel-owner+w=401wt.eu-S934875AbXHGP3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934875AbXHGP3T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 11:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758447AbXHGP3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 11:29:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33110 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752831AbXHGP3I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 11:29:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Toralf =?iso-8859-15?q?F=F6rster?= <toralf.foerster@gmx.de>
Subject: Re: [ibm-acpi-devel] suspend/hibernation regression between 2.6.19 and 2.6.20 w/ Thinkpad T41
Date: Tue, 7 Aug 2007 17:38:23 +0200
User-Agent: KMail/1.9.5
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       ibm-acpi-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>
References: <200708051902.18801.toralf.foerster@gmx.de> <20070807002116.GD27640@khazad-dum.debian.net> <200708071521.33679.toralf.foerster@gmx.de>
In-Reply-To: <200708071521.33679.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200708071738.24502.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 7 August 2007 15:21, Toralf Förster wrote:
> Am Dienstag, 7. August 2007 02:21 schrieb Henrique de Moraes Holschuh:
> > On Mon, 06 Aug 2007, Toralf Förster wrote:
> > > Because I
> > > (1) use the latest BIOS and
> > > (2) I'm able to wake up a suspended system via <Fn> under Windows XP (yes, dual
> > >     boot system I need it at work) regardless whether I previously hibernated
> > >     the system (under Windows XP) or not
> > > 
> > > I bisected this regression (rather of a feature than a bug, or ?) between
> > > the 2 tags v2.6.19 and v2.6.20 (~2400 commits, I read a good book in the
> > > meanwhile) and found :
> > > 
> > > last good commit : 7e244322cd4ea361ef9ee623b3fcb4d9f4ff841c
> > > first bad commit: cfee47f99bc14a6d7c6b0be2284db2cef310a815
> > > 
> > > I double checked these 2 commits - here's the first commit after which <Fn>
> > > doesn't wake up my system from suspend state after it was (at least one time
> > > before) hibernated:
> > > 
> > > commit cfee47f99bc14a6d7c6b0be2284db2cef310a815
> > > Merge: 7e24432... 9185cfa...
> > > Author: Len Brown <len.brown@intel.com>
> > > Date:   Sat Dec 16 01:01:18 2006 -0500
> > > 
> > >     Pull bugfix into test branch
> > > 
> > >     Conflicts:
> > > 
> > >         kernel/power/disk.c
> > 
> > There is a *very* interesting patch that was merged by the above commit (git
> > log 9185cfa ^7e24432 shows them):
> > 
> > 9185cfa92507d07ac787bc73d06c42222eec7239 ACPI: S4: Use "platform" rather
> > than "shutdown" mode by default
> > 
> > So, please configure the kernel/s2ram/whatever you use to suspend-to-disk to
> > use "shutdown" as the default mode for suspend-to-disk, and check if that
> > doesn't solve things.
> > 
> > You might want to also try platform mode, but with commit
> > 9185cfa92507d07ac787bc73d06c42222eec7239 reverted, since it does change
> > slightly the platform suspend code path (not in any way I think it should
> > matter, but hey, since I am not sure, I might as well say it).
> > 
> > This might not be the *root* of the problem even if it fixes your
> > regression, S4 *is* supposed to be the right way to suspend-to-disk, even on
> > some weird thinkpads.  Is there any way to find out what S-mode Windows use
> > to suspend-to-disk?  
> > 
> > Anyway, root-cause or not, it will be a damn good hint of what is really
> > wrong if switching to S5 for sleep-to-disk fixes the issue (if it is not
> > broken firmware).  And one can always document this in thinkwiki.org and
> > some other places, and add all thinkpads with your BIOS type (blacklist all
> > thinkpads with BIOS 1RET*) to a blacklist in s2ram/whatever.
> > 
> > Note that this should affect a HUGE number of thinkpads, at the very least
> > all of ThinkPad R50/p, R51 (1829, 1830, 1831, 1836), T40/p, T41/p, and T42/p
> > (all have BIOS 1RET*), which should cover a massive chunk of the thinkpads
> > currently running Linux.  Apparently, it is not very common for Linux
> > thinkpad users to wake it up using something other than the lid switch and
> > power button :-)
> > 
> > BTW, BIOS 1R was updated about one month ago, to 1RETDRWW (3.23).
> > 
> 
> I went to the first bad commit and applied the following patch manually:
> 
> diff --git a/kernel/power/main.c b/kernel/power/main.c
> index ff3a618..500eb87 100644
> --- a/kernel/power/main.c
> +++ b/kernel/power/main.c
> @@ -29,7 +29,7 @@
>  DEFINE_MUTEX(pm_mutex);
> 
>  struct pm_ops *pm_ops;
> -suspend_disk_method_t pm_disk_mode = PM_DISK_PLATFORM;
> +suspend_disk_method_t pm_disk_mode = PM_DISK_SHUTDOWN;
> 
>  /**
>   *     pm_set_ops - Set the global power method table.
> 
> 
> After that the regression was solved - I was able to wake a suspended system
> with <Fn> althought it was hibernated (and waked up) before.

Actually, you don't need the patch above, just do
"echo shutdown > /sys/power/disk" before the hibernation (or use
"shutdown method = shutdown" configuration option if you use s2disk).

BTW, can you please try this patch before you do that:
http://www.sisk.pl/kernel/hibernation_and_suspend/2.6.23-rc2/patches/19-ACPI-Enable-GPEs-before-_WAK-is-called.patch

> I use the latest installed BIOS (currently 3.23/3.04) from the ThinkWiki.
> 
> Hope this helps you to track down the root cause :-)

Not really ...

> > So, please configure the kernel/s2ram/whatever you use to suspend-to-disk to
> > use "shutdown" as the default mode for suspend-to-disk, and check if that
> > doesn't solve things.
> I use "echo -n mem > /sys/power/state" resp.and "echo -n disk > /sys/power/state"
> within the script /etc/acpi/default.sh.

So place "echo shutdown > /sys/power/disk" before that into your script.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
