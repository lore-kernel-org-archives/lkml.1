Return-Path: <linux-kernel-owner+w=401wt.eu-S1765287AbXJZUkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765287AbXJZUkr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 16:40:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764796AbXJZUjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 16:39:51 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:44399 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763539AbXJZUju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 16:39:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=sOk/zT31qVPAvRyB+Y3ChDX3K/UZTek/iM10m81ESznGjN0a6z7uey75C8pSSubfG0E7CKuOgME7ltPpFcyWtoG+jxzTgw3AarmF68+ws3dy9HurNo7vLAfsMqSOLEKuB/wMA6arKqgAstboKSusCyazj38U7GfzmgO+50It7Os=
Date: Sat, 27 Oct 2007 00:39:41 +0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <matthew@wil.cx>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, willy@linux.intel.com,
       Stephane Eranian <eranian@hpl.hp.com>
Subject: Re: [PATCH 2/5] Use macros instead of TASK_ flags
Message-ID: <20071026203941.GA15427@martell.zuzino.mipt.ru>
References: <11932286982175-git-send-email-matthew@wil.cx> <1193228698799-git-send-email-matthew@wil.cx> <20071026114515.6e90222c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071026114515.6e90222c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2007 at 11:45:15AM -0700, Andrew Morton wrote:
> On Wed, 24 Oct 2007 08:24:55 -0400
> Matthew Wilcox <matthew@wil.cx> wrote:
> 
> > Abstracting away direct uses of TASK_ flags allows us to change the
> > definitions of the task flags more easily.

> > --- a/arch/ia64/kernel/perfmon.c
> > +++ b/arch/ia64/kernel/perfmon.c
> > @@ -2631,7 +2631,7 @@ pfm_task_incompatible(pfm_context_t *ctx, struct task_struct *task)
> >  	 */
> >  	if (task == current) return 0;
> >  
> > -	if ((task->state != TASK_STOPPED) && (task->state != TASK_TRACED)) {
> > +	if (!is_task_stopped_or_traced(task)) {
> >  		DPRINT(("cannot attach to non-stopped task [%d] state=%ld\n", task_pid_nr(task), task->state));
> >  		return -EBUSY;
> >  	}
> > @@ -4792,7 +4792,7 @@ recheck:
> >  	 * the task must be stopped.
> >  	 */
> >  	if (PFM_CMD_STOPPED(cmd)) {
> > -		if ((task->state != TASK_STOPPED) && (task->state != TASK_TRACED)) {
> > +		if (!is_task_stopped_or_traced(task)) {
                     ^^^^^^^^^^^^^^^^^^^^^^^^^^

I think this is horrible. Are you going to add full blown static inline
function for every combination of state tests?

> I have dropped this hunk because the file which it is patching is removed
> by the (newly-added-to-mm) git-perfmon.patch.  I can't immediately find any
> corresponding code which was readded in a different place by git-perfmon so
> it looks like this code was simply zapped.
> 
> Of course, if git-perfmon doesn't merge in 2.6.25 then I'll end up merging
> your patch but accidentally leaving 2.6.25's arch/ia64/kernel/perfmon.c
> unpatched.  It looks like that'll be non-fatal.
> 
> This isn't going to go very well and I might end up having to drop this
> whole patch series and ask for a refactored one.  We'll see.
