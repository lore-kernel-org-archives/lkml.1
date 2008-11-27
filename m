Return-Path: <linux-kernel-owner+w=401wt.eu-S1753443AbYK0UQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443AbYK0UQA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 15:16:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752416AbYK0UPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 15:15:51 -0500
Received: from mx2.redhat.com ([66.187.237.31]:54910 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301AbYK0UPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 15:15:51 -0500
Date: Thu, 27 Nov 2008 21:13:58 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Tejun Heo <htejun@gmail.com>, Eric Van Hensbergen <ericvh@gmail.com>,
       Ron Minnich <rminnich@sandia.gov>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>,
       Miklos Szeredi <mszeredi@suse.cz>, Brad Boyer <flar@allandria.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Roland McGrath <roland@redhat.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] poll: allow f_op->poll to sleep, take#5
Message-ID: <20081127201358.GA19874@redhat.com>
References: <20081125173032.GA21539@redhat.com> <492CD1AB.3000802@kernel.org> <492CD358.2020603@gmail.com> <alpine.DEB.1.10.0811252148540.32523@alien.or.mcafeemobile.com> <492CEF04.6070100@gmail.com> <alpine.DEB.1.10.0811252313420.32523@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0811252313420.32523@alien.or.mcafeemobile.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26, Davide Libenzi wrote:
>
> w1) WR dev->events
> w2) WR triggered (1)
> w3) WMB
> w4) WR task->state (RUNNING)
> ...
> That is, an MB before w3 (triggered=1) and a set_mb(triggered,0) at
> s5+s6. The spinlock on the queue taken before entering pollwake() is not
> enough to guarantee the required ordering, since a LOCK is no guarantee
> that operations before it are visible after the LOCK.
> Without the MB at w2, it could happen [w3, s5, s7, w1] that will make us
> miss the event *and* sleep.

I think you are very right. Actually, this is just like

W:
	fill_data(&DATA);
	wmb();
	DATA_is_ready = 1;	// triggered
	wake_up(wq);

S:
	set_current_state(state);
	if (DATA_is_ready)
		ret = poll(&DATA);
	else
		schedule();

without wmb() above poll(&DATA) can obviously return the wrong value.

Oleg.

