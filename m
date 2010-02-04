Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932792Ab0BDVtK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 16:49:10 -0500
Received: from smtp-out.google.com ([216.239.33.17]:40738 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757684Ab0BDVtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 16:49:07 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=YEC0CcPDtrtf8tEEBjf5myChooI0T9opKaVzdnZOZj+p4yonzPLgCp8zFTmQLfPyz
	W3fIYJl9G58rty90wRGqg==
Date: Thu, 4 Feb 2010 13:48:59 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Rik van Riel <riel@redhat.com>
cc: Lubos Lunak <l.lunak@suse.cz>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Jiri Kosina <jkosina@suse.cz>
Subject: Re: Improving OOM killer
In-Reply-To: <4B6A1241.60009@redhat.com>
Message-ID: <alpine.DEB.2.00.1002041339220.6071@chino.kir.corp.google.com>
References: <201002012302.37380.l.lunak@suse.cz> <20100203170127.GH19641@balbir.in.ibm.com> <alpine.DEB.2.00.1002031021190.14088@chino.kir.corp.google.com> <201002032355.01260.l.lunak@suse.cz> <alpine.DEB.2.00.1002031600490.27918@chino.kir.corp.google.com>
 <4B6A1241.60009@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Feb 2010, Rik van Riel wrote:

> > Do you have any comments about the forkbomb detector or its threshold that
> > I've put in my heuristic?  I think detecting these scenarios is still an
> > important issue that we need to address instead of simply removing it from
> > consideration entirely.
> 
> I believe that malicious users are best addressed in person,
> or preemptively through cgroups and rlimits.
> 

Forkbombs need not be the result of malicious users.

> Having a process with over 500 children is quite possible
> with things like apache, Oracle, postgres and other forking
> daemons.
> 

It's clear that the forkbomb threshold would need to be definable from 
userspace and probably default to something high such as 1000.

Keep in mind that we're in the oom killer here, though.  So we're out of 
memory and we need to kill something; should Apache, Oracle, and postgres 
not be penalized for their cost of running by factoring in something like 
this?

	(lowest rss size of children) * (# of first-generation children) / 
			(forkbomb threshold)

> Killing the parent process can result in the service
> becoming unavailable, and in some cases even data
> corruption.
> 

There's only one possible rememdy for that, which is OOM_DISABLE; the oom 
killer cannot possibly predict data corruption as the result of killing a 
process and this is no different.  Everything besides init, kthreads, 
OOM_DISABLE threads, and threads that do not share the same cpuset, memcg, 
or set of allowed mempolicy nodes are candidates for oom kill.
