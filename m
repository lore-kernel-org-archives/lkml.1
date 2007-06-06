Return-Path: <linux-kernel-owner+w=401wt.eu-S1753240AbXFFHSa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240AbXFFHSa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 03:18:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752380AbXFFHSS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 03:18:18 -0400
Received: from smtp-out.google.com ([216.239.45.13]:47256 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbXFFHSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 03:18:15 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=fBIScSWt0hDFH5r8ziUoTzQCiT93HwQriyE4Sud3f1KFhC+VQQPS5nEslzKQSYiP6
	5Tetei1SwNDzdOznNAo1w==
Date: Wed, 6 Jun 2007 00:18:00 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Christoph Lameter <clameter@engr.sgi.com>, Paul Jackson <pj@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] cpusets: do not allow TIF_MEMDIE tasks to allocate
 globally
In-Reply-To: <1181113753.7348.164.camel@twins>
Message-ID: <alpine.DEB.0.99.0706060012260.15316@chino.kir.corp.google.com>
References: <alpine.DEB.0.99.0706051537450.13200@chino.kir.corp.google.com>
  <1181110846.7348.154.camel@twins>  <alpine.DEB.0.99.0706052334280.30783@chino.kir.corp.google.com>
 <1181113753.7348.164.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jun 2007, Peter Zijlstra wrote:

> Right, I see your point; however considering that its a system
> allocation, and all these constraints get violated by interrupts anyway,
> its more of an application container than a strict allocation container.
> 

It is not necessarily system allocations at all.  It is quite possible, as 
described earlier, to mlock a large quantity of memory that exceeds the 
capacity of all nodes in a task's mems_allowed and then when this task 
OOM's to continue allocating memory in get_user_pages() but with the 
TIF_MEMDIE exception that allows it to allocate anywhere.  Then other 
cpusets get their memory infringed upon and they can OOM themselves even 
though there was no preexisting memory pressure.  This happens before we 
return to userspace in the mlock() and thus we cannot properly handle the 
SIGKILL sent down from the OOM killer.

> Are you actually seeing the described behaviour, or just being pedantic
> (nothing wrong with that per-se)?
> 

Yes, as described above.  An exclusive cpuset containing only root, 
system-critical tasks was OOM'd when it was not under any memory pressure 
at all because a separate exclusive cpuset mlock'd a gigantic amount of 
memory and it could not reliably exit because the mlock continued to 
allocate outside its own cpuset and eventually OOM'd system-critical tasks 
or depleated all system memory.  True story.

At the least, if this patch is not agreed upon, I would suggest adding 
sanity checks against gfp_mask in cpuset_zone_allowed() to ensure we 
should allow the allocation in TIF_MEMDIE circumstances to avoid the above 
scenario.

		David
