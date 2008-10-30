Return-Path: <linux-kernel-owner+w=401wt.eu-S1753408AbYJ3Eyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408AbYJ3Eyo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 00:54:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751668AbYJ3Eyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 00:54:36 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:14706 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364AbYJ3Eyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 00:54:35 -0400
From: Andrey Mirkin <major@openvz.org>
To: devel@openvz.org
Subject: Re: [Devel] Re: [PATCH 10/10] Add support for multiple processes
Date: Thu, 30 Oct 2008 08:55:03 +0400
User-Agent: KMail/1.8.2
Cc: Oren Laadan <orenl@cs.columbia.edu>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
References: <1224285098-573-1-git-send-email-major@openvz.org> <1224285098-573-11-git-send-email-major@openvz.org> <4905E50C.8020803@cs.columbia.edu>
In-Reply-To: <4905E50C.8020803@cs.columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810300755.05077.major@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 October 2008 18:58 Oren Laadan wrote:
> Andrey Mirkin wrote:
> > The whole tree of processes can be checkpointed and restarted now.
> > Shared objects are not supported yet.
> >
> > Signed-off-by: Andrey Mirkin <major@openvz.org>
> > ---
> >  checkpoint/cpt_image.h   |    2 +
> >  checkpoint/cpt_process.c |   24 +++++++++++++
> >  checkpoint/rst_process.c |   85
> > +++++++++++++++++++++++++++------------------- 3 files changed, 76
> > insertions(+), 35 deletions(-)
> >
> > diff --git a/checkpoint/cpt_image.h b/checkpoint/cpt_image.h
> > index e1fb483..f370df2 100644
> > --- a/checkpoint/cpt_image.h
> > +++ b/checkpoint/cpt_image.h
> > @@ -128,6 +128,8 @@ struct cpt_task_image {
> >  	__u64	cpt_nivcsw;
> >  	__u64	cpt_min_flt;
> >  	__u64	cpt_maj_flt;
> > +	__u32	cpt_children_num;
> > +	__u32	cpt_pad;
> >  } __attribute__ ((aligned (8)));
> >
> >  struct cpt_mm_image {
> > diff --git a/checkpoint/cpt_process.c b/checkpoint/cpt_process.c
> > index 1f7a54b..d73ec3c 100644
> > --- a/checkpoint/cpt_process.c
> > +++ b/checkpoint/cpt_process.c
> > @@ -40,6 +40,19 @@ static unsigned int encode_task_flags(unsigned int
> > task_flags)
> >
> >  }
> >
> > +static int cpt_count_children(struct task_struct *tsk, struct
> > cpt_context *ctx) +{
> > +	int num = 0;
> > +	struct task_struct *child;
> > +
> > +	list_for_each_entry(child, &tsk->children, sibling) {
> > +		if (child->parent != tsk)
> > +			continue;
> > +		num++;
> > +	}
> > +	return num;
> > +}
> > +
>
> I noticed that don't take the appropriate locks when browsing through
> tasks lists (siblings, children, global list). Although I realize that
> the container should be frozen at this time, I keep wondering if this
> is indeed always safe.
You right here. We need to take tasklist_lock to be sure that everything will 
be consistent.

> For instance, are you protected against an OOM killer that might just
> occur uninvited and kill one of those tasks ?

OOM killer can't kill one of those tasks as all of them should be frozen at 
that time and be in uninterruptible state. So, we can just do not think about 
OOM at that time. But anyway you right and we need locking around browsing 
tasks list.

> Can the administrator force an un-freeze of the container ?  Or perhaps
> some error condition if the kernel cause that ?

The main idea is that context should be protected with a mutex and only one 
process can do some activity (freeze, dump, unfreeze, kill) with a container. 
Right now it is not implemented at all, but in future it will be added.

Andrey

> >  int cpt_dump_task_struct(struct task_struct *tsk, struct cpt_context
> > *ctx) {
> >  	struct cpt_task_image *t;
> > @@ -102,6 +115,7 @@ int cpt_dump_task_struct(struct task_struct *tsk,
> > struct cpt_context *ctx) t->cpt_egid = tsk->egid;
> >  	t->cpt_sgid = tsk->sgid;
> >  	t->cpt_fsgid = tsk->fsgid;
> > +	t->cpt_children_num = cpt_count_children(tsk, ctx);
> >
> >  	err = ctx->write(t, sizeof(*t), ctx);
> >
> > @@ -231,6 +245,16 @@ int cpt_dump_task(struct task_struct *tsk, struct
> > cpt_context *ctx) err = cpt_dump_fpustate(tsk, ctx);
> >  	if (!err)
> >  		err = cpt_dump_registers(tsk, ctx);
> > +	if (!err) {
> > +		struct task_struct *child;
> > +		list_for_each_entry(child, &tsk->children, sibling) {
> > +			if (child->parent != tsk)
> > +				continue;
> > +			err = cpt_dump_task(child, ctx);
> > +			if (err)
> > +				break;
>
> Here too.
>
> [...]
>
> Oren.
>
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/containers
>
> _______________________________________________
> Devel mailing list
> Devel@openvz.org
> https://openvz.org/mailman/listinfo/devel
