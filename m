Return-Path: <linux-kernel-owner+w=401wt.eu-S1764767AbXKTWK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764767AbXKTWK1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 17:10:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757784AbXKTWKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 17:10:13 -0500
Received: from main.gmane.org ([80.91.229.2]:57645 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756875AbXKTWKL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 17:10:11 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: trem <tremyfr@yahoo.fr>
Subject: Re: [PATCH][RT] 2.6.24-rc2-rt1 drivers/dma/ioat_dma.c compile fix
Date: Tue, 20 Nov 2007 23:09:53 +0100
Message-ID: <47435B31.2070304@yahoo.fr>
References: <BAE9DCEF64577A439B3A37F36F9B691C0371E3E3@orsmsx418.amr.corp.intel.com> <Pine.LNX.4.58.0711161214480.24276@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: atoulouse-256-1-136-84.w90-45.abo.wanadoo.fr
User-Agent: Thunderbird 2.0.0.6 (X11/20071101)
In-Reply-To: <Pine.LNX.4.58.0711161214480.24276@gandalf.stny.rr.com>
Cc: linux-rt-users@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

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

------------------------

Index: linux-2.6.23/drivers/dma/ioat_dma.c
===================================================================
--- linux-2.6.23.orig/drivers/dma/ioat_dma.c
+++ linux-2.6.23/drivers/dma/ioat_dma.c
@@ -244,7 +244,7 @@ static dma_cookie_t ioat_tx_submit(struc
        /* write address into NextDescriptor field of last desc in chain */
        to_ioat_desc(ioat_chan->used_desc.prev)->hw->next =
                                                        first->async_tx.phys;
-       __list_splice(&new_chain, ioat_chan->used_desc.prev);
+       list_splice_tail(&new_chain, &ioat_chan->used_desc);
 
        ioat_chan->pending += desc_count;
        if (ioat_chan->pending >= 4) {

