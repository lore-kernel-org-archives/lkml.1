Return-Path: <linux-kernel-owner+w=401wt.eu-S1753471AbZHDBrK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471AbZHDBrK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 21:47:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752504AbZHDBrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 21:47:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62946 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752280AbZHDBrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 21:47:09 -0400
Message-ID: <4A7792C4.5010504@cn.fujitsu.com>
Date: Tue, 04 Aug 2009 09:45:40 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Benjamin Blum <bblum@google.com>
CC: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       akpm@linux-foundation.org, serue@us.ibm.com, menage@google.com
Subject: Re: [PATCH 6/6] Makes procs file writable to move all threads by
 tgid 	at once
References: <20090731012908.27908.62208.stgit@hastromil.mtv.corp.google.com>	 <20090731015154.27908.9639.stgit@hastromil.mtv.corp.google.com>	 <4A7652E7.4020206@cn.fujitsu.com>	 <2f86c2480908031756j557e7aebmbf7951da6a1aadb0@mail.gmail.com>	 <4A778A49.6040302@cn.fujitsu.com> <2f86c2480908031819h2513cdb4tac3d6def3e0aa320@mail.gmail.com>
In-Reply-To: <2f86c2480908031819h2513cdb4tac3d6def3e0aa320@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Blum wrote:
> On Mon, Aug 3, 2009 at 6:09 PM, Li Zefan<lizf@cn.fujitsu.com> wrote:
>> Benjamin Blum wrote:
>>> On Sun, Aug 2, 2009 at 8:00 PM, Li Zefan<lizf@cn.fujitsu.com> wrote:
>>>> Ben Blum wrote:
>>>>> +     }
>>>>> +     write_unlock(&css_set_lock);
>>>>> +
>>>>> +     /*
>>>>> +      * We just gained a reference on oldcg by taking it from the task. As
>>>> This comment is incorrect, the ref we just got has been dropped by
>>>> the above put_css_set(oldcg).
>>> No, the idea is that even though we had a reference that we already
>>> dropped, we in effect "traded" the newcg to the task for its oldcg,
>>> giving it our reference on newcg and gaining its reference on oldcg. I
>>> believe the cgroup_mutex guarantees that it'll still be there when we
>>> do the trade - perhaps a BUG_ON(tsk->cgroups != oldcg) is wanted
>>> inside the second task_lock section there? At the very least, a
>>> clearer comment.
>>>
>> Maybe my English sucks..
>>
>> By "gained a reference", doesn't it mean get_css_set()? But this
>> put_css_set() is not against the get() just called.
> 
> not in the conventional way, no. the comment there is bad enough that
> this is unclear: before trading pointers, the task had a reference on
> its tsk->cgroups pointer (same as our oldcg pointer), which is what we
> are overwriting with newcg. the task will think that the reference it
> has is still on tsk->cgroups, but since the pointer has changed, its
> reference also changes to a reference on newcg - one that this
> function took care of getting for the task. additionally, now that the
> task's reference is no longer for oldcg, we have to take care of the
> refcount that still thinks it's being used.
> 

Ok.

>> And in fact the ref can be 0 before this put(), because task_exit
>> can drop the last ref, but put_css_set() will check this case,
>> so it's Ok.
> 
> the check for PF_EXITING precludes that case.
> 

No. Note task exiting is not protected by cgroup_lock, so this can
happen:

                               | cgroup_attach_task()
                               |   oldcg = tsk->cgroups;
                               |   (tasks->flags & TASK_EXISING == 0)
                               |   rcu_assign_pointer(tsk->cgroups, newcg);
cgroup_exit()                  |
  oldcg = tsk->cgroups;        |
  put_css_set_taskexit(oldcg); |
  (now ref of olcg is 0)       |
                               |   put_css_set(oldcg);
