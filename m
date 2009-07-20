Return-Path: <linux-kernel-owner+w=401wt.eu-S1752935AbZGTQOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935AbZGTQOg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 12:14:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752738AbZGTQNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 12:13:44 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:54931 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbZGTQNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 12:13:34 -0400
X-SpamScore: -9
X-BigFish: VPS-9(zz14ffO1402I4015Lzz1202hzzz32i43j63h)
X-Spam-TCS-SCL: 2:0
X-FB-SS: 5,
X-WSS-ID: 0KN391Y-04-7DQ-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: <mingo@elte.hu>, <hpa@zytor.com>, <tglx@linutronix.de>, <norsk5@yahoo.com>,
       <aris@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [RFC PATCH 0/14] amd64_edac: marry mcheck to amd64 edac
Date: Mon, 20 Jul 2009 18:12:51 +0200
Message-ID: <1248106385-27514-1-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.3.3
X-OriginalArrivalTime: 20 Jul 2009 16:13:10.0937 (UTC) FILETIME=[F9FB2890:01CA0954]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

this is the first version of the attempt to forward MCE information to
the amd64 EDAC module for further decoding. When the MCE handler gets
invoked and the EDAC module is loaded, here's how a decoded MCE looks
like:

Disabling lock debugging due to kernel taint

<0>HARDWARE ERROR
CPU 3: Machine Check Exception:                4 Bank 0: b20040001c000175
TSC 714e9b73cf 
PROCESSOR 2:100f22 TIME 1247237579 SOCKET 0 APIC 3
MC0_STATUS: Uncorrected error, report: yes, MiscV: invalid, CPU context corrupt: yes
 Data Cache Error: Data/Tag Evict error.
 Transaction: Evict, Type: Data, Cache Level: L1
This is not a software problem!
<0>Run through mcelog --ascii to decode and contact your hardware vendor
Machine check: Processor context corrupt
Kernel panic - not syncing: Fatal machine check on current CPU
Pid: 4817, comm: cc1 Tainted: G   M       2.6.31-rc2-00218-g78848b0-dirty #42
Call Trace:
 <#MC>  [<ffffffff8134a17a>] panic+0xaf/0x178
 [<ffffffff812b5d9e>] ? decode_mce+0x47e/0x540
 [<ffffffff81019210>] ? print_mce+0x90/0x110
 [<ffffffff810193e7>] mce_panic+0x157/0x180
 [<ffffffff81019de7>] do_machine_check+0x757/0x930
 [<ffffffff8134d96d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
 [<ffffffff8134e9cb>] machine_check+0x1b/0x20
 <EOE>

Clearly, the "Run through mcelog... " line is redundant now :) since
there's no need for userspace decoding anymore and the original EDAC
functionality (polling workqueue) is still preserved. The code currently
uses EDAC to decode DRAM ECC errors but this could clearly be extended
to handle all valid addresses acquired from MCi_ADDR registers.

Comments and further suggestions are most welcome.

Thanks,
Boris.

 arch/x86/kernel/cpu/mcheck/mce.c    |    7 +
 drivers/edac/amd64_edac.c           |  484 +++++++++++++++++++++--------------
 drivers/edac/amd64_edac.h           |   67 ++---
 drivers/edac/amd64_edac_dbg.c       |    2 +-
 drivers/edac/amd64_edac_err_types.c |  126 +++++-----
 5 files changed, 382 insertions(+), 304 deletions(-)

