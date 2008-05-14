Return-Path: <linux-kernel-owner+w=401wt.eu-S1759682AbYENFTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759682AbYENFTQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 01:19:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752987AbYENFTB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 01:19:01 -0400
Received: from smtp2a.orange.fr ([80.12.242.140]:7696 "EHLO smtp2a.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752750AbYENFS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 01:18:59 -0400
X-ME-UUID: 20080514051853322.4EBA87000099@mwinf2a24.orange.fr
Message-ID: <482A761F.7020609@cosmosbay.com>
Date: Wed, 14 May 2008 07:18:23 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gianni Tedesco <gxt@cs.nott.ac.uk>, arges@linux.vnet.ibm.com,
       Maynard Johnson <maynardj@us.ibm.com>,
       Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org,
       Fenghua Yu <fenghua.yu@intel.com>, Mike Travis <travis@sgi.com>
Subject: [PATCH] per_cpu: fix DEFINE_PER_CPU_SHARED_ALIGNED for modules
References: <1210593756.3708.7.camel@dao.KWGR614>	 <19f34abd0805120519t12fceef9u7870006a904c85b2@mail.gmail.com>	 <1210599105.3479.1.camel@dao.KWGR614> <48285002.9080702@us.ibm.com>	 <1210610283.7218.4.camel@snuffleupagus>	 <20080513014010.e0723e01.akpm@linux-foundation.org> <1210671688.3472.10.camel@dao.KWGR614> <4829AFCB.9090801@cosmosbay.com>
In-Reply-To: <4829AFCB.9090801@cosmosbay.com>
Content-Type: multipart/mixed;
 boundary="------------020800060102020204020500"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020800060102020204020500
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Andrew,

A typo was included in the patch I sent yesterday, since I was testing :

#ifdef CONFIG_MODULES

while the intention was to test

#ifdef MODULE

So that all SHARED_ALIGNED vmlinux percpu variables still are in the 
special section.
The fix is only needed when compiling modules.

Thank you

[PATCH] per_cpu: fix DEFINE_PER_CPU_SHARED_ALIGNED for modules

Current module loader lookups ".data.percpu" ELF section to perform
per_cpu relocation. But DEFINE_PER_CPU_SHARED_ALIGNED()
uses another section (".data.percpu.shared_aligned"), currently only
handled in vmlinux.lds, not by module loader.

To correct this problem, instead of adding logic into module loader,
or using at build time a module.lds file for all arches to group
".data.percpu.shared_aligned"  into ".data.percpu",
just use ".data.percpu" for modules.

Alignment requirements are correctly handled by ld and module loader.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
---
include/linux/percpu.h |    8 +++++++-
1 files changed, 7 insertions(+), 1 deletion(-)


--------------020800060102020204020500
Content-Type: text/plain;
 name="percpu_shared_aligned.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="percpu_shared_aligned.patch"

diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index d746a2a..4cdd393 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -13,8 +13,14 @@
 	__attribute__((__section__(".data.percpu")))			\
 	PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name
 
+#ifdef MODULE
+#define SHARED_ALIGNED_SECTION ".data.percpu"
+#else
+#define SHARED_ALIGNED_SECTION ".data.percpu.shared_aligned"
+#endif
+
 #define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)			\
-	__attribute__((__section__(".data.percpu.shared_aligned")))	\
+	__attribute__((__section__(SHARED_ALIGNED_SECTION)))		\
 	PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name		\
 	____cacheline_aligned_in_smp
 #else

--------------020800060102020204020500--


