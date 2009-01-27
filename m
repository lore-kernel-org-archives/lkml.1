Return-Path: <linux-kernel-owner+w=401wt.eu-S1754009AbZA0HmB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009AbZA0HmB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 02:42:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752056AbZA0Hlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 02:41:52 -0500
Received: from smtp-out.google.com ([216.239.45.13]:53801 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbZA0Hlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 02:41:51 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-gmailtapped-by:x-gmailtapped;
	b=HAz3wKxpZZWWh9PI5t6Ij4X41W6QfoftqtFp5YCOQunzbX3M5/zwRwmom/IPXQkbv
	6UT5mVmuuZVMj5pj6e8Lw==
Date: Mon, 26 Jan 2009 23:39:18 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, balbir@linux.vnet.ibm.com,
       Nikanth Karthikesan <knikanth@suse.de>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Torvalds <torvalds@linux-foundation.org>,
       Arve Hj?nnev?g <arve@android.com>, Evgeniy Polyakov <zbr@ioremap.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>, Linus@smtp1.linux-foundation.org,
       Paul Menage <menage@google.com>
Subject: Re: [RFC] [PATCH] Cgroup based OOM killer controller
In-Reply-To: <20090127155825.D476.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0901262325320.13157@chino.kir.corp.google.com>
References: <20090126195431.GC504@balbir.in.ibm.com> <20090126195622.1d5bf488@lxorguk.ukuu.org.uk> <20090127155825.D476.KOSAKI.MOTOHIRO@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-GMailtapped-By: 172.28.16.143
X-GMailtapped: rientjes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2009, KOSAKI Motohiro wrote:

> Confused.
> 
> As far as I know, people want the method of flexible cache treating.
> but oom seems less flexible than userland notification.
> 
> Why do you think notification is bad?
> 

There're a couple of proposals that have been discussed recently that 
share some functional behavior.

One is the cgroup oom notifier that allows you to attach a task to wait on 
an oom condition for a collection of tasks.  That allows userspace to 
respond to the condition by droping caches, adding nodes to a cpuset, 
elevating memory controller limits, sending a signal, etc.  It can also 
defer to the kernel oom killer as a last resort.

The other is /dev/mem_notify that allows you to poll() on a device file 
and be informed of low memory events.  This can include the cgroup oom 
notifier behavior when a collection of tasks is completely out of memory, 
but can also warn when such a condition may be imminent.  I suggested that 
this be implemented as a client of cgroups so that different handlers can 
be responsible for different aggregates of tasks.

I think the latter is a much more powerful tool and includes all the 
behavior of the former.  It preserves the oom killer as a last resort for 
the kernel and defers all preference killing or lowmem responses to 
userspace.
