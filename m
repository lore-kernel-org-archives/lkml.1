Return-Path: <linux-kernel-owner+w=401wt.eu-S1753421AbYIDS0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbYIDS0N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 14:26:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752725AbYIDSZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 14:25:50 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:55017 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754040AbYIDSZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 14:25:49 -0400
Subject: Re: [RFC v3][PATCH 4/9] Memory management (dump)
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: containers@lists.linux-foundation.org, jeremy@goop.org,
       linux-kernel@vger.kernel.org, arnd@arndb.de
In-Reply-To: <Pine.LNX.4.64.0809040403120.5982@takamine.ncl.cs.columbia.edu>
References: <Pine.LNX.4.64.0809040354440.460@takamine.ncl.cs.columbia.edu>
	 <Pine.LNX.4.64.0809040403120.5982@takamine.ncl.cs.columbia.edu>
Content-Type: text/plain
Date: Thu, 04 Sep 2008 11:25:25 -0700
Message-Id: <1220552725.23386.46.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-09-04 at 04:03 -0400, Oren Laadan wrote:
> +/* free a chain of page-arrays */
> +void cr_pgarr_free(struct cr_ctx *ctx)
> +{
> +       struct cr_pgarr *pgarr, *pgnxt;
> +
> +       for (pgarr = ctx->pgarr; pgarr; pgarr = pgnxt) {
> +               _cr_pgarr_release(ctx, pgarr);
> +               free_pages((unsigned long) ctx->pgarr->addrs, CR_PGARR_ORDER);
> +               free_pages((unsigned long) ctx->pgarr->pages, CR_PGARR_ORDER);
> +               pgnxt = pgarr->next;
> +               kfree(pgarr);
> +       }
> +}

What we effectively have here is:

void *addrs[CR_PGARR_TOTAL];
void *pages[CR_PGARR_TOTAL];

right?

Would any of this get simpler if we just had:

struct cr_page {
	struct page *page;
	unsigned long vaddr;
};

struct cr_pgarr {
       struct cr_page *cr_pages;
       struct cr_pgarr *next;
       unsigned short nleft;
       unsigned short nused;
};

Also, we do have lots of linked list implementations in the kernel.
They do lots of fun stuff like poisoning and checking for
initialization.  We should use them instead of rolling our own.  It lets
us do other fun stuff like list_for_each().

Also, just looking at this structure 'nleft' and 'nused' sound a bit
redundant.  I know from looking at the code that this is how many have
been filled and read back at restore time, but that is not very obvious
looking at the structure.  I think we can do a bit better in the
structure itself.

The length of the arrays is fixed at compile-time, right?  Should we
just make that explicit as well?  

-- Dave

