Return-Path: <linux-kernel-owner+w=401wt.eu-S1760426AbZADSjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760426AbZADSjr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 13:39:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750909AbZADSiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 13:38:50 -0500
Received: from casper.infradead.org ([85.118.1.10]:53425 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383AbZADSiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 13:38:46 -0500
Date: Sun, 4 Jan 2009 10:40:35 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, fweisbec@gmail.com,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-acpi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/4] fastboot: Asynchronous function calls to speed up
 kernel boot
Message-ID: <20090104104035.43028d8e@infradead.org>
In-Reply-To: <alpine.LFD.2.00.0901041024360.3179@localhost.localdomain>
References: <20090104092430.7ffd2c41@infradead.org>
	<20090104092857.5fbf6b2d@infradead.org>
	<alpine.LFD.2.00.0901041024360.3179@localhost.localdomain>
Organization: Intel
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Jan 2009 10:33:34 -0800 (PST)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Sun, 4 Jan 2009, Arjan van de Ven wrote:
> > +
> > +typedef u64 async_cookie_t;
> > +typedef void (async_func_ptr) (void *data, async_cookie_t cookie);
> > +
> > +extern void async_schedule(async_func_ptr *ptr, void *data);
> > +extern void async_synchronize_full(void);
> > +extern void async_synchronize_cookie(async_cookie_t cookie);
> 
> Hmm. The cookie use doesn't seem to make much sense.
> 
> Why do you pass in the cookie to the async function, but don't return
> it to the caller? That seems backwards - you'd normally expect that
> it is the _caller_ that wants the cookie (to synchronise with a
> specific async call), not the callee. But now the only one who knows
> the cookie is the wrong entry - just the callee, not the caller.

in fact, either could need it.
the callee could need it when IT does a global registration (for
example to get a device number) at the end of its sequence.
We'd want that registration to happen sequential (it's basically the
equivalent of a commit/retirement of the instruction in a CPU)
the caller could need it when it wants to wait for the async function
it kicked off.

so both make total sense to me.

> 
> Yes, yes, I read the explanation in the comments, and it says that
> the callee should do it to guarantee its own ordering, and your acpi
> port thing does that in order to apparently start a sequence that is 
> asynchronous only wrt the synchronous code, but not wrt itself.
> That's a _very_ odd model, but whatever works. But wouldn't it still
> make sense to let the caller wait for individual events too?
> 
> IOW, I'd just suggest changing the interface so that
> "async_schedule()" also returns the cookie. 

I had that originally... (as I described in the first mail).. but had
no users of it in the places I converted.
I'm happy to just return it; it does make sense (that's why I did this
originally)....


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
