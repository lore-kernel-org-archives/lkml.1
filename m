Return-Path: <linux-kernel-owner+w=401wt.eu-S1751771AbYIWMeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771AbYIWMeq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 08:34:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750839AbYIWMej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 08:34:39 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:59349 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807AbYIWMei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 08:34:38 -0400
Date: Tue, 23 Sep 2008 16:40:35 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, chad.zanonie@gmail.com, npiggin@suse.de,
       rientjes@google.com
Subject: Re: + mm-oom-killer-kills-more-than-needed.patch added to -mm tree
Message-ID: <20080923124035.GA253@tv-sign.ru>
References: <200809222238.m8MMcgAp001695@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809222238.m8MMcgAp001695@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22, Andrew Morton wrote:
>
> ------------------------------------------------------
> Subject: mm: oom-killer kills more than needed
> From: "Chad Zanonie" <chad.zanonie@gmail.com>
>
> Possibility exists for an exiting application to be in between marking its
> mm NULL and calling mmput when out_of_memory is invoked. 
> select_bad_process() will continue past this process as opposed to
> returning -1UL due to its mm being NULL.  This causes the oom killer in
> certain scenarios to not only kill the memory culprit, but also kill the
> runner up.
>
> EXIT_DEAD seems to be the only flag that guarantees that mmput() has
> finished.

I don't think this is right.

Let's suppose we have a single zombie. Now select_bad_process() always
returns -1 ? IOW, doesn't this means that, say,

	$ perl -e 'fork && sleep'

disables oom-kill completely and forever?

Hmm. But please see below. This doesn't happen because the usage
of EXIT_DEAD is not right.

> Checking for PF_KTHREAD should replace p->mm regardless.

Yes, almost every check for ->mm in oom_kill.c is not right.

> Adding EXIT_DEAD to the check seems to prevent unnecessary kills in local
> testing.

This is strange, could you re-test? Because

> @@ -216,7 +216,7 @@ static struct task_struct *select_bad_pr
>  		 * skip kernel threads and tasks which have already released
>  		 * their mm.
>  		 */
> -		if (!p->mm)
> +		if (p->flags & PF_KTHREAD || p->flags & EXIT_DEAD)
                                                ^^^^^^^^^^^^^^^^^

this is not possible. EXIT_DEAD lives in ->exit_state, not in ->flags.

Oleg.

