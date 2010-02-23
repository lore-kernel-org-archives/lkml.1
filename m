Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042Ab0BWIoN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 03:44:13 -0500
Received: from smtp-out.google.com ([216.239.44.51]:48535 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171Ab0BWIoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 03:44:12 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=fZIIVq8m3psUNp4vD/QJfrxb+PoMFJ3SdZC/Az+RKlfya4zzreFzIdXrFC/9w/dju
	SI33ydO392arQcLcZOYwg==
Date: Tue, 23 Feb 2010 00:44:02 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Miao Xie <miaox@cn.fujitsu.com>
cc: Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Lee Schermerhorn <lee.schermerhorn@hp.com>
Subject: Re: [regression] cpuset,mm: update tasks' mems_allowed in time
 (58568d2)
In-Reply-To: <4B839103.2060901@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1002230041240.12015@chino.kir.corp.google.com>
References: <20100218134921.GF9738@laptop> <alpine.DEB.2.00.1002181302430.13707@chino.kir.corp.google.com> <20100219033126.GI9738@laptop> <alpine.DEB.2.00.1002190143040.6293@chino.kir.corp.google.com> <20100222121222.GV9738@laptop>
 <alpine.DEB.2.00.1002221400060.23881@chino.kir.corp.google.com> <4B839103.2060901@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Feb 2010, Miao Xie wrote:

> Sorry, Could you explain what you advised?
> I think it is hard to fix this problem by adding a variant, because it is
> hard to avoid loading a word of the mask before
> 
> 	nodes_or(tsk->mems_allowed, tsk->mems_allowed, *newmems);
> 
> and then loading another word of the mask after
> 
> 	tsk->mems_allowed = *newmems;
> 
> unless we use lock.
> 
> Maybe we need a rw-lock to protect task->mems_allowed.
> 

I meant that we need to define synchronization only for configurations 
that do not do atomic nodemask_t stores, it's otherwise unnecessary.  
We'll need to load and store tsk->mems_allowed via a helper function that 
is defined to take the rwlock for such configs and only read/write the 
nodemask for others.
