Return-Path: <linux-kernel-owner+w=401wt.eu-S1755167AbYLPJl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167AbYLPJl7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 04:41:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752172AbYLPJlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 04:41:51 -0500
Received: from smtp-out.google.com ([216.239.45.13]:35112 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957AbYLPJlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 04:41:50 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=O+JNAHOzdgY0vqkILOe/PvS1zsHN6D232ETxRKcGfRIvu2C8scSTlTPI3mLSupa5y
	ayulH5BXsVjrtVNS2RTxg==
MIME-Version: 1.0
In-Reply-To: <1229337829.14605.41.camel@twins>
References: <494234B0.5@cn.fujitsu.com> <20081212100044.GB18152@elte.hu>
	 <4944754F.8050503@cn.fujitsu.com>
	 <1229258890.17130.9.camel@lappy.programming.kicks-ass.net>
	 <4945B200.7020207@cn.fujitsu.com> <1229328783.14605.11.camel@twins>
	 <49462890.1040002@cn.fujitsu.com> <1229337829.14605.41.camel@twins>
Date: Tue, 16 Dec 2008 01:41:45 -0800
Message-ID: <6599ad830812160141v5ed5d453h36f825b069554e57@mail.gmail.com>
Subject: Re: [PATCH] sched: fix another race when reading /proc/sched_debug
From: Paul Menage <menage@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2008 at 2:43 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>>
>> +             /*
>> +              * Some subsystems (cpu cgroup) might still be able to
>> +              * accessing the cgroup in rcu section.
>> +              */
>> +             synchronize_rcu();
>> +
>>               kfree(cgrp);
>>       }
>>       iput(inode);
>
> Is there any reason we cannot use call_rcu() ?

It should be OK to rcu-free cgrp and have it still safe to call
cgroup_path() on it - as long as we're confident that the dentry (and
all its parents) won't be released until after the RCU section as
well, since that's where we get the path elements from. And that does
seem to be the case from looking at dcache.c

It's certainly nicer than having two calls to synchronize_rcu() in
quick succession in cgroup_diput().
>
> Perhaps wrap that check in a cgroup_*() helper? That would avoid the
> duplication, be clearer and not open code the ->dentry assumption.

I think it would be simpler to not have the cgroup exposed to the
subsystem until the dentry and other structures have been created. The
current order (create subsystems, then create fs structures) is more
or less a carry-over from when I extended cpusets, rather than an
explicit design choice.

Paul
