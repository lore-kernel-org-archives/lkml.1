Return-Path: <linux-kernel-owner+w=401wt.eu-S1756310AbXF0JWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310AbXF0JWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 05:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753184AbXF0JWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 05:22:09 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58763 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753014AbXF0JWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 05:22:08 -0400
Date: Wed, 27 Jun 2007 02:21:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Kuan Luo" <kluo@nvidia.com>
Cc: <linux-kernel@vger.kernel.org>, <jeff@garzik.org>,
       "Peer Chen" <pchen@nvidia.com>
Subject: Re: [PATCH] ata: Add the SW NCQ support to sata_nv for
 MCP51/MCP55/MCP61
Message-Id: <20070627022114.455bc0d6.akpm@linux-foundation.org>
In-Reply-To: <15F501D1A78BD343BE8F4D8DB854566B059FE157@hkemmail01.nvidia.com>
References: <53f198c00706262004v27c80134m892dcf89d6c48e00@mail.gmail.com>
	<20070626222655.0270c7b7.akpm@linux-foundation.org>
	<15F501D1A78BD343BE8F4D8DB854566B059FE157@hkemmail01.nvidia.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

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
> >This is peculiar.  The array is sized ATA_MAX_QUEUE+1 (ie: 33) and the
> code
> >uses ATA_MAX_QUEUE+1 everywhere.
> 
> >It looks to me like the ata code was designed to queue up to 32
> elements
> >and all this code has taken that to 33.  What exactly is going on here?
> 
> 
> The code is designed to contain 32 elements. But the position of rear
> doesn't point to
> a valid element to check whether the queue is full or null. If front ==
> rear , queue is null.
>  if (rear + 1) % (ATA_MAX_QUEUE + 1) == front, queue is full.
> So the value of the array is 32 + 1.

that's the wrong way of doing a circular buffer..

It's better to allow the head and tail indices to wrap all the way through
0xffffffff and only mask them when they are actually used for subscripting.
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


