Return-Path: <linux-kernel-owner+w=401wt.eu-S1759326AbXIRP0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759326AbXIRP0m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 11:26:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756367AbXIRP0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 11:26:35 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:45902 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756105AbXIRP0e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 11:26:34 -0400
Date: Tue, 18 Sep 2007 19:29:41 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Guillaume Chazarain <guichaz@yahoo.fr>
Cc: Andrew Morton <akpm@linux-foundation.org>, balbir@linux.vnet.ibm.com,
       Jonathan Lim <jlim@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jay Lan <jlan@cthulhu.engr.sgi.com>
Subject: Re: Add all thread stats for TASKSTATS_CMD_ATTR_TGID (v5)
Message-ID: <20070918152941.GA177@tv-sign.ru>
References: <200708310302.l7V32ZpV410222@sabah.engr.sgi.com> <46D7C23F.7020509@linux.vnet.ibm.com> <20070831143535.2e4709c7@localhost.localdomain> <20070912171816.f0993440.akpm@linux-foundation.org> <20070915204239.4a6af65e@localhost.localdomain> <20070918002339.4a989377@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070918002339.4a989377@localhost.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18, Guillaume Chazarain wrote:
>
> @@ -508,7 +543,7 @@ void taskstats_exit(struct task_struct *
>  	if (!stats)
>  		goto err;
>  
> -	memcpy(stats, tsk->signal->stats, sizeof(*stats));
> +	fill_tgid(tsk->pid, tsk, stats);

No, no, this is wrong.

tsk->signal->stats contains the accumulated info about the already exited
threads, we shouldn't throw it out.

Also, fill_tgid() doesn't make sense here, current is the last live sub-thread.


Hmm. We have another race here. There is no guarantee that tsk->signal->stats
covers all sub-threads, as it is supposed to be. It is quite possible that
another sub-thread decremented ->signal->live before us, but didn't complete
taskstats_exit()->fill_tgid_exit() yet.

Oleg.

