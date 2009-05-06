Return-Path: <linux-kernel-owner+w=401wt.eu-S1759692AbZEFNrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759692AbZEFNrp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 09:47:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755442AbZEFNrh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 09:47:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:44005 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856AbZEFNrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 09:47:36 -0400
Date: Wed, 6 May 2009 09:47:34 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 10/11] ring-buffer: move big if statement down
In-Reply-To: <20090506082447.GA28675@elte.hu>
Message-ID: <alpine.DEB.2.00.0905060930190.3239@gandalf.stny.rr.com>
References: <20090506042101.231470089@goodmis.org> <20090506042334.938331281@goodmis.org> <20090506082447.GA28675@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 6 May 2009, Ingo Molnar wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > This patch changes it to a goto:
> > 
> > 	code;
> > 
> > 	if (cross to next page)
> > 		goto next_page;
> > 
> > 	more code;
> > 
> > 	return;
> > 
> > next_page:
> > 
> > 	[ lots of code]
> 
> I have pulled it, but could you please change it to a helper 
> function instead? There's almost never a good reason to combine 
> 'more code' with 'lots of code' in a single function. It also 
> documents the unlikeliness, etc.

As I stated in the change log, I did not want to convert it to a helper 
function because it uses the variables created before. It would end up 
going from:

	if (write > BUF_PAGE_SIZE)
		goto next_page;


to:

	if (write > BUF_PAGE_SIZE)
		return rb_move_tail(cpu_buffer, length, tail,
				    commit_page, tail_page);


Although it is the "unlikely" case, it is still a fast path. It happens 
every time a write into the page buffer crosses a page boundary. Since it 
is only used once, gcc would hopefully inline it. If it does not, then we 
are copying a bunch of parameters for nothing.

I could still do this and see what gcc does with it.

-- Steve

