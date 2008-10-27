Return-Path: <linux-kernel-owner+w=401wt.eu-S1752619AbYJ0P6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbYJ0P6i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 11:58:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751346AbYJ0P6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 11:58:30 -0400
Received: from serrano.cc.columbia.edu ([128.59.29.6]:57051 "EHLO
	serrano.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbYJ0P6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 11:58:30 -0400
Message-ID: <4905E50C.8020803@cs.columbia.edu>
Date: Mon, 27 Oct 2008 11:58:04 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Andrey Mirkin <major@openvz.org>
CC: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [PATCH 10/10] Add support for multiple processes
References: <1224285098-573-1-git-send-email-major@openvz.org>	<1224285098-573-2-git-send-email-major@openvz.org>	<1224285098-573-3-git-send-email-major@openvz.org>	<1224285098-573-4-git-send-email-major@openvz.org>	<1224285098-573-5-git-send-email-major@openvz.org>	<1224285098-573-6-git-send-email-major@openvz.org>	<1224285098-573-7-git-send-email-major@openvz.org>	<1224285098-573-8-git-send-email-major@openvz.org>	<1224285098-573-9-git-send-email-major@openvz.org>	<1224285098-573-10-git-send-email-major@openvz.org> <1224285098-573-11-git-send-email-major@openvz.org>
In-Reply-To: <1224285098-573-11-git-send-email-major@openvz.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Andrey Mirkin wrote:
> The whole tree of processes can be checkpointed and restarted now.
> Shared objects are not supported yet.
> 
> Signed-off-by: Andrey Mirkin <major@openvz.org>
> ---
>  checkpoint/cpt_image.h   |    2 +
>  checkpoint/cpt_process.c |   24 +++++++++++++
>  checkpoint/rst_process.c |   85 +++++++++++++++++++++++++++-------------------
>  3 files changed, 76 insertions(+), 35 deletions(-)
> 
> diff --git a/checkpoint/cpt_image.h b/checkpoint/cpt_image.h
> index e1fb483..f370df2 100644
> --- a/checkpoint/cpt_image.h
> +++ b/checkpoint/cpt_image.h
> @@ -128,6 +128,8 @@ struct cpt_task_image {
>  	__u64	cpt_nivcsw;
>  	__u64	cpt_min_flt;
>  	__u64	cpt_maj_flt;
> +	__u32	cpt_children_num;
> +	__u32	cpt_pad;
>  } __attribute__ ((aligned (8)));
>  
>  struct cpt_mm_image {
> diff --git a/checkpoint/cpt_process.c b/checkpoint/cpt_process.c
> index 1f7a54b..d73ec3c 100644
> --- a/checkpoint/cpt_process.c
> +++ b/checkpoint/cpt_process.c
> @@ -40,6 +40,19 @@ static unsigned int encode_task_flags(unsigned int task_flags)
>  		
>  }
>  
> +static int cpt_count_children(struct task_struct *tsk, struct cpt_context *ctx)
> +{
> +	int num = 0;
> +	struct task_struct *child;
> +
> +	list_for_each_entry(child, &tsk->children, sibling) {
> +		if (child->parent != tsk)
> +			continue;
> +		num++;
> +	}
> +	return num;
> +}
> +

I noticed that don't take the appropriate locks when browsing through
tasks lists (siblings, children, global list). Although I realize that
the container should be frozen at this time, I keep wondering if this
is indeed always safe.

For instance, are you protected against an OOM killer that might just
occur uninvited and kill one of those tasks ?

Can the administrator force an un-freeze of the container ?  Or perhaps
some error condition if the kernel cause that ?

>  int cpt_dump_task_struct(struct task_struct *tsk, struct cpt_context *ctx)
>  {
>  	struct cpt_task_image *t;
> @@ -102,6 +115,7 @@ int cpt_dump_task_struct(struct task_struct *tsk, struct cpt_context *ctx)
>  	t->cpt_egid = tsk->egid;
>  	t->cpt_sgid = tsk->sgid;
>  	t->cpt_fsgid = tsk->fsgid;
> +	t->cpt_children_num = cpt_count_children(tsk, ctx);
>  
>  	err = ctx->write(t, sizeof(*t), ctx);
>  
> @@ -231,6 +245,16 @@ int cpt_dump_task(struct task_struct *tsk, struct cpt_context *ctx)
>  		err = cpt_dump_fpustate(tsk, ctx);
>  	if (!err)
>  		err = cpt_dump_registers(tsk, ctx);
> +	if (!err) {
> +		struct task_struct *child;
> +		list_for_each_entry(child, &tsk->children, sibling) {
> +			if (child->parent != tsk)
> +				continue;
> +			err = cpt_dump_task(child, ctx);
> +			if (err)
> +				break;

Here too.

[...]

Oren.

