Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932981Ab0BDAWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 19:22:18 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:11045 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932096Ab0BDAWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 19:22:15 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,5881"; a="33403407"
Message-ID: <4B6A131B.1070005@codeaurora.org>
Date: Wed, 03 Feb 2010 16:21:47 -0800
From: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Tony Lindgren <tony@atomide.com>, Larry Bassel <lbassel@quicinc.com>,
       Daniel Walker <dwalker@codeaurora.org>,
       Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org
Subject: Re: [RFC PATCH] ARM: Change the mandatory barriers implementation
References: <20100203161434.15912.42697.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <20100203161434.15912.42697.stgit@pc1117.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The mandatory barriers (mb, rmb, wmb) are used even on uniprocessor
> systems for things like ordering Normal Non-cacheable memory accesses
> with DMA transfer (via Device memory writes). The current implementation
> uses dmb() for mb() and friends but this is not sufficient. The DMB only
> ensures the ordering of accesses with regards to a single observer
> accessing the same memory. If a DMA transfer is started by a write to
> Device memory, the data to be transfered may not reach the main memory
> (even if mapped as Normal Non-cacheable) before the device receives the
> notification to begin the transfer. The only barrier that would help in
> this situation is DSB which would completely drain the write buffers.

On ARMv7, DMB guarantees that all accesses prior to DMB are observed by 
an observer if that observer sees any accesses _after_ the DMB. In this 
case, since DMA engine observes a write to itself( It is being written 
to and hence must observe the write) it should also see the writes to 
the buffers. A dmb() after the writes to buffer and before write to DMA 
engine should suffice.

Moreover an mb() could be in places where accesses to ARM's Device type 
memory need ordering and are 1kb apart. Such usages of mb() would result 
in a dsb() and could cause performance problems.

Since you mention the write buffers this probably applies only to ARMv6. 
Correct me here, I think that dmb on ARMv6 should suffice too.
