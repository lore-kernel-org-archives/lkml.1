Return-Path: <linux-kernel-owner+w=401wt.eu-S1760349AbZAQGb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760349AbZAQGb0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 01:31:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753241AbZAQGbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 01:31:16 -0500
Received: from hera.kernel.org ([140.211.167.34]:50434 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752036AbZAQGbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 01:31:15 -0500
Message-ID: <49717AE6.9060207@kernel.org>
Date: Sat, 17 Jan 2009 15:29:58 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: roel kluin <roel.kluin@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Brian Gerst <brgerst@gmail.com>, Eric Biederman <ebiederm@xmission.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, travis@sgi.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, steiner@sgi.com,
       Hugh Dickins <hugh@veritas.com>
Subject: [PATCH core/percpu REPOST] linker script: add missing VMLINUX_SYMBOL
References: <20090115122222.GI22850@elte.hu> <496F3577.4020303@kernel.org> <20090115133206.GA31416@elte.hu> <20090115133916.GA3417@elte.hu> <496FB09A.8020808@kernel.org> <496FE2B3.3060706@gmail.com> <496FFE45.1070802@gmail.com> <20090116131601.GA20593@elte.hu> <49708FEA.9000508@gmail.com> <20090116221651.GA32736@elte.hu> <20090116223828.GA9294@elte.hu> <49716F0E.7060605@gmail.com> <49716FBF.7080203@kernel.org>
In-Reply-To: <49716FBF.7080203@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 17 Jan 2009 06:29:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The newly added PERCPU_*() macros define and use __per_cpu_load but
VMLINUX_SYMBOL() was missing from usages causing build failures on
archs where linker visible symbol is different from C symbols
(e.g. blackfin).

Signed-off-by: Tejun Heo <tj@kernel.org>
---
Just realized this was reply to a private mail.  Restoring cc list
and resending.

Thanks.

 include/asm-generic/vmlinux.lds.h |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index e53319c..aa6b9b1 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -432,13 +432,14 @@
 
 #define PERCPU_PROLOG(vaddr)						\
 	VMLINUX_SYMBOL(__per_cpu_load) = .;				\
-	.data.percpu vaddr : AT(__per_cpu_load - LOAD_OFFSET) {		\
+	.data.percpu vaddr : AT(VMLINUX_SYMBOL(__per_cpu_load)		\
+				- LOAD_OFFSET) {			\
 		VMLINUX_SYMBOL(__per_cpu_start) = .;
 
 #define PERCPU_EPILOG(phdr)						\
 		VMLINUX_SYMBOL(__per_cpu_end) = .;			\
 	} phdr								\
-	. = __per_cpu_load + SIZEOF(.data.percpu);
+	. = VMLINUX_SYMBOL(__per_cpu_load) + SIZEOF(.data.percpu);
 
 /**
  * PERCPU_VADDR_PREALLOC - define output section for percpu area with prealloc
-- 
1.6.0.2

