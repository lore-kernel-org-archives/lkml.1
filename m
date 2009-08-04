Return-Path: <linux-kernel-owner+w=401wt.eu-S1754832AbZHDBTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832AbZHDBTs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 21:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752185AbZHDBTs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 21:19:48 -0400
Received: from smtp-out.google.com ([216.239.33.17]:54060 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754343AbZHDBTr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 21:19:47 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=asNi2B7Y2AzZIZ/PiXCmWY8zeuI89kJPbajN/AjAvN3ynaSh9zFH7BFsawAH25JNx
	mnnnrka0FoMx/Dr8TD70Q==
MIME-Version: 1.0
In-Reply-To: <4A778A49.6040302@cn.fujitsu.com>
References: <20090731012908.27908.62208.stgit@hastromil.mtv.corp.google.com>
	 <20090731015154.27908.9639.stgit@hastromil.mtv.corp.google.com>
	 <4A7652E7.4020206@cn.fujitsu.com>
	 <2f86c2480908031756j557e7aebmbf7951da6a1aadb0@mail.gmail.com>
	 <4A778A49.6040302@cn.fujitsu.com>
Date: Mon, 3 Aug 2009 18:19:42 -0700
Message-ID: <2f86c2480908031819h2513cdb4tac3d6def3e0aa320@mail.gmail.com>
Subject: Re: [PATCH 6/6] Makes procs file writable to move all threads by tgid 
	at once
From: Benjamin Blum <bblum@google.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       akpm@linux-foundation.org, serue@us.ibm.com, menage@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 3, 2009 at 6:09 PM, Li Zefan<lizf@cn.fujitsu.com> wrote:
> Benjamin Blum wrote:
>> On Sun, Aug 2, 2009 at 8:00 PM, Li Zefan<lizf@cn.fujitsu.com> wrote:
>>> Ben Blum wrote:
>>>> +     }
>>>> +     write_unlock(&css_set_lock);
>>>> +
>>>> +     /*
>>>> +      * We just gained a reference on oldcg by taking it from the task. As
>>> This comment is incorrect, the ref we just got has been dropped by
>>> the above put_css_set(oldcg).
>>
>> No, the idea is that even though we had a reference that we already
>> dropped, we in effect "traded" the newcg to the task for its oldcg,
>> giving it our reference on newcg and gaining its reference on oldcg. I
>> believe the cgroup_mutex guarantees that it'll still be there when we
>> do the trade - perhaps a BUG_ON(tsk->cgroups != oldcg) is wanted
>> inside the second task_lock section there? At the very least, a
>> clearer comment.
>>
>
> Maybe my English sucks..
>
> By "gained a reference", doesn't it mean get_css_set()? But this
> put_css_set() is not against the get() just called.

not in the conventional way, no. the comment there is bad enough that
this is unclear: before trading pointers, the task had a reference on
its tsk->cgroups pointer (same as our oldcg pointer), which is what we
are overwriting with newcg. the task will think that the reference it
has is still on tsk->cgroups, but since the pointer has changed, its
reference also changes to a reference on newcg - one that this
function took care of getting for the task. additionally, now that the
task's reference is no longer for oldcg, we have to take care of the
refcount that still thinks it's being used.

> And in fact the ref can be 0 before this put(), because task_exit
> can drop the last ref, but put_css_set() will check this case,
> so it's Ok.

the check for PF_EXITING precludes that case.

>>>> +static int css_set_check_fetched(struct cgroup *cgrp, struct task_struct *tsk,
>>>> +                              struct css_set *cg,
>>>> +                              struct list_head *newcg_list)
>>>> +{
>>>> +     struct css_set *newcg;
>>>> +     struct cg_list_entry *cg_entry;
>>>> +     struct cgroup_subsys_state *template[CGROUP_SUBSYS_COUNT];
>>>> +     read_lock(&css_set_lock);
>>>> +     newcg = find_existing_css_set(cg, cgrp, template);
>>>> +     if (newcg)
>>>> +             get_css_set(newcg);
>>>> +     read_unlock(&css_set_lock);
>>>> +     /* doesn't exist at all? */
>>>> +     if (!newcg)
>>>> +             return 1;
>>> I think it's more intuitive to return 1 if found and 0 if not found.
>>
>> I was sticking with the convention of nonzero return values indicating
>> failure, as is used everywhere else in this context.
>>
>
> Quoted from Documentation/CodingStyle:
>
> ...Such a value can be represented as an error-code integer
> (-Exxx = failure, 0 = success) or a "succeeded" boolean (0 = failure,
> non-zero = success).

sure. a boolean return value will be better here.
