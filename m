Return-Path: <linux-kernel-owner+w=401wt.eu-S1755134AbYIWSEI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134AbYIWSEI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 14:04:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751954AbYIWSDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 14:03:55 -0400
Received: from byss.tchmachines.com ([208.76.80.75]:35302 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbYIWSDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 14:03:54 -0400
Date: Tue, 23 Sep 2008 11:03:50 -0700
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: Ingo Molnar <mingo@elte.hu>, stable@kernel.org
Cc: linux-kernel@vger.kernel.org,
       Glauber de Oliveira Costa <glommer@gmail.com>
Subject: Re: [PATCH] x86: Fix 27-rc crash on vsmp due to paravirt during
	module load
Message-ID: <20080923180350.GB26882@localdomain>
References: <20080923055847.GA26882@localdomain> <20080923083145.GD23031@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080923083145.GD23031@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2008 at 10:31:45AM +0200, Ingo Molnar wrote:
>
>* Ravikiran G Thirumalai <kiran@scalex86.org> wrote:
>
>> 27-rc fails to boot up if configured to use modules.  Turns out 
>> vsmp_patch was marked __init, and vsmp_patch being the pvops 'patch' 
>> routine for vsmp, a call to vsmp_patch just turns out to execute a 
>> code page with series of 0xcc (POISON_FREE_INITMEM -- int3).  Since 
>> apply_paravirt can only be called during init/module load, make 
>> vsmp_patch with "__init_or_module"
>
>applied to tip/x86/urgent, thanks Ravikiran!
>


Thanks Ingo.
Can this get into 2.6.26 stable as well, please?  (Re-sending patch for -stable,
re diffed against 2.6.26.5)

Thanks,
Kiran

---

vsmp_patch has been marked with __init ever since pvops, however,
apply_paravirt can be called during module load causing calls to
freed memory location.

Since apply_paravirt can only be called during bootup and module load,
mark vsmp patch with "__init_or_module"

Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>

Index: linux-2.6.26.5/arch/x86/kernel/vsmp_64.c
===================================================================
--- linux-2.6.26.5.orig/arch/x86/kernel/vsmp_64.c	2008-09-08 10:40:20.000000000 -0700
+++ linux-2.6.26.5/arch/x86/kernel/vsmp_64.c	2008-09-23 10:02:05.000000000 -0700
@@ -58,7 +58,7 @@
 	native_restore_fl((flags | X86_EFLAGS_IF) & (~X86_EFLAGS_AC));
 }
 
-static unsigned __init vsmp_patch(u8 type, u16 clobbers, void *ibuf,
+static unsigned __init_or_module vsmp_patch(u8 type, u16 clobbers, void *ibuf,
 				  unsigned long addr, unsigned len)
 {
 	switch (type) {
