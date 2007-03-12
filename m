Return-Path: <linux-kernel-owner+w=401wt.eu-S1752450AbXCLXzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450AbXCLXzl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 19:55:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752463AbXCLXzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 19:55:41 -0400
Received: from smtp-out.google.com ([216.239.45.13]:22454 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450AbXCLXzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 19:55:40 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:user-agent:mime-version:to:cc:
	subject:references:in-reply-to:content-type:content-transfer-encoding;
	b=E3crPwEGgMwKyhEbxHrTo7lLaiwgFY1ngDlC1Oqr9JQUrx2ozH30YycNTMUYIijgr
	AsMssOAfB/owa3Q2r9/Eg==
Message-ID: <45F5E84B.9010901@google.com>
Date: Mon, 12 Mar 2007 16:54:51 -0700
From: Ethan Solomita <solo@google.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/1] mm: Inconsistent use of node IDs
References: <45F5D974.2050702@google.com> <200703130019.30953.ak@suse.de>
In-Reply-To: <200703130019.30953.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Monday 12 March 2007 23:51, Ethan Solomita wrote:
>> This patch corrects inconsistent use of node numbers (variously "nid" or
>> "node") in the presence of fake NUMA.
> 
> I think it's very consistent -- your patch would make it inconsistent though.

	It's consistent to call node_online() with a physical node ID when the 
online node mask is composed of fake nodes?

> Sorry, but when you ask for NUMA emulation you will get it. I don't see
> any point in a "half way only for some subsystems I like" NUMA emulation. 
> It's unlikely that your ideas of where it is useful and where is not
> matches other NUMA emulation user's ideas too.

	I don't understand your comments. My code is intended to work for all 
systems. If the system is non-NUMA by nature, then all CPUs map to fake 
node 0.

	As an example, on a two chip dual-core AMD opteron system, there are 4 
"cpus" where CPUs 0 and 1 are close to the first half of memory, and 
CPUs 2 and 3 are close to the second half. Without this change CPUs 2 
and 3 are mapped to fake node 1. This results in awful performance. With 
this change, CPUs 2 and 3 are mapped to (roughly) 1/2 the fake node 
count. Their zonelists[] are ordered to do allocations preferentially 
from zones that are local to CPUs 2 and 3.

	Can you tell me the scenario where my code makes things worse?

> Besides adding such a secondary node space would be likely a huge long term 
> mainteance issue. I just can it see breaking with every non trivial change.

	I'm adding no data structures to do this. The current code already has 
get_phys_node. My changes use the existing information about node 
layout, both the physical and fake, and defines a mapping. The current 
mapping just takes a physical node and says "it's the fake node too".

> NACK.

	I wish you would include some specifics as to why you think what you 
do. You're suggesting we leave in place a system that destroys NUMA 
locality when using fake numa, and passes around physical node ids as an 
index into nodes[] whihc is indexed by fake nodes. My change has no 
effect without fake numa, and harms no one with fake numa.
	-- Ethan
