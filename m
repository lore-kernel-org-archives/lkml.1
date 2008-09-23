Return-Path: <linux-kernel-owner+w=401wt.eu-S1754130AbYIWF7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbYIWF7A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 01:59:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751911AbYIWF6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 01:58:53 -0400
Received: from byss.tchmachines.com ([208.76.80.75]:41577 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbYIWF6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 01:58:52 -0400
Date: Mon, 22 Sep 2008 22:58:47 -0700
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: Ingo Molnar <mingo@elte.hu>, torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
       Glauber de Oliveira Costa <glommer@gmail.com>
Subject: [PATCH] x86: Fix 27-rc crash on vsmp due to paravirt during module
	load
Message-ID: <20080923055847.GA26882@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

27-rc fails to boot up if configured to use modules.  Turns out vsmp_patch
was marked __init, and vsmp_patch being the pvops 'patch' routine for vsmp,
a call to vsmp_patch just turns out to execute a code page with series of 0xcc
(POISON_FREE_INITMEM -- int3).  Since apply_paravirt can only be called during
init/module load, make vsmp_patch with "__init_or_module"

Please apply

Thanks,
Kiran
---

vsmp_patch has been marked with __init ever since pvops, however,
apply_paravirt can be called during module load causing calls to
freed memory location.

Since apply_paravirt can only be called during bootup and module load,
mark vsmp patch with "__init_or_module"

Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>

Index: linux-2.6/arch/x86/kernel/vsmp_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/vsmp_64.c	2008-09-19 11:37:54.000000000 -0700
+++ linux-2.6/arch/x86/kernel/vsmp_64.c	2008-09-21 15:50:18.000000000 -0700
@@ -61,7 +61,7 @@
 	native_restore_fl((flags | X86_EFLAGS_IF) & (~X86_EFLAGS_AC));
 }
 
-static unsigned __init vsmp_patch(u8 type, u16 clobbers, void *ibuf,
+static unsigned __init_or_module vsmp_patch(u8 type, u16 clobbers, void *ibuf,
 				  unsigned long addr, unsigned len)
 {
 	switch (type) {

