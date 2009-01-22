Return-Path: <linux-kernel-owner+w=401wt.eu-S1756834AbZAVIqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834AbZAVIqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 03:46:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753355AbZAVIqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 03:46:00 -0500
Received: from smtp-out.google.com ([216.239.45.13]:59487 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756590AbZAVIp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 03:45:59 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-gmailtapped-by:x-gmailtapped;
	b=q+pC7SDXRIGKx1Ix5fK6q0HQIClvzVmherj+OTPz3vMbQ+BacThLEctzEbW0nyRaD
	Gr9kOfMqtrAmQMf0ka+OQ==
Date: Thu, 22 Jan 2009 00:43:38 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Nikanth Karthikesan <knikanth@suse.de>
cc: Evgeniy Polyakov <zbr@ioremap.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>,
       =?UTF-8?Q?Arve_Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
       Paul Menage <menage@google.com>, containers@lists.linux-foundation.org
Subject: Re: [RFC] [PATCH] Cgroup based OOM killer controller
In-Reply-To: <200901221042.30957.knikanth@suse.de>
Message-ID: <alpine.DEB.2.00.0901220036440.28850@chino.kir.corp.google.com>
References: <200901211638.23101.knikanth@suse.de> <200901212054.34929.knikanth@suse.de> <alpine.DEB.2.00.0901211241040.21080@chino.kir.corp.google.com> <200901221042.30957.knikanth@suse.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-GMailtapped-By: 172.25.146.78
X-GMailtapped: rientjes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jan 2009, Nikanth Karthikesan wrote:

> No, this is not specific to memcg or cpuset cases alone. The same needless 
> kills will take place even without memcg or cpuset when an administrator 
> specifies a light memory consumer to be killed before a heavy memory user. But 
> it is up to the administrator to use it wisely.

You can't specify different behavior for an oom cgroup depending on what 
type of oom it is, which is the problem with this proposal.

For example, if your task triggers an oom as the result of its exclusive 
cpuset placement, the oom killer should prefer to kill a task within that 
cpuset to allow for future memory freeing.

So, with your proposal, an administrator can specify the oom priority of 
an entire aggregate of tasks but the behavior may not be desired for a 
cpuset-constrained oom, while it may be perfectly legitimate for a global 
unconstrained oom.

I can specify a higher oom priority for a cpuset because its jobs are less 
critical and I would prefer it gets killed in a system-wide oom, but any 
other cpuset that ooms will needlessly kill these tasks when there is no 
benefit.

> We also provide a panic_on_oom 
> option that an administrator could use, not just to kill few more tasks but 
> all tasks in the system ;)
> 

panic_on_oom allows you to specify whether you want to panic on any oom or 
on global non-constrained ooms, as well.  When the sysctl is not set to 2, 
it is a no-op in a cpuset, mempolicy, or memcg oom condition.
