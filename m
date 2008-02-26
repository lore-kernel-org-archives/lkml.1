Return-Path: <linux-kernel-owner+w=401wt.eu-S1760213AbYBZNU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760213AbYBZNU4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 08:20:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752723AbYBZNUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 08:20:46 -0500
Received: from ti-out-0910.google.com ([209.85.142.188]:16893 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381AbYBZNUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 08:20:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pYJm/7RbCEyhVf4p/2K7Lc/zf02mElXW+fuf4FUmmHOoiRQ2iDGfEG885MzS2G7gIT/fSsDY9aPxvLMUz/BKz+M7/MUkdFYYTB5tBhVaewys6gDLpJ/wb89FTQdrx/jvhbC2dJ/AjHslfIci/N54NDjAIYICwus0eGQgX/RbJj4=
Message-ID: <998d0e4a0802260520x77fdea2dr32bc30a5448f32b3@mail.gmail.com>
Date: Tue, 26 Feb 2008 14:20:44 +0100
From: "J.C. Pizarro" <jcpiza@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Please, put 64-bit counter per task and incr.by.one each ctxt switch.
In-Reply-To: <20080225123439.90645f2f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <998d0e4a0802231908h37978d07wa5379d5c01b2c2ee@mail.gmail.com>
	 <20080223221750.429cf0d9@bree.surriel.com>
	 <998d0e4a0802232008w5c6566f0se15ab749ec6f1ceb@mail.gmail.com>
	 <20080223232651.41dffa72@bree.surriel.com>
	 <998d0e4a0802240512t859c5a1y3c30bd401530a43@mail.gmail.com>
	 <20080225123439.90645f2f.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008/2/25, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Sun, 24 Feb 2008 14:12:47 +0100 "J.C. Pizarro" <jcpiza@gmail.com> wrote:
>
>  > It's statistic, yes, but it's a very important parameter for the CPU-scheduler.
>  > The CPU-scheduler will know the number of context switches of each task
>  >  before of to take a blind decision into infinitum!.
>
>
> We already have these:
>
>         unsigned long nvcsw, nivcsw; /* context switch counts */
>
>  in the task_struct.

1. They use "unsigned long" instead "unsigned long long".
2. They use "= 0;" instead of "= 0ULL";
3. They don't use ++ (incr. by one per ctxt-switch).
4. I don't like the separation of voluntary and involuntary ctxt-switches,
    and i don't understand the utility of this separation.

The tsk->nvcsw & tsk->nivcsw mean different to i had proposed.

It's simple, when calling to function kernel/sched.c:context_switch(..)
to do ++, but they don't do it.

I propose you
1. unsigned long long tsk->ncsw = 0ULL;  and  tsk->ncsw++;
2. unsigned long long tsk->last_registered_ncsw = tsk->ncsw; when it's polling.
3. long tsk->vcsw =  ( tsk->ncsw - tsk->last_registered_ncsw ) / ( t2 - t1 )
/* velocity of task (ctxt-switches per second), (t1 != t2 in seconds
for no zerodiv)
4. long tsk->last_registered_vcsw = tsk->vcsw;
5. long tsk->normalized_vcsw =
       (1 - alpha)*tsk->last_registered_vcsw + alpha*tsk->vcsw; /* 0<alpha<1 */

    Sincerely yours ;)
