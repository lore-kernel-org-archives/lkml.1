Return-Path: <linux-kernel-owner+w=401wt.eu-S934809AbZDBF4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934809AbZDBF4M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 01:56:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754281AbZDBFzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 01:55:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:37519 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612AbZDBFzy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 01:55:54 -0400
Message-ID: <49D45364.2010703@kernel.org>
Date: Thu, 02 Apr 2009 14:55:48 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: More problems in setup_pcpu_remap()
References: <20090401.213112.96144152.davem@davemloft.net>	<49D44251.4000606@kernel.org> <20090401.215233.134215150.davem@davemloft.net>
In-Reply-To: <20090401.215233.134215150.davem@davemloft.net>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 02 Apr 2009 05:55:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, David.

David Miller wrote:
>> I guess we'll have to put a cap on how high possible cpus can be for
>> remap allocator.  e.g. if single chunk size is over 20% of the whole
>> vmalloc area, don't use remap.  Does anyone have a good random %
>> number on mind?
> 
> I would suggest instead to rethink what this code is doing.

Actually, I've been looking at the numbers and I'm not sure if the
concern is valid.  On x86_32, the practical number of maximum
processors would be around 16 so it will end up 32M, which isn't nice
and it would probably a good idea to introduce a parameter to select
which allocator to use but still it's far from consuming all the VM
area.  On x86_64, the vmalloc area is obscenely large at 2^45, ie 32
terabytes.  Even with 4096 processors, single chunk is measly 0.02%.

If it's a problem for other archs or extreme x86_32 configurations, we

can add some safety measures but in general I don't think it is a
problem.

> It would make more sense to carve up 2MB chunks into some-power-of-2
> pieces and use that as the unit size.
>
> You could retain the NUMA goals of this function, as well as the
> ability to be using 2MB pages in the TLBs.

Can you please elaborate a bit?

> And consider that if the dynamic allocation part of this code triggers
> even once, you'll end up eating twice as much VMALLOC space.
> 
> Using 2MB per cpu is just rediculious, and really not even necessary.

The focus at the moment is using large page for the first chunk to
reduce pressure on TLB, not necessarily actually using 2MB for each
unit.

Thanks.

-- 
tejun
