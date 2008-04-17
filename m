Return-Path: <linux-kernel-owner+w=401wt.eu-S1754329AbYDQFMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329AbYDQFMT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 01:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751199AbYDQFMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 01:12:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58254 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750849AbYDQFMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 01:12:08 -0400
Message-ID: <4806DBC9.3090607@cn.fujitsu.com>
Date: Thu, 17 Apr 2008 13:10:33 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Paul Jackson <pj@sgi.com>
Subject: Re: [PATCH] cgroup: fix a race condition in manipulating tsk->cg_list
References: <4806C5EB.3040102@cn.fujitsu.com>	<20080416211144.a38f6fc0.akpm@linux-foundation.org>	<6599ad830804162117w14364b7cg20d3694ffdfeb867@mail.gmail.com> <20080416215907.63d71409.akpm@linux-foundation.org>
In-Reply-To: <20080416215907.63d71409.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 16 Apr 2008 21:17:34 -0700 "Paul Menage" <menage@google.com> wrote:
> 
>> On Wed, Apr 16, 2008 at 9:11 PM, Andrew Morton
>> <akpm@linux-foundation.org> wrote:
>>>  I don't fully understand the race.  Both paths hold css_set_lock.
>>>
>>>  Can you describe it in more detail please?
>> Task A starts exiting, passes the check for unlinking current->cg_list.
> 
> So cgroup_exit() sees !list_empty(tsk->cg_list)
> 

cgroup_exit() sees list_empty(tsk->cg_list), then cgroup_enable_task_cg_list()
links the task to the list, and then the task exited, so the list entry won't
get deleted.

> And the list_del() sets tsk->cg_list to LIST_POISON[12], which still means
> !list_empty().  Or we remove that debugging code and avoid writing to
> tsk->cg_list, and it _still_ is !list_empty().
> 
>> Before it completely exits task B does the very first
>> cgroup_iter_begin() call (via reading a cgroups tasks file) which
>> links all tasks in to their css_set objects via tsk->cg_list.
> 
> But it won't link this task, because it's !list_empty().
> 
>> Then task A finishes exiting and is freed, but doesn't unlink from the cg_list.
>>
>>>  afacit the task at *p could set PF_EXITING immediately after this code has
>>>  tested PF_EXITING and then the task at *p could proceed until we hit the
>>>  same race (whatever that is).
>> The important fact there is that the task sets PF_EXITING *before* it
>> checks whether it needs to unlink from current->cg_list.
>>
>> Paul
> 
> 

