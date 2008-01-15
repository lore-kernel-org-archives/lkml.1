Return-Path: <linux-kernel-owner+w=401wt.eu-S1756713AbYAOKB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713AbYAOKB0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 05:01:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753134AbYAOKAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 05:00:43 -0500
Received: from mx1.suse.de ([195.135.220.2]:56470 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752611AbYAOKAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 05:00:40 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Jan Beulich" <jbeulich@novell.com>
Subject: Re: [PATCH] [12/31] CPA: CLFLUSH support in change_page_attr()
Date: Tue, 15 Jan 2008 10:57:39 +0100
User-Agent: KMail/1.9.6
Cc: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
References: <200801141116.534682000@suse.de> <20080114221644.816F314F83@wotan.suse.de> <478C7F8B.76E4.0078.0@novell.com>
In-Reply-To: <478C7F8B.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801151057.39164.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 January 2008 09:40:27 Jan Beulich wrote:
> >-	/* clflush is still broken. Disable for now. */
> >-	if (1 || !cpu_has_clflush)
> >+	if (a->full_flush)
> > 		asm volatile("wbinvd" ::: "memory");
> >-	else list_for_each_entry(pg, l, lru) {
> >-		void *adr = page_address(pg);
> >-		clflush_cache_range(adr, PAGE_SIZE);
> >+	list_for_each_entry(f, &a->l, l) {
> >+		if (!a->full_flush)
> 
> This if() looks redundant (could also be avoided in the 32-bit variant, but
> isn't redundant there at present). Also, is there no
> wbinvd() on 64bit?

That's all done in a later patch.

The transformation steps are not always ideal, but in the end the code
is ok I think.

-Andi

The final result of the series is for 32bit & flush_kernel_map:

 static void flush_kernel_map(void *arg)
 {
-       struct list_head *lh = (struct list_head *)arg;
-       struct page *p;
+       struct flush_arg *a = (struct flush_arg *)arg;
+       struct flush *f;
+       int cache_flush = a->full_flush == FLUSH_CACHE;
+
+       list_for_each_entry(f, &a->l, l) {
+               if (!a->full_flush)
+                       __flush_tlb_one(f->addr);
+               if (f->mode == FLUSH_CACHE && !cpu_has_ss) {
+                       if (cpu_has_clflush)
+                               clflush_cache_range((void *)f->addr, PAGE_SIZE);
+                       else
+                               cache_flush++;
+               }
+       }
 
-       /* High level code is not ready for clflush yet */
-       if (0 && cpu_has_clflush) {
-               list_for_each_entry (p, lh, lru)
-                       cache_flush_page(p);
-       } else if (boot_cpu_data.x86_model >= 4)
-               wbinvd();
+       if (a->full_flush)
+               __flush_tlb_all();
 
-       /* Flush all to work around Errata in early athlons regarding 
-        * large page flushing. 
+       /*
+        * RED-PEN: Intel documentation ask for a CPU synchronization step
+        * here and in the loop. But it is moot on Self-Snoop CPUs anyways.
         */
-       __flush_tlb_all();      
+
+       if (cache_flush > 0 && !cpu_has_ss && boot_cpu_data.x86_model >= 4)
+               wbinvd();
 }

