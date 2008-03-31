Return-Path: <linux-kernel-owner+w=401wt.eu-S1758053AbYCaUa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053AbYCaUa3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 16:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755553AbYCaUaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 16:30:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35449 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755438AbYCaUaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 16:30:11 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] do_wait reorganization
In-Reply-To: Oleg Nesterov's message of  Monday, 31 March 2008 12:51:10 +0400 <20080331085110.GA400@tv-sign.ru>
References: <20080329033412.120EE26FA1D@magilla.localdomain>
	<alpine.LFD.1.00.0803290906050.14670@woody.linux-foundation.org>
	<20080331035701.3926726F8E9@magilla.localdomain>
	<20080331085110.GA400@tv-sign.ru>
X-Zippy-Says: Is this my STOP??
Message-Id: <20080331202910.5C4C926F8E9@magilla.localdomain>
Date: Mon, 31 Mar 2008 13:29:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This looks wrong, we shouldn't clear *retval if the child is EXIT_DEAD.

You're right.  Thanks for catching that.
I think it should look like this:

    {
	    int ret = eligible_child(type, pid, options, p);
	    if (ret <= 0)
		    return ret;

	    if (p->exit_state == EXIT_DEAD)
		    return 0;

	    /*
	     * We don't reap group leaders with subthreads.
	     */
	    if (p->exit_state == EXIT_ZOMBIE && !delay_group_leader(p))
		    return wait_task_zombie(p, options, infop, stat_addr, ru);

	    /*
	     * It's stopped or running now, so it might
	     * later continue, exit, or stop again.
	     */
	    *retval = 0;

	    if (task_is_stopped_or_traced(p))
		    return wait_task_stopped(p, options, infop, stat_addr, ru);

	    return wait_task_continued(p, options, infop, stat_addr, ru);
    }

What do you think?


Thanks,
Roland
