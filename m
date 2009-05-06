Return-Path: <linux-kernel-owner+w=401wt.eu-S1760074AbZEFOiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760074AbZEFOiU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 10:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755490AbZEFOiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 10:38:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51498 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667AbZEFOiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 10:38:09 -0400
Date: Wed, 6 May 2009 16:37:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 10/11] ring-buffer: move big if statement down
Message-ID: <20090506143755.GB29044@elte.hu>
References: <20090506042101.231470089@goodmis.org> <20090506042334.938331281@goodmis.org> <20090506082447.GA28675@elte.hu> <alpine.DEB.2.00.0905060930190.3239@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0905060930190.3239@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> On Wed, 6 May 2009, Ingo Molnar wrote:
> 
> > 
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > This patch changes it to a goto:
> > > 
> > > 	code;
> > > 
> > > 	if (cross to next page)
> > > 		goto next_page;
> > > 
> > > 	more code;
> > > 
> > > 	return;
> > > 
> > > next_page:
> > > 
> > > 	[ lots of code]
> > 
> > I have pulled it, but could you please change it to a helper 
> > function instead? There's almost never a good reason to combine 
> > 'more code' with 'lots of code' in a single function. It also 
> > documents the unlikeliness, etc.
> 
> As I stated in the change log, I did not want to convert it to a helper 
> function because it uses the variables created before. It would end up 
> going from:
> 
> 	if (write > BUF_PAGE_SIZE)
> 		goto next_page;
> 
> 
> to:
> 
> 	if (write > BUF_PAGE_SIZE)
> 		return rb_move_tail(cpu_buffer, length, tail,
> 				    commit_page, tail_page);
> 
> 
> Although it is the "unlikely" case, it is still a fast path. It 
> happens every time a write into the page buffer crosses a page 
> boundary. Since it is only used once, gcc would hopefully inline 
> it. If it does not, then we are copying a bunch of parameters for 
> nothing.
> 
> I could still do this and see what gcc does with it.

GCC might make a mess of it - but parameters shouldnt be copied 
normally (on 64-bit at least), they'll just be held in parameter 
registers.

	Ingo
