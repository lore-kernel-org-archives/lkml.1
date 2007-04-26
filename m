Return-Path: <linux-kernel-owner+w=401wt.eu-S1031371AbXDZSkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031371AbXDZSkF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 14:40:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031429AbXDZSkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 14:40:04 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:2155 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031371AbXDZSkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 14:40:01 -0400
Message-ID: <4630F203.7020005@shadowen.org>
Date: Thu, 26 Apr 2007 19:40:03 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc7-mm2 -- PPC link failure
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org> <4630A662.8090502@shadowen.org> <4630ABF2.1040305@shadowen.org> <4630EBFA.9000207@shadowen.org> <Pine.LNX.4.64.0704261123080.3560@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0704261123080.3560@schroedinger.engr.sgi.com>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Thu, 26 Apr 2007, Andy Whitcroft wrote:
> 
>>> Ok, this is a SLUB related link failure.  Am investigating if PPC simply
>>> needs larger allocs and needs CONFIG_LARGE_ALLOCS, of if this is an
>>> inlining issue.
>> Ok this is confirmed as an inlining issue.  With the compiler below on
>> ppc64 we get the above link failure:
>>
>>   gcc version 3.3.3 (SuSE Linux)
>>
>> What seems to happen is that although the optimiser is capable of
>> collapsing the kmalloc_index() call it then fails to collapse
>> kmalloc_slab().  This leads to the never used reference to
>> __kmalloc_size_too_large() and the link failure.  From my testing this
>> seems to occur at sizes >= 32k.  At 16k all of the code collapses
> 
> Interesting. Why would that boundary be of relevance to the compiler? Some 
> offset heuristics?
> 
>> correctly, at 32k it does not.  I am not entirely sure what to think at
>> this point, it is cirtainly not at all clear why the 32k version fails
>> and the 16k succeeds they are almost identical.
> 
> Likely a backend optimization issue.
> 
>> Either way it seems to me that assuming the optimiser will remove the
>> code is perhaps over optimistic.  Perhaps it would make more sense to
>> put a BUG() in here.  Though that points out the anomaly that the
>> kmalloc() for constants has different semantics to that for variable values?
> 
> Yes but that has always been the case. We want to reduce kmalloc for 
> constants at compile time to use the appropriate kmalloc cache. If kmalloc 
> does not use a constant then we will do run time determination of the 
> kmalloc cache.
> 
> The code in SLAB is easier to fold since it does not use a subroutine call.
> 
> We could simply #ifdef out the __kmalloc_sizes_too_large for ppc and let 
> it fall back to __kmalloc? That would mean only that kmallocs >32k 
> would require an additional determination of the kmalloc cache at run 
> time.
> 
> But then how important is gcc 3.3 support?

Well we say 3.2 is the minimum.  If we simply return(NULL) or BUG() in
that branch the generated code actually works and is mostly optimised
away.  We end up with the assembly equivalent of:

	index = 15;
	if (index == 0)
		return NULL;
	if (index < 0)
		__kmalloc_sizes_too_large();

	return &kmalloc_caches[index];

The code is functionally correct, just stupid as clearly the if's can
never trigger.  We do not need to lose the constant optimisation, its
just that the clever attempt to get a link error fails on this compiler.

I am inclined to suggest we change it for BUG:

	BUG(index < 0);

Perhaps only on older compilers.

-apw
