Return-Path: <linux-kernel-owner+w=401wt.eu-S1755372AbZG1WGL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372AbZG1WGL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 18:06:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753870AbZG1WGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 18:06:11 -0400
Received: from mail-bw0-f221.google.com ([209.85.218.221]:58606 "EHLO
	mail-bw0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344AbZG1WGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 18:06:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=tbzp/AbTMruUjMDpgR8VCIRStL1iUIXFzEyofzaqO/WMAFFgEgWOLeiw+QyrRfxLv5
         f8y1PlXFnJc47mpuWcThD8Owu/6wCDt/1E2AEUjEo2KVWnxojYwK+6JMllyrKBXLmO94
         kD/aQFajblNffixjfe9UnPElboG+DiMWrumj4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Ingo Molnar <mingo@redhat.com>
Subject: [PATCH] mce: don't log boot MCEs on Pentium M (model == 13) CPUs
Date: Tue, 28 Jul 2009 23:52:54 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc4-next-20090728-04869-gdae50fe-dirty; KDE/4.2.4; i686; ; )
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907282352.55047.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] mce: don't log boot MCEs on Pentium M (model == 13) CPUs

On my legacy Pentium M laptop (Acer Extensa 2900) I get bogus MCE on a cold
boot with CONFIG_X86_NEW_MCE enabled, i.e. (after decoding it with mcelog):

MCE 0
HARDWARE ERROR. This is *NOT* a software problem!
Please contact your hardware vendor
CPU 0 BANK 1 MCG status:
MCi status:
Error overflow
Uncorrected error
Error enabled
Processor context corrupt
MCA: Data CACHE Level-1 UNKNOWN Error
STATUS f200000000000195 MCGSTATUS 0

[ The other STATUS values observed: f2000000000001b5 (... UNKNOWN error)
  and f200000000000115 (... READ Error).

  To verify that this is not a CONFIG_X86_NEW_MCE bug I also modified
  the CONFIG_X86_OLD_MCE code (which doesn't log any MCEs) to dump
  content of STATUS MSR before it is cleared during initialization. ]

Since the bogus MCE results in a kernel taint (which in turn disables
lockdep support) don't log boot MCEs on Pentium M (model == 13) CPUs
by default ("mce=bootlog" boot parameter can be be used to get the old
behavior).

Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: b/arch/x86/kernel/cpu/mcheck/mce.c
===================================================================
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1273,6 +1273,10 @@ static void mce_cpu_quirks(struct cpuinf
 		if ((c->x86 > 6 || (c->x86 == 6 && c->x86_model >= 0xe)) &&
 			monarch_timeout < 0)
 			monarch_timeout = USEC_PER_SEC;
+
+		/* There are also broken BIOSes on some Pentium M systems. */
+		if (c->x86 == 6 && c->x86_model == 13 && mce_bootlog < 0)
+			mce_bootlog = 0;
 	}
 	if (monarch_timeout < 0)
 		monarch_timeout = 0;
