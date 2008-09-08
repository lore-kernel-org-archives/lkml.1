Return-Path: <linux-kernel-owner+w=401wt.eu-S1753036AbYIHJGN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036AbYIHJGN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 05:06:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751013AbYIHJF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 05:05:58 -0400
Received: from smtp113.mail.mud.yahoo.com ([209.191.84.66]:30622 "HELO
	smtp113.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750894AbYIHJF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 05:05:57 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=dTvPKvu+1siotR525b7+nVKI6BgE12I/xD4T7UtL3yYwR0uu6OqJyKrweZV2Q3txs3hw17exQX71aUW59n1Wz7vUZpzO5VBsh6pZCJ+LfooPc4uXv4pDFaknuqRv41KqzY9W4VGRd+tVDnQEtXqrKpZyauqn/swvn/N8G8HOxtI=  ;
X-YMail-OSG: rxvuJXcVM1lBbEYNOXpPuXuel.EGe_zDBf4nUdYP7vhsmbzo3epHg3f59kdmxroJCnBSxB49ThIDJwXegO91.tc2DGldj205sxAei5F9KqREdwW.LmMmadZWXR_pF9hkxuw-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.27-rc5-mm1: 3 WARN_ON dumps during boot (acpi + vmap_pte_range)
Date: Mon, 8 Sep 2008 19:05:40 +1000
User-Agent: KMail/1.9.5
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>, linux-kernel@vger.kernel.org,
       Dave Airlie <airlied@linux.ie>, Rusty Russell <rusty@rustcorp.com.au>
References: <20080906084558.dff614d4.krzysztof.h1@poczta.fm> <20080905235014.fc31b2b0.akpm@linux-foundation.org>
In-Reply-To: <20080905235014.fc31b2b0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809081905.40660.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 06 September 2008 16:50, Andrew Morton wrote:
> That's coming out of the module loader and is a new one.  It's the same
>
> warning as the agp one:
> : static int vmap_pte_range(pmd_t *pmd, unsigned long addr,
> : 		unsigned long end, pgprot_t prot, struct page **pages, int *nr)
> : {
> : 	pte_t *pte;
> :
> : 	/*
> : 	 * nr is a running index into the array which helps higher level
> : 	 * callers keep track of where we're up to.
> : 	 */
> :
> : 	pte = pte_alloc_kernel(pmd, addr);
> : 	if (!pte)
> : 		return -ENOMEM;
> : 	do {
> : 		struct page *page = pages[*nr];
> :
> : -->>		if (WARN_ON(!pte_none(*pte)))
> : 			return -EBUSY;
> : 		if (WARN_ON(!page))
> : 			return -ENOMEM;
> : 		set_pte_at(&init_mm, addr, pte, mk_pte(page, prot));
> : 		(*nr)++;
> : 	} while (pte++, addr += PAGE_SIZE, addr != end);
> : 	return 0;
> : }
>
> I'm suspecting an overactive assertion in the new vmap code?

It shouldn't be, because the old code has that same warning I think.

It also probably shouldn't be the caller, because nothing is using
the new interfaces yet.

I'm sure it must be something wrong with the vmap rewrite patch, but
I'm simply not having any luck reproducing it yet. Is 32-bit a common
theme? (I'm trying to test 64-bit with a greatly reduced vmalloc space,
but I don't have access to a 32-bit compiler just now - travelling).

I might have to send a test-and-report-back debug patch...
