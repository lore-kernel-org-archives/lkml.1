Return-Path: <linux-kernel-owner+w=401wt.eu-S1752690AbZDMOOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690AbZDMOOU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 10:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752472AbZDMONv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 10:13:51 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41342 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350AbZDMONu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 10:13:50 -0400
Subject: Re: [PATCH 4/4] tracing: fix splice return too large
From: Steven Rostedt <srostedt@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090408095509.GA22471@elte.hu>
References: <49D46674.9030804@cn.fujitsu.com>
	 <20090403131629.GA8875@elte.hu> <49DC6F01.6030203@cn.fujitsu.com>
	 <20090408095509.GA22471@elte.hu>
Content-Type: text/plain
Organization: Red Hat
Date: Mon, 13 Apr 2009 10:13:39 -0400
Message-Id: <1239632019.21121.7.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2009-04-08 at 11:55 +0200, Ingo Molnar wrote:
> * Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> 
> > Ingo Molnar wrote:
> > > * Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> > > 
> > >> -	for (i = 0; i < PIPE_BUFFERS && len; i++, len -= size) {
> > >> +	if (*ppos & (PAGE_SIZE - 1)) {
> > >> +		WARN_ONCE(1, "Ftrace: previous read must page-align\n");

Small English grammar nit,

  "Ftrace: previous read must be page-aligned"

> > >> +		return -EINVAL;
> > >> +	}
> > >> +
> > >> +	if (len & (PAGE_SIZE - 1)) {
> > >> +		WARN_ONCE(1, "Ftrace: splice_read should page-align\n");

  "Ftrace: splice_read should be page-aligned"

> > >> +		if (len < PAGE_SIZE)
> > >> +			return -EINVAL;
> > >> +		len &= PAGE_MASK;
> > >> +	}
> > > 
> > > Hm, the fix looks good, but is it a good idea to allow the 
> > > triggering of this message from user-space?
> > > 
> > 
> > But it is only triggered once.
> > 
> > If user get content from trace_pipe_raw with non-page-align, the 
> > content is garbage. It's wasting, the kernel disallows it. This 
> > message tell user why he read failed.
> > 
> > These 4 patches make trace_pipe_raw more robustious and consistent 
> > (read by read(2) and splice). I focus on handling raw ftrace data 
> > in userspace, these raw ftrace data should be trustiness.
> 
> Ok, agreed.
> 
> i've applied these four fixes from you to tip:tracing/splice, 
> thanks. Steve: i think they are tracing/urgent material - do you 
> agree?

Agreed. With my comments above:

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve


