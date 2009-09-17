Return-Path: <linux-kernel-owner+w=401wt.eu-S1758318AbZIQDGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758318AbZIQDGQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 23:06:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754428AbZIQDGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 23:06:15 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:64373 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbZIQDGO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 23:06:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DanFoA5R5zRcEUalYkRohsFmmr51QK7Ph+DOt2RAVL5lnRF/vKVFdpM0k/CRJrCSlA
         MQELk7smJ5kPolp1ZkpSX+0T/j3UMMowXi+1N6iWuBh6nVHyFyEnnT/g6+XvWLIoHcrK
         OtBg3PYEwpQ3vonakgg7MLApGv2m30DuBa9mY=
MIME-Version: 1.0
In-Reply-To: <84889d57a3943f47b3ee0df6d1ff25c2.squirrel@webmail-b.css.fujitsu.com>
References: <20090914032901.GA16189@localhost>
	 <20090915165852.032d164f.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090916142956.9998ba71.kamezawa.hiroyu@jp.fujitsu.com>
	 <2375c9f90909160120u151b0449x2eac665080a3ae82@mail.gmail.com>
	 <20090916174434.219ddd04.kamezawa.hiroyu@jp.fujitsu.com>
	 <2375c9f90909160213q7e011117hd4e4ea2f386ed42a@mail.gmail.com>
	 <84889d57a3943f47b3ee0df6d1ff25c2.squirrel@webmail-b.css.fujitsu.com>
Date: Thu, 17 Sep 2009 11:06:18 +0800
Message-ID: <2375c9f90909162006x624496afy4979b4ce94196d2f@mail.gmail.com>
Subject: Re: [RFC][PATCH][bugfix] more checks for negative f_pos handling (Was 
	Re: Question: how to handle too big f_pos
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>, viro@zeniv.linux.org.uk,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       oleg@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/9/16 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>:
> Am�+1rico_Wang wrote:
>> On Wed, Sep 16, 2009 at 4:44 PM, KAMEZAWA Hiroyuki
>> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>>> Ah, sorry. I should CC: you.
>>
>>
>> No problem. :)
>>
>>>> > --- mmotm-2.6.31-Sep14.orig/fs/proc/base.c
>>>> > +++ mmotm-2.6.31-Sep14/fs/proc/base.c
>>>> > @@ -903,18 +903,30 @@ out_no_task:
>>>> >
>>>> > ?loff_t mem_lseek(struct file *file, loff_t offset, int orig)
>>>> > ?{
>>>> > + ? ? ? struct task_struct *task =
>>>> get_proc_task(file->f_path.dentry->d_inode);
>>>> > + ? ? ? unsigned long long new_offset = -EINVAL;
>>>>
>>>>
>>>> Why not make 'new_offset' as loff_t? This can make your code easier.
>>>>
>>> loff_t is "long long", I wanted "unsigned long long" for showing
>>> f_pos here is treated as "unsigned".
>>>
>>
>>
>> Yeah, the same as for __verify_negative_pos_range(), right...
>>
>>
>> <snip>
>>
>>>> > ? ? ? ?}
>>>> > - ? ? ? force_successful_syscall_return();
>>>> > - ? ? ? return file->f_pos;
>>>> > + ? ? ? if (new_offset < (unsigned long long)TASK_SIZE_OF(task)) {
>>>>
>>>>
>>>> Hmm, why this check?
>>>>
>>> 2 reasons.
>>>
>>> ?1. If this lseek has to check something, this is it.
>>> ?2. On architecture where 32bit program can ran on 64bit,
>>> ? ? moving f_pos above 4G is out-of-range, for example.
>>>
>>> But mem_read() will catch any bad f_pos, anyway. So, just making
>>> allow all f_pos here is maybe a choice. Considering lseek,
>>> providing this range check here is not so bad.
>>
>> Ok, I misunderstood the macro 'TASK_SIZE_OF', then no problem.
>>
>> Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>
>>
> Ah, very sorry. I noticed I didn't handle pread/pwrite, splice, etc...
> I'll do retry.

Yes? Not necessary...

In man page, it said /proc/<pid>/mem can be accessed via open(),
read(), fseek(), no pread(), no splice()...
