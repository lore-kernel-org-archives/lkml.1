Return-Path: <linux-kernel-owner+w=401wt.eu-S1754345AbYJ2Axh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345AbYJ2Axh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 20:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753420AbYJ2Ax3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 20:53:29 -0400
Received: from cpsmtpo-eml04.KPNXCHANGE.COM ([213.75.38.153]:44081 "EHLO
	cpsmtpo-eml04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753345AbYJ2Ax2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 20:53:28 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: Re: Long delays and keystrokes required - related to disk encryption?
Date: Wed, 29 Oct 2008 01:53:21 +0100
User-Agent: KMail/1.9.9
Cc: Yves-Alexis Perez <corsac@debian.org>,
       "Carlos R. Mafra" <crmafra2@gmail.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
References: <200810281744.52587.elendil@planet.nl>
In-Reply-To: <200810281744.52587.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810290153.23514.elendil@planet.nl>
X-OriginalArrivalTime: 29 Oct 2008 00:53:25.0531 (UTC) FILETIME=[BFDC76B0:01C93960]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 October 2008, Frans Pop wrote:
> I'm seeing some very strange behavior with 2.6.28-rc2-95-g49fdf67 on my
> HP 2510p notebook.
>
> During the boot there are several places where I need to hit a key for
> the boot to continue. There are also some very long delays before the
> next syslog message is displayed.
> The boot does continue and regularly hitting a key helps (but does not
> get rid of all delays), but it is a huge regression from 2.6.27.
>
> The delays seem to continue until file systems get mounted.
>
> As the delays start at the point my system asks for the passphrase to
> unlock (LUKS) encrypted disks, I suspect it has to do with that.
> Especially since hitting a key seems to "trigger" new disk activity.
>
> However, the delays happen _again_ during shutdown, which makes it
> extra strange that the system does behave normally when logged in.
>
> During the first boot wireless networking failed. During the second
> boot, wireless networking did come up (without any relevant changes).
> This gave an interesting extra data point: with wireless the delays on
> shutdown started later: after iwlagn gets disabled.

I've bisected it to:
commit dc4304f7deee29fcdf6a2b62f7146ea7f505fd42
Author: Arjan van de Ven <arjan@linux.intel.com>
Date:   Mon Oct 13 10:32:15 2008 -0400
    rangetimers: fix the bug reported by Ingo for real

The bisection was one of those annoying ones where you switch branches
often and get a load of config changes. This means that I'm not 100% sure
about it, especially as the behavior changed for the last few "bad"s:
instead of endlessly repeated delays there would be only a few of them
immediately after entering the LUKS passphrase.

I'm fairly confident that the issue is in Arjan's hrtimer/rangetimer
series, but there seems to be some interaction with other changes.
The fact that the last bisect was a "good" also gives some assurance.

CC'ing Ingo and Thomas as they've worked on these changes as well.

Here is the full bisect log:
git-bisect start
# good: [3fa8749e584b55f1180411ab1b51117190bac1e5] Linux 2.6.27
git-bisect good 3fa8749e584b55f1180411ab1b51117190bac1e5
# bad: [c1ca9151db2d432b6fa485cbff25b627f0926c76] SATA: Blacklist systems that spin off disks during ACPI power off
git-bisect bad c1ca9151db2d432b6fa485cbff25b627f0926c76
# good: [cf2fa66055d718ae13e62451bb546505f63906a2] Merge branch 'for_linus' of 
git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6
git-bisect good cf2fa66055d718ae13e62451bb546505f63906a2
# good: [2be508d847392e431759e370d21cea9412848758] Merge git://git.infradead.org/mtd-2.6
git-bisect good 2be508d847392e431759e370d21cea9412848758
# good: [e82cff752f57810a2259415ad2e9087c2d69484c] Merge branch 'irq-fixes-for-linus' of 
git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
git-bisect good e82cff752f57810a2259415ad2e9087c2d69484c
# good: [5b34653963de7a6d0d8c783527457d68fddc60fb] Merge branch 'x86/um-header' of 
git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
git-bisect good 5b34653963de7a6d0d8c783527457d68fddc60fb
# bad: [c3c9897c63ebb0b93b7f78724e38d6ee1da04041] Merge branch 'x86-fixes-for-linus' of 
git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
git-bisect bad c3c9897c63ebb0b93b7f78724e38d6ee1da04041
# good: [54d822a6169b76b807b8cdbbf76ff2812a88947f] Merge git://git.kernel.org/pub/scm/linux/kernel/git/hskinnemoen/avr32-2.6
git-bisect good 54d822a6169b76b807b8cdbbf76ff2812a88947f
# bad: [1f6d6e8ebe73ba9d9d4c693f7f6f50f661dbd6e4] Merge branch 'v28-range-hrtimers-for-linus-v2' of 
git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
git-bisect bad 1f6d6e8ebe73ba9d9d4c693f7f6f50f661dbd6e4
# good: [db563fc2e80534f98c7f9121a6f7dfe41f177a79] Merge git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6
git-bisect good db563fc2e80534f98c7f9121a6f7dfe41f177a79
# FJP: repeated due to merge failure because of ext3 build error fix
# good: [db563fc2e80534f98c7f9121a6f7dfe41f177a79] Merge git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6
git-bisect good db563fc2e80534f98c7f9121a6f7dfe41f177a79
# good: [da8f2e170ea94cc20f8ebbc8ee8d127edb8f12f1] hrtimer: add a hrtimer_start_range() function
git-bisect good da8f2e170ea94cc20f8ebbc8ee8d127edb8f12f1
# good: [9fd87545c97b91cf9cfa52e914d66863878efe60] Merge branch 'master' of 
git://git.kernel.org/pub/scm/linux/kernel/git/arjan/linux-2.6-hrtimer into timers/range-hrtimers
git-bisect good 9fd87545c97b91cf9cfa52e914d66863878efe60
# bad: [b6a4b7de4cb45ccf7157fc58de09c96f84d67108] Merge branch 'for-linus' of 
git://git.kernel.org/pub/scm/linux/kernel/git/arjan/linux-2.6-hrtimer into timers/range-hrtimers
git-bisect bad b6a4b7de4cb45ccf7157fc58de09c96f84d67108
# bad: [40b8606253552109815786e5d4b0de98782d31f5] DECLARE_PER_CPU needs linux/percpu.h
git-bisect bad 40b8606253552109815786e5d4b0de98782d31f5
# bad: [dc4304f7deee29fcdf6a2b62f7146ea7f505fd42] rangetimers: fix the bug reported by Ingo for real
git-bisect bad dc4304f7deee29fcdf6a2b62f7146ea7f505fd42
# good: [030aebd2e439a2ebcca2b0ce30a02ed84feb043e] rangetimer: fix BUG_ON reported by Ingo
git-bisect good 030aebd2e439a2ebcca2b0ce30a02ed84feb043e
