Return-Path: <linux-kernel-owner+w=401wt.eu-S1756662AbZEKTKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662AbZEKTKW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 15:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753458AbZEKTKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 15:10:07 -0400
Received: from smtp-out.google.com ([216.239.45.13]:29693 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208AbZEKTKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 15:10:05 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=MKMPzUCHpnPAPOgFRDm9dFK1vcvL3gORakXTn+1kbd6lXcVKgvxU2pRQd/Mi1VigT
	mRbxIwWZPNVGfq35+sX0g==
Date: Mon, 11 May 2009 12:09:57 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Hansen <dave@linux.vnet.ibm.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Mel Gorman <mel@csn.ul.ie>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <cl@linux-foundation.org>,
       San Mehat <san@android.com>, Arve Hjonnevag <arve@android.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 08/11 -mmotm] oom: invoke oom killer for __GFP_NOFAIL
In-Reply-To: <1242057793.8109.34342.camel@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.0905111159130.23739@chino.kir.corp.google.com>
References: <20090511085750.B9AC.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.0905101719040.31823@chino.kir.corp.google.com> <20090511104310.B9C1.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.0905110143190.24726@chino.kir.corp.google.com>
 <1242057793.8109.34342.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 May 2009, Dave Hansen wrote:

> Could you explain a little more about why you think this scenario works
> for you?  Are large contiguous areas of memory pinned by the task
> getting which you want to get killed?  Why wasn't swapping effective
> against this task?  Was the task itself taking up a large portion of
> total memory?
> 

We frequently do cpuset-constrained oom kills where the lionshare of 
memory on a set of nodes is allocated by a single task or a group of 
threads all sharing the same memory.  Swapping is largely effective but at 
this point in the code path it's obviously not making any progress in 
freeing pages.  So this change fixes two issues:

 - __GFP_NOFAIL allocations should not be allowed to return NULL, and

 - we should prevent looping endlessly in the page allocator if reclaim
   cannot free the requisite amount of memory.

There is no reason that the oom killer would not be able to kill a task 
that could free 64K of contiguous memory, especially for those that 
mlock() their memory.  You could argue that any __GFP_NOFAIL allocation 
above order 3 is insane and should not kill tasks, but that's an issue 
higher up the stack.  If you'd like to identify such instances, we could 
emit a warning message here and a stack trace.
