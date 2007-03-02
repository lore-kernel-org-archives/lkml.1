Return-Path: <linux-kernel-owner+w=401wt.eu-S1422709AbXCBBmP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422709AbXCBBmP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 20:42:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422710AbXCBBmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 20:42:15 -0500
Received: from smtp.osdl.org ([65.172.181.24]:34597 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422709AbXCBBmO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 20:42:14 -0500
Date: Thu, 1 Mar 2007 17:42:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: support@coraid.com
Cc: "Ed L. Cashin" <ecashin@coraid.com>, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>
Subject: Re: PATCH 2.6.21-rc1 aoe: handle zero _count pages in bios
Message-Id: <20070301174204.a550dd3a.akpm@linux-foundation.org>
In-Reply-To: <20070301231510.GC8524@coraid.com>
References: <20070301231510.GC8524@coraid.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Mar 2007 18:15:10 -0500
"Ed L. Cashin" <ecashin@coraid.com> wrote:

> This patch works around a problem discussed here and on the XFS
> mailing list in January.
> 
>   http://lkml.org/lkml/2007/1/19/56
> 
> To summarize the issue: If XFS (or any other creator of bios) gives
> the aoe driver a bio with pages that have a zero page _count, and then
> the aoe driver hands the page to the network layer in an sk_buff's
> frags, and if the network card does not support the scatter gather
> feature, then the network layer will eventually try to put_page on the
> page, and the kernel winds up panicing.
> 
> There is a disconnect between the assumptions of the bio creator (that
> pages don't need to have a non-zero _count), and the assumptions of
> the network layer (where it's assumed that pages will always have a
> positive count).  There was no response, though, to a call in January
> for ideas about resolving the disconnect.
> 
> So to work around the issue, the simple patch below increments the
> page _count before handing it to the network layer and decrements it
> after the network layer is done with the page.  This patch eliminates
> panics for XFS on aoe users who lack scatter gather support in their
> network cards.

Something funny is going on here.

Generally, one should increment the refcount of a page when it is put into
some container.  That means that the page should get +1 when it is added to
a bio.  (direct-io does this, but the mpage.c pagecache code cheats, and
relies upon PG_locked and PG-writeback protecting the page).

Similarly, the network code (or its caller) should be incrementing the
page's refcount as the page goes into a container (ie: the skb) and
decrementing it as the page is removed.

But someone somewhere is breaking those rules.  Who?

> It's regrettable that _count is manipulated directly, because Andrew
> Morton changed the page "count" member to a _count to prevent exactly
> this kind of direct manipulation of the data.  There does not appear
> to be a "right" way to increment and decrement the count, however,
> inside a driver without unwanted side effects.  The closest candidates
> are in mm/internal.h and are presumably intended to be used
> exclusively by mm/*.c.
> 

Odd.  You _should_ be able to use plain old get_page() and put_page().  If
you use a raw decrement of page->count then there's a risk that this was
the final reference and the page will leak forever.  We do need to use
put_page()'s return-it-to-the-allocator-if-this-was-the-last-use logic.


So.  Who is breaking refcounting protocol here?  Perhaps it is AOE, failing
to increment the refcount on pages as they are added to an skb?

(Do we know which callsite in XFS is adding zero-ref pages to a BIO, btw?)

