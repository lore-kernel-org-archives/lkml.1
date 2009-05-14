Return-Path: <linux-kernel-owner+w=401wt.eu-S1753699AbZENVMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699AbZENVMk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 17:12:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbZENVMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 17:12:30 -0400
Received: from smtp-out.google.com ([216.239.33.17]:6684 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbZENVMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 17:12:30 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=T5S6aopHMfL3qkFqTwuOTAXPxP2SU8q7U39EOeZlh6oVVSX/VzVQxaO4Lt+k8dNDm
	jCmMqj+E7UWnD51YADHhA==
Date: Thu, 14 May 2009 14:12:23 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Hansen <dave@linux.vnet.ibm.com>
cc: Christoph Lameter <cl@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Mel Gorman <mel@csn.ul.ie>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       San Mehat <san@android.com>, Arve Hj?nnev?g <arve@android.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Misleading OOM messages
In-Reply-To: <1242335120.15391.242.camel@nimitz>
Message-ID: <alpine.DEB.2.00.0905141412130.30300@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0905101458430.18804@chino.kir.corp.google.com> <alpine.DEB.2.00.0905101503070.18804@chino.kir.corp.google.com> <alpine.DEB.1.10.0905121708470.14226@qirst.com> <20090514092909.GG1365@ucw.cz> <alpine.DEB.1.10.0905141546040.1381@qirst.com>
 <1242333519.15391.210.camel@nimitz> <alpine.DEB.2.00.0905141346030.28074@chino.kir.corp.google.com> <1242335120.15391.242.camel@nimitz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 May 2009, Dave Hansen wrote:

> On Thu, 2009-05-14 at 13:49 -0700, David Rientjes wrote:
> > I think switching all the oom killer messages to be "no available memory" 
> > as it is in the MPOL_BIND case would be the best alternative.  We 
> > currently use "out of memory" even for cpusets, for example, when it 
> > happens because it cannot accommodate any more hardwall allocations while 
> > there may be an abundance of memory elsewhere that it cannot access.  I 
> > also think "no available memory" makes more sense than "out of memory" 
> > when describing situations where we're at or below the minimum watermarks 
> > for all allowable zones.  Either that or "no allowable memory".
> 
> How about something like this to start?  We can "mv mm/oom_kill.c
> mm/nam_kill.c" later. ;)
> 

I don't think it's that easy, I think we need to indicate what the set of 
available memory is.  For instance, we need to show the nodes that 
MPOL_BIND is allowed to access, what the hard limit for the memory cgroup 
is, what current->mems_allowed is for cpuset ooms, why we can't allocate 
in ZONE_DMA or ZONE_DMA32 because of lowmem_reserve_ratio, etc.

oom_kill_allocating_task, for instance, can indicate all of the above 
scenarios but it doesn't show the cause for the oom like others do, even 
with your patch.  It simply shows that 
/proc/sys/vm/oom_kill_allocating_task was set to avoid the expensive 
tasklist scan.
