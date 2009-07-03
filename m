Return-Path: <linux-kernel-owner+w=401wt.eu-S1756560AbZGCBSM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560AbZGCBSM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 21:18:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751906AbZGCBR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 21:17:59 -0400
Received: from smtp-out.google.com ([216.239.33.17]:61623 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731AbZGCBR6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 21:17:58 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=gZWCSYtSaD4pZyt4YFPA86mYja4eIhQUREqCkTWHbYP1ZPtPGLWABReY/AGWeoPAd
	tbi80ZOsx7Xnvl9Sj+5AA==
MIME-Version: 1.0
In-Reply-To: <6599ad830907021808o6f3bb51eh324e4bf13544d83e@mail.gmail.com>
References: <20090702231814.3969.44308.stgit@menage.mtv.corp.google.com>
	 <20090702232620.3969.16680.stgit@menage.mtv.corp.google.com>
	 <20090702164649.303c4952.akpm@linux-foundation.org>
	 <2f86c2480907021731h13e0bb95q94f06829eded9aa6@mail.gmail.com>
	 <20090702175341.fd2e26d5.akpm@linux-foundation.org>
	 <6599ad830907021808o6f3bb51eh324e4bf13544d83e@mail.gmail.com>
Date: Thu, 2 Jul 2009 18:17:56 -0700
Message-ID: <2f86c2480907021817o79fce75yd9785aab682f7bb4@mail.gmail.com>
Subject: Re: [PATCH 1/2] Adds a read-only "procs" file similar to "tasks" that 
	shows only unique tgids
From: Benjamin Blum <bblum@google.com>
To: Paul Menage <menage@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, lizf@cn.fujitzu.com,
       serue@us.ibm.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 2, 2009 at 6:08 PM, Paul Menage<menage@google.com> wrote:
> On Thu, Jul 2, 2009 at 5:53 PM, Andrew Morton<akpm@linux-foundation.org> wrote:
>>> In the first snippet, count will be at most equal to length. As length
>>> is determined from cgroup_task_count, it can be no greater than the
>>> total number of pids on the system.
>>
>> Well that's a problem, because there can be tens or hundreds of
>> thousands of pids, and there's a fairly low maximum size for kmalloc()s
>> (include/linux/kmalloc_sizes.h).
>>
>> And even if this allocation attempt doesn't exceed KMALLOC_MAX_SIZE,
>> large allocations are less unreliable.  There is a large break point at
>> 8*PAGE_SIZE (PAGE_ALLOC_COSTLY_ORDER).
>
> This has been a long-standing problem with the tasks file, ever since
> the cpusets days.
>
> There are ways around it - Lai Jiangshan <laijs@cn.fujitsu.com> posted
> a patch that allocated an array of pages to store pids in, with a
> custom sorting function that let you specify indirection rather than
> assuming everything was in one contiguous array. This was technically
> the right approach in terms of not needing vmalloc and never doing
> large allocations, but it was very complex; an alternative that was
> mooted was to use kmalloc for small cgroups and vmalloc for large
> ones, so the vmalloc penalty wouldn't be paid generally. The thread
> fizzled AFAICS.

As it is currently, the kmalloc call will simply fail if there are too
many pids, correct? Do we prefer not being able to read the file in
this case, or would we rather use vmalloc?

>
>>
>> One could perhaps create an alias (symlink?) and leave that in place
>> for a few kernel releases and then remove the old names.  The trick to
>> doing this politely is to arrange for a friendly printk to come out
>> when userspace uses the old filename, so people know to change their
>> tools.  That printk should come out once-per-boot, not once-per-access.
>
> Personally, I feel that a bit of ugliness in the naming inconsistency
> is less painful than trying to deprecate something that people might
> be using.

That's what the people who designed x86 said :P

> If we could just flip the names without breaking anyone,
> that would be great, but this is just a style issue rather than a
> functional issue. My experience of such printk() statements scattered
> around in code is that no-one takes much notice of them.

Whether or not we get rid of the old ones, it would be good to put in
aliases with the new style now so there's the option of removing the
old style ones later.

>
> Paul
>
