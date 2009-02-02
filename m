Return-Path: <linux-kernel-owner+w=401wt.eu-S1755883AbZBBTo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883AbZBBTo1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 14:44:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753087AbZBBToS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 14:44:18 -0500
Received: from mx2.redhat.com ([66.187.237.31]:56059 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752971AbZBBToR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 14:44:17 -0500
Date: Mon, 2 Feb 2009 20:41:05 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@lst.de>, Ingo Molnar <mingo@elte.hu>,
       Pavel Emelyanov <xemul@openvz.org>, Vitaliy Gusev <vgusev@openvz.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] kthreads: rework kthread_stop()
Message-ID: <20090202194105.GA23141@redhat.com>
References: <20090130123358.GA26216@redhat.com> <20090130125058.GA26931@redhat.com> <200901312246.07737.rusty@rustcorp.com.au> <20090201102117.GA5728@redhat.com> <m1wsc82033.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1wsc82033.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02, Eric W. Biederman wrote:
>
> Oleg on that note we should not need a barrier at all. We should be
> able to simply say:
>
> cmplp = k->vfork_done;
> if (cmplp){
> 	/* if vfork_done is NULL we have passed mm_release */
> 	kthread = container_of(cmplp, struct kthread, exited);
> 	kthread->should_stop = 1;
> 	wake_up_process(k);
> 	wait_for_completion(&kthread->exited);
> }

Yes, but the compiler can read ->vfork_done twice, and turn this code
into

	cmplp = k->vfork_done;
	if (cmplp){
		kthread = container_of(k->vfork_done, struct kthread, exited);
		...

and when we read k->vfork_done again it can be already NULL.
Probably we could use ACCESS_ONCE() instead.

Perhaps this barrier() is not needed in practice, but just to be safe.
And in fact I saw the bug report with this code:

	ac.ac_tty = current->signal->tty ?
		old_encode_dev(tty_devnum(current->signal->tty)) : 0;

this code is wrong anyway, but ->tty was read twice. I specially
asked for .s file because I wasn't able to believe the bug manifests
itself this way.

> Thinking of it I wish we had someplace we could store a pointer
> that would not be cleared so we could remove that whole confusing
> conditional.  I just looked through task_struct and there doesn't
> appear to be anything promising.
>
> Perhaps we could rename vfork_done mm_done and not clear it in
> mm_release.

Yes, in that case we don't need the barrier().

I was thinking about changing mm_release() too, but we should clear
->vfork_done (or whatever) in exec_mmap() anyway.

Oleg.

