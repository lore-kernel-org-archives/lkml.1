Return-Path: <linux-kernel-owner+w=401wt.eu-S965458AbXC0VcM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965458AbXC0VcM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 17:32:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965494AbXC0VcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 17:32:11 -0400
Received: from sp604005mt.neufgp.fr ([84.96.92.11]:64227 "EHLO smtp.Neuf.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965458AbXC0VcJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 17:32:09 -0400
Date: Tue, 27 Mar 2007 23:29:34 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: 2.6.21-rc5-mm1
In-reply-to: <20070327131214.656e1ad7.akpm@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Badari Pulavarty <pbadari@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>
Message-id: <46098CBE.7010807@cosmosbay.com>
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_1GEPV/kaAp/+Adtk5AumIQ)"
References: <20070326205706.a750bb35.akpm@linux-foundation.org>
 <1175017173.16728.19.camel@dyn9047017100.beaverton.ibm.com>
 <20070327084838.34dc1b84.akpm@linux-foundation.org>
 <1175018270.16728.26.camel@dyn9047017100.beaverton.ibm.com>
 <20070327131214.656e1ad7.akpm@linux-foundation.org>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--Boundary_(ID_1GEPV/kaAp/+Adtk5AumIQ)
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 8BIT

Andrew Morton a écrit :
> 
> The wheel spins around, slows then settles on.... 
> time-smp-friendly-alignment-of-struct-clocksource.patch!
> 
> Presumably because the ____cacheline_aligned made vsyscall_gtod_data_t get
> too big.  Or something.

Very strange, since here I have plenty of available room (256 bytes) :

ffffffffff600000 T vgettimeofday
ffffffffff60004e t vsysc2
ffffffffff600140 t vread_hpet
ffffffffff600150 t vread_tsc
ffffffffff600180 D __vsyscall_gtod_data
ffffffffff600280 D __vgetcpu_mode
ffffffffff6002c0 D __jiffies
<lot of space (256 bytes)>
ffffffffff600400 T vtime
ffffffffff600413 t vsysc1
ffffffffff600800 T vgetcpu
ffffffffff600c00 T venosys_1

It must depends on the compiler, and/or CONFIG_XXX options...

Anyway, I think we can safely move __vgetcpu_mode & __jiffies to the 1024 
bytes area dedicated to vgetcpu() implementation. This saves 128 bytes from 
vsyscall_0 area.

Could we add this patch instead of dropping 
time-smp-friendly-alignment-of-struct-clocksource.patch ?

Thank you

[PATCH] x86_64 : move __vgetcpu_mode & __jiffies  to the vsyscall_2 zone

We apparently hit the 1024 limit of vsyscall_0 zone when some debugging 
options are set, or if __vsyscall_gtod_data is 64 bytes larger.

In order to save 128 bytes from the vsyscall_0 zone, we move __vgetcpu_mode & 
__jiffies to vsyscall_2 zone where they really belong, since they are used 
only from vgetcpu() (which is in this vsyscall_2 area).

After patch is applied, new layout is :

ffffffffff600000 T vgettimeofday
ffffffffff60004e t vsysc2
ffffffffff600140 t vread_hpet
ffffffffff600150 t vread_tsc
ffffffffff600180 D __vsyscall_gtod_data
ffffffffff600400 T vtime
ffffffffff600413 t vsysc1
ffffffffff600800 T vgetcpu
ffffffffff600870 D __vgetcpu_mode
ffffffffff600880 D __jiffies
ffffffffff600c00 T venosys_1


Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>

--Boundary_(ID_1GEPV/kaAp/+Adtk5AumIQ)
Content-type: text/plain; name=x86_64_vmlinux_lds.patch
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=x86_64_vmlinux_lds.patch

--- linux-2.6.21-rc5/arch/x86_64/kernel/vmlinux.lds.S
+++ linux-2.6.21-rc5-ed/arch/x86_64/kernel/vmlinux.lds.S
@@ -94,6 +94,12 @@ SECTIONS
 		{ *(.vsyscall_gtod_data) }
   vsyscall_gtod_data = VVIRT(.vsyscall_gtod_data);
 
+
+  .vsyscall_1 ADDR(.vsyscall_0) + 1024: AT(VLOAD(.vsyscall_1))
+		{ *(.vsyscall_1) }
+  .vsyscall_2 ADDR(.vsyscall_0) + 2048: AT(VLOAD(.vsyscall_2))
+		{ *(.vsyscall_2) }
+
   .vgetcpu_mode : AT(VLOAD(.vgetcpu_mode)) { *(.vgetcpu_mode) }
   vgetcpu_mode = VVIRT(.vgetcpu_mode);
 
@@ -101,10 +107,6 @@ SECTIONS
   .jiffies : AT(VLOAD(.jiffies)) { *(.jiffies) }
   jiffies = VVIRT(.jiffies);
 
-  .vsyscall_1 ADDR(.vsyscall_0) + 1024: AT(VLOAD(.vsyscall_1))
-		{ *(.vsyscall_1) }
-  .vsyscall_2 ADDR(.vsyscall_0) + 2048: AT(VLOAD(.vsyscall_2))
-		{ *(.vsyscall_2) }
   .vsyscall_3 ADDR(.vsyscall_0) + 3072: AT(VLOAD(.vsyscall_3))
 		{ *(.vsyscall_3) }
 

--Boundary_(ID_1GEPV/kaAp/+Adtk5AumIQ)--
