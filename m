Return-Path: <linux-kernel-owner+w=401wt.eu-S1758558AbYGVX2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758558AbYGVX2u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 19:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756713AbYGVXUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 19:20:06 -0400
Received: from ns1.suse.de ([195.135.220.2]:53216 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756232AbYGVXUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 19:20:04 -0400
Date: Tue, 22 Jul 2008 16:16:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 31/47] slub: Fix use-after-preempt of per-CPU data structure
Message-ID: <20080722231638.GF8282@suse.de>
References: <20080722230208.148102983@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="slub-fix-use-after-preempt-of-per-cpu-data-structure.patch"
In-Reply-To: <20080722231342.GA8282@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>

commit bdb21928512a860a60e6a24a849dc5b63cbaf96a upstream

Vegard Nossum reported a crash in kmem_cache_alloc():

	BUG: unable to handle kernel paging request at da87d000
	IP: [<c01991c7>] kmem_cache_alloc+0xc7/0xe0
	*pde = 28180163 *pte = 1a87d160
	Oops: 0002 [#1] PREEMPT SMP DEBUG_PAGEALLOC
	Pid: 3850, comm: grep Not tainted (2.6.26-rc9-00059-gb190333 #5)
	EIP: 0060:[<c01991c7>] EFLAGS: 00210203 CPU: 0
	EIP is at kmem_cache_alloc+0xc7/0xe0
	EAX: 00000000 EBX: da87c100 ECX: 1adad71a EDX: 6b6b6b6b
	ESI: 00200282 EDI: da87d000 EBP: f60bfe74 ESP: f60bfe54
	DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068

and analyzed it:

  "The register %ecx looks innocent but is very important here. The disassembly:

       mov    %edx,%ecx
       shr    $0x2,%ecx
       rep stos %eax,%es:(%edi) <-- the fault

   So %ecx has been loaded from %edx... which is 0x6b6b6b6b/POISON_FREE.
   (0x6b6b6b6b >> 2 == 0x1adadada.)

   %ecx is the counter for the memset, from here:

       memset(object, 0, c->objsize);

  i.e. %ecx was loaded from c->objsize, so "c" must have been freed.
  Where did "c" come from? Uh-oh...

       c = get_cpu_slab(s, smp_processor_id());

  This looks like it has very much to do with CPU hotplug/unplug. Is
  there a race between SLUB/hotplug since the CPU slab is used after it
  has been freed?"

Good analysis.

Yeah, it's possible that a caller of kmem_cache_alloc() -> slab_alloc()
can be migrated on another CPU right after local_irq_restore() and
before memset().  The inital cpu can become offline in the mean time (or
a migration is a consequence of the CPU going offline) so its
'kmem_cache_cpu' structure gets freed ( slab_cpuup_callback).

At some point of time the caller continues on another CPU having an
obsolete pointer...

Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Reported-by: Vegard Nossum <vegard.nossum@gmail.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/slub.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1575,9 +1575,11 @@ static __always_inline void *slab_alloc(
 	void **object;
 	struct kmem_cache_cpu *c;
 	unsigned long flags;
+	unsigned int objsize;
 
 	local_irq_save(flags);
 	c = get_cpu_slab(s, smp_processor_id());
+	objsize = c->objsize;
 	if (unlikely(!c->freelist || !node_match(c, node)))
 
 		object = __slab_alloc(s, gfpflags, node, addr, c);
@@ -1590,7 +1592,7 @@ static __always_inline void *slab_alloc(
 	local_irq_restore(flags);
 
 	if (unlikely((gfpflags & __GFP_ZERO) && object))
-		memset(object, 0, c->objsize);
+		memset(object, 0, objsize);
 
 	return object;
 }

-- 
