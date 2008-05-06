Return-Path: <linux-kernel-owner+w=401wt.eu-S932611AbYEFRqL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932611AbYEFRqL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 13:46:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765825AbYEFRnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 13:43:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56935 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932768AbYEFRnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 13:43:15 -0400
Date: Tue, 6 May 2008 10:42:15 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Matthew Wilcox <matthew@wil.cx>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: AIM7 40% regression with 2.6.26-rc1
In-Reply-To: <20080506165112.GL19219@parisc-linux.org>
Message-ID: <alpine.LFD.1.10.0805061013530.32269@woody.linux-foundation.org>
References: <1210052904.3453.30.camel@ymzhang> <20080506114449.GC32591@elte.hu> <20080506120934.GH19219@parisc-linux.org> <20080506162332.GI19219@parisc-linux.org> <alpine.LFD.1.10.0805060931450.32269@woody.linux-foundation.org> <20080506164231.GK19219@parisc-linux.org>
 <20080506173948.6aed7475@core> <20080506165112.GL19219@parisc-linux.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 May 2008, Matthew Wilcox wrote:

> On Tue, May 06, 2008 at 05:39:48PM +0100, Alan Cox wrote:
> > > > Hmm?
> > > 
> > > So that find_conflict doesn't end up in the first column, which causes
> > > diff to treat it as a function name for the purposes of the @@ lines.
> > 
> > Please can we just fix the tools not mangle the kernel to work around
> > silly bugs ?
> 
> The people who control the tools refuse to fix them.

That's just plain bullocks.

First off, that "@@" line thing in diffs is not important enough to screw 
up the source code for. Ever.  It's just a small hint to make it somewhat 
easier to see more context for humans.

Second, it's not even that bad to show the last label there, rather than 
the function name.

Third, you seem to be a git user, so if you actually really care that much 
about the @@ line, then git actually lets you set your very own pattern 
for those things.

In fact, you can even do it on a per-file basis based on things like 
filename rules (ie you can have different patterns for what to trigger on 
for a *.c file and for a *.S file, since in a *.S file the 'name:' thing 
_is_ the right pattern).

So not only are you making idiotic changes just for irrelevant tool usage, 
you're also apparently lying about people "refusing to fix" things as an 
excuse.

You can play with it. It's documented in gitattributes (see "Defining a 
custom hunk header"), and the default one is just the same one that GNU 
diff uses for "-p". I think.

You can add something like this to your ~/.gitconfig:

	[diff "default"]
		funcname=^[a-zA-Z_$].*(.*$

to only trigger the funcname pattern on a line that starts with a valid C 
identifier hing, and contains a '('.

And you can just override the default like the above (that way you don't 
have to specify attributes), but if you want to do things differently for 
*.c files than from *.S files, you can edit your .git/info/attributes file 
and make it contain something like

	*.S	diff=assembler
	*.c	diff=C

and now you can make your ~/.gitconfig actually show them differently, ie 
something like

	[diff "C"]
		funcname=^[a-zA-Z_$].*(.*$

	[diff "assembler"]
		funcname=^[a-zA-Z_$].*:

etc.

Of course, there is a real cost to this, but it's cheap enough in practice 
that you'll never notice.

			Linus
