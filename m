Return-Path: <linux-kernel-owner+w=401wt.eu-S1753987Ab0ADX2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987Ab0ADX2y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 18:28:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753421Ab0ADX2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 18:28:51 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:48347 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157Ab0ADX2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 18:28:51 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,5851"; a="31360004"
Message-ID: <4B4279A1.4090706@codeaurora.org>
Date: Mon, 04 Jan 2010 15:28:33 -0800
From: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: RFC non barrier versions of dma_map functions 
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello  All,

   This is a request for extending the DMA api for efficient handling of 
multiple buffers or scatter gather mapping/unmapping operations.

   I am based on an ARMv7 device and we have a situation where we need 
to dma map multiple cached buffers for a single dma transaction.

   The current DMA api suggests the use of dma_map_single/ 
dma_unmap_single for cache consistency. On ARMv7 it performs the 
necessary cache-operations and calls data sync barrier instruction 
(DSB). In our case we would be executing multiple DSB instructions
before starting the dma operation - we need memory to be consistent
only after we map the last buffer.

   I am thinking we could define "no barrier" version's of all the 
mapping/unmapping functions and then a barrier function that results
in DSB before the dma is started.

   Here are numbers from a test ran on my board.

It kmallocs N buffers of size 'size', dirties their cache by writing
to them and calls dma_map_single that calls the arch specific clean
operations with and without DSB. In "without DSB" case a dsb is executed
after the last buffer is mapped. The time is in microseconds

size    N    map_single    map_single w/o DSB    delta
128    16    8             5                     60%
512    16    9             6                     50%
512    32    15            8                     88%
512    48    20            11                    82%
512    64    27            14                    93%
64     4     4             3                     33%
64     8     4             3                     33%
64     16    7             4                     75%
64     32    12            4                     200%
64     48    17            6                     183%
64     64    21            7                     200%
1024   16    9             7                     29%

These buffer sizes and N are very close to real world sizes the
framebuffer driver handles. Cases where N is large happen the most
often.

Clearly,we could benefit from the nobarrier versions of the cache
operations and we could use them in scatter gather mappings as well.

Since this kind of API change will affect all the platforms, I was 
directed by the arm-linux community to take this up on the linux kernel 
mailing list.

For architectures that don't need a barrier for the completions of
cache operations we can simply call the existing
dma_map_signle/dma_unmap_single.

Requesting alternative ideas or code design to get the desired 
nonbarrier versions of the mapping functions.

Thanks,
Abhijeet Dharmapurikar

