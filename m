Return-Path: <linux-kernel-owner+w=401wt.eu-S1761920AbXKPRHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761920AbXKPRHj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 12:07:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753635AbXKPRHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 12:07:31 -0500
Received: from mga09.intel.com ([134.134.136.24]:4592 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752131AbXKPRHa convert rfc822-to-8bit (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 12:07:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,426,1188802800"; 
   d="scan'208";a="206801218"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: Re: [PATCH][RT] 2.6.24-rc2-rt1 drivers/dma/ioat_dma.c compile fix
Date: Fri, 16 Nov 2007 09:07:29 -0800
Message-ID: <BAE9DCEF64577A439B3A37F36F9B691C0371E3E3@orsmsx418.amr.corp.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Re: [PATCH][RT] 2.6.24-rc2-rt1 drivers/dma/ioat_dma.c compile fix
Thread-Index: AcgocuIH/9ndVZ4lTrWnMLERhY99xwAACP0A
From: "Nelson, Shannon" <shannon.nelson@intel.com>
To: <linux-rt-users@vger.kernel.org>, <Linux-kernel@vger.kernel.org>,
       "Sven-Thorsten Dietrich" <sdietrich@novell.com>
X-OriginalArrivalTime: 16 Nov 2007 17:07:29.0971 (UTC) FILETIME=[2BB54830:01C82873]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 16, 2007 3:57 AM, Sven-Thorsten Dietrich <sdietrich@novell.com>
wrote:
> Compile fix for new code in -rc2.
> 
> I'm not positive about the insertion point...
> 
> Subject: compile error fix (needs review)
> 
> RT changes __list_splice to require prev and next pointers.
> 
> This changes the use in the new code to list_splice_tail,
> but the optimal insertion point needs to be analyzed.
> 
> Signed-off-by: Sven-Thorsten Dietrich <sdietrich@suse.de>
> 
> ---
>  drivers/dma/ioat_dma.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6.23/drivers/dma/ioat_dma.c
> ===================================================================
> --- linux-2.6.23.orig/drivers/dma/ioat_dma.c
> +++ linux-2.6.23/drivers/dma/ioat_dma.c
> @@ -244,7 +244,7 @@ static dma_cookie_t ioat_tx_submit(struc
>         /* write address into NextDescriptor field of last desc in
chain */
>         to_ioat_desc(ioat_chan->used_desc.prev)->hw->next =
>
first->async_tx.phys;
> -       __list_splice(&new_chain, ioat_chan->used_desc.prev);
> +       list_splice_tail(&new_chain, ioat_chan->used_desc.prev);
> 

NAK.

These functions do insertions differently.  The 'prev' is pointing to
the last valid descriptor in the queue and you really want to get the
new_chain stuck on after this.  Your list_splice_tail() will insert the
new_chain just before it which will muck up the order of the DMA
requests.

You might have more success with
	list_splice_tail(&new_chain, ioat_chan->used_desc);
where used_desc points to the whole list, rather than using the .prev
pointer to a specific node.

Please copy me on future ioatdma related comments.

Thanks,
sln
--
======================================================================
Mr. Shannon Nelson                 LAN Access Division, Intel Corp.
Shannon.Nelson@intel.com                I don't speak for Intel
(503) 712-7659                    Parents can't afford to be squeamish.
