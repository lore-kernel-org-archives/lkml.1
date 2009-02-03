Return-Path: <linux-kernel-owner+w=401wt.eu-S1755462AbZBCNlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462AbZBCNlj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 08:41:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753562AbZBCNlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 08:41:15 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:36996 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753153AbZBCNlN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 08:41:13 -0500
Date: Tue, 3 Feb 2009 05:41:10 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@lst.de>, Ingo Molnar <mingo@elte.hu>,
       Pavel Emelyanov <xemul@openvz.org>, Vitaliy Gusev <vgusev@openvz.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] kthreads: rework kthread_stop()
Message-ID: <20090203134110.GC6607@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090130123358.GA26216@redhat.com> <20090130125058.GA26931@redhat.com> <200901312246.07737.rusty@rustcorp.com.au> <20090201102117.GA5728@redhat.com> <m1wsc82033.fsf@fess.ebiederm.org> <20090202194105.GA23141@redhat.com> <m1hc3c19s7.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1hc3c19s7.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 02, 2009 at 07:25:44PM -0800, Eric W. Biederman wrote:
> Oleg Nesterov <oleg@redhat.com> writes:
> 
> > On 02/02, Eric W. Biederman wrote:
> >>
> >> Oleg on that note we should not need a barrier at all. We should be
> >> able to simply say:
> >>
> >> cmplp = k->vfork_done;
> >> if (cmplp){
> >> 	/* if vfork_done is NULL we have passed mm_release */
> >> 	kthread = container_of(cmplp, struct kthread, exited);
> >> 	kthread->should_stop = 1;
> >> 	wake_up_process(k);
> >> 	wait_for_completion(&kthread->exited);
> >> }
> >
> > Yes, but the compiler can read ->vfork_done twice, and turn this code
> > into
> >
> > 	cmplp = k->vfork_done;
> > 	if (cmplp){
> > 		kthread = container_of(k->vfork_done, struct kthread, exited);
> > 		...
> >
> > and when we read k->vfork_done again it can be already NULL.
> > Probably we could use ACCESS_ONCE() instead.
> >
> > Perhaps this barrier() is not needed in practice, but just to be safe.
> 
> Certainly.   I definitely see where you are coming from.
> And of course all of this only works because a pointer is a word size
> so it is read and updated atomically by the compiler.
> 
> I wish we had a good idiom we could use to make it clear what we
> are doing.  The rcu pointer read code perhaps?

ACCESS_ONCE() suffices in many cases, but if the pointer being accessed
points to a structure that might recently have been initialized, then
rcu_dereference() will be required on Alpha.  Though perhaps the
discussion below removes the need entirely, but cannot say that I fully
understand this part of the kernel.

							Thanx, Paul

> > And in fact I saw the bug report with this code:
> >
> > 	ac.ac_tty = current->signal->tty ?
> > 		old_encode_dev(tty_devnum(current->signal->tty)) : 0;
> >
> > this code is wrong anyway, but ->tty was read twice. I specially
> > asked for .s file because I wasn't able to believe the bug manifests
> > itself this way.
> 
> Interesting.
> 
> >> Thinking of it I wish we had someplace we could store a pointer
> >> that would not be cleared so we could remove that whole confusing
> >> conditional.  I just looked through task_struct and there doesn't
> >> appear to be anything promising.
> >>
> >> Perhaps we could rename vfork_done mm_done and not clear it in
> >> mm_release.
> >
> > Yes, in that case we don't need the barrier().
> >
> > I was thinking about changing mm_release() too, but we should clear
> > ->vfork_done (or whatever) in exec_mmap() anyway.
> 
> Yes.  I realized that just after I wrote that.  So clearing
> vfork_done in all cases is a good idea so we don't make get sloppy.
> 
> Eric
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
