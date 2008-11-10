Return-Path: <linux-kernel-owner+w=401wt.eu-S1753692AbYKJOXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692AbYKJOXX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 09:23:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753233AbYKJOXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 09:23:15 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:48426 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982AbYKJOXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 09:23:15 -0500
Message-ID: <491843C4.9090306@cosmosbay.com>
Date: Mon, 10 Nov 2008 15:23:00 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>, Robert Richter <robert.richter@amd.com>,
       Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] oprofile: re-arm APIC_DM_NMI in ppro_check_ctrs()
References: <20081107171339.GQ9785@erda.amd.com>	<4917EB51.9020304@cosmosbay.com> <87ljvsott2.fsf@basil.nowhere.org>
In-Reply-To: <87ljvsott2.fsf@basil.nowhere.org>
Content-Type: multipart/mixed;
 boundary="------------050302080407000908030804"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Mon, 10 Nov 2008 15:23:03 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050302080407000908030804
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Andi Kleen a =E9crit :
> Eric Dumazet <dada1@cosmosbay.com> writes:
>=20
>> diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_=
model_ppro.c
>> index 3f1b81a..716d26f 100644
>> --- a/arch/x86/oprofile/op_model_ppro.c
>> +++ b/arch/x86/oprofile/op_model_ppro.c
>> @@ -69,7 +69,7 @@ static void ppro_setup_ctrs(struct op_msrs const * c=
onst msrs)
>>  	int i;
>> =20
>>  	if (!reset_value) {
>> -		reset_value =3D kmalloc(sizeof(unsigned) * num_counters,
>> +		reset_value =3D kmalloc(sizeof(reset_value[0]) * num_counters,
>=20
> Thanks for tracking this down.
>=20
> But that still doesn't explain why 2.6.27 fails too?

Desesperatly Seeking Oprofile, next round.

I know *nothing* about APIC but spent few hours to try several tricks
and finally found something.

It solved my problem : oprofile can run several hours without
any freeze of NMI on any core.

# grep NMI /proc/interrupts
NMI:   10902884    9635871   10333815    8372989    7971483    8298373   =
 8877495   10206963   Non-maskable interrupts
=2E..
# grep NMI /proc/interrupts
NMI:   15518834   14340713   15038694   13078235   12676585   13003394   =
13582115   14912146   Non-maskable interrupts


Can anybody understand and explain what is happening ?

Is it a software or hardware problem ?

[PATCH] oprofile: re-arm APIC_DM_NMI in ppro_check_ctrs()

While using oprofile on my HP BL460c G1, (two quad core intel E5450 CPU),=

I noticed that one CPU after the other could not get anymore NMI.

After a while, all cores where blocked (ie not generating events for opro=
file)
I tried all major linux versions and all where affected by this freeze.

I found that we have to re-arm APIC_DM_NMI *before* writing to MSR counte=
r
when we get event notification.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
 arch/x86/oprofile/op_model_ppro.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

--------------050302080407000908030804
Content-Type: text/plain;
 name="oprofile_msr.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="oprofile_msr.patch"

diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
index 3f1b81a..7b142da 100644
--- a/arch/x86/oprofile/op_model_ppro.c
+++ b/arch/x86/oprofile/op_model_ppro.c
@@ -132,13 +132,15 @@ static int ppro_check_ctrs(struct pt_regs * const regs,
 		rdmsrl(msrs->counters[i].addr, val);
 		if (CTR_OVERFLOWED(val)) {
 			oprofile_add_sample(regs, i);
+			/*
+			 * We need to unmask the apic vector *before*
+			 * writing reset_value to msr counter
+			 */
+			apic_write(APIC_LVTPC, APIC_DM_NMI);
 			wrmsrl(msrs->counters[i].addr, -reset_value[i]);
 		}
 	}
 
-	/* Only P6 based Pentium M need to re-unmask the apic vector but it
-	 * doesn't hurt other P6 variant */
-	apic_write(APIC_LVTPC, apic_read(APIC_LVTPC) & ~APIC_LVT_MASKED);
 
 	/* We can't work out if we really handled an interrupt. We
 	 * might have caught a *second* counter just after overflowing

--------------050302080407000908030804--
