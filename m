Return-Path: <linux-kernel-owner+w=401wt.eu-S1758910AbZAPD0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758910AbZAPD0U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 22:26:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754817AbZAPD0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 22:26:07 -0500
Received: from ti-out-0910.google.com ([209.85.142.185]:19831 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239AbZAPD0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 22:26:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=WBsNiRt8q2V5mkuYS1zNEa6cvYNjLwEhUa2Tfez84+TounM73K1KOULmmlXOy24AUi
         8YBFUiCXoca5S+nDu/VVWqCDbH8+XuJByQz8P9Aer8H1Lmobb6F4CQF7laz+31sgCArA
         x3ijZGVDRDH02IVGicurXXzFLtsuSnqVdfD9U=
Message-ID: <496FFE45.1070802@gmail.com>
Date: Fri, 16 Jan 2009 12:25:57 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: roel kluin <roel.kluin@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Brian Gerst <brgerst@gmail.com>, ebiederm@xmission.com,
       cl@linux-foundation.org, rusty@rustcorp.com.au, travis@sgi.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       steiner@sgi.com, hugh@veritas.com
Subject: [PATCH x86/percpu] x86_64: initialize this_cpu_off to __per_cpu_load
References: <496C9FB7.9050907@kernel.org> <496D8CEB.5060402@zytor.com> <20090114093834.GA19799@elte.hu> <25e057c00901150204x61c54d9fl91afe23477d1f12f@mail.gmail.com> <496F0F5E.3080404@kernel.org> <20090115113230.GH22850@elte.hu> <496F1FA6.6050204@kernel.org> <20090115122222.GI22850@elte.hu> <496F3577.4020303@kernel.org> <20090115133206.GA31416@elte.hu> <20090115133916.GA3417@elte.hu> <496FB09A.8020808@kernel.org> <496FE2B3.3060706@gmail.com>
In-Reply-To: <496FE2B3.3060706@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On x86_64, if get_per_cpu_var() is used before per cpu area is setup
(if lockdep is turned on, it happens), it needs this_cpu_off to point
to __per_cpu_load.  Initialize accordingly.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
Okay, this fixes the problem.  Tested with gcc-4.3.2 and binutils-2.19
(openSUSE 11.1).  For all four variants I can test (64-smp, 64-up,
32-smp, 32-up).  This and the previous merge fix patch are available
in the following git branch.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git tj-percpu

 arch/x86/kernel/smpcommon.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/smpcommon.c b/arch/x86/kernel/smpcommon.c
index 84395fa..7e15781 100644
--- a/arch/x86/kernel/smpcommon.c
+++ b/arch/x86/kernel/smpcommon.c
@@ -3,8 +3,13 @@
  */
 #include <linux/module.h>
 #include <asm/smp.h>
+#include <asm/sections.h>
 
+#ifdef CONFIG_X86_64
+DEFINE_PER_CPU(unsigned long, this_cpu_off) = (unsigned long)__per_cpu_load;
+#else
 DEFINE_PER_CPU(unsigned long, this_cpu_off);
+#endif
 EXPORT_PER_CPU_SYMBOL(this_cpu_off);
 
 #ifdef CONFIG_X86_32
-- 
1.6.0.2

