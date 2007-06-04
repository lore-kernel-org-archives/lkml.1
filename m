Return-Path: <linux-kernel-owner+w=401wt.eu-S1752800AbXFDIst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800AbXFDIst (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 04:48:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751416AbXFDIsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 04:48:43 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48892 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751037AbXFDIsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 04:48:42 -0400
Date: Mon, 4 Jun 2007 01:47:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: [patch 1/2] ufd v1 - unsequential O(1) fdmap core
Message-Id: <20070604014759.aaa3b051.akpm@linux-foundation.org>
In-Reply-To: <20070604084227.GA29446@elte.hu>
References: <send-serie.davidel@xmailserver.org.24319.1180825145.1>
	<46633047.1020707@cosmosbay.com>
	<Pine.LNX.4.64.0706031536000.13247@alien.or.mcafeemobile.com>
	<20070603230859.5000424d.akpm@linux-foundation.org>
	<20070604080537.GA22898@elte.hu>
	<20070604080941.GA23537@elte.hu>
	<20070604013449.ea3acca8.akpm@linux-foundation.org>
	<20070604084227.GA29446@elte.hu>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jun 2007 10:42:27 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > If we just want some pseudo-private fd space for glibc to use then I'd 
> > have thought that the existing code could be tweaked to do that: 
> > top-down allocation, start at some high offset, etc.  But apparently 
> > there's more to it than this.
> 
> top-down has the problem of rlimits: 'where is top' is a variable 
> notion.

Well, sort-of.  rlimits affect the number of open files, not the actual fd
indices.  But whatever.

> start-at-high-offset using the existing scheme has a 'bitmap size' 
> problem: even at 2^28 the bitmap size would be 32+ MB. per process (!). 
> The bitmap could be allocated on demand, but that slows down the current 
> code, uglifies it, and it would still end up somewhere looking a bit 
> like Davide's clean new code.

OK, so the existing code doesn't support a holey bitmap.

> so, instead of trying to mesh this thing into the old fd data structures 
> which are very much centered around and tailored to the 
> continuous-allocation usage model, Davide cleanly separated it out into 
> a separate data structure that fits this independently-allocated usage 
> model well and leaves the original data structure alone. I'm strongly in 
> favor of such clean data structure separations.

a) Were IDR trees evaluated and if so, why were they rejected?

b) it's a bit disappointing that this new allocator is only usable for
   one specific application.  We have a *lot* of places in the kernel which
   want allocators of this type.  Many of them are open-coded and crappy. 
   Some use IDR trees.

   If we're going to go and add a complete new allocator, it would be
   good to position it as a library thing if poss.

