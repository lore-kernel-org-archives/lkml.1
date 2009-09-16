Return-Path: <linux-kernel-owner+w=401wt.eu-S1758672AbZIPMGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758672AbZIPMGu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 08:06:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756044AbZIPMGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 08:06:49 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45864 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593AbZIPMGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 08:06:48 -0400
Message-ID: <84889d57a3943f47b3ee0df6d1ff25c2.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <2375c9f90909160213q7e011117hd4e4ea2f386ed42a@mail.gmail.com>
References: <20090914032901.GA16189@localhost>
    <20090915165852.032d164f.kamezawa.hiroyu@jp.fujitsu.com>
    <20090916142956.9998ba71.kamezawa.hiroyu@jp.fujitsu.com>
    <2375c9f90909160120u151b0449x2eac665080a3ae82@mail.gmail.com>
    <20090916174434.219ddd04.kamezawa.hiroyu@jp.fujitsu.com>
    <2375c9f90909160213q7e011117hd4e4ea2f386ed42a@mail.gmail.com>
Date: Wed, 16 Sep 2009 21:06:48 +0900 (JST)
Subject: Re: [RFC][PATCH][bugfix] more checks for negative f_pos handling
 (Was  Re: Question: how to handle too big f_pos
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: Am=?ISO-2022-JP?B?P3JpY29fV2FuZw==?= <xiyou.wangcong@gmail.com>
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Wu Fengguang" <fengguang.wu@intel.com>, viro@zeniv.linux.org.uk,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       oleg@redhat.com
User-Agent: SquirrelMail/1.4.16
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Américo_Wang wrote:
> On Wed, Sep 16, 2009 at 4:44 PM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>> Ah, sorry. I should CC: you.
>
>
> No problem. :)
>
>>> > --- mmotm-2.6.31-Sep14.orig/fs/proc/base.c
>>> > +++ mmotm-2.6.31-Sep14/fs/proc/base.c
>>> > @@ -903,18 +903,30 @@ out_no_task:
>>> >
>>> > ?loff_t mem_lseek(struct file *file, loff_t offset, int orig)
>>> > ?{
>>> > + ? ? ? struct task_struct *task =
>>> get_proc_task(file->f_path.dentry->d_inode);
>>> > + ? ? ? unsigned long long new_offset = -EINVAL;
>>>
>>>
>>> Why not make 'new_offset' as loff_t? This can make your code easier.
>>>
>> loff_t is "long long", I wanted "unsigned long long" for showing
>> f_pos here is treated as "unsigned".
>>
>
>
> Yeah, the same as for __verify_negative_pos_range(), right...
>
>
> <snip>
>
>>> > ? ? ? ?}
>>> > - ? ? ? force_successful_syscall_return();
>>> > - ? ? ? return file->f_pos;
>>> > + ? ? ? if (new_offset < (unsigned long long)TASK_SIZE_OF(task)) {
>>>
>>>
>>> Hmm, why this check?
>>>
>> 2 reasons.
>>
>> ?1. If this lseek has to check something, this is it.
>> ?2. On architecture where 32bit program can ran on 64bit,
>> ? ? moving f_pos above 4G is out-of-range, for example.
>>
>> But mem_read() will catch any bad f_pos, anyway. So, just making
>> allow all f_pos here is maybe a choice. Considering lseek,
>> providing this range check here is not so bad.
>
> Ok, I misunderstood the macro 'TASK_SIZE_OF', then no problem.
>
> Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>
>
Ah, very sorry. I noticed I didn't handle pread/pwrite, splice, etc...
I'll do retry.

Sorry,
-Kame


> Thanks.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


