Return-Path: <linux-kernel-owner+w=401wt.eu-S1753664AbYKHCr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664AbYKHCr1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 21:47:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751565AbYKHCrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 21:47:19 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47680 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751311AbYKHCrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 21:47:18 -0500
Date: Fri, 7 Nov 2008 18:46:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, David Miller <davem@davemloft.net>,
       LKML <linux-kernel@vger.kernel.org>, maneesh@in.ibm.com,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Srinivasa Ds <srinivasa@in.ibm.com>
Subject: Re: [PATCH] kprobe: increase kprobe_hash_table size
Message-Id: <20081107184629.97eb5ec3.akpm@linux-foundation.org>
In-Reply-To: <4914FA8D.4000607@redhat.com>
References: <4914D2DE.9030603@redhat.com>
	<20081107155646.b375413e.akpm@linux-foundation.org>
	<4914DAEE.2050301@redhat.com>
	<20081107170307.1a4f815e.akpm@linux-foundation.org>
	<4914FA8D.4000607@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Nov 2008 21:33:49 -0500 Masami Hiramatsu <mhiramat@redhat.com> wrote:

> Not really. Hmm, I have to investigate more on this problem.

OK ;)

Meanwhile, how does this look?



From: Andrew Morton <akpm@linux-foundation.org>

We only need the cacheline padding on SMP kernels.  Saves 6k:

   text    data     bss     dec     hex filename
   5713     388    2632    8733    221d kernel/kprobes.o
   5713     388    8840   14941    3a5d kernel/kprobes.o

Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kprobes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/kprobes.c~a kernel/kprobes.c
--- a/kernel/kprobes.c~a
+++ a/kernel/kprobes.c
@@ -72,7 +72,7 @@ static bool kprobe_enabled;
 DEFINE_MUTEX(kprobe_mutex);		/* Protects kprobe_table */
 static DEFINE_PER_CPU(struct kprobe *, kprobe_instance) = NULL;
 static struct {
-	spinlock_t lock ____cacheline_aligned;
+	spinlock_t lock ____cacheline_aligned_in_smp;
 } kretprobe_table_locks[KPROBE_TABLE_SIZE];
 
 static spinlock_t *kretprobe_table_lock_ptr(unsigned long hash)
_

