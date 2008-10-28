Return-Path: <linux-kernel-owner+w=401wt.eu-S1754033AbYJ1Utm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbYJ1Utm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 16:49:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753142AbYJ1Utd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 16:49:33 -0400
Received: from smtp-out.google.com ([216.239.45.13]:49031 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687AbYJ1Utc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 16:49:32 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type;
	b=v+tmZnb9vQkRuYspu8FZ23fbP8wed+GgpMLkBE/Dw+0X18UKbTx2H8xbRmAsWEZlo
	wBKiwFjxfZPJcyb339n9w==
Date: Tue, 28 Oct 2008 13:48:53 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Paul Menage <menage@google.com>,
       Derek Fults <dfults@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/7] cpusets: add dirty map to struct address_space
In-Reply-To: <1225215459.15763.33.camel@lappy.programming.kicks-ass.net>
Message-ID: <alpine.DEB.1.10.0810281337530.6470@chino.kir.corp.google.com>
References: <alpine.DEB.1.10.0810280259500.15270@chino.kir.corp.google.com> <1225215459.15763.33.camel@lappy.programming.kicks-ass.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Oct 2008, Peter Zijlstra wrote:

> > This patch implements the management of dirty node maps for an address
> > space through the following functions:
> > 
> > cpuset_clear_dirty_nodes(mapping)	Clear the map of dirty nodes
> > 
> > cpuset_update_nodes(mapping, page)	Record a node in the dirty nodes
> > 					map
> > 
> > cpuset_init_dirty_nodes(mapping)	Initialization of the map
> > 
> > 
> > The dirty map may be stored either directly in the mapping (for NUMA
> > systems with less then BITS_PER_LONG nodes) or separately allocated for
> > systems with a large number of nodes (f.e. ia64 with 1024 nodes).
> > 
> > Updating the dirty map may involve allocating it first for large
> > configurations.  Therefore, we protect the allocation and setting of a
> > node in the map through the tree_lock.  The tree_lock is already taken
> > when a page is dirtied so there is no additional locking overhead if we
> > insert the updating of the nodemask there.
> 
> I find this usage of tree lock most bothersome, as my concurrent
> pagecache patches take the lock out. In which case this _does_ cause
> extra locking overhead.
> 

Yeah, if we don't serialize with tree_lock then we'll need to protect the 
attachment of mapping->dirty_nodes with a new spinlock in struct 
address_space (and only for configs where MAX_NUMNODES > BITS_PER_LONG). 
That locking overhead is negligible when mapping->dirty_nodes is non-NULL 
since there's no requirement to protect the setting of the node in the 
nodemask.

Are your concurrent pagecache patches in the latest mmotm?  If so, I can 
rebase this entire patchset off that.
