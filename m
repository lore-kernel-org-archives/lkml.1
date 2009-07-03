Return-Path: <linux-kernel-owner+w=401wt.eu-S1756214AbZGCBIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214AbZGCBIi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 21:08:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752380AbZGCBIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 21:08:31 -0400
Received: from smtp-out.google.com ([216.239.33.17]:60764 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbZGCBIa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 21:08:30 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=RZhnBd8sYF96s8O1PMaRq87yhj2lxTN/4xqYxDRcdsR49mpZJ+GXSwJoAKgaRoDHL
	A5QAY7IBpSQ0QvpmwiBBQ==
MIME-Version: 1.0
In-Reply-To: <20090702175341.fd2e26d5.akpm@linux-foundation.org>
References: <20090702231814.3969.44308.stgit@menage.mtv.corp.google.com>
	 <20090702232620.3969.16680.stgit@menage.mtv.corp.google.com>
	 <20090702164649.303c4952.akpm@linux-foundation.org>
	 <2f86c2480907021731h13e0bb95q94f06829eded9aa6@mail.gmail.com>
	 <20090702175341.fd2e26d5.akpm@linux-foundation.org>
Date: Thu, 2 Jul 2009 18:08:29 -0700
Message-ID: <6599ad830907021808o6f3bb51eh324e4bf13544d83e@mail.gmail.com>
Subject: Re: [PATCH 1/2] Adds a read-only "procs" file similar to "tasks" that 
	shows only unique tgids
From: Paul Menage <menage@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Benjamin Blum <bblum@google.com>, lizf@cn.fujitzu.com, serue@us.ibm.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 2, 2009 at 5:53 PM, Andrew Morton<akpm@linux-foundation.org> wrote:
>> In the first snippet, count will be at most equal to length. As length
>> is determined from cgroup_task_count, it can be no greater than the
>> total number of pids on the system.
>
> Well that's a problem, because there can be tens or hundreds of
> thousands of pids, and there's a fairly low maximum size for kmalloc()s
> (include/linux/kmalloc_sizes.h).
>
> And even if this allocation attempt doesn't exceed KMALLOC_MAX_SIZE,
> large allocations are less unreliable.  There is a large break point at
> 8*PAGE_SIZE (PAGE_ALLOC_COSTLY_ORDER).

This has been a long-standing problem with the tasks file, ever since
the cpusets days.

There are ways around it - Lai Jiangshan <laijs@cn.fujitsu.com> posted
a patch that allocated an array of pages to store pids in, with a
custom sorting function that let you specify indirection rather than
assuming everything was in one contiguous array. This was technically
the right approach in terms of not needing vmalloc and never doing
large allocations, but it was very complex; an alternative that was
mooted was to use kmalloc for small cgroups and vmalloc for large
ones, so the vmalloc penalty wouldn't be paid generally. The thread
fizzled AFAICS.

>
> One could perhaps create an alias (symlink?) and leave that in place
> for a few kernel releases and then remove the old names.  The trick to
> doing this politely is to arrange for a friendly printk to come out
> when userspace uses the old filename, so people know to change their
> tools.  That printk should come out once-per-boot, not once-per-access.

Personally, I feel that a bit of ugliness in the naming inconsistency
is less painful than trying to deprecate something that people might
be using. If we could just flip the names without breaking anyone,
that would be great, but this is just a style issue rather than a
functional issue. My experience of such printk() statements scattered
around in code is that no-one takes much notice of them.

Paul
