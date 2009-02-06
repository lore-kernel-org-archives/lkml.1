Return-Path: <linux-kernel-owner+w=401wt.eu-S1757225AbZBFTTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225AbZBFTTl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 14:19:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753186AbZBFTTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 14:19:33 -0500
Received: from smtp-out.google.com ([216.239.45.13]:19745 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144AbZBFTTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 14:19:32 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:
	x-gmailtapped-by:x-gmailtapped;
	b=ZoAen+FoQ5kNl51DHlAMCWXzOZVx76GMWjOvdtkwS2uqKTmX+5LkcaWdGyztW998z
	XiLv6832NEVWmn2jHqe2A==
MIME-Version: 1.0
In-Reply-To: <4989606F.9030804@cn.fujitsu.com>
References: <4976D77C.3020107@cn.fujitsu.com>
	 <20090127144233.18cf9b3f.akpm@linux-foundation.org>
	 <4987B925.1010405@cn.fujitsu.com>
	 <20090203141645.91c7ea18.akpm@linux-foundation.org>
	 <6599ad830902031449j1fa3dd08re842b57f8700b389@mail.gmail.com>
	 <4989606F.9030804@cn.fujitsu.com>
Date: Fri, 6 Feb 2009 11:19:27 -0800
Message-ID: <6599ad830902061119t2d82c782pb6442f9a35fbb01c@mail.gmail.com>
Subject: Re: [PATCH] cpuset: fix allocating page cache/slab object on the 
	unallowed node when memory spread is set
From: Paul Menage <menage@google.com>
To: miaox@cn.fujitsu.com
Cc: Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, cl@linux-foundation.org,
       nickpiggin@yahoo.com.au
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.25.146.38
X-GMailtapped: menage
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 4, 2009 at 1:31 AM, Miao Xie <miaox@cn.fujitsu.com> wrote:
>> AFAICS this patch still has a race between a thread reading its
>> mems_allowed, and another thread updating it. The current architecture
>> of having task->mems_allowed be only updatable by current was PaulJ's
>> code originally, and I'm a bit loathe to touch it. But if we're going
>> to, we'll need at the minimum to add a lock for any code that touches
>> current->mems_allowed.
>
> Agree! But mems_allowed is touched in the module of memory management
> in general, adding a lock to protect mems_allowed may lead to performance
> regression.
>

I've asked Andrew to remove this from -mm until we can figure out:

- whether it's needed
- how to do it safely.

Basically the problem that you're seeing is that when you move a task
into a cpuset that has memory_spread_page=1, it fails to call
cpuset_update_task_memory_state()?

One thing missing from your test - can you verify that the test
program really did get migrated into the child cpuset? If it failed
(and echo failed to report the error) that would explain what you're
seeing.

Paul
