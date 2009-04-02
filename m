Return-Path: <linux-kernel-owner+w=401wt.eu-S932809AbZDBSW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932809AbZDBSW0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 14:22:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760905AbZDBSWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 14:22:15 -0400
Received: from cantor.suse.de ([195.135.220.2]:58620 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760029AbZDBSWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 14:22:14 -0400
Date: Thu, 2 Apr 2009 20:22:10 +0200
From: Nick Piggin <npiggin@suse.de>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 1/2] fs: mnt_want_write speedup
Message-ID: <20090402182210.GB17175@wotan.suse.de>
References: <20090310143718.GB15977@wotan.suse.de> <1236809477.30142.83.camel@nimitz> <20090312041334.GB1893@wotan.suse.de> <1237403623.8286.196.camel@nimitz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237403623.8286.196.camel@nimitz>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 18, 2009 at 12:13:43PM -0700, Dave Hansen wrote:
> On Thu, 2009-03-12 at 05:13 +0100, Nick Piggin wrote: 
> > On Wed, Mar 11, 2009 at 03:11:17PM -0700, Dave Hansen wrote:
> > > I'm feeling a bit better about these, although I am still honestly quite
> > > afraid of the barriers.  I also didn't like all the #ifdefs much, but
> > > here's some help on that.
> > 
> > FWIW, we have this in suse kernels because page fault performance was
> > so bad compared with SLES10. mnt_want_write & co was I think the 2nd
> > biggest offender for file backed mappings (after pvops). I think we're
> > around parity again even with pvops.
> 
> Page faults themselves?  Which path was that from?

Yes. file_update_time.

 
> > Basically I think we have to improve this one way or another in mainline
> > too. Is there any way to make you feel better about the barriers? More
> > comments?
> > 
> > mnt_make_readonly()                    mnt_want_write()
> > 1. mnt_flags |= MNT_WRITE_HOLD         A. mnt_writers[x]++
> > 2. smp_mb()                            B. smp_mb()
> > 3. count += mnt_writers[0]             C. while (mnt_flags & MNT_WRITE_HOLD) ;
> >    ...                                 D. smp_rmb()
> >    count += mnt_writers[N]             E. if (mnt_flags & MNT_READONLY)
> > 4. if (count == 0)                     F.    mnt_writers[x]-- /* fail */
> > 5.     mnt_flags |= MNT_READONLY       G. else /* success */
> > 6. else /* fail */
> > 7. smp_wmb()
> > 8. mnt_flags &= ~MNT_WRITE_HOLD
> > 
> > * 2 ensures that 1 is visible before 3 is loaded
> > * B ensures that A is visible before C is loaded
> > * Therefore, either count != 0 at 4, or C will loop (or both)
> > * If count == 0
> >   * (make_readonly success)
> >   * C will loop until 8
> >   * D ensures E is not loaded until loop ends
> >   * 7 ensures 5 is visible before 8 is
> >   * Therefore E will find MNT_READONLY (want_write fail)
> > * If C does not loop
> >   * 4 will find count != 0 (make_readonly fail)
> >   * Therefore 5 is not executed.
> >   * Therefore E will not find MNT_READONLY (want_write success)
> > * If count != 0 and C loops
> >   * (make_readonly fail)
> >   * 5 will not be executed
> >   * Therefore E will not find MNT_READONLY (want_write success)
> 
> It is great to spell it out like that.  But, honestly, I think the code
> and comments that are there are probably better than looking at an out
> of line description like that.  

Well I think the above gives a higher confidence of correctness
than the code and comments posted (at least, until the reader
workss through similar steps themselves). At least if you don't
like it, then it could just go int othe patch changelog.

 
> > I don't know if that helps (I should reference which statements rely
> > on which). I think it shows that either one or the other only must
> > succeed.
> > 
> > It does not illustrate how the loop in the want_write side prevents
> > the sumation from getting confused by decrementing count on a different
> > CPU than it was incremented, but I've commented that case in the code
> > fairly well I think.
> 
> I think you mentioned a seqlock being a possibility here.  That would
> slot in as a replacement for MNT_WRITE_HOLD, right?  mnt_make_readonly()
> takes a seq_write, mnt_want_write() takes a seq_read and doesn't
> consider MNT_READONLY valid until it gets a clear read of it.  It would
> internalize all the barriers into the seqlock implementation except for
> the mnt_writers[]-related ones.
> 
> As for mnt_writers, you'd need an smp_rmb() in mnt_make_readonly()
> before reading the counters and an smp_wmb() after writing the counter
> in mnt_want_write().
> 
> Is see that those are effectively consolidated down in your version into
> a single smp_mb() at both call sites when combined with the
> MNT_WRITE_HOLD barriers.
> 
> If we can get this down to two explicit calls to the barrier functions
> that paired and very clear, I think I'd be much more OK with it.

seqlock as I said doesn't get its barriers quite right for having
stores in the read protected section. I was musing the possibility,
but I think it ends up being less clear if you just end up having
to a) look at seqlock implementation, b) work out it is insufficnet,
c) add barriers to make up for it. May as well just open code it
here with sufficient comment to justify correctness (which I think
I have come up with).

