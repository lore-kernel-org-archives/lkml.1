Return-Path: <linux-kernel-owner+w=401wt.eu-S1751725AbYLXSHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751725AbYLXSHU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 13:07:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbYLXSHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 13:07:08 -0500
Received: from main.gmane.org ([80.91.229.2]:54733 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751148AbYLXSHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 13:07:06 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Robert Hancock <hancockr@shaw.ca>
Subject: Memory vs. MMIO ordering, again
Date: Wed, 24 Dec 2008 12:06:54 -0600
Message-ID: <gittnv$2qj$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: s0106000c41bb86e1.ss.shawcable.net
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A question came up recently about memory ordering in libata. Essentially 
we have the classic case (ata_bmdma_setup in drivers/ata/libata-sff.c) 
where we do some writes to memory (specifically the PRD table) and want 
to make sure the device will see those writes before we poke it to go 
and use that memory. Right now this is using an mb() (which seems like 
overkill, even in the worst case it seems like only a wmb() should be 
needed).

I just finished digging through the 2006 LKML discussion "Opinion on 
ordering of writel vs. stores to RAM" which ironically failed to clearly 
answer the question asked in its subject.

Documentation/memory-barriers.txt does not answer this question either. 
The only thing it contains that seems to pertain to this question is the 
following:

"Memory mapped I/O usually takes place through memory locations that are 
part of a window in the CPU's memory space that has different properties 
assigned than the usual RAM directed window.

Amongst these properties is usually the fact that such accesses bypass 
the caching entirely and go directly to the device buses.  This means 
MMIO accesses may, in effect, overtake accesses to cached memory that 
were emitted earlier. A memory barrier isn't sufficient in such a case, 
but rather the cache must be flushed between the cached memory write and 
the MMIO access if the two are in any way dependent."

This seems like BS to me.. Flush the cache? How is a driver supposed to 
know how to do that? Furthermore, why should it need to worry about this 
  kind of detail? This seems wrong or at least a low-level detail that 
normal code should not have to be concerned with.

 From what I can vaguely infer from that 2006 discussion it seems like 
powerpc was going to be fixed so that writel, etc. would provide the 
expected ordering with respect to memory writes, however I don't know if 
this is actually the case. The documentation that driver writers would 
rely on should be updated to be explicit on this question...

