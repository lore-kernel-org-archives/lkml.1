Return-Path: <linux-kernel-owner+w=401wt.eu-S1756174AbXIJR1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174AbXIJR1R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 13:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754450AbXIJR1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 13:27:07 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59199 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754391AbXIJR1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 13:27:06 -0400
Date: Mon, 10 Sep 2007 10:25:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>, Adrian Bunk <bunk@kernel.org>,
       perex@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] unexport sys_{open,read}
Message-Id: <20070910102556.de35e825.akpm@linux-foundation.org>
In-Reply-To: <20070910124358.GB21089@ftp.linux.org.uk>
References: <20070909202527.GT3563@stusta.de>
	<20070909203920.GA11764@infradead.org>
	<20070909145940.0b41c8a5.akpm@linux-foundation.org>
	<20070910090808.GA31204@infradead.org>
	<20070910022324.c69e1897.akpm@linux-foundation.org>
	<20070910124358.GB21089@ftp.linux.org.uk>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Sep 2007 13:43:58 +0100 Al Viro <viro@ftp.linux.org.uk> wrote:

> On Mon, Sep 10, 2007 at 02:23:24AM -0700, Andrew Morton wrote:
> > > And I think almost everyone disagrees with you.  We just carry too much
> > > crap around because of your subborness in this issue, and it gets really
> > > annoying to have some high up on the food chain fighting his longly flight
> > > against the other people.
> > 
> > I would like to see "everyone" explain what we lose by giving developers a
> > bit of warning before we break their stuff.
> > 
> > 
> > And it would need to be a good explanation, Christoph.  A measured one
> > which recognises and then weighs the tradeoffs involved, and the costs.  An
> > inebriated-sounding rant will not impress, sorry.
> 
> Fine, then.  Just how much of a warning is needed in this particular case?

A single kernel release seems sufficient.  It gives the maintainers of such
code time to hear about the breakage and time to fix it.

> Normally I'm the last one to support Adrian's exportectomy binges, but in
> case of sys_open() it's _way_ overdue.

We have two ways of warning people about upcoming changes:
__deprecated_for_modules will cause a build-time warning and
EXPORT_UNUSED_SYMBOL() will generate a modprobe-time warning.

A year or so ago we decided that EXPORT_UNUSED_SYMBOL() should be
associated with a comment which reminds us when to kill the export.

This is all pretty lightweight.

>  There had been warnings for quite
> a while; moreover, fixing the breakage in any case that is not already
> badly broken is going to take a few minutes.  People who had not found
> spare ten minutes during the last few years have my sincere condolences,
> but they bloody can do that when it hits the fan and I see no reason to
> believe that a warning in build time or modprobe time would do more than
> multiple warnings on maillists.

You guys keep on talking about developers.  It's not to do with them.

Fact is, people use external modules.  To get their machines working
correctly, to get their work done, to do stuff they want done.

Many of these people are non-programmers.  So when they download a new
kernel and find that the module which they use doesn't work because of
something which we've done, they get pissed off, and we lose a tester. 
This has happened many times.

Furthermore I have on at least two occasions been working a bug with a
reporter who was unable (or unwilling, I forget) to run the latest kernel
because we'd broken some out-of-tree code which that tester uses.  So, very
occasionally the breakage interferes with our ability to fix our bugs.  


Now, the above two problems are minor ones, but it is very very easy for us
to lessen them.   We do two things:

a) Adrian's patch does

-EXPORT_SYMBOL(foo);
+EXPORT_SYMBOL_UNUSED(foo);		/* Remove in 2.6.25 */

b) Each release we do a grep for EXPORT_SYMBOL_UNUSED and clean up the
   dead ones.

Total cost of this effort: maybe ten developer minutes per release, and a
few tens of additional bytes in the released vmlinux.

I think that for a few additional testers and a few less-pissed-off users
(nothing to do with developers), this cost is justified.  That's all.


Also, Adrian goes on and on with weird theories about how I'm picking on
him.  But other patches (such as 7d12e780e003f93433d49ce78c) DO OTHER
STUFF.  Like simplify the code, and make it smaller, faster or more
maintainable or more reliable.  So the tradeoff is quite different from a
one-liner which does nothing but kill an export.  And, contrary to his
claims, we _do_ put temporary back-compat wrappers in there when we
change interfaces on those relatively rare occasions when it is possible,
and when we remember to do it.

