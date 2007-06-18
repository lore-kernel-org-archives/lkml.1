Return-Path: <linux-kernel-owner+w=401wt.eu-S932415AbXFRUmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932415AbXFRUmy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 16:42:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764337AbXFRUmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 16:42:47 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35539 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764174AbXFRUmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 16:42:46 -0400
Date: Mon, 18 Jun 2007 13:42:18 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Carlo Wood <carlo@alinoe.com>
cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
       eric@anholt.net, zhenyu.z.wang@intel.com, lethal@linux-sh.org,
       y-goto@jp.fujitsu.com
Subject: Re: 2.6.22-rc5 regression
In-Reply-To: <20070618195415.GA7481@alinoe.com>
Message-ID: <alpine.LFD.0.98.0706181332400.3593@woody.linux-foundation.org>
References: <20070617182254.GA17595@alinoe.com> <20070617195805.GA6125@alinoe.com>
 <20070617214905.GA6207@alinoe.com> <alpine.LFD.0.98.0706180950130.14121@woody.linux-foundation.org>
 <20070618181225.GB8054@alinoe.com> <alpine.LFD.0.98.0706181127380.14121@woody.linux-foundation.org>
 <20070618195415.GA7481@alinoe.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 18 Jun 2007, Carlo Wood wrote:
> 
> Well,... when, and because, it's not a linear thing as you mentioned
> before - it's not necessarily precisely a cut into half... so I thought,
> seeing those weird (not half) numbers that that was the cause.

You're correct - "git bisect" will not always be able to find an exact 
half-way point, and I was wrong to imply that it will always be quite that 
close.

It's easily off by a few commits because of merges that make it harder to 
find a good bisection point, but it should never (practically) be off by 
quite as much as you saw. 

For example, I could expect that from 127 commits, it would go down to 70 
rather than 64. But not to 110 - not unless there are some *really* 
strange patterns with lots of criss-crossing merges.

And indeed, for me, using the same commit ID's as you used, I see a nice 
bisection to just about exactly half.

> > It might be worth it just making sure your git is ok. It really is acting 
> > oddly. What version is it?
> 
> git version 1.4.4.4

You really do want to use git-1.5.x these days.

It does look like 1.4.4.4 may have a bug, although I'm really surprised: 
we've certainly tweaked stuff in bisection, but I and others have used 
"git bisect" since long before the git-1.4 days, and it has always worked 
ok. So I wonder if it's something specific to that debian build.

Or possibly to the fact that you have some other dirty state (you might 
want to do a "git diff HEAD" to see what the changes are, and maybe a "git 
checkout -f" to get rid of any differences)

> I am using Debian (suite 'testing') and trying to be a debian purist -
> so it isn't like I can easily upgrade to 1.5.x : there is no debian
> package for that version in 'testing'.

I'm surprised that debuan 

> 
> Nevertheless, if you think it's important - then I can download and
> compile a tar ball of course - certainly when I don't have to install
> it to test it.
> 
> -- 
> Carlo Wood <carlo@alinoe.com>
> 
> PS The result of 'git diff' is:
> 
> diff --git a/include/asm-blackfin/macros.h b/include/asm-blackfin/macros.h
> deleted file mode 100644
> index e69de29..0000000

Ok, something deleted an empty file. Probably "make distclean". Our "make 
clean" is sometimes too aggressive, and we generally shouldn't have empty 
files.

> diff --git a/scripts/package/Makefile b/scripts/package/Makefile
> index 7c434e0..f758b75 100644
> --- a/scripts/package/Makefile
> +++ b/scripts/package/Makefile

but this one has actually been modified. To this:

> +# Dummy file 
> +help:

And finally, 

> diff --git a/scripts/package/builddeb b/scripts/package/builddeb
> deleted file mode 100644
> index 6edb29f..0000000

That one also has been actually deleted. And "make distclean" doesn't do 
that. You have something else going on.

		Linus
