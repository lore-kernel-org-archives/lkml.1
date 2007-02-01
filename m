Return-Path: <linux-kernel-owner+w=401wt.eu-S1161228AbXBAB2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161228AbXBAB2B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 20:28:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161230AbXBAB2B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 20:28:01 -0500
Received: from stargate.chelsio.com ([12.22.49.110]:12975 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161228AbXBAB2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 20:28:00 -0500
Message-ID: <45C1420E.7080701@chelsio.com>
Date: Wed, 31 Jan 2007 17:27:42 -0800
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Divy Le Ray <None@chelsio.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, swise@opengridcomputing.com,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH 8/10] cxgb3 - Unmap offload packets when they are freed.
References: <20070131034424.8651.4713.stgit@localhost.localdomain> <45C07275.9010501@garzik.org>
In-Reply-To: <45C07275.9010501@garzik.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Feb 2007 01:27:45.0968 (UTC) FILETIME=[2D413300:01C745A0]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Divy Le Ray wrote:
>> From: Divy Le Ray <divy@chelsio.com>
>>
>> Offload packets may be DMAed long after their SGE Tx descriptors are 
>> done
>> so they must remain mapped until they are freed rather than until their
>> descriptors are freed.  Unmap such packets through an skb destructor.
>>
>> Signed-off-by: Divy Le Ray <divy@chelsio.com>
>
> this is questionable and sounds like you are working around a bug.  I 
> can't think of another driver that uses skb destructors, and I could 
> have sworn that skb destructors were not for drivers to use anyway
It's not a bug work around.  The payload of RDMA packets is DMAd lazily, 
potentially well after the DMA descriptors themselves have been 
processed and released. On plaftorms w/ IOMMUs, the packets need to 
remain mapped in the IOMMU until their payload is fetched, at which time 
the Scatter/Gather Engine may or may not still have knowledge of those 
packets.  So the SGE maps them for the IOMMU, then sets up the 
destructor so they can be unmapped whenever they complete.  It's true 
that drivers don't typically set up destructors but the lazy DMA this 
device does is also uncommon.  Packets carrying these destructors are 
exchanged between the RDMA driver and the low-level driver and aren't 
visible to any parts of the stack that may have different expectations 
of destructors.  Using the destructor is the simplest, most convenient 
way to solve this problem.

Cheers,
Divy
