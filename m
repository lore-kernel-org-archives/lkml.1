Return-Path: <linux-kernel-owner+w=401wt.eu-S1764093AbZAUKmh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764093AbZAUKmh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 05:42:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758035AbZAUKmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 05:42:05 -0500
Received: from smtp-out.google.com ([216.239.33.17]:27954 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756980AbZAUKmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 05:42:03 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:
	x-gmailtapped-by:x-gmailtapped;
	b=lSR6NRIuqdTYKWgIGkBY8XJVxGIviLzf6On8ulX38RTFfxMm2ClEpJ1CtCnomNjEB
	QLvcKIwg7n/FpXEylRs9g==
MIME-Version: 1.0
In-Reply-To: <4976D77C.3020107@cn.fujitsu.com>
References: <4976D77C.3020107@cn.fujitsu.com>
Date: Wed, 21 Jan 2009 02:41:56 -0800
Message-ID: <6599ad830901210241y1fe96d93x462e23d9883e7ab5@mail.gmail.com>
Subject: Re: [PATCH] cpuset: fix allocating page cache/slab object on the 
	unallowed node when memory spread is set
From: Paul Menage <menage@google.com>
To: miaox@cn.fujitsu.com
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.28.16.76
X-GMailtapped: menage
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2009 at 12:06 AM, Miao Xie <miaox@cn.fujitsu.com> wrote:
> The task still allocated the page caches on old node after modifying its
> cpuset's mems when 'memory_spread_page' was set, it is caused by the old
> mem_allowed_list of the task, the current kernel doesn't updates it unless some
> function invokes cpuset_update_task_memory_state(), it is too late sometimes.

Can you give a more concrete example of how the current code can break?

> We must update the mem_allowed_list of the tasks in time.

This is a fairly fundamental change to the way that mems_allowed is
handled - it dates back to fairly early in cpusets' history.

> - * The task_struct fields mems_allowed and mems_generation may only
> - * be accessed in the context of that task, so require no locks.
> + * The task_struct fields mems_allowed may only be accessed in the context
> + * of that task, so require no locks.

This comment is no longer true, since mems_allowed is now being
updated by other processes.

What's to stop a task reading current->mems_allowed and racing with an
update from update_tasks_nodemask() ? Or else, why can that not lead
to badness?

Paul
