Return-Path: <linux-kernel-owner+w=401wt.eu-S1760696AbXH0Tbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760696AbXH0Tbh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 15:31:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932272AbXH0TbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 15:31:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:41660 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932195AbXH0TbM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 15:31:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,313,1183359600"; 
   d="scan'208";a="122224260"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [md-accel PATCH 16/19] dmaengine: driver for the iop32x, iop33x, and iop13xx raid engines
Date: Mon, 27 Aug 2007 12:31:10 -0700
Message-ID: <0C7297FA1D2D244A9C7F6959C0BF1E52025B10E4@azsmsx413.amr.corp.intel.com>
In-Reply-To: <c70ff3ad0708270614t6f17b38nfbdf84ace69b8d78@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [md-accel PATCH 16/19] dmaengine: driver for the iop32x, iop33x, and iop13xx raid engines
Thread-Index: AcforCpGTGSf57AMR/+X5MV/HEqZjgAMhwfQ
References: <20070627014823.18962.96398.stgit@dwillia2-linux.ch.intel.com> <20070627015155.18962.88413.stgit@dwillia2-linux.ch.intel.com> <c70ff3ad0708270611x5598fa9dlc3afa5f6fabd6563@mail.gmail.com> <c70ff3ad0708270614t6f17b38nfbdf84ace69b8d78@mail.gmail.com>
From: "Williams, Dan J" <dan.j.williams@intel.com>
To: "saeed bishara" <saeed.bishara@gmail.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-raid@vger.kernel.org>,
       <neilb@suse.de>, "Nelson, Shannon" <shannon.nelson@intel.com>
X-OriginalArrivalTime: 27 Aug 2007 19:31:11.0366 (UTC) FILETIME=[D3000260:01C7E8E0]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From: saeed bishara [mailto:saeed.bishara@gmail.com]
> Hi Dan,
> I think you have a bug in this function, the list_splice_init adds the
> new slots in the head of the chain_node, but you get the
> old_chain_tail (latest descriptor) from the tail of the chain!!
> 
>  > +static dma_cookie_t
>  > +iop_adma_tx_submit(struct dma_async_tx_descriptor *tx)
>  > +{
>  > +
>  > +       old_chain_tail = list_entry(iop_chan->chain.prev,
>  > +               struct iop_adma_desc_slot, chain_node);
>  > +       list_splice_init(&sw_desc->group_list, &old_chain_tail-
> >chain_node);
>  > +
>  > +       /* fix up the hardware chain */
>  > +       iop_desc_set_next_desc(old_chain_tail, grp_start->phys);
>  > +
[ dropped akpm, davem, jeff, and chris from the cc ]

This looks ok to me.  &sw_desc->group_list is the head of a new list of
descriptors to be added to the chain.  old_chain_tail is youngest
descriptor at the end of the current channel chain.

Before list_splice_init:
old_chain_tail->next = channel_chain_head
channel_chain_head->prev = old_chain_tail
new_chain_start->prev = sw_desc->group_list;
new_chain_end->next = sw_desc->group_list;

After list_splice_init:
new_chain_start->prev = old_chain_tail
old_chain_tail->next = new_chain_start
new_chain_end->next = channel_chain_head
channel_chain_head->prev = new_chain_end

sw_desc->group_list is empty

--
Dan
