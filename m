Return-Path: <linux-kernel-owner+w=401wt.eu-S1754908AbYJWLgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908AbYJWLgt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 07:36:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752352AbYJWLgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 07:36:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:39704 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204AbYJWLgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 07:36:39 -0400
Date: Thu, 23 Oct 2008 07:36:37 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Jan Kiszka <jan.kiszka@siemens.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       "David S. Miller" <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 08/13 v2] ftrace: do not trace init sections
In-Reply-To: <49005CD0.2070807@siemens.com>
Message-ID: <alpine.DEB.1.10.0810230732100.31839@gandalf.stny.rr.com>
References: <20081022212721.167005680@goodmis.org> <20081022213552.440512191@goodmis.org> <49005CD0.2070807@siemens.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 23 Oct 2008, Jan Kiszka wrote:

> Steven Rostedt wrote:
> > The recordmcount script is now robust enough not to process any sections
> > but the .text section. But the gcc compiler still adds a call to mcount.
> > 
> > Note: The function mcount looks like:
> > 
> >   ENTRY(mcount)
> > 	ret
> >   END(mcount)
> > 
> > Which means the overhead is just a return.
> > 
> > This patch adds notrace to the init sections to not even bother calling
> > mcount (which simply returns).
> 
> Sorry for a potentially dumb question (didn't follow all recent ftrace
> developments), but doesn't this mean that code in such sections is now
> invisible for all tracers, even with dynamic tracing disabled (in which
> case they should cause no problem)? What if you *do* want to have such
> functions in your trace as they may contribute to problem or give other
> useful hints?

Not a dumb question, I've thought about this too.

Well, you can still add tracing into those functions, just the mcount call 
will not be there. I've thought about other ways to handle this. Perhaps 
add it only when DYNAMIC_FTRACE is configured. But that to me is a new 
feature. The patches I'm submitting is to help with performance, bug 
fixes, and sanity checks. So I left out any optional notraces.

e.g. in init.h I could do something like.

#ifdef CONFIG_DYNAMIC_FTRACE
# define init_notrace notrace
#else
# define init_notrace
#endif

And then use the init_notrace throughout the file. If this is considered 
something that is acceptible for adding into 28, I would be happy to 
supply a patch.

-- Steve

