Return-Path: <linux-kernel-owner+w=401wt.eu-S965768AbXCTC3O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965768AbXCTC3O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 22:29:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965792AbXCTC3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 22:29:14 -0400
Received: from mga05.intel.com ([192.55.52.89]:2484 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965768AbXCTC3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 22:29:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,302,1170662400"; 
   d="scan'208"; a="215475014:sNHT19382699"
Subject: Re: SMP performance degradation with sysbench
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Andrea Arcangeli <andrea@suse.de>,
       Anton Blanchard <anton@samba.org>, Rik van Riel <riel@redhat.com>,
       Lorenzo Allegrucci <l_allegrucci@yahoo.it>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>
In-Reply-To: <20070314233301.GK30596@linux-os.sc.intel.com>
References: <20070312220042.GA807@kryten> <45F63266.1080509@yahoo.com.au>
	 <20070313094559.GC8992@v2.random> <45F67796.4040508@yahoo.com.au>
	 <20070313103134.GF8992@v2.random> <45F67F02.5020401@yahoo.com.au>
	 <20070313105742.GG8992@v2.random> <45F68713.9040608@yahoo.com.au>
	 <20070313114215.GI8992@v2.random> <45F6945B.2030309@yahoo.com.au>
	 <20070314233301.GK30596@linux-os.sc.intel.com>
Content-Type: text/plain; charset=utf-8
Date: Tue, 20 Mar 2007 10:29:08 +0800
Message-Id: <1174357748.4448.21.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-14 at 16:33 -0700, Siddha, Suresh B wrote:
> On Tue, Mar 13, 2007 at 05:08:59AM -0700, Nick Piggin wrote:
> > I would agree that it points to MySQL scalability issues, however the
> > fact that such large gains come from tcmalloc is still interesting.
> 
> What glibc version are you, Anton and others are using?
> 
> Does that version has this fix included?
> 
> Dynamically size mmap treshold if the program frees mmaped blocks.
> 
> http://sources.redhat.com/cgi-bin/cvsweb.cgi/libc/malloc/malloc.c.diff?r1=1.158&r2=1.159&cvsroot=glibc
> 
Last week, I reproduced it on RHEL4U3 with glibc 2.3.4-2.19. Today, I
installed RHEL5GA and reproduced it again. RHEL5GA uses glibc 2.5-12 which
already includes the dynamically size mmap threshold patch, so this patch doesn’t
resolve the issue.

The problem is really relevant to malloc/free of glibc multi-thread.

My paxville has 16 logical cpu (dual core+HT). I disabled HT by hot
removing the last 8 logical processors.

I captured the schedule status. When sysbench thread=8 (best performance),
there are about 3.4% context switches caused by __down_read/__down_write_nested.
When sysbench thread=10 (best performance), the percentage becomes 11.83%.

I captured the thread status by gdb. When sysbench thread=10, usually 2 threads
are calling mprotect/mmap. When sysbench thread=8, there are no threads calling
mprotect/mmap. Such capture has random behavior, but I tried for many times.

I think the increased percentage of context switch related to
__down_read/__down_write_nested is caused by mprotect/mmap. mprotect/mmap
accesses the semaphore of vm, so there are some contentions on the sema which
make performance down.

The strace shows mysqld often calls mprotect/mmap with the same data length
61440. That’s another evidence. Gdb showed such mprotect is called by
init_io_malloc=>my_malloc=>malloc=>init_malloc=>mprotect. Mmap is caused by
__init_free=>mmap. I checked the source codes of glibc and found the real call
chains are malloc=>init_malloc=>grow_heap=>mprotect and __init_free=>heap_trim=>mmap.

I guess the transaction processing of mysql/sysbench is: mysql accepts a connection
and initiates a block for the connection. After processing a couple of transactions,
sysbench closes the connection. Then, restart the procedure.

So why are there so many mprotect/mmap?

Glibc uses arena to speedup malloc/free at multi-thread environment.
mp.trim_threshold only controls main_arena. In function __init_free,
FASTBIN_CONSOLIDATION_THRE might be helpful, but it’s a fixed value.

The *ROOT CAUSE* is dynamic thresholds don’t apply to non-main arena.

To verify my idea, I created a small patch. When freeing a block, always
check mp_.trim_threshold even though it might not be in main arena. The
patch is just to verify my idea instead of the final solution.

--- glibc-2.5-20061008T1257_bak/malloc/malloc.c	2006-09-08 00:06:02.000000000 +0800
+++ glibc-2.5-20061008T1257/malloc/malloc.c	2007-03-20 07:41:03.000000000 +0800
@@ -4607,10 +4607,13 @@ _int_free(mstate av, Void_t* mem)
       } else {
 	/* Always try heap_trim(), even if the top chunk is not
 	   large, because the corresponding heap might go away.  */
+	if ((unsigned long)(chunksize(av->top)) >=
+	    (unsigned long)(mp_.trim_threshold)) {
 	heap_info *heap = heap_for_ptr(top(av));
 
 	assert(heap->ar_ptr == av);
 	heap_trim(heap, mp_.top_pad);
+	}
       }
     }
 

With the patch, I recompiled glibc and reran sysbench/mysql. The result is good.
When thread number is larger than 8, the tps and response time(avg) are smooth, and
don't drop severely.

Is there anyone being able to test it on AMD machine?

Yanmin
