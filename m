Return-Path: <linux-kernel-owner+w=401wt.eu-S1758142AbYAHJHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758142AbYAHJHf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 04:07:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750902AbYAHJHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 04:07:21 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59347 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758AbYAHJHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 04:07:19 -0500
Date: Tue, 8 Jan 2008 10:07:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: travis@sgi.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Christoph Lameter <clameter@sgi.com>, Jack Steiner <steiner@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/10] percpu: Per cpu code simplification V3
Message-ID: <20080108090702.GB27671@elte.hu>
References: <20080108021142.585467000@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080108021142.585467000@sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* travis@sgi.com <travis@sgi.com> wrote:

> This patchset simplifies the code that arches need to maintain to 
> support per cpu functionality. Most of the code is moved into arch 
> independent code. Only a minimal set of definitions is kept for each 
> arch.
> 
> The patch also unifies the x86 arch so that there is only a single 
> asm-x86/percpu.h
> 
> V1->V2:
> - Add support for specifying attributes for per cpu declarations (preserves
>   IA64 model(small) attribute).
>   - Drop first patch that removes the model(small) attribute for IA64
>   - Missing #endif in powerpc generic config /  Wrong Kconfig
>   - Follow Randy's suggestions on how to do the Kconfig settings
> 
> V2->V3:
>   - fix x86_64 non-SMP case
>   - change SHIFT_PTR to SHIFT_PERCPU_PTR
>   - fix various percpu_modcopy()'s to reference correct per_cpu_offset()
>   - s390 has a special way to determine the pointer to a per cpu area

thanks, i've picked up the x86 and core bits, for testing.

i had the patch below for v2, it's still needed (because i didnt apply 
the s390/etc. bits), right?

	Ingo

------------->
Subject: x86: let other arches build
From: Ingo Molnar <mingo@elte.hu>

let architectures which still have the DEFINE_PER_CPU/etc. build
properly.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/percpu.h |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-x86.q/include/linux/percpu.h
===================================================================
--- linux-x86.q.orig/include/linux/percpu.h
+++ linux-x86.q/include/linux/percpu.h
@@ -14,6 +14,7 @@
 #endif
 
 #ifdef CONFIG_SMP
+#ifndef DEFINE_PER_CPU
 #define DEFINE_PER_CPU(type, name)					\
 	__attribute__((__section__(".data.percpu")))			\
 	PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name
@@ -32,6 +33,7 @@
 
 #define EXPORT_PER_CPU_SYMBOL(var) EXPORT_SYMBOL(per_cpu__##var)
 #define EXPORT_PER_CPU_SYMBOL_GPL(var) EXPORT_SYMBOL_GPL(per_cpu__##var)
+#endif
 
 /* Enough to cover all DEFINE_PER_CPUs in kernel, including modules. */
 #ifndef PERCPU_ENOUGH_ROOM
