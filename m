Return-Path: <linux-kernel-owner+w=401wt.eu-S1753842AbYJ1Rh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842AbYJ1Rh6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 13:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752478AbYJ1Rht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 13:37:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:37602 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142AbYJ1Rhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 13:37:48 -0400
Subject: Re: [patch 1/7] cpusets: add dirty map to struct address_space
From: Peter Zijlstra <peterz@infradead.org>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Paul Menage <menage@google.com>,
       Derek Fults <dfults@sgi.com>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.1.10.0810280259500.15270@chino.kir.corp.google.com>
References: <alpine.DEB.1.10.0810280259500.15270@chino.kir.corp.google.com>
Content-Type: text/plain
Date: Tue, 28 Oct 2008 18:37:39 +0100
Message-Id: <1225215459.15763.33.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-28 at 09:08 -0700, David Rientjes wrote:

> This patch implements the management of dirty node maps for an address
> space through the following functions:
> 
> cpuset_clear_dirty_nodes(mapping)	Clear the map of dirty nodes
> 
> cpuset_update_nodes(mapping, page)	Record a node in the dirty nodes
> 					map
> 
> cpuset_init_dirty_nodes(mapping)	Initialization of the map
> 
> 
> The dirty map may be stored either directly in the mapping (for NUMA
> systems with less then BITS_PER_LONG nodes) or separately allocated for
> systems with a large number of nodes (f.e. ia64 with 1024 nodes).
> 
> Updating the dirty map may involve allocating it first for large
> configurations.  Therefore, we protect the allocation and setting of a
> node in the map through the tree_lock.  The tree_lock is already taken
> when a page is dirtied so there is no additional locking overhead if we
> insert the updating of the nodemask there.

I find this usage of tree lock most bothersome, as my concurrent
pagecache patches take the lock out. In which case this _does_ cause
extra locking overhead.

