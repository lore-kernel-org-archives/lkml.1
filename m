Return-Path: <linux-kernel-owner+w=401wt.eu-S1753382AbZGAPbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbZGAPbf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 11:31:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbZGAPb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 11:31:28 -0400
Received: from mail.atmel.fr ([81.80.104.162]:54982 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092AbZGAPb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 11:31:27 -0400
Message-ID: <4A4B812E.2080308@atmel.com>
Date: Wed, 01 Jul 2009 17:30:54 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>, dan.j.williams@intel.com
CC: maciej.sosnowski@intel.com, avictor.za@gmail.com,
       linux-arm-kernel@lists.arm.linux.org.uk, patrice.vilchez@atmel.com,
       linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: [PATCH 1/2 v2] dmaengine: at_hdmac: new driver for the Atmel
 AHB DMA Controller
References: <1246012936-10812-1-git-send-email-nicolas.ferre@atmel.com> <20090628.000624.208780184.anemo@mba.ocn.ne.jp>
In-Reply-To: <20090628.000624.208780184.anemo@mba.ocn.ne.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Atsushi Nemoto :
> On Fri, 26 Jun 2009 12:42:15 +0200, Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
>> This AHB DMA Controller (aka HDMA or DMAC on AT91 systems) is availlable on
>> at91sam9rl chip. It will be used on other products in the future.
> 
> It seems this driver was written based on dw_dmac driver.  A while ago
> I had some investigation of that driver.
> (http://lkml.org/lkml/2008/12/29/172)

Thank you for recall me this thread.

> Some of issues reported at that time could be applied on your driver
> too.  With a quick look, the queue list management issue is a
> candidate.  Here is an excerpt from the thread:
> 
> --- --- ---
> 3.  dwc->queue list management
> 
> The function dwc_tx_submit() add the descriptor to dwc->queue list if
> active list was not empty.  But it does not manage lli.llp list.  And
> all descriptors in the queue list will be moved to active list at a
> time.  So it seems non-first descriptors in queue list will never
> processed by the hardware.
> 
> The dwc_tx_submit() should rewrite lli.llp of the last descriptor in
> queue list (it it had children, the last children of it) by txd.phys
> of newly queued descriptor.  Or, only first elements of queue list
> should be moved to active list at a time.
> 
> Is my analysis correct?

I try to replay the life of a descriptor chain in "queue" list:
- it is queued by atc_tx_submit()
- tasklet or atc_issue_pendig() will "advance_work" and so run
atc_complete_all() at some point.
- atc_complete_all() will issue an atc_dostart() on the first chain in
queue list and move all to active_list
- then all chains will be managed as active_list members:
  - tasklet or atc_issue_pendig() will "advance_work"
  - first member will be managed by chain_complete()
  - next member will be started by dostart()
  - and so on...
- last chain in active_list will run complete_all() and may move again
queued descriptors to active_list.

=> non-first descriptor moved from queue to active_list will be
proceeded by act_dostart() in atc_advance_work() function.

In this way of addressing descriptors, I try to keep descriptor chains
as they are built by the prep_dma_memcpy function. I am not trying to
rewrite the internal arrangement of a descriptor chain (not touching
lli.dscr).
It may be not optimal for the descriptor management speed but it tries
to split problems in a kind of layered way (we build chains and then
manage their flow in dma engine and associated lists).

I hope that there is no hole in this management as I am sure it is
difficult to debug...
I hope that my response is solid enough. Please do not hesitate to break
my demonstration ;-).

> --- --- ---
> 
> And one more comment.
> 
>> +	/*
>> +	 * We use dma_unmap_page() regardless of how the buffers were
>> +	 * mapped before they were submitted...
>> +	 */
> 
> You can use DMA_COMPL_{SRC,DEST}_UNMAP_SINGLE since 2.6.30.

Ok, even if it is exactly the same for ARM implementation, I do the
modification for my driver (taking iop_dma.c as an example).


Thanks a lot for your help and your deep review.

Best regards,
-- 
Nicolas Ferre

