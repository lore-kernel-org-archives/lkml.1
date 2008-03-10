Return-Path: <linux-kernel-owner+w=401wt.eu-S1751777AbYCJJNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751777AbYCJJNz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 05:13:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750761AbYCJJNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 05:13:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58984 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699AbYCJJNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 05:13:45 -0400
Date: Mon, 10 Mar 2008 10:13:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, gvaughan@jpl.nasa.gov, akpm@osdl.org,
       jeremy@goop.org
Subject: Re: [PATCH] Fix check after use in kernel/exit.c
Message-ID: <20080310091321.GA9452@elte.hu>
References: <20080308085322.GA29628@elte.hu> <20080308.165821.119846418.xiyou.wangcong@gmail.com> <20080309114844.GC30331@elte.hu> <20080310.162351.21322673.xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080310.162351.21322673.xiyou.wangcong@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* WANG Cong <xiyou.wangcong@gmail.com> wrote:

> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -583,8 +583,6 @@ static void exit_mm(struct task_struct * tsk)
>  	struct mm_struct *mm = tsk->mm;
>  
>  	mm_release(tsk, mm);
> -	if (!mm)
> -		return;

> @@ -464,6 +464,8 @@ void mm_release(struct task_struct *tsk, struct mm_struct *mm)
>  {
>  	struct completion *vfork_done = tsk->vfork_done;
>  
> +	if (!mm)
> +		return;
>  	/* Get rid of any cached register state */
>  	deactivate_mm(tsk, mm);

no, this is buggy in the same way - we wont do a deactivate_mm() for 
kernel threads. The check should be left alone in exit_mm(), we should 
at most add a check for NULL mm to this place:

        if (tsk->clear_child_tid
            && !(tsk->flags & PF_SIGNALED)
            && atomic_read(&mm->mm_users) > 1) {

but ... can mm in fact ever be NULL if tsk->clear_child_tid is set?

	Ingo
