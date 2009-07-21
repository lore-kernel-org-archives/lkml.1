Return-Path: <linux-kernel-owner+w=401wt.eu-S1756007AbZGUTzM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007AbZGUTzM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 15:55:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755570AbZGUTzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 15:55:10 -0400
Received: from smtp-out.google.com ([216.239.33.17]:11037 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756002AbZGUTzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 15:55:08 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=kCWPn/WbhR8AEfV0RsC/leBE4ssBiT/IN8+8Y6m5tPuCq6vqXYnxm1BICAR6rNKbu
	l1FKK4ZYlyQxfrvt0sLaA==
Date: Tue, 21 Jul 2009 12:54:59 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Menage <menage@google.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mel@csn.ul.ie, npiggin@suse.de
Subject: Re: [PATCH] copy over oom_adj value at fork time
In-Reply-To: <6599ad830907210906tf81842ds897012bbf0e5606d@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0907211250530.10356@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0907171559290.30600@chino.kir.corp.google.com> <6599ad830907201452h5b57a444mf4be96e194cb737@mail.gmail.com> <20090721161319.2ABD.A69D9226@jp.fujitsu.com> <6599ad830907210906tf81842ds897012bbf0e5606d@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Jul 2009, Paul Menage wrote:

> No, Rik's patch just fixes the lack of inheritability that David
> introduced originally. It doesn't address the problem that the
> intention of the patches is to disallow separate processes sharing the
> same VM from having different oom_adj scores, which breaks the
> previous ability to vfork() or clone(CLONE_VM) a child and set its
> oom_adj to a non-disabled value prior to execve().
> 

That's exactly the scenario my patches were addressing, actually.  It was 
possible to get an oom killer livelock if a thread was constantly chosen 
when sharing memory with an OOM_DISABLE task.  So your example is a recipe 
for livelock without my patches since the parent is OOM_DISABLE and the 
child is not, yet they share an ->mm so neither can be killed.  If the 
child is repeatedly chosen prior to execve, no memory freeing is possible 
unless another task happens to exceed the badness score of the child.
