Return-Path: <linux-kernel-owner+w=401wt.eu-S1753580AbZHDBK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580AbZHDBK5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 21:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751889AbZHDBK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 21:10:56 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59511 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751862AbZHDBK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 21:10:56 -0400
Message-ID: <4A778A49.6040302@cn.fujitsu.com>
Date: Tue, 04 Aug 2009 09:09:29 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Benjamin Blum <bblum@google.com>
CC: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       akpm@linux-foundation.org, serue@us.ibm.com, menage@google.com
Subject: Re: [PATCH 6/6] Makes procs file writable to move all threads by
 tgid 	at once
References: <20090731012908.27908.62208.stgit@hastromil.mtv.corp.google.com>	 <20090731015154.27908.9639.stgit@hastromil.mtv.corp.google.com>	 <4A7652E7.4020206@cn.fujitsu.com> <2f86c2480908031756j557e7aebmbf7951da6a1aadb0@mail.gmail.com>
In-Reply-To: <2f86c2480908031756j557e7aebmbf7951da6a1aadb0@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Blum wrote:
> On Sun, Aug 2, 2009 at 8:00 PM, Li Zefan<lizf@cn.fujitsu.com> wrote:
>> Ben Blum wrote:
>>> +     }
>>> +     write_unlock(&css_set_lock);
>>> +
>>> +     /*
>>> +      * We just gained a reference on oldcg by taking it from the task. As
>> This comment is incorrect, the ref we just got has been dropped by
>> the above put_css_set(oldcg).
> 
> No, the idea is that even though we had a reference that we already
> dropped, we in effect "traded" the newcg to the task for its oldcg,
> giving it our reference on newcg and gaining its reference on oldcg. I
> believe the cgroup_mutex guarantees that it'll still be there when we
> do the trade - perhaps a BUG_ON(tsk->cgroups != oldcg) is wanted
> inside the second task_lock section there? At the very least, a
> clearer comment.
> 

Maybe my English sucks..

By "gained a reference", doesn't it mean get_css_set()? But this
put_css_set() is not against the get() just called.

And in fact the ref can be 0 before this put(), because task_exit
can drop the last ref, but put_css_set() will check this case,
so it's Ok.

>>> +static int css_set_check_fetched(struct cgroup *cgrp, struct task_struct *tsk,
>>> +                              struct css_set *cg,
>>> +                              struct list_head *newcg_list)
>>> +{
>>> +     struct css_set *newcg;
>>> +     struct cg_list_entry *cg_entry;
>>> +     struct cgroup_subsys_state *template[CGROUP_SUBSYS_COUNT];
>>> +     read_lock(&css_set_lock);
>>> +     newcg = find_existing_css_set(cg, cgrp, template);
>>> +     if (newcg)
>>> +             get_css_set(newcg);
>>> +     read_unlock(&css_set_lock);
>>> +     /* doesn't exist at all? */
>>> +     if (!newcg)
>>> +             return 1;
>> I think it's more intuitive to return 1 if found and 0 if not found.
> 
> I was sticking with the convention of nonzero return values indicating
> failure, as is used everywhere else in this context.
> 

Quoted from Documentation/CodingStyle:

...Such a value can be represented as an error-code integer
(-Exxx = failure, 0 = success) or a "succeeded" boolean (0 = failure,
non-zero = success).
