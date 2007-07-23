Return-Path: <linux-kernel-owner+w=401wt.eu-S1762658AbXGWVmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762658AbXGWVmT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 17:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754523AbXGWVmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 17:42:07 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:30049 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755221AbXGWVmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 17:42:05 -0400
Subject: Re: v2.6.22.1-rt5
From: Daniel Walker <dwalker@mvista.com>
To: Rui Nuno Capela <rncbc@rncbc.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <46A51D9E.8040104@rncbc.org>
References: <20070723210236.GA25104@elte.hu>  <46A51D9E.8040104@rncbc.org>
Content-Type: text/plain; charset=utf-8
Date: Mon, 23 Jul 2007 14:30:26 -0700
Message-Id: <1185226226.2573.147.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-23 at 22:29 +0100, Rui Nuno Capela wrote:
> Ingo Molnar wrote:
> > we are pleased to announce the v2.6.22.1-rt5 kernel (collected and 
> > assembled by Thomas), which can be downloaded from the usual place:
> >   
> >   http://redhat.com/~mingo/realtime-preempt/
> >   
> > more info about the -rt patchset can be found in the RT wiki:
> >    
> >   http://rt.wiki.kernel.org
> > 
> > Changes since -rt4:
> > 
> >  - MM fix: PCP pages locking (Peter Zijlstra)
> > 
> >  - yield() fix: remove stale RCU-unlock (Daniel Walker)
> > 
> >  - dont do check_pgt_cache() in idle (found by Daniel Walker)
> > 
> >  - moved 8 patches, created 6 new patches out of larger patches to 
> >    make the -rt queue more bisectable (Daniel Walker)
> > 
> >  - cleanup (Daniel Walker)
> > 
> >  - fix the latency tracer under paravirt
> > 
> > to build a 2.6.22.1-rt5 tree, the following patches should be applied:
> >   
> >   http://kernel.org/pub/linux/kernel/v2.6/linux-2.6.22.1.tar.bz2
> >   http://redhat.com/~mingo/realtime-preempt/patch-2.6.22.1-rt5
> >   
> > 	Ingo
> > -
> 
> Maybe I was too quick, but `make all` on is failing here:
> 
> ...
> In file included from arch/i386/mm/pgtable.c:16:
> include/linux/quicklist.h: In function ‘quicklist_alloc’:
> include/linux/quicklist.h:50: warning: unused variable ‘q’
> include/linux/quicklist.h: In function ‘__quicklist_free’:
> include/linux/quicklist.h:79: error: ‘per_cpu__quicklist’ undeclared
> (first use in this function)
> include/linux/quicklist.h:79: error: (Each undeclared identifier is
> reported only once
> include/linux/quicklist.h:79: error: for each function it appears in.)
> include/linux/quicklist.h:79: warning: type defaults to ‘int’ in
> declaration of ‘type name’
> include/linux/quicklist.h:79: error: invalid type argument of ‘unary *’
> make[1]: *** [arch/i386/mm/pgtable.o] Error 1
> make: *** [arch/i386/mm] Error 2

Yeah, the quicklist patch wasn't fully tested .. The delta patch below
is what I had to change to get it working ..

Signed-Off-By: Daniel Walker <dwalker@mvista.com>

diff -u linux-2.6/include/linux/quicklist.h linux-2.6.22.1/include/linux/quicklist.h
--- linux-2.6/include/linux/quicklist.h
+++ linux-2.6.22.1/include/linux/quicklist.h
@@ -47,7 +47,6 @@
 
 static inline void *quicklist_alloc(int nr, gfp_t flags, void (*ctor)(void *))
 {
-	struct quicklist *q;
 	void **p = NULL;
 	int cpu;
 
@@ -66,6 +65,7 @@
 static inline void __quicklist_free(int nr, void (*dtor)(void *), void *p,
 	struct page *page)
 {
+	int cpu;
 	struct quicklist *q;
 	int nid = page_to_nid(page);
 
@@ -76,11 +76,11 @@
 		return;
 	}
 
-	q = &get_cpu_var(quicklist)[nr];
+	q = &get_cpu_var_locked(quicklist, &cpu)[nr];
 	*(void **)p = q->page;
 	q->page = p;
 	q->nr_pages++;
-	put_cpu_var(quicklist);
+	put_cpu_var_locked(quicklist, cpu);
 }
 
 static inline void quicklist_free(int nr, void (*dtor)(void *), void *pp)
diff -u linux-2.6/mm/quicklist.c linux-2.6.22.1/mm/quicklist.c
--- linux-2.6/mm/quicklist.c
+++ linux-2.6.22.1/mm/quicklist.c
@@ -80,7 +80,7 @@
 	struct quicklist *ql, *q;
 
 	for_each_online_cpu(cpu) {
-		ql = per_cpu(quicklist, cpu);
+		ql = per_cpu_var_locked(quicklist, cpu);
 		for (q = ql; q < ql + CONFIG_NR_QUICK; q++)
 			count += q->nr_pages;
 	}


