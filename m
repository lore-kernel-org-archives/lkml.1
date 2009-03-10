Return-Path: <linux-kernel-owner+w=401wt.eu-S1754020AbZCJCBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020AbZCJCBz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 22:01:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752046AbZCJCBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 22:01:45 -0400
Received: from smtp-out.google.com ([216.239.33.17]:49968 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbZCJCBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 22:01:44 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=gmlwh1FB5fAlfSaTSMwtDQNSi9WJKQmyvypUB5TKeR1tppz6Th5zZoKSsca/9PAZO
	YRPMNwdwXjaUFKTzVG9jA==
Date: Mon, 9 Mar 2009 19:01:18 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Paul Menage <menage@google.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch -mm] cpusets: add memory_slab_hardwall flag
In-Reply-To: <20090310102926.A47E.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0903091853000.25296@chino.kir.corp.google.com>
References: <alpine.DEB.1.10.0903091448110.20314@qirst.com> <alpine.DEB.2.00.0903091307570.27253@chino.kir.corp.google.com> <20090310102926.A47E.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Mar 2009, KOSAKI Motohiro wrote:

> That's pointless.
> Again, any fastpath modification should have reasonable reason.
> We are looking for your explanation.
> 

The fastpath modification simply checks if the hardwall bit is set in the 
allocating task's cpuset flags.  If it's disabled, there is no additional 
overhead.

This requirement was mandated during the first review of the patch by 
Christoph, who requested that it be configurable.  Before that it was 
possible to simply check if the global `number_of_cpusets' count was > 1.  
If not, cpuset_node_allowed_hardwall() would always return true.  If the 
system had more than one cpuset, it would have reduced to checking

	return in_interrupt() || (gfp_mask & __GFP_THISNODE) ||
	       node_isset(node, current->mems_allowed);

As I already mentioned, if fastpath optimization is your only concern, 
that we could simply add PF_SLAB_HARDWALL task flags that would simply 
make this

	return current->flags & PF_SLAB_HARDWALL;

So the fastpath cost can be mitigated at the expense of an additional task 
flag.
