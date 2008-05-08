Return-Path: <linux-kernel-owner+w=401wt.eu-S1758925AbYEHDf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758925AbYEHDf1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 23:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755164AbYEHDfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 23:35:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37723 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754809AbYEHDfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 23:35:01 -0400
Date: Wed, 7 May 2008 20:34:40 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
cc: Matthew Wilcox <matthew@wil.cx>, Ingo Molnar <mingo@elte.hu>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: AIM7 40% regression with 2.6.26-rc1
In-Reply-To: <1210217099.3453.92.camel@ymzhang>
Message-ID: <alpine.LFD.1.10.0805072030480.3024@woody.linux-foundation.org>
References: <1210052904.3453.30.camel@ymzhang>  <20080506114449.GC32591@elte.hu> <20080506120934.GH19219@parisc-linux.org>  <20080506162332.GI19219@parisc-linux.org> <1210217099.3453.92.camel@ymzhang>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 8 May 2008, Zhang, Yanmin wrote:
> 
> On Tue, 2008-05-06 at 10:23 -0600, Matthew Wilcox wrote:
> > On Tue, May 06, 2008 at 06:09:34AM -0600, Matthew Wilcox wrote:
> > > So the only likely things I can see are:
> > > 
> > >  - file locks
> > >  - fasync
> > 
> > I've wanted to fix file locks for a while.  Here's a first attempt.
> > It was done quickly, so I concede that it may well have bugs in it.
> > I found (and fixed) one with LTP.
> > 
> > It takes *no account* of nfsd, nor remote filesystems.  We need to have
> > a serious discussion about their requirements.
>
> I tested it on 8-core stoakley. aim7 result becomes 23% worse than the one of
> pure 2.6.26-rc1.

Ouch. That's really odd. The BKL->spinlock conversion looks really 
obvious, so it shouldn't be that noticeably slower.

The *one* difference is that the BKL has the whole "you can take it 
recursively and you can sleep without dropping it because the scheduler 
will drop it for you" thing. The spinlock conversion changed all of that 
into explicit "drop and retake" locks, and maybe that causes some issues. 

But 23% worse? That sounds really odd/extreme.

Can you do a oprofile run or something?

			Linus
