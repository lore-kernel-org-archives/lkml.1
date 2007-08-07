Return-Path: <linux-kernel-owner+w=401wt.eu-S933842AbXHGAVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933842AbXHGAVd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 20:21:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933339AbXHGAVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 20:21:24 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:49342 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932406AbXHGAVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 20:21:23 -0400
X-Sasl-enc: 34gFA2ILrspTdsOxbQjHD8tc7EQ+cdxqWqUeOMC5RdLU 1186446081
Date: Mon, 6 Aug 2007 21:21:17 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: ibm-acpi-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [ibm-acpi-devel] suspend/hibernation regression between 2.6.19
	and 2.6.20 w/ Thinkpad T41
Message-ID: <20070807002116.GD27640@khazad-dum.debian.net>
References: <200708051902.18801.toralf.foerster@gmx.de> <200708061136.50491.toralf.foerster@gmx.de> <20070806143631.GB31615@khazad-dum.debian.net> <200708062113.44511.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200708062113.44511.toralf.foerster@gmx.de>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 06 Aug 2007, Toralf Förster wrote:
> Because I
> (1) use the latest BIOS and
> (2) I'm able to wake up a suspended system via <Fn> under Windows XP (yes, dual
>     boot system I need it at work) regardless whether I previously hibernated
>     the system (under Windows XP) or not
> 
> I bisected this regression (rather of a feature than a bug, or ?) between
> the 2 tags v2.6.19 and v2.6.20 (~2400 commits, I read a good book in the
> meanwhile) and found :
> 
> last good commit : 7e244322cd4ea361ef9ee623b3fcb4d9f4ff841c
> first bad commit: cfee47f99bc14a6d7c6b0be2284db2cef310a815
> 
> I double checked these 2 commits - here's the first commit after which <Fn>
> doesn't wake up my system from suspend state after it was (at least one time
> before) hibernated:
> 
> commit cfee47f99bc14a6d7c6b0be2284db2cef310a815
> Merge: 7e24432... 9185cfa...
> Author: Len Brown <len.brown@intel.com>
> Date:   Sat Dec 16 01:01:18 2006 -0500
> 
>     Pull bugfix into test branch
> 
>     Conflicts:
> 
>         kernel/power/disk.c

There is a *very* interesting patch that was merged by the above commit (git
log 9185cfa ^7e24432 shows them):

9185cfa92507d07ac787bc73d06c42222eec7239 ACPI: S4: Use "platform" rather
than "shutdown" mode by default

So, please configure the kernel/s2ram/whatever you use to suspend-to-disk to
use "shutdown" as the default mode for suspend-to-disk, and check if that
doesn't solve things.

You might want to also try platform mode, but with commit
9185cfa92507d07ac787bc73d06c42222eec7239 reverted, since it does change
slightly the platform suspend code path (not in any way I think it should
matter, but hey, since I am not sure, I might as well say it).

This might not be the *root* of the problem even if it fixes your
regression, S4 *is* supposed to be the right way to suspend-to-disk, even on
some weird thinkpads.  Is there any way to find out what S-mode Windows use
to suspend-to-disk?  

Anyway, root-cause or not, it will be a damn good hint of what is really
wrong if switching to S5 for sleep-to-disk fixes the issue (if it is not
broken firmware).  And one can always document this in thinkwiki.org and
some other places, and add all thinkpads with your BIOS type (blacklist all
thinkpads with BIOS 1RET*) to a blacklist in s2ram/whatever.

Note that this should affect a HUGE number of thinkpads, at the very least
all of ThinkPad R50/p, R51 (1829, 1830, 1831, 1836), T40/p, T41/p, and T42/p
(all have BIOS 1RET*), which should cover a massive chunk of the thinkpads
currently running Linux.  Apparently, it is not very common for Linux
thinkpad users to wake it up using something other than the lid switch and
power button :-)

BTW, BIOS 1R was updated about one month ago, to 1RETDRWW (3.23).

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
