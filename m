Return-Path: <linux-kernel-owner+w=401wt.eu-S1760396AbZBDV0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760396AbZBDV0N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 16:26:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754294AbZBDVZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 16:25:54 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36079 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753550AbZBDVZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 16:25:53 -0500
Date: Wed, 4 Feb 2009 13:25:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: jeremy@goop.org, jaswinderrajput@gmail.com, randy.dunlap@oracle.com,
       linux-kernel@vger.kernel.org, x86@kernel.org, righi.andrea@gmail.com
Subject: Re: mmotm 2009-02-02-17-12 uploaded (x86/nopmd etc.)
Message-Id: <20090204132529.4b77dd4a.akpm@linux-foundation.org>
In-Reply-To: <20090204200846.GF22608@elte.hu>
References: <200902030112.n131CNiq010549@imap1.linux-foundation.org>
	<498893C8.6080506@oracle.com>
	<20090203191804.GA24698@elte.hu>
	<20090203121706.423d5cab.akpm@linux-foundation.org>
	<20090203212538.GB20527@elte.hu>
	<20090203134128.37042ea8.akpm@linux-foundation.org>
	<20090204200846.GF22608@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Feb 2009 21:08:46 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > > > This is getting painful.
> > > 
> > > the include file spaghetti is ... interesting there, and it's historic.
> > > 
> > > I could blame it on highmem, PAE or paravirt - but i'll only blame it on 
> > > paravirt for now because those developers are still around! ;-)
> > > 
> > > Jeremy, any ideas how to reduce the historic dependency mess in that area?
> > > I think we should go on three routes at once:
> > > 
> > >  - agressive splitup and separation of type definitions from method
> > >    declaration (+ inline definitions). The spinlock_types.h / spinlock.h 
> > >    splitup was really nice in solving such dependency problems.
> > 
> > I like this one.  The mixing up of declare-something with use-something
> > is often the source of our woes.
> 
> yes. I mapped this problem area once and this is how the include file 
> spaghetti gets generated in practice:
> 
>   - type A gets declared
>   - type A gets _used_ in the same file in an inline method, BUT,
> 
>       that usage also brings in instantiated use of type X1, X2 and X3.
> 
> if all types are declared like that everywhere, it can be seen (and it's a 
> mathematical certainty) that the only conflict-free way of doing this is to:
> 
>   - initially add random #include lines to bring in type X1, X2 and X3. 
>     Which brings in recursive dependencies from those X1 X2 and X3 files.
> 
>   - when the stuff hits the fan then folks are in a big mess already and 
>     only a deep restructuring could gets them out of it - which they rarely 
>     do in an iterative environment. So they work it around iteratively: 
>     instead of new nice inline methods [which we really prefer] they delay 
>     all the 'usage' instantiation to .c file via the use of CPP macros 
>     [which we hate because they hide bugs and cause bugs].

None of which would happen if we didn't also have an inlining fetish.

