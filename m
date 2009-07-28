Return-Path: <linux-kernel-owner+w=401wt.eu-S1752723AbZG1AaO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723AbZG1AaO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 20:30:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752655AbZG1AaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 20:30:13 -0400
Received: from smtp-out.google.com ([216.239.45.13]:29872 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555AbZG1AaL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 20:30:11 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=NP8CKQe41u/fyeXmMmydS/V+wNBzqCzAkvxC27QYzZHdvTLybq069FyjNyUTiZY7K
	VHLU0Y3p7vvukGjkV9rLQ==
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0907271658550.27881@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0907261446050.12973@chino.kir.corp.google.com>
	 <6599ad830907271648v41b006c0j727fc09665f4f47e@mail.gmail.com>
	 <alpine.DEB.2.00.0907271658550.27881@chino.kir.corp.google.com>
Date: Mon, 27 Jul 2009 17:30:03 -0700
Message-ID: <6599ad830907271730y2f783042q87e1bed5d7130550@mail.gmail.com>
Subject: Re: [patch -mmotm] mm: introduce oom_adj_child
From: Paul Menage <menage@google.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 27, 2009 at 5:10 PM, David Rientjes<rientjes@google.com> wrote:
> On Mon, 27 Jul 2009, Paul Menage wrote:
>
>> On Sun, Jul 26, 2009 at 2:50 PM, David Rientjes<rientjes@google.com> wrote:
>> > +If oom_adj_child is set to equal oom_adj, then it will mirror oom_adj whenever
>> > +it changes.  This avoids having to set both values when simply tuning oom_adj
>> > +and that value should be inherited by all children.
>>
>> Maybe have a distinct value for oom_adj_child (the default) that means
>> "default to mm->oom_adj" ?
>>
>
> That's implicitly what mm->oom_adj == mm->oom_adj_child means.  If they
> are equal at the time oom_adj is changed, oom_adj_child also changes, but
> if oom_adj_child differs then it remains static.

So a process that sets its oom_adj value from A to B and back A again
might unintentionally synchronize oom_adj and oom_adj_child for the
future, if oom_adj_child was originally set to B?

Besides, if oom_adj_child is per-task as suggested below, changing
oom_adj_child when oom_adj changes involves scanning the entire task
list to find mm users.

>
>> Shouldn't oom_adj_child be per-task? Otherwise you're theoretically
>> allowing races between different threads that try to fork children
>> with different oom_adj values at the same time. Not a particularly
>> likely problem, but it seems bad to bake the change of races into the
>> API.
>>
>
> Good point, the newly initialized mm can get its oom_adj value from
> current rather than current->mm.
>
>> Also, I'm not sure that the requirement that oom_adj_child be >=
>> oom_adj is a good restriction. Sure, if a task gives its child a lower
>> oom_adj than itself it's potentially playing with fire, but it may
>> well be that the new child is expected todaemonize itself in the very
>> near future and hence no longer be the child of the current process. I
>> don't think that restricting the values that the sysadmin or root
>> processes can apply on the grounds that they might not do what they
>> want is the right approach.
>>
>
> Ok, we can allow oom_adj_child to be less than oom_adj for
> CAP_SYS_RESOURCE.

Sounds fine to me, since you already need CAP_SYS_RESOURCE to set
oom_adj anyway. But actually, shouldn't you just be requiring
CAP_SYS_RESOURCE to set oom_adj_child at all?

Otherwise an unprivileged process that starts with oom_adj=0 could set
its oom_adj_child value to something slightly less immune than its
oom_adj, say 1; then even if the sysadmin sets if oom_adj value to
very non-immune, it would still be able to create children with
oom_adj 1.

Paul
