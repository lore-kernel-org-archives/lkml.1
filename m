Return-Path: <linux-kernel-owner+w=401wt.eu-S932071AbZHDA44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071AbZHDA44 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 20:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752879AbZHDA4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 20:56:55 -0400
Received: from smtp-out.google.com ([216.239.45.13]:59837 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833AbZHDA4y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 20:56:54 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=mXNMUs3LG3DrVE7FSNcKbIdl7TIQYjfyXq4HOcT4jxI/wnrTJ7XPkG7mLtyoiXKFC
	X0OecAErsYKE0cZZ6OgAA==
MIME-Version: 1.0
In-Reply-To: <4A7652E7.4020206@cn.fujitsu.com>
References: <20090731012908.27908.62208.stgit@hastromil.mtv.corp.google.com>
	 <20090731015154.27908.9639.stgit@hastromil.mtv.corp.google.com>
	 <4A7652E7.4020206@cn.fujitsu.com>
Date: Mon, 3 Aug 2009 17:56:51 -0700
Message-ID: <2f86c2480908031756j557e7aebmbf7951da6a1aadb0@mail.gmail.com>
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

On Sun, Aug 2, 2009 at 8:00 PM, Li Zefan<lizf@cn.fujitsu.com> wrote:
> Ben Blum wrote:
>> +     }
>> +     write_unlock(&css_set_lock);
>> +
>> +     /*
>> +      * We just gained a reference on oldcg by taking it from the task. As
>
> This comment is incorrect, the ref we just got has been dropped by
> the above put_css_set(oldcg).

No, the idea is that even though we had a reference that we already
dropped, we in effect "traded" the newcg to the task for its oldcg,
giving it our reference on newcg and gaining its reference on oldcg. I
believe the cgroup_mutex guarantees that it'll still be there when we
do the trade - perhaps a BUG_ON(tsk->cgroups != oldcg) is wanted
inside the second task_lock section there? At the very least, a
clearer comment.

>> +static int css_set_check_fetched(struct cgroup *cgrp, struct task_struct *tsk,
>> +                              struct css_set *cg,
>> +                              struct list_head *newcg_list)
>> +{
>> +     struct css_set *newcg;
>> +     struct cg_list_entry *cg_entry;
>> +     struct cgroup_subsys_state *template[CGROUP_SUBSYS_COUNT];
>> +     read_lock(&css_set_lock);
>> +     newcg = find_existing_css_set(cg, cgrp, template);
>> +     if (newcg)
>> +             get_css_set(newcg);
>> +     read_unlock(&css_set_lock);
>> +     /* doesn't exist at all? */
>> +     if (!newcg)
>> +             return 1;
>
> I think it's more intuitive to return 1 if found and 0 if not found.

I was sticking with the convention of nonzero return values indicating
failure, as is used everywhere else in this context.
