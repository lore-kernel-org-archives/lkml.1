Return-Path: <linux-kernel-owner+w=401wt.eu-S1752852AbYAXNyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852AbYAXNyr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 08:54:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751749AbYAXNyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 08:54:37 -0500
Received: from mail2.neteffect.com ([204.57.75.68]:30221 "EHLO
	mail2.neteffect.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbYAXNyh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 08:54:37 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: InfiniBand/RDMA merge plans for 2.6.25
Date: Thu, 24 Jan 2008 07:54:36 -0600
Message-ID: <5E701717F2B2ED4EA60F87C8AA57B7CC0794FEB4@venom2>
In-Reply-To: <adave5kp1g0.fsf@cisco.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: InfiniBand/RDMA merge plans for 2.6.25
Thread-Index: AcheF5aj+WigHiacTsC8awNCWSpncwAd6tWg
From: "Glenn Streiff" <gstreiff@NetEffect.com>
To: "Roland Dreier" <rdreier@cisco.com>,
       "Christoph Hellwig" <hch@infradead.org>
Cc: <linux-kernel@vger.kernel.org>, <general@lists.openfabrics.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> From: Roland Dreier [mailto:rdreier@cisco.com]
> To: Christoph Hellwig; Glenn Streiff 
> 
> Rather than arguing over whether we have to have sparse clean code, I
> decided to annotate the code myself.  Here's a patch that fixes most
> of the sparse warnings in the nes driver.  There's still some stuff
> that actually looks buggy, like the way hte_index stuff is handled.
> You initialize hte_index_mask as:
> 
> 	hte_index_mask = ((u32)1 << ((u32temp & 0x001f)+1))-1;
> 	nesadapter->hte_index_mask = hte_index_mask;
> 
> but then compute hte_index stuff with:
> 
> 	nesqp->hte_index = cpu_to_be32(
> 			crc32c(~0, (void *)&nes_quad, 
> sizeof(nes_quad)) ^ 0xffffffff);
> 
> and then do:
> 
> 	nesqp->hte_index &= nesadapter->hte_index_mask;
> 
> which seems odd to say the least (hte_index is big-endian,
> hte_index_mask is cpu-endian).
> 
> And also, there's code with the loc_addr/rem_addr etc that seem very
> confused.  For example
> 
> 	cm_info->loc_addr = htonl(cm_info->loc_addr);
> 	cm_info->rem_addr = htonl(cm_info->rem_addr);
> 	cm_info->loc_port = htons(cm_info->loc_port);
> 	cm_info->rem_port = htons(cm_info->rem_port);
> 
> which is obviously impossible to annotate correctly, and I couldn't
> keep track of the endianness stuff elsewhere.

Thanks for the additional review and patch.  I take your point.  

The part is little endian and the driver is functional for little and big endian 
platforms.  There may have been some expedience with the declarations there.  
I think it can be improved.  Let me take it up with the person who wrote that code.

Also, I want everyone to understand that my skill set is weighted more
towards build/install/config.  And I guess I'll be patch wrangling as well.
So I'll rely on input from my developers for issues that drill down or
I'll have them post directly.  I respect the work you guys do.

For now, let me get some qa cycles with your patch across x86_64 and power
(and probably a couple others).

Regards,

Glenn

> 
> Anyway this is what I have in case the promised cleanups don't turn up
> in time...
> 
> Signed-off-by: Roland Dreier <rolandd@cisco.com>
> 
> 
