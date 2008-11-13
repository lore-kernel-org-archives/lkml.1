Return-Path: <linux-kernel-owner+w=401wt.eu-S1755668AbYKMVto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755668AbYKMVto (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 16:49:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751653AbYKMVtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 16:49:33 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:40590 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbYKMVtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 16:49:32 -0500
Message-ID: <491CA0DC.8070405@cosmosbay.com>
Date: Thu, 13 Nov 2008 22:49:16 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jiri Kosina <jkosina@suse.cz>, Andi Kleen <andi@firstfloor.org>,
       Robert Richter <robert.richter@amd.com>, oprofile-list@lists.sf.net,
       Jiri Benc <jbenc@suse.cz>, Vilem Marsik <vmarsik@suse.cz>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: Oprofile [still] doesn't work on 2.6.28-rc4 on certain CPU
References: <alpine.LNX.1.10.0811132147030.19853@jikos.suse.cz> <20081113212446.GA5694@elte.hu> <alpine.LNX.1.10.0811132226140.19853@jikos.suse.cz> <20081113213744.GA8429@elte.hu>
In-Reply-To: <20081113213744.GA8429@elte.hu>
Content-Type: multipart/mixed;
 boundary="------------070107010902030505040905"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Thu, 13 Nov 2008 22:49:18 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070107010902030505040905
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Ingo Molnar a =E9crit :
> * Jiri Kosina <jkosina@suse.cz> wrote:
>=20
>> On Thu, 13 Nov 2008, Ingo Molnar wrote:
>>
>>>> I haven't yet found a time to start bisecting this.
>>> Would be nice to identify a commit to revert - in case we run out of =

>>> time fixing it.
>> Yup, I first wanted to make this known to the public in hope that it=20
>> will ring a bell somewhere.
>>
>> If noone sees an obvous reason for this, I will do my best to bisect=20
>> this tomorrow.
>=20
> We've got the one patch below pending, but that's not for AMD cpus so=20
> it shouldnt impact your case.
>=20
> But ... some change made it all much more fragile. I'm curious why=20
> things became more fragile.
>=20
> 	Ingo
>=20
> --------------->
> Subject: oprofile: un-mask APIC before resetting counter in ppro_check_=
ctrs()
> From: Eric Dumazet <dada1@cosmosbay.com>
> Date: Tue, 11 Nov 2008 09:32:12 +0100
>=20
> While using oprofile on my HP BL460c G1, (two quad core intel E5450 CPU=
),
> I noticed that one CPU after the other could not get anymore NMI.
>=20
> After a while, all cores where blocked (ie not generating events for op=
rofile)
> I tried all major linux versions and all where affected by this freeze.=

>=20
> I found that we have to un-mask APIC *before* writing to MSR counter
> when we get event notification, because we use APIC_LVTPC in edge trigg=
ered mode.
>=20
> Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/oprofile/op_model_ppro.c |   10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>=20
> Index: tip/arch/x86/oprofile/op_model_ppro.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- tip.orig/arch/x86/oprofile/op_model_ppro.c
> +++ tip/arch/x86/oprofile/op_model_ppro.c
> @@ -126,6 +126,12 @@ static int ppro_check_ctrs(struct pt_reg
>  	u64 val;
>  	int i;
> =20
> +	/*
> +	 * We need to unmask the apic vector *before* writing reset_value
> +	 * to msr counter, because we use edge trigger
> +	 */
> +	apic_write(APIC_LVTPC, apic_read(APIC_LVTPC) & ~APIC_LVT_MASKED);
> +
>  	for (i =3D 0 ; i < num_counters; ++i) {
>  		if (!reset_value[i])
>  			continue;
> @@ -136,10 +142,6 @@ static int ppro_check_ctrs(struct pt_reg
>  		}
>  	}
> =20
> -	/* Only P6 based Pentium M need to re-unmask the apic vector but it
> -	 * doesn't hurt other P6 variant */
> -	apic_write(APIC_LVTPC, apic_read(APIC_LVTPC) & ~APIC_LVT_MASKED);
> -
>  	/* We can't work out if we really handled an interrupt. We
>  	 * might have caught a *second* counter just after overflowing
>  	 * the interrupt for this counter then arrives

Just to clarify, I found this patch necessary for previous linux versions=
 as well.

Maybe new CPUS from intel triggers a software bug, I dont know.


Also, I posted a patch about the kmalloc() of reset_value, I am not sure =
patch was pushed.

This one is a real bug.

[PATCH] oprofile: fix an overflow in ppro code

reset_value was changed from long to u64 in commit b99170288421c79f0c2efa=
8b33e26e65f4bb7fb8
(oprofile: Implement Intel architectural perfmon support)

But dynamic allocation of this array use a wrong type (long instead of u6=
4)

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
---
arch/x86/oprofile/op_model_ppro.c |    2 +-
1 files changed, 1 insertion(+), 1 deletion(-)


--------------070107010902030505040905
Content-Type: text/plain;
 name="oprofile_ppro.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="oprofile_ppro.patch"

diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
index 3f1b81a..716d26f 100644
--- a/arch/x86/oprofile/op_model_ppro.c
+++ b/arch/x86/oprofile/op_model_ppro.c
@@ -69,7 +69,7 @@ static void ppro_setup_ctrs(struct op_msrs const * const msrs)
 	int i;
 
 	if (!reset_value) {
-		reset_value = kmalloc(sizeof(unsigned) * num_counters,
+		reset_value = kmalloc(sizeof(reset_value[0]) * num_counters,
 					GFP_ATOMIC);
 		if (!reset_value)
 			return;

--------------070107010902030505040905--
