Return-Path: <linux-kernel-owner+w=401wt.eu-S932584AbXA1Qwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932584AbXA1Qwt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 11:52:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932622AbXA1Qwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 11:52:49 -0500
Received: from dvhart.com ([64.146.134.43]:41999 "EHLO dvhart.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932584AbXA1Qws (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 11:52:48 -0500
Message-ID: <45BCD4C9.2030302@mbligh.org>
Date: Sun, 28 Jan 2007 08:52:25 -0800
From: "Martin J. Bligh" <mbligh@mbligh.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070104)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] breaking the global file_list_lock
References: <20070128115118.837777000@programming.kicks-ass.net> <20070128144325.GB16552@infradead.org> <20070128152404.GB9196@elte.hu>
In-Reply-To: <20070128152404.GB9196@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Christoph Hellwig <hch@infradead.org> wrote:
> 
>> On Sun, Jan 28, 2007 at 12:51:18PM +0100, Peter Zijlstra wrote:
>>> This patch-set breaks up the global file_list_lock which was found 
>>> to be a severe contention point under basically any filesystem 
>>> intensive workload.
>> Benchmarks, please.  Where exactly do you see contention for this?
> 
> it's the most contended spinlock we have during a parallel kernel 
> compile on an 8-way system. But it's pretty common-sense as well, 
> without doing any measurements, it's basically the only global lock left 
> in just about every VFS workload that doesnt involve massive amount of 
> dentries created/removed (which is still dominated by the dcache_lock).
> 
>> filesystem intensive workload apparently means namespace operation 
>> heavy workload, right?  The biggest bottleneck I've seen with those is 
>> dcache lock.
> 
> the dcache lock is not a problem during kernel compiles. (its 
> rcu-ification works nicely in that workload)

Mmm. not wholly convinced that's true. Whilst i don't have lockmeter
stats to hand, the heavy time in __d_lookup seems to indicate we may
still have a problem to me. I guess we could move the spinlocks out
of line again to test this fairly easily (or get lockmeter upstream).

114076 total                                      0.0545
  57766 default_idle                             916.9206
  11869 prep_new_page                             49.4542
   3830 find_trylock_page                         67.1930
   2637 zap_pte_range                              3.9125
   2486 strnlen_user                              54.0435
   2018 do_page_fault                              1.1941
   1940 do_wp_page                                 1.6973
   1869 __d_lookup                                 7.7231
   1331 page_remove_rmap                           5.2196
   1287 do_no_page                                 1.6108
   1272 buffered_rmqueue                           4.6423
   1160 __copy_to_user_ll                         14.6835
   1027 _atomic_dec_and_lock                      11.1630
    655 release_pages                              1.9670
    644 do_path_lookup                             1.6304
    630 schedule                                   0.4046
    617 kunmap_atomic                              7.7125
    573 __handle_mm_fault                          0.7365
    548 free_hot_page                             78.2857
    500 __copy_user_intel                          3.3784
    483 copy_pte_range                             0.5941
    482 page_address                               2.9571
    478 file_move                                  9.1923
    441 do_anonymous_page                          0.7424
    429 filemap_nopage                             0.4450
    401 anon_vma_unlink                            4.8902
