Return-Path: <linux-kernel-owner+w=401wt.eu-S1764021AbZDHJzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764021AbZDHJzc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 05:55:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751840AbZDHJzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 05:55:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44813 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268AbZDHJzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 05:55:22 -0400
Date: Wed, 8 Apr 2009 11:55:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <srostedt@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] tracing: fix splice return too large
Message-ID: <20090408095509.GA22471@elte.hu>
References: <49D46674.9030804@cn.fujitsu.com> <20090403131629.GA8875@elte.hu> <49DC6F01.6030203@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49DC6F01.6030203@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Lai Jiangshan <laijs@cn.fujitsu.com> wrote:

> Ingo Molnar wrote:
> > * Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> > 
> >> -	for (i = 0; i < PIPE_BUFFERS && len; i++, len -= size) {
> >> +	if (*ppos & (PAGE_SIZE - 1)) {
> >> +		WARN_ONCE(1, "Ftrace: previous read must page-align\n");
> >> +		return -EINVAL;
> >> +	}
> >> +
> >> +	if (len & (PAGE_SIZE - 1)) {
> >> +		WARN_ONCE(1, "Ftrace: splice_read should page-align\n");
> >> +		if (len < PAGE_SIZE)
> >> +			return -EINVAL;
> >> +		len &= PAGE_MASK;
> >> +	}
> > 
> > Hm, the fix looks good, but is it a good idea to allow the 
> > triggering of this message from user-space?
> > 
> 
> But it is only triggered once.
> 
> If user get content from trace_pipe_raw with non-page-align, the 
> content is garbage. It's wasting, the kernel disallows it. This 
> message tell user why he read failed.
> 
> These 4 patches make trace_pipe_raw more robustious and consistent 
> (read by read(2) and splice). I focus on handling raw ftrace data 
> in userspace, these raw ftrace data should be trustiness.

Ok, agreed.

i've applied these four fixes from you to tip:tracing/splice, 
thanks. Steve: i think they are tracing/urgent material - do you 
agree?

	Ingo
