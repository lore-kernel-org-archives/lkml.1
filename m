Return-Path: <linux-kernel-owner+w=401wt.eu-S1759490AbYCYTPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759490AbYCYTPh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 15:15:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758391AbYCYTPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 15:15:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:11877 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753984AbYCYTPQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 15:15:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,553,1199692800"; 
   d="scan'208";a="309526375"
X-MIMEOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [11/14] vcompound: Fallbacks for order 1 stack allocations on IA64 and x86
Date: Tue, 25 Mar 2008 12:09:49 -0700
Message-ID: <1FE6DD409037234FAB833C420AA843ECE9DDFA@orsmsx424.amr.corp.intel.com>
In-reply-to: <Pine.LNX.4.64.0803251036410.15870@schroedinger.engr.sgi.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [11/14] vcompound: Fallbacks for order 1 stack allocations on IA64 and x86
Thread-Index: AciOoHRrzFD2jnLHTuySZ/f1vGvFagAChZ4w
References: <20080321061726.782068299@sgi.com> <20080321.002502.223136918.davem@davemloft.net> <Pine.LNX.4.64.0803211037140.18671@schroedinger.engr.sgi.com> <20080321.145712.198736315.davem@davemloft.net> <Pine.LNX.4.64.0803241121090.3002@schroedinger.engr.sgi.com> <1FE6DD409037234FAB833C420AA843ECE5B84D@orsmsx424.amr.corp.intel.com> <Pine.LNX.4.64.0803251036410.15870@schroedinger.engr.sgi.com>
From: "Luck, Tony" <tony.luck@intel.com>
To: "Christoph Lameter" <clameter@sgi.com>
Cc: "David Miller" <davem@davemloft.net>, <linux-mm@kvack.org>,
       <linux-kernel@vger.kernel.org>, <linux-ia64@vger.kernel.org>
X-OriginalArrivalTime: 25 Mar 2008 19:09:50.0476 (UTC) FILETIME=[CCB0F4C0:01C88EAB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I thought the only pinned TLB entry was for the per cpu area? How does it 
> pin the TLB? The expectation is that a single TLB covers the complete 
> stack area? Is that a feature of fault handling?

Pinning TLB entries on ia64 is done using TR registers with the "itr"
instruction.  Currently we have the following pinned mappings:

itr[0] : maps kernel code.  64MB page at virtual 0xA000000100000000
dtr[1] : maps kernel data.  64MB page at virtual 0xA000000100000000

itr[1] : maps PAL code as required by architecture

dtr[1] : maps an area of region 7 that spans kernel stack
         page size is kernel granule size (default 16M).
         This mapping needs to be reset on a context switch
         where we move to a stack in a different granule.

We used to used dtr[2] to map the 64K per-cpu area at 0xFFFFFFFFFFFF0000
but Ken Chen found that performance was better to use a dynamically
inserted DTC entry from the Alt-TLB miss handler which allows this
entry in the TLB to be available for generic use (on most processor
models).

-Tony

