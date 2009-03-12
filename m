Return-Path: <linux-kernel-owner+w=401wt.eu-S1757372AbZCLSp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372AbZCLSp0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 14:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754934AbZCLSpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 14:45:12 -0400
Received: from smtp-out.google.com ([216.239.33.17]:4840 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754857AbZCLSpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 14:45:10 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=IzPQCkwpS7I4g9mz7hIkkfIaC82Q1Ywp8Y/qfapkd/XBbNhfulkh+4mqeuWyDAY/E
	UWCLHOXSeuYxaoIakf9oQ==
Date: Thu, 12 Mar 2009 11:43:57 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Paul Menage <menage@google.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch -mm v2] cpusets: add memory_slab_hardwall flag
In-Reply-To: <alpine.DEB.1.10.0903121145510.27660@qirst.com>
Message-ID: <alpine.DEB.2.00.0903121137320.1514@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0903091920100.7539@chino.kir.corp.google.com> <alpine.DEB.1.10.0903101651480.20363@qirst.com> <alpine.DEB.2.00.0903101416160.4495@chino.kir.corp.google.com> <alpine.DEB.1.10.0903121145510.27660@qirst.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Mar 2009, Christoph Lameter wrote:

> > Cpusets are hierarchical, so it is quite possible that a parent cpuset
> > will include a group of cpus that has affinity to a specific group of
> > mems.  This isolates that cpuset and all of its children for NUMA
> > optimiziations.  Within that, there can be several descendant cpusets that
> > include disjoint subsets of mems to isolate the memory that can be used
> > for specific jobs.
> 
> Yes cpusets are hierachical for management purposes but it is well known
> that overlaying cpusets for running applications can cause issues with the
> scheduler etc. Jobs run in the leaf not in the higher levels that may
> overlap.
> 

Yes, jobs are running in the leaf with my above example.  And it's quite 
possible that the higher level has segmented the machine for NUMA locality 
and then further divided that memory for individual jobs.  When a job 
completes or is killed, the slab cache that it has allocated can be freed 
in its entirety with no partial slab fragmentation (i.e. there are no 
objects allocated from its slabs for disjoint, still running jobs).  That 
cpuset may then serve another job.
