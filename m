Return-Path: <linux-kernel-owner+w=401wt.eu-S932475AbYDOVBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932475AbYDOVBB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 17:01:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758855AbYDOVAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 17:00:46 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:56142 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752947AbYDOVAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 17:00:45 -0400
Date: Tue, 15 Apr 2008 23:59:50 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Paul Menage <menage@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, balbir@linux.vnet.ibm.com,
       serue@us.ibm.com, penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org
Subject: Re: [Fwd: [-mm] Add an owner to the mm_struct (v9)]
Message-ID: <20080415195950.GA113@tv-sign.ru>
References: <48036677.3010807@linux.vnet.ibm.com> <20080414170709.736819b6.akpm@linux-foundation.org> <20080415171359.GA352@tv-sign.ru> <6599ad830804151113i73010bb4x48e658195f295d41@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830804151113i73010bb4x48e658195f295d41@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15, Paul Menage wrote:
>
> On Tue, Apr 15, 2008 at 10:13 AM, Oleg Nesterov <oleg@tv-sign.ru> wrote:
> >
> >  Let's suppose the process with a lot of threads does exit_group() and nobody
> >  else uses this ->mm. How many time we will re-assign mm->owner and iterate
> >  over the all threads in system ?
> >
> 
> In general we won't get to the third loop, since one of the first two
> loops (children or siblings) will find another mm user.

Well yes, the second loop checks parent->children ... all sub-threads have
the same parent.

I'd suggest to use ->real_parent though. And the third loop could be

	for_each_process(g) {
		c = g;
		do {
			if (!c->mm)
				continue;
			if (c->mm != mm)
				break;
			goto assign_new_owner;
		} while_each_thread(g, c);
	}

Still. can't we make mm->mm_users_list ?

Oleg.

