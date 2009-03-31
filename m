Return-Path: <linux-kernel-owner+w=401wt.eu-S1762339AbZCaQTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762339AbZCaQTs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 12:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760694AbZCaQTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 12:19:35 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:47836 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458AbZCaQTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 12:19:34 -0400
Date: Tue, 31 Mar 2009 12:12:26 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Ingo Molnar <mingo@elte.hu>
cc: Tejun Heo <tj@kernel.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>,
       rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com,
       Paul Mundt <lethal@linux-sh.org>, rmk@arm.linux.org.uk,
       starvik@axis.com, ralf@linux-mips.org, davem@davemloft.net,
       cooloney@kernel.org, kyle@mcmartin.ca, matthew@wil.cx,
       grundler@parisc-linux.org, takata@linux-m32r.org,
       benh@kernel.crashing.org, rth@twiddle.net, ink@jurassic.park.msu.ru,
       heiko.carstens@de.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH UPDATED] percpu: use dynamic percpu allocator as the
 default percpu allocator
In-Reply-To: <alpine.DEB.1.10.0903301049060.13333@qirst.com>
Message-ID: <alpine.DEB.1.10.0903311208110.17960@qirst.com>
References: <1236671631-9305-1-git-send-email-tj@kernel.org> <20090316190132.7965a49a@skybase> <49C300D8.5080204@kernel.org> <49C8FAC4.6060508@kernel.org> <20090325122738.42d105b7@skybase> <49CA1AC3.9080908@kernel.org> <20090325150035.541e707a@skybase>
 <49CA3C2C.5030702@kernel.org> <49D099F0.3000807@kernel.org> <20090330114938.GB10070@elte.hu> <alpine.DEB.1.10.0903301049060.13333@qirst.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I reviewed the new per cpu allocator. Quite extensive work. Found two
issues that I would like to have addressed. But basically:

Reviewed-by: Christoph Lameter <cl@linux.com>


Two issues

1. Lot of unnecessary use of __read_mostly for local static variables that
are not on the hotpath. Patch follows in this message.

2. rbtree is not necessary since we can link back through the an available
field in struct page. Patch in next message.



Subject: Remove __read_mostly from percpu allocator symbols.

__read_mostly is reserved for hot code path items. The percpu variables
are used in allocation and freeing of percpu items which are typically
not hot code paths. It also reduces the cache footprint of the percpu
allocator if the variables are placed near each other. __read_mostly
would move a portion of the variable into a different linker section.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 mm/percpu.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

Index: linux-2.6/mm/percpu.c
===================================================================
--- linux-2.6.orig/mm/percpu.c	2009-03-31 10:59:34.000000000 -0500
+++ linux-2.6/mm/percpu.c	2009-03-31 11:11:22.000000000 -0500
@@ -100,14 +100,14 @@ struct pcpu_chunk {
 	struct page		*page_ar[];	/* #cpus * UNIT_PAGES */
 };

-static int pcpu_unit_pages __read_mostly;
-static int pcpu_unit_size __read_mostly;
-static int pcpu_chunk_size __read_mostly;
-static int pcpu_nr_slots __read_mostly;
-static size_t pcpu_chunk_struct_size __read_mostly;
+static int pcpu_unit_pages;
+static int pcpu_unit_size;
+static int pcpu_chunk_size;
+static int pcpu_nr_slots;
+static size_t pcpu_chunk_struct_size;

 /* the address of the first chunk which starts with the kernel static area */
-void *pcpu_base_addr __read_mostly;
+void *pcpu_base_addr;
 EXPORT_SYMBOL_GPL(pcpu_base_addr);

 /* optional reserved chunk, only accessible for reserved allocations */
@@ -139,7 +139,7 @@ static int pcpu_reserved_chunk_limit;
 static DEFINE_MUTEX(pcpu_alloc_mutex);	/* protects whole alloc and reclaim */
 static DEFINE_SPINLOCK(pcpu_lock);	/* protects index data structures */

-static struct list_head *pcpu_slot __read_mostly; /* chunk list slots */
+static struct list_head *pcpu_slot; /* chunk list slots */
 static struct rb_root pcpu_addr_root = RB_ROOT;	/* chunks by address */

 /* reclaim work to release fully free chunks, scheduled from free path */
