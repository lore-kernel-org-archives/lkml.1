Return-Path: <linux-kernel-owner+w=401wt.eu-S1765934AbXKOU5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765934AbXKOU5T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 15:57:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753041AbXKOU5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 15:57:10 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53493 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752235AbXKOU5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 15:57:09 -0500
Date: Thu, 15 Nov 2007 12:56:55 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Bron Gondwana <brong@fastmail.fm>, Christian Kujau <lists@nerdbynature.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       robm@fastmail.fm
Subject: Re: mmap dirty limits on 32 bit kernels (Was: [BUG] New Kernel
 Bugs)
In-Reply-To: <1195159457.22457.35.camel@lappy>
Message-ID: <alpine.LFD.0.9999.0711151252340.4260@woody.linux-foundation.org>
References: <20071113.043207.44732743.davem@davemloft.net>  <20071113110259.44c56d42.akpm@linux-foundation.org>  <alpine.DEB.0.9999.0711132055550.7865@sheep.housecafe.de>  <20071113130411.26ccae12.akpm@linux-foundation.org>  <alpine.DEB.0.99999.0711132239350.3960@sheep.housecafe.de>
  <20071115040708.GB15302@brong.net>  <alpine.LFD.0.9999.0711142020220.2786@woody.linux-foundation.org>  <20071115052538.GA21522@brong.net>  <alpine.LFD.0.9999.0711142130090.2786@woody.linux-foundation.org>  <alpine.LFD.0.9999.0711142148380.2786@woody.linux-foundation.org>
  <20071115115049.GA8297@brong.net>  <alpine.LFD.0.9999.0711150818320.2786@woody.linux-foundation.org>  <1195155601.22457.25.camel@lappy> <1195159457.22457.35.camel@lappy>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 15 Nov 2007, Peter Zijlstra wrote:
> 
> Something like this ought to do I guess. Although my
> mapping_is_buffercache() is the ugliest thing. I'm sure that can be done
> better.

No, this absolutely sucks.

Why?

It's totally unacceptable to have per-mapping notions of how much memory 
we have. We used to do *exactly* that, and it's idiocy.

The reason it's unacceptable idiocy is that it means that two processes 
that access different files will then have *TOTALLY*DIFFERENT* notions of 
what the "dirty limit" is. And as a result, one process will happily write 
lots and lots of dirty stuff and never throttle, and the other process 
will have to throttle all the time - and clean up after the process that 
didn't!

See?

The fact is, because we count dirty pages as one resource, we must also 
have *one* limit.

So this patch is a huge regression. You might not notice it, because if 
everybody writes to the same kind of mapping, nobody will be hurt (they 
all have effectively the same global limit anyway), but you *will* notice 
if you ever have two different values of "highmem".

Unacceptable. We used to do exactly what your patch does, and it got fixed 
once. We're not introducing that fundamentally broken concept again.

		Linus
