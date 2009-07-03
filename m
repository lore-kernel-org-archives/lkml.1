Return-Path: <linux-kernel-owner+w=401wt.eu-S1757756AbZGCPkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757756AbZGCPkj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 11:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758004AbZGCPkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 11:40:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:58761 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757761AbZGCPkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 11:40:21 -0400
Message-ID: <4A4E2638.9080101@kernel.org>
Date: Fri, 03 Jul 2009 08:39:36 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: alex.shi@intel.com, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       "bugzilla-daemon@bugzilla.kernel.org" 
	<bugzilla-daemon@bugzilla.kernel.org>,
       "bugme-daemon@bugzilla.kernel.org" <bugme-daemon@bugzilla.kernel.org>,
       Mel Gorman <mel@csn.ul.ie>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       yanmin.zhang@intel.com, tim.c.chen@intel.com
Subject: Re: [Bugme-new] [Bug 13690] New: nodes_clear cause hugepage unusable
 on non-NUMA machine
References: <bug-13690-10286@http.bugzilla.kernel.org/>  <20090701183452.8660c8a9.akpm@linux-foundation.org>  <4A4C17FD.3080404@kernel.org> <1246517111.15721.5.camel@alexs-hp> <4A4C74D8.30809@kernel.org> <alpine.DEB.1.10.0907021003450.16359@gentwo.org>
In-Reply-To: <alpine.DEB.1.10.0907021003450.16359@gentwo.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Thu, 2 Jul 2009, Yinghai Lu wrote:
> 
>> Index: linux-2.6/arch/x86/mm/init_64.c
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/mm/init_64.c
>> +++ linux-2.6/arch/x86/mm/init_64.c
>> @@ -598,8 +598,14 @@ void __init paging_init(void)
>>
>>  	sparse_memory_present_with_active_regions(MAX_NUMNODES);
>>  	sparse_init();
>> -	/* clear the default setting with node 0 */
>> +#if MAX_NUMNODES > 1
>> +	/*
>> +	 * clear the default setting with node 0
>> +	 * note: don't clear it, node_set_state will do nothing
>> +	 *	 (aka set it back) when numa support is not compiled in
>> +	 */
>>  	nodes_clear(node_states[N_NORMAL_MEMORY]);
> 
> The problem was that nodes_clear() does not fall back to a noop on !NUMA.
> The node_set/clear_states() operations do become noops.
> 
> Could we make it more consistent by using only operations of the same
> type? F.e. Add a node_clearall_states() in include/linux/nodemask.h that
> falls back to a noop on !NUMA like the node_*_states operation?
> 
> Another options is to restore node_states[N_NORMAL_MEMORY] to its
> initial condition. See the definition of node_states in page_alloc.c.

could use node_clear_state(0, N_NORMAL_MEMORY) instead. because default one only have node 0 set in that mask.

YH
