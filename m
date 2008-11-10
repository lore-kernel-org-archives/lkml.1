Return-Path: <linux-kernel-owner+w=401wt.eu-S1754709AbYKJIGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709AbYKJIGR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 03:06:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753903AbYKJIFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 03:05:46 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:45721 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026AbYKJIFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 03:05:44 -0500
Message-ID: <4917EB51.9020304@cosmosbay.com>
Date: Mon, 10 Nov 2008 09:05:37 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Robert Richter <robert.richter@amd.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@linux.intel.com>
Subject: Re: [git pull] OProfile fixes for v2.6.28
References: <20081107171339.GQ9785@erda.amd.com>
In-Reply-To: <20081107171339.GQ9785@erda.amd.com>
Content-Type: multipart/mixed;
 boundary="------------070705080700050901090909"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Mon, 10 Nov 2008 09:05:37 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070705080700050901090909
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Robert Richter a =E9crit :
> Hi Ingo,
>=20
> please pull oprofile fixes for 2.6.28 for tip regression:
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git oprofil=
e-for-tip
>=20
> Thanks,
>=20
> -Robert
>=20
> Andi Kleen (1):
>       oprofile: Fix p6 counter overflow check
>=20
> Carl Love (2):
>       Cell OProfile: Incorrect local array size in activate spu profili=
ng function
>       Cell OProfile: Incorrect local array size in activate spu profili=
ng function
>=20
> Jesper Dangaard Brouer (1):
>       Change UTF8 chars in Kconfig help text about Oprofile AMD barcelo=
na
>=20
> Nick Piggin (1):
>       oprofile: fix memory ordering
>=20
> Robert Richter (1):
>       Revert "Cell OProfile: Incorrect local array size in activate spu=
 profiling function"
>=20

Hi Robert

I am still trying to find why oprofile stops after some millions of sampl=
es on my machine.

(All versions of linux supporting oprofile/NMI on this machine have this =
problem)
Note : I am using a 32bit kernel.

While doing code review I found this bug.

Impact: 32bit kernels, memory corruption

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


--------------070705080700050901090909
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

--------------070705080700050901090909--
