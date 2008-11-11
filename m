Return-Path: <linux-kernel-owner+w=401wt.eu-S1755561AbYKKIcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561AbYKKIcg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 03:32:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754913AbYKKIc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 03:32:28 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:49981 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754898AbYKKIc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 03:32:27 -0500
Message-ID: <4919430C.6050502@cosmosbay.com>
Date: Tue, 11 Nov 2008 09:32:12 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] oprofile: re-arm APIC_DM_NMI in ppro_check_ctrs()
References: <20081107171339.GQ9785@erda.amd.com> <4917EB51.9020304@cosmosbay.com> <87ljvsott2.fsf@basil.nowhere.org> <491843C4.9090306@cosmosbay.com> <20081110154948.GW29626@one.firstfloor.org>
In-Reply-To: <20081110154948.GW29626@one.firstfloor.org>
Content-Type: multipart/mixed;
 boundary="------------060201000209020609090001"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 11 Nov 2008 09:32:14 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060201000209020609090001
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Andi Kleen a =E9crit :
>>  			oprofile_add_sample(regs, i);
>> +			/*
>> +			 * We need to unmask the apic vector *before*
>> +			 * writing reset_value to msr counter
>> +			 */
>> +			apic_write(APIC_LVTPC, APIC_DM_NMI);
>>  			wrmsrl(msrs->counters[i].addr, -reset_value[i]);
>>  		}
>>  	}
>> =20
>> -	/* Only P6 based Pentium M need to re-unmask the apic vector but it
>> -	 * doesn't hurt other P6 variant */
>> -	apic_write(APIC_LVTPC, apic_read(APIC_LVTPC) & ~APIC_LVT_MASKED);
>=20
> Did you also test if it really needs to be inside the if () or=20
> just before the wrmsrl?=20
>=20

Andi, the following patch also works well for me. The key is we must
unmask APIC before the wrmsrl. after/before the rdmsrl has no impact.

I wonder then if the final comment in ppro_check_ctrs() is still applicab=
le.


PATCH] oprofile: un-mask APIC before resetting counter in ppro_check_ctrs=
()

While using oprofile on my HP BL460c G1, (two quad core intel E5450 CPU),=

I noticed that one CPU after the other could not get anymore NMI.

After a while, all cores where blocked (ie not generating events for opro=
file)
I tried all major linux versions and all where affected by this freeze.

I found that we have to un-mask APIC *before* writing to MSR counter
when we get event notification, because we use APIC_LVTPC in edge trigger=
ed mode.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
---
 arch/x86/oprofile/op_model_ppro.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

--------------060201000209020609090001
Content-Type: text/plain;
 name="oprofile_msr.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="oprofile_msr.patch"

diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
index 3f1b81a..8484528 100644
--- a/arch/x86/oprofile/op_model_ppro.c
+++ b/arch/x86/oprofile/op_model_ppro.c
@@ -126,6 +126,12 @@ static int ppro_check_ctrs(struct pt_regs * const regs,
 	u64 val;
 	int i;
 
+	/*
+	 * We need to unmask the apic vector *before* writing reset_value
+	 * to msr counter, because we use edge trigger
+	 */
+	apic_write(APIC_LVTPC, apic_read(APIC_LVTPC) & ~APIC_LVT_MASKED);
+
 	for (i = 0 ; i < num_counters; ++i) {
 		if (!reset_value[i])
 			continue;
@@ -136,10 +142,6 @@ static int ppro_check_ctrs(struct pt_regs * const regs,
 		}
 	}
 
-	/* Only P6 based Pentium M need to re-unmask the apic vector but it
-	 * doesn't hurt other P6 variant */
-	apic_write(APIC_LVTPC, apic_read(APIC_LVTPC) & ~APIC_LVT_MASKED);
-
 	/* We can't work out if we really handled an interrupt. We
 	 * might have caught a *second* counter just after overflowing
 	 * the interrupt for this counter then arrives

--------------060201000209020609090001--
