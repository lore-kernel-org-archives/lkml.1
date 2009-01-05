Return-Path: <linux-kernel-owner+w=401wt.eu-S1755321AbZAEUFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321AbZAEUFh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 15:05:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751302AbZAEUFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 15:05:15 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:40371 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693AbZAEUFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 15:05:12 -0500
Date: Mon, 5 Jan 2009 15:05:11 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Sam Ravnborg <sam@ravnborg.org>
cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <srostedt@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, "David S. Miller" <davem@davemloft.net>,
       sparclinux <sparclinux@vger.kernel.org>
Subject: Re: ftrace breaks sparc64 build
In-Reply-To: <20090105195415.GA6204@uranus.ravnborg.org>
Message-ID: <alpine.DEB.1.10.0901051458460.25066@gandalf.stny.rr.com>
References: <20090105181922.GA25622@uranus.ravnborg.org> <alpine.DEB.1.10.0901051428370.27085@gandalf.stny.rr.com> <20090105195415.GA6204@uranus.ravnborg.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 5 Jan 2009, Sam Ravnborg wrote:

> Hi Steven.
> 
> > 
> > Honestly, that code is a little obfuscated, and would be better to write 
> > it as:
> > 
> > 	if (vp->major == 0 && vp->minor=0)
> > 		return ldc_abort(lp);
> > 
> > 	vap = find_by_major(vp->major);
> > 	if (!vap)
> > 		return ldc_abort(lp);
> > 
> > 	[...]
> > 
> > This is much easier to read and we can remove the else statement 
> > altogether. And I bet the warning will go away if we did it this way.
> 
> Fully ageed on the readability.
> I happen to trigger this as an error in the sparc code.
> But I see the same warning also in generic code.
> 
> >From kernel/module.c:
>         /* Suck in entire file: we'll want most of it. */
>         /* vmalloc barfs on "unusual" numbers.  Check here */
>         if (len > 64 * 1024 * 1024 || (hdr = vmalloc(len)) == NULL)
>                 return ERR_PTR(-ENOMEM);
> 
> 
> This gives following warning:
> kernel/module.c: In function `load_module':
> kernel/module.c:1842: warning: 'hdr' might be used uninitialized in this function

Probably the same issue. The problem is that the first use of a variable 
is in the OR section of an if statement that does a return.

	if (x || !(y = init_me())
		return;

	use_me(y);

IMHO I find this sloppy code. When reading the code it can cause reviewers 
trouble, and wasted time, to see that y is indeed initialized. I'm 
impressed that gcc was able to figure it out.

> 
> So this is not a pattern we seen only in sparc code and I wonder if this is
> the first time it is brought up?
> 
> I can fix up the cases in sparc - no problem.
> But it was a suprise to me _why_ these warnings started to creep
> up and then it break my build.

Have you always been compiling with -Werror?

The reason that gcc complains is because you have the "branch_tracer" on 
that converts 'if ()' into a macro (as you saw in your -E compile). This 
makes the if statement more complex, and goes beyond gcc's ability to know 
that the above 'y' is initialized properly. I would work on fixing this in 
the branch tracer, but honestly, I'm kind of glad that gcc barfs on it. 
This will help us point out this kind of sloppy initializations (sorry if 
I'm offending anybody about calling it sloppy). I just believe that it 
makes the code a bit more obfuscated to initialize in an if statement, and 
a second part of a complex if statement at that!

-- Steve

