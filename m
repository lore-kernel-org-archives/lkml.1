Return-Path: <linux-kernel-owner+w=401wt.eu-S1756046AbZBZMrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046AbZBZMrQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 07:47:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753231AbZBZMrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 07:47:00 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:41025 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082AbZBZMrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 07:47:00 -0500
Date: Thu, 26 Feb 2009 07:46:55 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v2 0/5] [RFC] copy_strtok_from_user
In-Reply-To: <20090226123017.GA2041@elte.hu>
Message-ID: <alpine.DEB.2.00.0902260742460.26792@gandalf.stny.rr.com>
References: <20090226053240.607719846@goodmis.org> <1235642612.4645.4737.camel@laptop> <20090226122859.GD23099@elte.hu> <20090226123017.GA2041@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 26 Feb 2009, Ingo Molnar wrote:

> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > On Thu, 2009-02-26 at 00:32 -0500, Steven Rostedt wrote:
> > > > This is the second series of the uaccess code.
> > > > 
> > > > Changes in v2:
> > > > 
> > > >  - moved probe_kernel_* functions to lib/uaccess.c
> > > > 
> > > >  - renamed copy_word_from_user to copy_strtok_from_user.
> > > > 
> > > >  - changed copy_strtok_from_user to pass in a delimiter string.
> > > >    ftrace defines SPACE to be ' \t\r\n'.
> > > > 
> > > > Ingo,
> > > > I added your copy right to lib/uaccess.c since git blame shows you
> > > > as the author of the probe_kernel_* code. Also, is it OK that I
> > > > added the "GPL v2" line in that file as well?
> > > > 
> > > > Andrew,
> > > > Since you are, in essence, the memory maintainer, could you give
> > > > your Acked-by: to the copy_strtok_from_user code.
> > > > 
> > > > The probe_kernel code is still EXPORT_SYMBOL_GPL, and I added
> > > > that too to copy_strtok_from_user. Are there any objections to that?
> > > 
> > > I have to ask,..
> > > 
> > > cant this be done with a regular copy_from_user() followed 
> > > by a regular strtok()? Do we really have to combine all 
> > > that?
> > 
> > yes. Note that strsep() is the preferred API. (in fact it's 
> > the only such string API that is in the kernel)
> 
> btw., for larger strings we cannot really copy into the kernel i 
> suspect. We'd have to kmalloc() and that adds overhead, etc.
> 
> Nevertheless, copy_strsep_from_user() would be the symmetric API 
> here.

not really. strsep stops at the first delimiter. strtok skips multiple 
delimiters. I could implement the copy_strtok_from_user with a 
copy_from_user (all of read), and then use strtok_r (reentrant version) to 
find the next token. This would require implementing strtok_r for the 
kernel.

Having the copy_strtok_from_user will handle the copying and the caller 
would not need to worry about having a big enough buffer to hold 
delimiters and tokens. The copy_strtok_from_user would copy first to an 
internal buffer, then scan for tokens to copy into the callers buffer. 
Then repeat until read or copy limits have been hit.

-- Steve

