Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659Ab0BPG7i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 01:59:38 -0500
Received: from smtp-out.google.com ([216.239.44.51]:32021 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384Ab0BPG7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 01:59:36 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=HDie6TwBoa4o9zuSMxR1dNtNbjqaN1beEEAIKiwgGFbIuCFkOnsmvd2a0fxOdpdGg
	IEd0JmihY3AjIrW5OGVfA==
Date: Mon, 15 Feb 2010 22:59:26 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Nick Piggin <npiggin@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch -mm 4/9 v2] oom: remove compulsory panic_on_oom mode
In-Reply-To: <20100216062035.GA5723@laptop>
Message-ID: <alpine.DEB.2.00.1002152252310.2745@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1002151416470.26927@chino.kir.corp.google.com> <alpine.DEB.2.00.1002151418190.26927@chino.kir.corp.google.com> <20100216062035.GA5723@laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Feb 2010, Nick Piggin wrote:

> What is the point of removing it, though? If it doesn't significantly
> help some future patch, just leave it in. It's not worth breaking the
> user/kernel interface just to remove 3 trivial lines of code.
> 

Because it is inconsistent at the user's expense, it has never panicked 
the machine for memory controller ooms, so why is a cpuset or mempolicy 
constrained oom conditions any different?  It also panics the machine even 
on VM_FAULT_OOM which is ridiculous, the tunable is certainly not being 
used how it was documented and so given the fact that mempolicy 
constrained ooms are now much smarter with my rewrite and we never simply 
kill current unless oom_kill_quick is enabled anymore, the compulsory 
panic_on_oom == 2 mode is no longer required.  Simply set all tasks 
attached to a cpuset or bound to a specific mempolicy to be OOM_DISABLE, 
the kernel need not provide confusing alternative modes to sysctls for 
this behavior.  Before panic_on_oom == 2 was introduced, it would have 
only panicked the machine if panic_on_oom was set to a non-zero integer, 
defining it be something different for '2' after it has held the same 
semantics for years is inappropriate.  There is just no concrete example 
that anyone can give where they want a cpuset-constrained oom to panic the 
machine when other tasks on a disjoint set of mems can continue to do 
work and the cpuset of interest cannot have its tasks set to OOM_DISABLE.
