Return-Path: <linux-kernel-owner+w=401wt.eu-S933876AbXHFUd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933876AbXHFUd2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 16:33:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759390AbXHFUdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 16:33:20 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:43606 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758262AbXHFUdT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 16:33:19 -0400
X-Greylist: delayed 3609 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Aug 2007 16:33:19 EDT
Date: Tue, 7 Aug 2007 00:33:26 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [RFC, PATCH] handle the multi-threaded init's exit() properly
Message-ID: <20070806203326.GA188@tv-sign.ru>
References: <20070802212009.GA516@tv-sign.ru> <20070806131345.3322c99e.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070806131345.3322c99e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06, Andrew Morton wrote:
>
> On Fri, 3 Aug 2007 01:20:09 +0400 Oleg Nesterov <oleg@tv-sign.ru> wrote:
> 
> > 2. We are playing games with ->nsproxy->pid_ns. This code is bogus today, and
> >    it has to be changed anyway when we really support pid namespaces, just
> >    remove it.
>
> This patch broke
> 
> pid-namespaces-define-and-use-task_active_pid_ns-wrapper.patch.  This hunk:
> 
> ***************
> *** 908,915 ****
>   	if (unlikely(!tsk->pid))
>   		panic("Attempted to kill the idle task!");
>   	if (unlikely(tsk == child_reaper(tsk))) {
> - 		if (tsk->nsproxy->pid_ns != &init_pid_ns)
> - 			tsk->nsproxy->pid_ns->child_reaper = init_pid_ns.child_reaper;
>   		else
>   			panic("Attempted to kill init!");
>   	}
> --- 908,916 ----
>   	if (unlikely(!tsk->pid))
>   		panic("Attempted to kill the idle task!");
>   	if (unlikely(tsk == child_reaper(tsk))) {
> + 		if (task_active_pid_ns(tsk) != &init_pid_ns)
> + 			task_active_pid_ns(tsk)->child_reaper =
> + 					init_pid_ns.child_reaper;
>   		else
>   			panic("Attempted to kill init!");
>   	}
> 
> has no place to live any more, so I just removed it.

Ah, thanks. I should have done this patch against -mm tree.

I hope it is OK to drop this chunk of
	pid-namespaces-define-and-use-task_active_pid_ns-wrapper.patch

Because it can't work right now anyway, and Sukadev+Pavel already have
new patches on top this one which make namespace switch actually work.

Oleg.

