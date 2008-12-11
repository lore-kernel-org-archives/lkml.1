Return-Path: <linux-kernel-owner+w=401wt.eu-S1756111AbYLKGtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111AbYLKGtA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 01:49:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751811AbYLKGsv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 01:48:51 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64472 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751094AbYLKGsv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 01:48:51 -0500
Message-ID: <4940B77C.6020800@cn.fujitsu.com>
Date: Thu, 11 Dec 2008 14:47:24 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Paul Menage <menage@google.com>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [RFC][PATCH 2/3] CGroups: Use hierarchy_mutex in memory controller
References: <20081210233654.563182000@menage.corp.google.com>	<20081210234432.236302000@menage.corp.google.com>	<20081211094938.85b00cf3.kamezawa.hiroyu@jp.fujitsu.com>	<6599ad830812101652o25bc33f3r2a710e0879f9b196@mail.gmail.com>	<20081211100501.bf538f0c.kamezawa.hiroyu@jp.fujitsu.com> <20081211063307.GL3008@balbir.in.ibm.com>
In-Reply-To: <20081211063307.GL3008@balbir.in.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2008-12-11 10:05:01]:
> 
>> On Wed, 10 Dec 2008 16:52:57 -0800
>> Paul Menage <menage@google.com> wrote:
>>
>>> On Wed, Dec 10, 2008 at 4:49 PM, KAMEZAWA Hiroyuki
>>> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>>>>        an operation like rmdir() in somewhere.
>>>>                hierarchy_lock for A (acquired)
>>>>                hierarchy_lock for B (waiting)
>>>>
>>>>        in subsys A.
>>>>                mmap_sem (acquired)
>>>>                hierarchy_lock for A (waiting)
>>>>        in subsys B.
>>>>                hierarchy_lock for B (aquired)
>>>>                mmap_sem             (waiting)
>>>>
>>> That's a valid deadlock - you'd need to require the mmap_sem nests
>>> either inside all hierarchy_mutexes or else outside all of them.
>>>
>> This was a found dead lock between memcg and cpuset.
>>
>> another one was 
>>
>> 	an operation like rmdir() in somewhere.
>> 		hierarchy_lock for memcg (acquired)
>> 		hierarchy_lock for B (waiting)
>>
>> 	in subsys B.
>> 		hierarchy_lock for B (aquired)
> 
> But then the hierarchy_locks acquired will be different right?
> 

Yes, I'm worrying this too. The lock order by cgroup_lock_hierarchy() is:
	lock A -> lock B -> lock C
But a call chain may end up with:
	... -> lock B -> ... lock A -> ...

So though this hierarchy lock proprosal can solve specific deadlock between
cpuset and memcg by making cpuset holding cgroup_lock and memcg holding hierarchy_lock,
but we'll probably encounter other deadlocks describled above.

>> 		have to do some memory reclaim -> hierarchy_lock for memcg (waiting)
>>
>> I have no objections to hierarchy_lock itself but calling context to memcg is very
>> complicated and simple replace of these locks will be just a small help.
> 
> Could you please explain the race better?
> 
