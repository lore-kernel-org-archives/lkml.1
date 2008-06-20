Return-Path: <linux-kernel-owner+w=401wt.eu-S1753094AbYFTJxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094AbYFTJxY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 05:53:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751491AbYFTJxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 05:53:14 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40367 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292AbYFTJxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 05:53:13 -0400
Date: Fri, 20 Jun 2008 11:52:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
       linux-acpi@vger.kernel.org
Cc: Zhao Yakui <yakui.zhao@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [bug, acpi] BUG: spinlock bad magic on CPU#0, swapper/1, ACPI
	Exception (utmutex-0263): AE_BAD_PARAMETER
Message-ID: <20080620095247.GA24557@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


-tip auto-testing started triggering this spinlock corruption message 
yesterday:

[    3.976213] calling  acpi_rtc_init+0x0/0xd3
[    3.980213] ACPI Exception (utmutex-0263): AE_BAD_PARAMETER, Thread F7C50000 could not acquire Mutex [3] [20080321]
[    3.992213] BUG: spinlock bad magic on CPU#0, swapper/1
[    3.992213]  lock: c2508dc4, .magic: 00000000, .owner: swapper/1, .owner_cpu: 0
[    3.992213] Pid: 1, comm: swapper Not tainted 2.6.26-rc6-00325-gc0793f7-dirty #8570
[    3.992213]  [<c0521040>] spin_bug+0x7c/0x87
[    3.992213]  [<c0521064>] _raw_spin_unlock+0x19/0x72
[    3.992213]  [<c13ee1f2>] _spin_unlock_irqrestore+0x25/0x55
[    3.992213]  [<c05ae056>] acpi_os_release_lock+0xd/0xf
[    3.992213]  [<c05c3a23>] acpi_set_register+0x214/0x26c
[    3.992213]  [<c05b66b5>] acpi_clear_event+0x5e/0x7f
[    3.992213]  [<c1f58ace>] acpi_rtc_init+0x42/0xd3
[    3.992213]  [<c1f2b645>] kernel_init+0x128/0x269
[    3.992213]  [<c1f58a8c>] ? acpi_rtc_init+0x0/0xd3
[    3.992213]  [<c0513664>] ? trace_hardirqs_on_thunk+0xc/0x10
[    3.992213]  [<c011abf0>] ? restore_nocheck_notrace+0x0/0xe
[    3.992213]  [<c1f2b51d>] ? kernel_init+0x0/0x269
[    3.992213]  [<c1f2b51d>] ? kernel_init+0x0/0x269
[    3.992213]  [<c011b813>] kernel_thread_helper+0x7/0x10
[    3.992213]  =======================
[    3.996213] initcall acpi_rtc_init+0x0/0xd3 returned 0 after 15 msecs
[    4.004213] calling  acpi_event_init+0x0/0x74
[    4.008213] initcall acpi_event_init+0x0/0x74 returned 0 after 0 msecs

i have found the AE_BAD_PARAMETER in older logs a well, but the spinlock 
corruption is new and nothing in that area is changed by -tip so i 
suspect it's a mainline problem as well.

it's not reproducible so it's not bisectable - it happened a few times 
sporadically, but on a repeated reboot with the same bzImage it does not 
reproduce. The config, full bootlog and bzImage can be found at:

  http://redhat.com/~mingo/misc/config-Fri_Jun_20_11_19_25_CEST_2008.bad
  http://redhat.com/~mingo/misc/log-Fri_Jun_20_11_19_25_CEST_2008.bad
  http://redhat.com/~mingo/misc/bzImage-Fri_Jun_20_11_19_25_CEST_2008.bad

(more info about the system on request.)

NOTE, this is with the following boot parameters:

 maxcpus=1 nosmp no_hz=off highres=0 nmi_watchdog=0 noapic nolapic_timer 
 hpet=disable idle=mwait idle=poll highmem=512m nopat notsc acpi=off 
 pci=nomsi

the bzImage i've uploaded adds most of those boot parameters 
automatically. These boot parameters worked fine in the past.

given that it involves acpi_rtc_init:acpi_rtc_init(), one suspect would 
be this change:

| commit e1094bfa26e5e94af2fea79e004614dbce42b008
| Author: Zhao Yakui <yakui.zhao@intel.com>
| Date:   Wed May 14 11:32:59 2008 +0800
|
|    ACPI: Disable Fixed_RTC event when installing RTC handler

given that it's not bisectable, i can only "slow-test" any patch: i.e. i 
can apply any patch and report whether the spinlock corruption has 
occured after 2 days of continuous testing.

	Ingo
