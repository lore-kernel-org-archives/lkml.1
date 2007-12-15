Return-Path: <linux-kernel-owner+w=401wt.eu-S1758898AbXLOD4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758898AbXLOD4c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 22:56:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752776AbXLOD4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 22:56:25 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:13777 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755AbXLOD4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 22:56:24 -0500
Subject: [PATCH][RT] 2.6.24-rc5-rt1 drivers/dma/ioat_dma.c compile fix
From: Sven-Thorsten Dietrich <sven@thebigcorporation.com>
To: Steven Rostedt <rostedt@goodmis.org>, shannon.nelson@intel.com
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       trem <tremyfr@yahoo.fr>
In-Reply-To: <47435B31.2070304@yahoo.fr>
References: <BAE9DCEF64577A439B3A37F36F9B691C0371E3E3@orsmsx418.amr.corp.intel.com>
	 <Pine.LNX.4.58.0711161214480.24276@gandalf.stny.rr.com>
	 <47435B31.2070304@yahoo.fr>
Content-Type: text/plain
Organization: The Big Corporation
Date: Fri, 14 Dec 2007 19:56:13 -0800
Message-Id: <1197690973.12832.12.camel@sx.thebigcorporation.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve, 

looks like this patch didn't make it into 2.6.23-rc5-rt1.

I refreshed Trem's final version - please review and include in the next
RT release.

Thanks 

Sven 



On Tue, 2007-11-20 at 23:09 +0100, trem wrote:
> Steven Rostedt wrote:
> > On Fri, 16 Nov 2007, Nelson, Shannon wrote:
> >> first->async_tx.phys;
> >>> -       __list_splice(&new_chain, ioat_chan->used_desc.prev);
> >>> +       list_splice_tail(&new_chain, ioat_chan->used_desc.prev);
> >>>
> >> NAK.
> >>
> >> These functions do insertions differently.  The 'prev' is pointing
> to
> >> the last valid descriptor in the queue and you really want to get
> the
> >> new_chain stuck on after this.  Your list_splice_tail() will insert
> the
> >> new_chain just before it which will muck up the order of the DMA
> >> requests.
> >>
> >> You might have more success with
> >> 	list_splice_tail(&new_chain, ioat_chan->used_desc);
> >> where used_desc points to the whole list, rather than using
> the .prev
> >> pointer to a specific node.
> >>
> >> Please copy me on future ioatdma related comments.
> >>
> > 

> Hi
> 
> I've tried this change, but it still don't compile. So I propose this patch.
> 
> regards,
> trem


From: trem <tremyfr@yahoo.fr>
Subject:  Re: [PATCH][RT] 2.6.24-rc2-rt1 drivers/dma/ioat_dma.c compile fix

Steven Rostedt wrote:
> On Fri, 16 Nov 2007, Nelson, Shannon wrote:
>> first->async_tx.phys;
>>> -       __list_splice(&new_chain, ioat_chan->used_desc.prev);
>>> +       list_splice_tail(&new_chain, ioat_chan->used_desc.prev);
>>>
>> NAK.
>>
>> These functions do insertions differently.  The 'prev' is pointing to
>> the last valid descriptor in the queue and you really want to get the
>> new_chain stuck on after this.  Your list_splice_tail() will insert the
>> new_chain just before it which will muck up the order of the DMA
>> requests.
>>
>> You might have more success with
>> 	list_splice_tail(&new_chain, ioat_chan->used_desc);
>> where used_desc points to the whole list, rather than using the .prev
>> pointer to a specific node.
>>
>> Please copy me on future ioatdma related comments.
>>
> 
> And people wonder why we post RT related patches to LKML. This is exactly
> why!
> 
> Thanks for the response Shannon!
> 
> -- Steve
> 

Hi

I've tried this change, but it still don't compile. So I propose this patch.

regards,
trem

Acked-by: Sven-Thorsten Dietrich <sdietrich@suse.de>

------------------------

---
 drivers/dma/ioat_dma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.23/drivers/dma/ioat_dma.c
===================================================================
--- linux-2.6.23.orig/drivers/dma/ioat_dma.c
+++ linux-2.6.23/drivers/dma/ioat_dma.c
@@ -260,7 +260,7 @@ static dma_cookie_t ioat1_tx_submit(stru
 	/* write address into NextDescriptor field of last desc in chain */
 	to_ioat_desc(ioat_chan->used_desc.prev)->hw->next =
 							first->async_tx.phys;
-	__list_splice(&new_chain, ioat_chan->used_desc.prev);
+	list_splice(&new_chain, &ioat_chan->used_desc);
 
 	ioat_chan->dmacount += desc_count;
 	ioat_chan->pending += desc_count;



