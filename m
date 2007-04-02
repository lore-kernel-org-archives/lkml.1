Return-Path: <linux-kernel-owner+w=401wt.eu-S1752219AbXDBC7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219AbXDBC7R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 22:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752192AbXDBC7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 22:59:17 -0400
Received: from mga05.intel.com ([192.55.52.89]:23352 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752146AbXDBC7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 22:59:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,359,1170662400"; 
   d="scan'208"; a="223125086:sNHT27871676"
Subject: Re: SMP performance degradation with sysbench
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Andrea Arcangeli <andrea@suse.de>,
       Anton Blanchard <anton@samba.org>, Rik van Riel <riel@redhat.com>,
       Lorenzo Allegrucci <l_allegrucci@yahoo.it>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>, drepper@redhat.com
In-Reply-To: <1174357748.4448.21.camel@ymzhang>
References: <20070312220042.GA807@kryten> <45F63266.1080509@yahoo.com.au>
	 <20070313094559.GC8992@v2.random> <45F67796.4040508@yahoo.com.au>
	 <20070313103134.GF8992@v2.random> <45F67F02.5020401@yahoo.com.au>
	 <20070313105742.GG8992@v2.random> <45F68713.9040608@yahoo.com.au>
	 <20070313114215.GI8992@v2.random> <45F6945B.2030309@yahoo.com.au>
	 <20070314233301.GK30596@linux-os.sc.intel.com>
	 <1174357748.4448.21.camel@ymzhang>
Content-Type: text/plain; charset=utf-8
Date: Mon, 02 Apr 2007 10:59:08 +0800
Message-Id: <1175482748.14017.40.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-20 at 10:29 +0800, Zhang, Yanmin wrote:
> On Wed, 2007-03-14 at 16:33 -0700, Siddha, Suresh B wrote:
> > On Tue, Mar 13, 2007 at 05:08:59AM -0700, Nick Piggin wrote:
> > > I would agree that it points to MySQL scalability issues, however the
> > > fact that such large gains come from tcmalloc is still interesting.
> > 
> > What glibc version are you, Anton and others are using?
> > 
> > Does that version has this fix included?
> > 
> > Dynamically size mmap treshold if the program frees mmaped blocks.
> > 
> > http://sources.redhat.com/cgi-bin/cvsweb.cgi/libc/malloc/malloc.c.diff?r1=1.158&r2=1.159&cvsroot=glibc

> The *ROOT CAUSE* is dynamic thresholds don’t apply to non-main arena.
> 
> To verify my idea, I created a small patch. When freeing a block, always
> check mp_.trim_threshold even though it might not be in main arena. The
> patch is just to verify my idea instead of the final solution.
> 
> --- glibc-2.5-20061008T1257_bak/malloc/malloc.c	2006-09-08 00:06:02.000000000 +0800
> +++ glibc-2.5-20061008T1257/malloc/malloc.c	2007-03-20 07:41:03.000000000 +0800
> @@ -4607,10 +4607,13 @@ _int_free(mstate av, Void_t* mem)
>        } else {
>  	/* Always try heap_trim(), even if the top chunk is not
>  	   large, because the corresponding heap might go away.  */
> +	if ((unsigned long)(chunksize(av->top)) >=
> +	    (unsigned long)(mp_.trim_threshold)) {
>  	heap_info *heap = heap_for_ptr(top(av));
>  
>  	assert(heap->ar_ptr == av);
>  	heap_trim(heap, mp_.top_pad);
> +	}
>        }
>      }
>  
> 
I sent a new patch to glibc maintainer, but didn't get response. So resend it here.

Glibc arena is to decrease the malloc/free contention among threads. But arena
chooses to shrink agressively, so also grow agressively. When heaps grow, mprotect
is called. When heaps shrink, mmap is called. In kernel, both mmap and mprotect
need hold the write lock of mm->mmap_sem which introduce new contention. The new
contention actually causes the arena effort to become 0.

Here is a new patch to address this issue.

Signed-off-by: Zhang Yanmin <yanmin.zhang@intel.com>

---

--- glibc-2.5-20061008T1257_bak/malloc/malloc.c	2006-09-08 00:06:02.000000000 +0800
+++ glibc-2.5-20061008T1257/malloc/malloc.c	2007-03-30 09:01:18.000000000 +0800
@@ -4605,12 +4605,13 @@ _int_free(mstate av, Void_t* mem)
 	  sYSTRIm(mp_.top_pad, av);
 #endif
       } else {
-	/* Always try heap_trim(), even if the top chunk is not
-	   large, because the corresponding heap might go away.  */
-	heap_info *heap = heap_for_ptr(top(av));
-
-	assert(heap->ar_ptr == av);
-	heap_trim(heap, mp_.top_pad);
+	if ((unsigned long)(chunksize(av->top)) >=
+	    (unsigned long)(mp_.trim_threshold)) {
+	  heap_info *heap = heap_for_ptr(top(av));
+
+	  assert(heap->ar_ptr == av);
+	  heap_trim(heap, mp_.top_pad);
+	}
       }
     }
 
