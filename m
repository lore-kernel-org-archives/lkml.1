Return-Path: <linux-kernel-owner+w=401wt.eu-S966037AbXDHBsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966037AbXDHBsL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 21:48:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966039AbXDHBsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 21:48:11 -0400
Received: from smtp.osdl.org ([65.172.181.24]:37659 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966037AbXDHBsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 21:48:09 -0400
Date: Sat, 7 Apr 2007 18:48:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Hugh Dickins <hugh@veritas.com>, Nick Piggin <npiggin@suse.de>,
       dgc@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Optimize compound_head() by avoiding a shared page
 flag
Message-Id: <20070407184801.b6f3f549.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0704071825510.32544@schroedinger.engr.sgi.com>
References: <20070405223651.21698.77505.sendpatchset@schroedinger.engr.sgi.com>
	<20070405223657.21698.32754.sendpatchset@schroedinger.engr.sgi.com>
	<20070406222336.4dcdd663.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704071509550.31503@schroedinger.engr.sgi.com>
	<20070407155148.94da92e8.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704071718530.31790@schroedinger.engr.sgi.com>
	<20070407182506.4386dc13.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704071825510.32544@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Apr 2007 18:32:04 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:

> On Sat, 7 Apr 2007, Andrew Morton wrote:
> 
> > > I just tried the approach that we discussed earlier and it was not 
> > > nice either.
> > 
> > We've discussed at least three approaches, so we don't know to what you refer.
> 
> Thats the approach of checking two flags at the same time. In that case 
> the compiler will generate and "and-immediate" and then a 
> "compare-immediate" one branch but .... Yuck.

Right.

        movl    (%ebx), %eax    # <variable>.flags, tmp399
        andl    $48, %eax       #, tmp399
        cmpl    $48, %eax       #, tmp399
        je      .L265   #,

what's "yuck" about that?

With the single page flag:

	movl	(%ebx), %eax	#* page.521, D.21940
	testb	$32, %al	#, D.21940
	jne	.L265	#,

So you're talking about saving one sole single silly solitary instruction.


> > Because I don't expect there will be much efficiency difference between the
> > above and the use of another page flag.
> 
> Then we end up with all these small efficiency differences in all 
> the code paths. I'd rather go for optimal performance in a frequently used 
> construct like this.

You can save that worrisome single instruction in the common case by putting the
handling of the uncommon compound pages out of line, as I indicated.

