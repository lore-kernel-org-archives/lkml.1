Return-Path: <linux-kernel-owner+w=401wt.eu-S1752360AbXDHBZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360AbXDHBZR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 21:25:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932469AbXDHBZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 21:25:17 -0400
Received: from smtp.osdl.org ([65.172.181.24]:37420 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752368AbXDHBZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 21:25:15 -0400
Date: Sat, 7 Apr 2007 18:25:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Hugh Dickins <hugh@veritas.com>, Nick Piggin <npiggin@suse.de>,
       dgc@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Optimize compound_head() by avoiding a shared page
 flag
Message-Id: <20070407182506.4386dc13.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0704071718530.31790@schroedinger.engr.sgi.com>
References: <20070405223651.21698.77505.sendpatchset@schroedinger.engr.sgi.com>
	<20070405223657.21698.32754.sendpatchset@schroedinger.engr.sgi.com>
	<20070406222336.4dcdd663.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704071509550.31503@schroedinger.engr.sgi.com>
	<20070407155148.94da92e8.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704071718530.31790@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Apr 2007 17:21:38 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:

> On Sat, 7 Apr 2007, Andrew Morton wrote:
> 
> > Which is all a ton of fun, but this subversion of the architecture's
> > freedom to use volatile, memory barriers etc is a worry.  We do the same in
> > page_alloc.c, of course...  
> 
> I just tried the approach that we discussed earlier and it was not 
> nice either.

We've discussed at least three approaches, so we don't know to what you refer.

>  Lets just use a page flag please.

Nope, try harder.

PageCompound is an unlikely case.  Back in the old days we would have done



	if (PageCompound(page))
		goto out_of_line;
back:

	do_stuff_with(page);
	return;

out_of_line:
	if (PageTail(page)) {
		page = page_tail(page);
		goto back;
	}
	<do other stuff>

and nowadays we hope that gcc does the above for us.  If it doesn't do it
for us, perhaps it needs open-coded help.

Because I don't expect there will be much efficiency difference between the
above and the use of another page flag.

