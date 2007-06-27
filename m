Return-Path: <linux-kernel-owner+w=401wt.eu-S1757333AbXF0KSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333AbXF0KSo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 06:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753487AbXF0KSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 06:18:36 -0400
Received: from hqemgate01.nvidia.com ([216.228.112.170]:19460 "EHLO
	HQEMGATE01.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072AbXF0KSg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 06:18:36 -0400
x-mimeole: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] ata: Add the SW NCQ support to sata_nv for MCP51/MCP55/MCP61
Date: Wed, 27 Jun 2007 18:17:51 +0800
Message-ID: <15F501D1A78BD343BE8F4D8DB854566B059FE158@hkemmail01.nvidia.com>
In-Reply-To: <20070627022114.455bc0d6.akpm@linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] ata: Add the SW NCQ support to sata_nv for MCP51/MCP55/MCP61
Thread-Index: Ace4nKV+BC71xsFzSAS1yjiPYS1aiwABtKXQ
References: <53f198c00706262004v27c80134m892dcf89d6c48e00@mail.gmail.com><20070626222655.0270c7b7.akpm@linux-foundation.org><15F501D1A78BD343BE8F4D8DB854566B059FE157@hkemmail01.nvidia.com> <20070627022114.455bc0d6.akpm@linux-foundation.org>
From: "Kuan Luo" <kluo@nvidia.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, <jeff@garzik.org>,
       "Peer Chen" <pchen@nvidia.com>
X-OriginalArrivalTime: 27 Jun 2007 10:17:52.0231 (UTC) FILETIME=[6B934770:01C7B8A4]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A pretty good way.  I will modify my code.

-----Original Message-----
From: Andrew Morton [mailto:akpm@linux-foundation.org] 
Sent: Wednesday, June 27, 2007 5:21 PM
To: Kuan Luo
Cc: linux-kernel@vger.kernel.org; jeff@garzik.org; Peer Chen
Subject: Re: [PATCH] ata: Add the SW NCQ support to sata_nv for
MCP51/MCP55/MCP61

On Wed, 27 Jun 2007 17:09:29 +0800 "Kuan Luo" <kluo@nvidia.com> wrote:

> > +static void nv_swncq_qc_to_dq(struct ata_port *ap, struct
> ata_queued_cmd *qc)
> > +{
> > +	struct nv_swncq_port_priv *pp = ap->private_data;
> > +	defer_queue_t	*dq = &pp->defer_queue;
> > +	
> > +	/* queue is full */
> > +	WARN_ON((dq->rear + 1) % (ATA_MAX_QUEUE + 1) == dq->front);
> 
> >This is peculiar.  The array is sized ATA_MAX_QUEUE+1 (ie: 33) and
the
> code
> >uses ATA_MAX_QUEUE+1 everywhere.
> 
> >It looks to me like the ata code was designed to queue up to 32
> elements
> >and all this code has taken that to 33.  What exactly is going on
here?
> 
> 
> The code is designed to contain 32 elements. But the position of rear
> doesn't point to
> a valid element to check whether the queue is full or null. If front
==
> rear , queue is null.
>  if (rear + 1) % (ATA_MAX_QUEUE + 1) == front, queue is full.
> So the value of the array is 32 + 1.

that's the wrong way of doing a circular buffer..

It's better to allow the head and tail indices to wrap all the way
through
0xffffffff and only mask them when they are actually used for
subscripting.
That way:

add:
	array[head++ & (ATA_MAX_QUEUE-1)] = item;

remove:
	item = array[tail++ & (ATA_MAX_QUEUE-1)];

full:
	head - tail == ATA_MAX_QUEUE

empty:
	head == tail

number of items:
	head - tail

This requires that the array size be a power of two.


-----------------------------------------------------------------------------------
This email message is for the sole use of the intended recipient(s) and may contain
confidential information.  Any unauthorized review, use, disclosure or distribution
is prohibited.  If you are not the intended recipient, please contact the sender by
reply email and destroy all copies of the original message.
-----------------------------------------------------------------------------------
