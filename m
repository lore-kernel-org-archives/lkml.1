Return-Path: <linux-kernel-owner+w=401wt.eu-S933489AbZINSiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933489AbZINSiP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 14:38:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933147AbZINSiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 14:38:14 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:4959 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932989AbZINSiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 14:38:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=eb4HfcItUJlOXyxjNEV31EZwI1tZ1LTyDeaXi9sJtz4p2MZjyi7fn9yrd4ji9zMQS9
         1CPxkh6QQaxVlvDkhvKtqwA6zo/92qZwJQ7eYVFX1PCrHhqr6HcE1ki3GComJ6Q/LJXo
         XtysOnWYj8qXSdpMO5e0z2+9xrwCWWE2d2IMo=
Date: Mon, 14 Sep 2009 20:38:10 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <srostedt@redhat.com>
Cc: Christopher Li <sparse@chrisli.org>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Stephen Rothwell <sfr@canb.auug.org.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org,
       Josh Triplett <josh@freedesktop.org>
Subject: Re: Warning from ring buffer code (Was: Re: linux-next: tip tree
	build warning)
Message-ID: <20090914183808.GB6045@nowhere>
References: <20090804161640.70817ee6.sfr@canb.auug.org.au> <1249403089.4634.139.camel@localhost.localdomain> <20090912165300.9d257283.sfr@canb.auug.org.au> <20090912073906.GA3972@elte.hu> <1252753957.12217.10.camel@ht.satnam> <1252941416.2964.143.camel@localhost.localdomain> <70318cbf0909141009v46581785m4c70edf31fcb79fa@mail.gmail.com> <1252952238.2964.154.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252952238.2964.154.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14, 2009 at 02:17:18PM -0400, Steven Rostedt wrote:
> On Mon, 2009-09-14 at 10:09 -0700, Christopher Li wrote:
> > On Mon, Sep 14, 2009 at 8:16 AM, Steven Rostedt <srostedt@redhat.com> wrote:
> > > static void func(int size_me) {
> > >        char array[size_me];
> > >
> > >        memcpy(array, "hello", size);
> > > };
> > >
> > > and sparse failed on it as well. Note, you need to have something call
> > > func, or sparse will ignore it.
> > 
> > Gcc allows variable size. Sparse expects the size of an array is constant.
> > For the kernel using variable array size is consider bad. Because the kernel
> > has very limited stack size. (8K if I remember correctly). Using dynamic array
> > is very easy to overflow the stack without realizing it.
> > 
> > It deserves a warning. I agree the warning message can use a better description
> > though.
> 
> Good point!
> 
> I've added Frederic to the Cc list, since he wrote the code.
> 
> Frederic, how big can one of those events get. The ring buffer (and
> TRACE_EVENT) allow up to almost a page size, which is very hefty for the
> stack. This code needs to either be rewritten or we need to set a limit
> to the size of a profile entry.
> 
> We could add:
> 
> 	if (__entry_size > 256)
> 		return;
> 
> Thoughts?
> 


Well it can be big, especially once we play with array fields or
__string().

I can manage the __string() that said, by only copying their
pointer and later delay the copy.

Well actually I would like to rewrite all that entirely to avoid
any stack allocation, especially for arrays and string.

Lemme think about a CPP magic way to directly interact with perf
buffer. I think it's possible.

