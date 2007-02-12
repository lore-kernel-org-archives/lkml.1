Return-Path: <linux-kernel-owner+w=401wt.eu-S964825AbXBLJdJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964825AbXBLJdJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 04:33:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964827AbXBLJdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 04:33:09 -0500
Received: from smtp-out.google.com ([216.239.33.17]:29569 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964825AbXBLJdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 04:33:05 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=WoR076p/LgV3KMeSE0/i4BKWrnUoSwvL6z+GbBviz7aD+g9dVXmWiEsfnrHZC4Fkr
	p2mmpjDiXLZXuhP/MJJHw==
Message-ID: <6599ad830702120132r181d338cy28b23736fa393de5@mail.gmail.com>
Date: Mon, 12 Feb 2007 01:32:51 -0800
From: "Paul Menage" <menage@google.com>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: [PATCH 0/7] containers (V7): Generic Process Containers
Cc: akpm@osdl.org, sekharan@us.ibm.com, dev@sw.ru, xemul@sw.ru,
       serue@us.ibm.com, vatsa@in.ibm.com, ebiederm@xmission.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       rohitseth@google.com, mbligh@google.com, winget@google.com,
       containers@lists.osdl.org, devel@openvz.org
In-Reply-To: <20070212011843.c6e8f4ae.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070212081521.808338000@menage.corp.google.com>
	 <20070212011843.c6e8f4ae.pj@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/12/07, Paul Jackson <pj@sgi.com> wrote:
>
> You'll have a rough time selling me on the idea that some kernel thread
> should be waking up every few seconds, grabbing system-wide locks, on a
> big honkin NUMA box, for the few times per hour, or less, that a cpuset is
> abandoned.

I think it could be made smarter than that, e.g. have a workqueue task
that's only woken when a refcount does actually reach zero. (I think
that waking a workqueue task is something that can be done without too
much worry about locks)

>
> Can you explain to me how this intruded on the reference counting?
>

Essentially, it means that anything that releases a reference count on
a container needs to be able to trigger a call to the release agent.
The reference count is often released at a point when important locks
are held, so you end up having to pass buffers into any function that
might drop a ref count, in order to store a path to a release agent to
be invoked.

In particular, the new container_clone() function can be called during
the task fork path; at which point forking a new release_agent process
would be impossible, or at least nasty. Additionally, if containers
are potentially going to be used for virtual servers, having the
release agent run from a top-level process rather than the process
context that released the refcount sounds like a sane option.

Paul
