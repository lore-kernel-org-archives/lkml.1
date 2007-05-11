Return-Path: <linux-kernel-owner+w=401wt.eu-S1760306AbXEKG3O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760306AbXEKG3O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 02:29:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754888AbXEKG26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 02:28:58 -0400
Received: from wr-out-0506.google.com ([64.233.184.236]:57848 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755046AbXEKG25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 02:28:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VBbyPTdSLfen40uxWGWWZoNIa5GHkGDskSI+314nLMUVb1e4I7BNmN2LsmfUiVXQCRLl2KSTzUsvIhn6yqMe7PM0H/ujWIUQsVlUNhrUivGwL4hdubp41Usr6+QZ+UvJi9qPr1ptmIJgszwRqVV/0VzdUW9wkwVLTcM9YVY9S88=
Message-ID: <a781481a0705102328u3ec92d42o83b69005b81b97b3@mail.gmail.com>
Date: Fri, 11 May 2007 11:58:53 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: (hacky) [PATCH] silence MODPOST section mismatch warnings
Cc: "David Miller" <davem@davemloft.net>, cw@f00f.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070510210134.GA23149@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070510203417.GA23019@tuatara.stupidest.org>
	 <20070510.135147.55726615.davem@davemloft.net>
	 <20070510205427.GF29713@flint.arm.linux.org.uk>
	 <20070510210134.GA23149@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam,

On 5/11/07, Sam Ravnborg <sam@ravnborg.org> wrote:
> On Thu, May 10, 2007 at 09:54:27PM +0100, Russell King wrote:
> > On Thu, May 10, 2007 at 01:51:47PM -0700, David Miller wrote:
> > > From: Chris Wedgwood <cw@f00f.org>
> > > Date: Thu, 10 May 2007 13:34:18 -0700
> > >
> > > > MODPOST seems to be spewing bogus warnings.  It's not clear how best
> > > > to fix it so perhaps we should silence it for now?
> > >
> > > Most of them are legitimate, the only one that needs sorting
> > > is the mm/slab.c case and people are working on that.
> > >
> > > The rest are useful and I've been working to fix things up
> > > on sparc64 and the networking, and in fact I'm very happy
> > > about these notifications.
> > >
> > > Please don't apply a sledgehammer to this issue, thanks.
> >
> > I've not had one accurate one on ARM yet.
> You had one patch from me in latest submission to linus that
> was a clear bug.
>
> >
> > Here's another example:
> >
> > WARNING: init/built-in.o - Section mismatch: reference to .init.text:
> >  from .text between 'rest_init' (at offset 0x4c) and 'run_init_process'
> >
> > from init/main.c:
> >
> > static void noinline rest_init(void)
> >         __releases(kernel_lock)
> >
> > static void run_init_process(char *init_filename)
> >
> > Clearly, it just does _not_ work.
> As I have already explained to you this is a binutils issue
> that causes this false positive.
>
> The plan is to annotate functions that are not __init that
> they intentional reference a function or data in a init section.
> I just not there yet.

The thought makes me *extremely* uncomfortable. Better to _heed_
warnings, than _hide_ them, isn't it -- they only tell us what the
code says, after all. Personally, I'd much rather see a few warnings
on my screen (which I _know_ are false positives) than hide a genuine
potential issue only to crash later.

For bogus warnings caused by binutils issues, the solution clearly
lies in fixing _binutils_.

For the "genuine false positives" (where we *do* call .init.text from
.text, but somehow ensure that it doesn't happen after boot) -- I
don't really know, but a solution that solves the (kmem_cache_create
-> setup_cpu_cache + g_cpucache_up -> set_up_list3s) problem in
_logic_ sounds more elegant to me, than inventing something like
__nowarn_calls_init (?). The problem with stuff of the latter sort is
that they often tend to be abused later by everyone even where they
are avoidable / inapplicable, which opens up a can of worms.

Just my 2 paise,
Satyam
