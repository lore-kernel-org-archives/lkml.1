Return-Path: <linux-kernel-owner+w=401wt.eu-S1752083AbXDGFXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083AbXDGFXq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 01:23:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752093AbXDGFXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 01:23:45 -0400
Received: from smtp.osdl.org ([65.172.181.24]:44957 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752083AbXDGFXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 01:23:44 -0400
Date: Fri, 6 Apr 2007 22:23:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Hugh Dickins <hugh@veritas.com>, Nick Piggin <npiggin@suse.de>,
       dgc@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Optimize compound_head() by avoiding a shared page
 flag
Message-Id: <20070406222336.4dcdd663.akpm@linux-foundation.org>
In-Reply-To: <20070405223657.21698.32754.sendpatchset@schroedinger.engr.sgi.com>
References: <20070405223651.21698.77505.sendpatchset@schroedinger.engr.sgi.com>
	<20070405223657.21698.32754.sendpatchset@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  5 Apr 2007 15:36:57 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:

> Unalias PG_tail for performance reasons
> 
> If PG_tail is an alias then we need to check PageCompound before PageTail.
> This is particularly bad because the slab and others have to use these tests
> in performance critical paths. 
> 
> This patch uses one of the freed up software suspend flags that is defined
> next to PG_compound.

I get a reject from this because it is dependent upon later patches.  As
the Official Protector Of Page Flags, I'm going to drop it.

Did you investigate

static inline int page_tail(struct page *page)
{
	return ((page->flags & (PG_compound|PG_tail)) == (PG_compound|PG_tail));
}

and

static inline int page_tail(struct page *page)
{
	return unlikely(PageCompound(page)) && unlikely(PageTail(page));
}

?

In the latter case we _should_ have a not-taken branch to not-inline code. 
If the compiler doesn't do that, we can make the PageTail() test an
out-of-line function.  Or make the whole thing an uninlined function.

More work needed, please.  I don't expect that a not-taken branch to
not-inline code is worth a new page flag.  Especially as it does not
actually reduce the number of branch decisions in the common case.

(I'm assuming in all of this that !PageCompound() is the very common case
with slub.  If that is not true, we need to talk).

