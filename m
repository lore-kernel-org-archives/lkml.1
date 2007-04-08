Return-Path: <linux-kernel-owner+w=401wt.eu-S932501AbXDHBcG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932501AbXDHBcG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 21:32:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966020AbXDHBcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 21:32:06 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:36883 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932658AbXDHBcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 21:32:05 -0400
Date: Sat, 7 Apr 2007 18:32:04 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Hugh Dickins <hugh@veritas.com>, Nick Piggin <npiggin@suse.de>,
       dgc@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Optimize compound_head() by avoiding a shared page
 flag
In-Reply-To: <20070407182506.4386dc13.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0704071825510.32544@schroedinger.engr.sgi.com>
References: <20070405223651.21698.77505.sendpatchset@schroedinger.engr.sgi.com>
 <20070405223657.21698.32754.sendpatchset@schroedinger.engr.sgi.com>
 <20070406222336.4dcdd663.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704071509550.31503@schroedinger.engr.sgi.com>
 <20070407155148.94da92e8.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704071718530.31790@schroedinger.engr.sgi.com>
 <20070407182506.4386dc13.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Apr 2007, Andrew Morton wrote:

> > I just tried the approach that we discussed earlier and it was not 
> > nice either.
> 
> We've discussed at least three approaches, so we don't know to what you refer.

Thats the approach of checking two flags at the same time. In that case 
the compiler will generate and "and-immediate" and then a 
"compare-immediate" one branch but .... Yuck.

> Because I don't expect there will be much efficiency difference between the
> above and the use of another page flag.

Then we end up with all these small efficiency differences in all 
the code paths. I'd rather go for optimal performance in a frequently used 
construct like this.

This check is not rare. It is done on every SLAB free and on every 
get_page() and put_page(). Lets do the page flag.

