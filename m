Return-Path: <linux-kernel-owner+w=401wt.eu-S1756145AbYLPM4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145AbYLPM4v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 07:56:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753178AbYLPM4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 07:56:40 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51578 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751644AbYLPM4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 07:56:40 -0500
Message-ID: <4947A53B.9050600@cn.fujitsu.com>
Date: Tue, 16 Dec 2008 20:55:23 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] sched: fix another race when reading /proc/sched_debug
References: <494234B0.5@cn.fujitsu.com> <20081212100044.GB18152@elte.hu>	 <4944754F.8050503@cn.fujitsu.com>	 <1229258890.17130.9.camel@lappy.programming.kicks-ass.net>	 <4945B200.7020207@cn.fujitsu.com> <1229328783.14605.11.camel@twins>	 <49462890.1040002@cn.fujitsu.com> <1229337829.14605.41.camel@twins>	 <6599ad830812160141v5ed5d453h36f825b069554e57@mail.gmail.com> <6599ad830812160442p349fac09u9627ac2b81f76905@mail.gmail.com>
In-Reply-To: <6599ad830812160442p349fac09u9627ac2b81f76905@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Tue, Dec 16, 2008 at 1:41 AM, Paul Menage <menage@google.com> wrote:
>> It should be OK to rcu-free cgrp and have it still safe to call
>> cgroup_path() on it - as long as we're confident that the dentry (and
>> all its parents) won't be released until after the RCU section as
>> well, since that's where we get the path elements from. And that does
>> seem to be the case from looking at dcache.c
>>
>> It's certainly nicer than having two calls to synchronize_rcu() in
>> quick succession in cgroup_diput().
> 
> How about something like this?
> 

This solves half of the problem..

This avoids accessing a destroyed cgroup, but still race with cgroup_create.
You sugguested call cgroup_create_dir() before calling subsystems' create()
method.

> Paul
> 
>  include/linux/cgroup.h |    9 +++++++++
>  kernel/cgroup.c        |   49 ++++++++++++++++++++++++++++---------------------
>  2 files changed, 37 insertions(+), 21 deletions(-)
> 
