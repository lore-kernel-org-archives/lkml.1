Return-Path: <linux-kernel-owner+w=401wt.eu-S1757592AbZFARam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757592AbZFARam (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 13:30:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751554AbZFARae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 13:30:34 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:40343 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbZFARad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 13:30:33 -0400
Date: Mon, 1 Jun 2009 10:30:30 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Matt Helsley <matthltc@us.ibm.com>, xemul@parallels.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       dave@linux.vnet.ibm.com, mingo@elte.hu, torvalds@linux-foundation.org
Subject: Re: [PATCH 14/38] Remove struct mm_struct::exe_file et al
Message-ID: <20090601173030.GL9285@us.ibm.com>
References: <20090526113618.GJ28083@us.ibm.com> <20090526162415.fb9cefef.akpm@linux-foundation.org> <20090531215427.GA29534@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090531215427.GA29534@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 01, 2009 at 01:54:27AM +0400, Alexey Dobriyan wrote:
> On Tue, May 26, 2009 at 04:24:15PM -0700, Andrew Morton wrote:
> > On Tue, 26 May 2009 04:36:18 -0700
> > Matt Helsley <matthltc@us.ibm.com> wrote:
> > 
> > > I don't see any mention in the changelog of the point brought up by Ingo:
> > > 
> > > http://lkml.org/lkml/2009/4/10/105
> > 
> > Nor of Eric's comments.
> > 
> > Alexey, pleeeze don't do this.  We (read: I) heavily depend upon patch
> > submitters to keep track of outstanding issues and review comments,
> > etc.
> > 
> > If the patch submitter simply blows these things off then it devolves
> > to me having to keep track of each patch's issue list as well as the
> > patch itself.  My workload goes up by a factor of N and the error rate
> > goes up by N^2 :(
> 
> grmbh..
> 
> "Security" and "holding ->mmap_sem" were answered and dismissed.
> 
> You can't do readlink(2) on /proc/*/exe if you can't ptrace task.
> So no new possible holes are created.

Yes, I messed up: you answered the security question.

I still like that exe_file avoids the VMA walk with mmap_sem held. Holding
mmap_sem seems like a bigger performance difference than adding a branch
based on vm_flags in the VMA add/remove/split/merge code. Wouldn't vm_flags
be cache-hot? If so the typical cost added is an && and the branch
itself. Performance-related side effects of those are extra instruction fetches
and, perhaps most of all, typical branch costs like pipeline stalls and
flushes.

I suspect you could avoid most of the hypothesized performance difference
introduced by exe_file (if it's even measurable) by marking the branch
unlikely(). I guess that flag is unlikely since it's only applied
during exec by the kernel, the splits or removals of these areas are
probably near-constant in number, and they usually take place shortly after
exec anyway.

Of course if branch prediction hardware is very good then it may be
even better to leave these alone.

> 
> ->mmap_sem was held since /proc/*/exe was added and nobody cared.

"nobody cared" isn't a good reason to put it back. That kind of argument just
as easily supports exe_file: "I added code to the VMA paths and nobody cared."
Of course now you care about these changes to the VMA paths and I care
about holding mmap_sem...

> And, again, you can't readlink _any_ /proc/*/exe.

Yup. Sorry about that again.

In summary: I think the performance benefits of this patch have yet to be
established and really the only benefit I agree with is the nice reduction
in code.

Cheers,
	-Matt Helsley
