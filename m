Return-Path: <linux-kernel-owner+w=401wt.eu-S1757631AbZEOS35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757631AbZEOS35 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 14:29:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756482AbZEOS3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 14:29:24 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:39950 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756297AbZEOS3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 14:29:22 -0400
Date: Fri, 15 May 2009 13:57:53 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Pavel Machek <pavel@ucw.cz>
cc: Dave Hansen <dave@linux.vnet.ibm.com>,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Mel Gorman <mel@csn.ul.ie>, Peter Ziljstra <a.p.ziljstra@chello.nl>,
       San Mehat <san@android.com>, Arve Hj?nnev?g <arve@android.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Misleading OOM messages
In-Reply-To: <20090514213403.GB14741@elf.ucw.cz>
Message-ID: <alpine.DEB.1.10.0905151346550.26559@qirst.com>
References: <alpine.DEB.2.00.0905101458430.18804@chino.kir.corp.google.com> <alpine.DEB.2.00.0905101503070.18804@chino.kir.corp.google.com> <alpine.DEB.1.10.0905121708470.14226@qirst.com> <20090514092909.GG1365@ucw.cz> <alpine.DEB.1.10.0905141546040.1381@qirst.com>
 <1242333519.15391.210.camel@nimitz> <alpine.DEB.2.00.0905141346030.28074@chino.kir.corp.google.com> <1242335120.15391.242.camel@nimitz> <alpine.DEB.1.10.0905141729180.30187@qirst.com> <20090514213403.GB14741@elf.ucw.cz>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 May 2009, Pavel Machek wrote:

> > "No available memory" still suggests that plugging in more memory is the
> > right solution.
>
> And... on correctly working kernel, it is, right?

Nope. Usually something else is amiss if OOM occurs.

> If you have no swap space and too many applications, you plug more
> memory. (Or invent some swap).

Thats not a usual configuration. OOM there also depends on various OS
knobs. The failure occurred because application did anonymous allocations
and you did not give the OS a way to effectively push these pages out to
disk. Thus it was not able to reclaim memory.

> If you misconfigured cgroups, you give more memory to them.

If you do not have enough memory in a cgroup then your application should
slow down (because of page evictions) but the system should not OOM.
Are cgroups broken or why are you getting OOMs when using them?

> If your applications mlocked 900MB and you have 1GB, you need to plug
> more memory.

IMHO the mlocking is the issue. There are safeguards (ulimit) to prevent
this. Again a typical misconfiguration that requires disabling safeguards.
If you increase memory then more memory is likely going to be mlocked by
whoever went crazy with mlocking in the first place.

> So... when is plugging more memory _not_ valid answer? AFAICT it is
> when it is some kernel problem, resulting in memory not being
> reclaimed fast enough....

Reclaim failures occur typically because memory is not reclaimable due to
mlocking, memory allocation in a context where we cannot perform
effective reclaim (no disk access, atomic context) (device
drivers are prone to that), or when asking for higher order pages and the
defrag logic cannot satisfy your request.

Then there is the issue on 32 bit platforms where certain kernel
allocations must occur in the memory zone under 1G. If you add more memory
then less memory is available e under !G because the kernel needs to
allocate more metadata to manage more memory. Thus you OOM faster.

So I thin that an OOM is about misconfigurations or a kernel bug. If the
application needs more memory then the pageing mechanism of the OS should
create more virtual memory for the process.

