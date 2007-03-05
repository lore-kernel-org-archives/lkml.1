Return-Path: <linux-kernel-owner+w=401wt.eu-S1752082AbXCEXEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082AbXCEXEe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 18:04:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752141AbXCEXEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 18:04:33 -0500
Received: from smtp.osdl.org ([65.172.181.24]:40523 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752082AbXCEXEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 18:04:32 -0500
Date: Mon, 5 Mar 2007 14:57:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Will Trives <will@trivescon.com.au>, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Chuck Ebbert <cebbert@redhat.com>
Subject: Re: [PATCH] fs: nobh_truncate_page() fix
Message-Id: <20070305145753.1180a1d4.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703051333140.3998@woody.linux-foundation.org>
References: <20070305150317.57e62d70@disher.kickcrew>
	<45EC3058.2010903@redhat.com>
	<1173108985.9109.11.camel@kleikamp.austin.ibm.com>
	<1173109811.9109.17.camel@kleikamp.austin.ibm.com>
	<1173128289.9109.36.camel@kleikamp.austin.ibm.com>
	<Pine.LNX.4.64.0703051333140.3998@woody.linux-foundation.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Mar 2007 13:43:03 -0800 (PST)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Mon, 5 Mar 2007, Dave Kleikamp wrote:
> > 
> > This fixes a regression caused by 22c8ca78f20724676b6006232bf06cc3e9299539.
> > 
> > nobh_prepare_write() no longer marks the page uptodate, so
> > nobh_truncate_page() needs to do it.
> 
> I'm not convinced...
> 
> If the page wasn't up-to-date from before, it's *not* necessarily 
> up-to-date after the truncate either! So why do we have that at all?

The thing about nobh mode is that because we have no buffer_heads, we can't
track the uptodateness of sections of the page.  Hence nobh pages are
basically always uptodate.  The only place where we can tolerate partial
uptodateness is in between prepare_write and commit_write, where we omit
the initialisation of the section of the page which the caller is writing
to.

Of course, this won't perform very well with 64k pages..

> The same comment is true of "nobh_commit_write()" (which _does_ have the 
> SetPageUptodate() there).

nobh_prepare_write brings uptodate the sections of the page (0->from) and
(to->PAGE_CACHE_SIZE), and the nobh_prepare_write() caller brings the
(from->to) section uptodate.  So the page is uptodate at
nobh_commit_write().  It has to be, because we don't know how to bring a
non-uptodate nobh page uptodate apart from writing something to every byte
in it.

> So I have three questions:
> 
>  - why is that valid in the first place (the page is *not* guaranteed to 
>    be up-to-date as far as I can see!)
> 
>  - why is it valid to do in "nobh_commit_write()"
> 
>  - why doesn't "nobh_truncate_page()"
> 	(a) call nobh_prepare_write() through an indirect pointer?
> 	(b) call nobh_commit_write() at all? (Yeah, I realize it's because 
> 	    of brokenness with i_size, so this is more of a "those 
> 	    functions should be factored out properly" statement rather 
> 	    than a question.

It's not really appropriate that nobh_truncate_page() call
->prepare_write() at all.  But it just happened that nobh_prepare_write()
does exactly what nobh_truncate_page() wants to do, so I just called
nobh_prepare_write() for code-sharing reasons.

Perhaps I should have called nobh_prepare_write() directly, or created some
common private function which both nobh_prepare_write() and
nobh_truncate_page() internally call.

> IOW, I'm sure your patch _fixes_ something, but no, it's certainly not 
> obvious to me. A few added comments would be good.. Why is it ok to do 
> this on a page that wasn't up-to-date before (since obviously, if it *was* 
> up-to-date, it's pointless).

Is OK, I think.  nobh_prepare_write() brings the outside-from-and-to
sections of the page uptodate and memset in nobh_truncate_page() brings the
rest of the page uptodate.

We bring the to->PAGE_CACHE_SIZE section uptodate twice, which could be
optimised.

