Return-Path: <linux-kernel-owner+w=401wt.eu-S1755159AbYIGBy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159AbYIGBy1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 21:54:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753375AbYIGByS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 21:54:18 -0400
Received: from brinza.cc.columbia.edu ([128.59.29.8]:63640 "EHLO
	brinza.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbYIGByR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 21:54:17 -0400
Message-ID: <48C3343D.9000407@cs.columbia.edu>
Date: Sat, 06 Sep 2008 21:54:05 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: containers@lists.linux-foundation.org, jeremy@goop.org,
       linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [RFC v3][PATCH 4/9] Memory management (dump)
References: <Pine.LNX.4.64.0809040354440.460@takamine.ncl.cs.columbia.edu>	 <Pine.LNX.4.64.0809040403120.5982@takamine.ncl.cs.columbia.edu> <1220552725.23386.46.camel@nimitz>
In-Reply-To: <1220552725.23386.46.camel@nimitz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Dave Hansen wrote:
> On Thu, 2008-09-04 at 04:03 -0400, Oren Laadan wrote:
>> +/* free a chain of page-arrays */
>> +void cr_pgarr_free(struct cr_ctx *ctx)
>> +{
>> +       struct cr_pgarr *pgarr, *pgnxt;
>> +
>> +       for (pgarr = ctx->pgarr; pgarr; pgarr = pgnxt) {
>> +               _cr_pgarr_release(ctx, pgarr);
>> +               free_pages((unsigned long) ctx->pgarr->addrs, CR_PGARR_ORDER);
>> +               free_pages((unsigned long) ctx->pgarr->pages, CR_PGARR_ORDER);
>> +               pgnxt = pgarr->next;
>> +               kfree(pgarr);
>> +       }
>> +}
> 
> What we effectively have here is:
> 
> void *addrs[CR_PGARR_TOTAL];
> void *pages[CR_PGARR_TOTAL];
> 
> right?
> 
> Would any of this get simpler if we just had:
> 
> struct cr_page {
> 	struct page *page;
> 	unsigned long vaddr;
> };
> 
> struct cr_pgarr {
>        struct cr_page *cr_pages;
>        struct cr_pgarr *next;
>        unsigned short nleft;
>        unsigned short nused;
> };

The reason I use separate arrays instead of an array of tuples is that
the logic is to write all vaddr at once - simply by dumping the array
of vaddrs.

> 
> Also, we do have lots of linked list implementations in the kernel.
> They do lots of fun stuff like poisoning and checking for
> initialization.  We should use them instead of rolling our own.  It lets
> us do other fun stuff like list_for_each().
> 
> Also, just looking at this structure 'nleft' and 'nused' sound a bit
> redundant.  I know from looking at the code that this is how many have
> been filled and read back at restore time, but that is not very obvious
> looking at the structure.  I think we can do a bit better in the
> structure itself.
> 
> The length of the arrays is fixed at compile-time, right?  Should we
> just make that explicit as well?  

The length of the array may be tunable, or even adaptive (e.g. based
on statistics from recent checkpoints), in the future.

Oren.

