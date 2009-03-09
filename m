Return-Path: <linux-kernel-owner+w=401wt.eu-S1754205AbZCIU12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205AbZCIU12 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 16:27:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752935AbZCIU1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 16:27:19 -0400
Received: from smtp-out.google.com ([216.239.45.13]:62410 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386AbZCIU1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 16:27:18 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=vQFe1xEB72HNKbkmlXctdE1YdekNYguCWiIytmmsOJbBykoj+b3KhJHlnKGhsjRDu
	lP4OCsX7V5d/4sic/1GMw==
Date: Mon, 9 Mar 2009 13:26:15 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Paul Menage <menage@google.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch -mm] cpusets: add memory_slab_hardwall flag
In-Reply-To: <20090309181756.CF66.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0903091313090.27253@chino.kir.corp.google.com>
References: <20090309123011.A228.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.0903090206010.24605@chino.kir.corp.google.com> <20090309181756.CF66.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Mar 2009, KOSAKI Motohiro wrote:

> My question mean, Why anyone need isolation?
> your patch insert new branch into hotpath.
> then, it makes slower hotpath a abit although a user don't use this feature.
> 

On large NUMA machines, it is currently possible for a very large 
percentage (if not all) of your slab allocations to come from memory that 
is distant from your application's set of allowable cpus.  Such 
allocations that are long-lived would benefit from having affinity to 
those processors.  Again, this is the typical use case for cpusets: to 
bind memory nodes to groups of cpus with affinity to it for the tasks 
attached to the cpuset.

> typically, slab cache don't need strict node binding because
> inode/dentry touched from multiple cpus.
> 

This change would obviously require inode and dentry objects to originate 
from a node on the cpuset's set of mems_allowed.  That would incur a 
performance penalty if the cpu slab is not from such a node, but that is 
assumed by the user who has enabled the option.

> In addition, on large numa systems, slab cache is relatively small
> than page cache. then this feature's improvement seems relatively small too.
> 

That's irrelevant, large NUMA machines may still require memory affinity 
to a specific group of cpus, the size of the global slab cache isn't 
important if that's the goal.  When the option is enabled for cpusets 
that require that memory locality, we happily trade off partial list 
fragmentation and increased slab allocations for the long-lived local 
allocations.
