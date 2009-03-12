Return-Path: <linux-kernel-owner+w=401wt.eu-S1753908AbZCLENt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908AbZCLENt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 00:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750943AbZCLENj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 00:13:39 -0400
Received: from ns.suse.de ([195.135.220.2]:50728 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742AbZCLENi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 00:13:38 -0400
Date: Thu, 12 Mar 2009 05:13:34 +0100
From: Nick Piggin <npiggin@suse.de>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 1/2] fs: mnt_want_write speedup
Message-ID: <20090312041334.GB1893@wotan.suse.de>
References: <20090310143718.GB15977@wotan.suse.de> <1236809477.30142.83.camel@nimitz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236809477.30142.83.camel@nimitz>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 03:11:17PM -0700, Dave Hansen wrote:
> I'm feeling a bit better about these, although I am still honestly quite
> afraid of the barriers.  I also didn't like all the #ifdefs much, but
> here's some help on that.

FWIW, we have this in suse kernels because page fault performance was
so bad compared with SLES10. mnt_want_write & co was I think the 2nd
biggest offender for file backed mappings (after pvops). I think we're
around parity again even with pvops.

Basically I think we have to improve this one way or another in mainline
too. Is there any way to make you feel better about the barriers? More
comments?

mnt_make_readonly()                    mnt_want_write()
1. mnt_flags |= MNT_WRITE_HOLD         A. mnt_writers[x]++
2. smp_mb()                            B. smp_mb()
3. count += mnt_writers[0]             C. while (mnt_flags & MNT_WRITE_HOLD) ;
   ...                                 D. smp_rmb()
   count += mnt_writers[N]             E. if (mnt_flags & MNT_READONLY)
4. if (count == 0)                     F.    mnt_writers[x]-- /* fail */
5.     mnt_flags |= MNT_READONLY       G. else /* success */
6. else /* fail */
7. smp_wmb()
8. mnt_flags &= ~MNT_WRITE_HOLD

* 2 ensures that 1 is visible before 3 is loaded
* B ensures that A is visible before C is loaded
* Therefore, either count != 0 at 4, or C will loop (or both)
* If count == 0
  * (make_readonly success)
  * C will loop until 8
  * D ensures E is not loaded until loop ends
  * 7 ensures 5 is visible before 8 is
  * Therefore E will find MNT_READONLY (want_write fail)
* If C does not loop
  * 4 will find count != 0 (make_readonly fail)
  * Therefore 5 is not executed.
  * Therefore E will not find MNT_READONLY (want_write success)
* If count != 0 and C loops
  * (make_readonly fail)
  * 5 will not be executed
  * Therefore E will not find MNT_READONLY (want_write success)

I don't know if that helps (I should reference which statements rely
on which). I think it shows that either one or the other only must
succeed.

It does not illustrate how the loop in the want_write side prevents
the sumation from getting confused by decrementing count on a different
CPU than it was incremented, but I've commented that case in the code
fairly well I think.


> How about this on top of what you have as a bit of a cleanup?  It gets
> rid of all the new #ifdefs in .c files?
> 
> Did I miss the use of get_mnt_writers_ptr()?  I don't think I actually
> saw it used anywhere in this pair of patches, so I've stolen it.  I
> think gcc should compile all this new stuff down to be basically the
> same as you had before.  The one thing I'm not horribly sure of is the
> "out_free_devname:" label.  It shouldn't be reachable in the !SMP case. 
> 
> I could also consolidate the header #ifdefs into a single one if you
> think that looks better.

I don't like the get_mnt_writers_ptr terribly. The *_mnt_writers functions
are quite primitive and just happen to be in the .c file because they're
private to it. The alloc/free_mnt_writers is good (they could be
in the .c file too?).

Another thing I should probably do is slash away most of the crap from
mnt_want_write in the UP case. It only needs to do a preempt_disable,
test MNT_READONLY, increment mnt_writers (and similarly for mnt_make_readonly)
