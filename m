Return-Path: <linux-kernel-owner+w=401wt.eu-S1755865AbZCYNKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865AbZCYNKW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 09:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753838AbZCYNKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 09:10:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:41010 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753700AbZCYNKF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 09:10:05 -0400
Date: Wed, 25 Mar 2009 13:09:29 GMT
From: Wang Chen <wangchen@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, wangchen@cn.fujitsu.com, mingo@elte.hu,
       penguin-kernel@i-love.sakura.ne.jp
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, wangchen@cn.fujitsu.com,
       penguin-kernel@i-love.sakura.ne.jp, mingo@elte.hu
In-Reply-To: <49C9FFEA.7060908@cn.fujitsu.com>
References: <49C9FFEA.7060908@cn.fujitsu.com>
Subject: [tip:x86/mm] x86: early_ioremap_init(), use __fix_to_virt(), because we are sure it's safe
Message-ID: <tip-9f4f25c86ff2233dd98d4bd6968afb1ca66558a0@git.kernel.org>
Git-Commit-ID: 9f4f25c86ff2233dd98d4bd6968afb1ca66558a0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 25 Mar 2009 13:09:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9f4f25c86ff2233dd98d4bd6968afb1ca66558a0
Gitweb:     http://git.kernel.org/tip/9f4f25c86ff2233dd98d4bd6968afb1ca66558a0
Author:     Wang Chen <wangchen@cn.fujitsu.com>
AuthorDate: Wed, 25 Mar 2009 14:07:11 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 25 Mar 2009 14:07:11 +0100

x86: early_ioremap_init(), use __fix_to_virt(), because we are sure it's safe

Tetsuo Handa reported this link bug:

 |  arch/x86/mm/built-in.o(.init.text+0x1831): In function `early_ioremap_init':
 |  : undefined reference to `__this_fixmap_does_not_exist'
 |  make: *** [.tmp_vmlinux1] Error 1

Commit:8827247ffcc9e880cbe4705655065cf011265157 used a variable (which
would be optimized to constant) as fix_to_virt()'s parameter.
It's depended on gcc's optimization and fails on old gcc. (Tetsuo used gcc 3.3)

We can use __fix_to_vir() instead, because we know it's safe and
don't need link time error reporting.

Reported-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: Wang Chen <wangchen@cn.fujitsu.com>
Cc: sfr@canb.auug.org.au
LKML-Reference: <49C9FFEA.7060908@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/ioremap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 83ed74a..0dfa09d 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -516,7 +516,7 @@ void __init early_ioremap_init(void)
 		printk(KERN_INFO "early_ioremap_init()\n");
 
 	for (i = 0; i < FIX_BTMAPS_SLOTS; i++)
-		slot_virt[i] = fix_to_virt(FIX_BTMAP_BEGIN - NR_FIX_BTMAPS*i);
+		slot_virt[i] = __fix_to_virt(FIX_BTMAP_BEGIN - NR_FIX_BTMAPS*i);
 
 	pmd = early_ioremap_pmd(fix_to_virt(FIX_BTMAP_BEGIN));
 	memset(bm_pte, 0, sizeof(bm_pte));
