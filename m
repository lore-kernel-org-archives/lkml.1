Return-Path: <linux-kernel-owner+w=401wt.eu-S1753820AbZCIJOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820AbZCIJOQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 05:14:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752927AbZCIJNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 05:13:25 -0400
Received: from smtp-out.google.com ([216.239.33.17]:33806 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365AbZCIJNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 05:13:21 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=bAVh127a46WoSfUcHe51DGK4jQg0M/QJbuhrlCf+DollKJd4N77ohbkNQxCbcbk08
	wdTFx49hDGCheDiYHeTlw==
Date: Mon, 9 Mar 2009 02:12:21 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Paul Menage <menage@google.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch -mm] cpusets: add memory_slab_hardwall flag
In-Reply-To: <20090309123011.A228.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0903090206010.24605@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0903080917460.25207@chino.kir.corp.google.com> <20090309123011.A228.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Mar 2009, KOSAKI Motohiro wrote:

> Hmmm,
> this description only explay how to implement this.
> but no explain why this patch is useful.
> 
> Could you please who and why need it?
> 

The change to Documentation/cgroups/cpusets.txt should have explained it.

This is for two cases: true memory isolation (now including slab 
allocations at the object level) and NUMA optimizations.

Prior to this change, it was possible for slabs to be allocated in a 
cpuset while its objects were largely consumed by disjoint cpusets.  We 
can fix that by only allocating objects from slabs that are found on 
current->mems_allowed.  While this incurs a performance penalty, some 
users may find that true isolation outweighs the cache optimizations.

It is also helpful for long-lived objects that require NUMA affinity to a 
certain cpu or group of cpus.  That is, after all, the reasoning behind 
cpusets in the first place.  If slab objects were all allocated from a 
node with remote affinity to the cpus that will be addressing it, it 
negates a significant advantage that cpusets provides to the user.
