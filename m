Return-Path: <linux-kernel-owner+w=401wt.eu-S1755090AbZGYGgD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090AbZGYGgD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 02:36:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751589AbZGYGgD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 02:36:03 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:14866 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbZGYGgB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 02:36:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tXIqLLkzUYcr6JTNG0/qf2lq54pFXl4M9gbbIBTAwbYQn0btfwF+G6jD0bA5wVtcFf
         pghEy2yzzPik8937lHY+ECJbhM2E7UtebeB01RIjA+SVwV/VxEYqv5cQQW+NzPWggY7l
         7LH9f+qoAm6S7DnnKML1VujxPetwmFMezz4oE=
MIME-Version: 1.0
In-Reply-To: <7b6bb4a50907242318ocdb8ba8m3e7dc49a2f40a73e@mail.gmail.com>
References: <1248419547-30261-1-git-send-email-dfeng@redhat.com>
	 <d82e647a0907242038l460c01b0ud51a7265f70d6c2e@mail.gmail.com>
	 <7b6bb4a50907242318ocdb8ba8m3e7dc49a2f40a73e@mail.gmail.com>
Date: Sat, 25 Jul 2009 14:36:01 +0800
Message-ID: <d82e647a0907242336w209bec43u6afc9c92aa419955@mail.gmail.com>
Subject: Re: [PATCH] lib/kobject: put kobject if kobject_add_internal fails
From: Ming Lei <tom.leiming@gmail.com>
To: Xiaotian Feng <xtfeng@gmail.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/25 Xiaotian Feng <xtfeng@gmail.com>:
>
>
> On Sat, Jul 25, 2009 at 11:38 AM, Ming Lei <tom.leiming@gmail.com> wrote:
>>
>> 2009/7/24 Xiaotian Feng <dfeng@redhat.com>:
>> > The proper way to use kobject_init_and_add should be:
>> >
>> >        retval = kobject_init_and_add(&foo->kobj, &foo_ktype, NULL, "%s",
>> > name);
>> >        if (retval) {
>> >                kobject_put(&foo->kobj); (*)
>> >                return NULL;
>> >        }
>> >
>>
>> Yes, you are correct.
>>
>> > kobject_init_and_add calls kobject_add_vargs finally, kobject_add_vargs
>> > is divided
>> > into two parts: kobject_set_name_vargs and kobject_add_internal. Both
>> > the two parts
>> > may return an error. If the error is came from kobject_add_internal,
>> > this means
>> > kobject_set_name_vargs already alloc memory for kobj->name.
>> >
>> > So if caller forgets to use kobject_put when this kind of error occurs,
>> > the memory
>> > for kobj->name leaks. Unfortunately, most of the callers is forgotten to
>> > use
>> > kobject_put in this rare situation, grep kobject_init_and_add in kernel
>> > source code,
>> > there are 20+ files forgotten this. So I'd prefer to fix this in
>> > lib/kobject, not
>> > the whole 20+ files.
>>
>> No, you should fix the 20+ files instead of lib/kobject. One rule should
>> be:
>>
>>             One who allocated kobject should free the kobject,
>> instead of others.
>>
>> Image you have allocated a object, and call some .init function to
>> initialize it,
>> but .init frees the object due to some exception, it is very ugly and very
>> prone
>> to access of the freed object.
>>
>> Your patch may lead to much oops if the drivers use the proper way of
>> kobject_init_and_add:
>>
>>        retval = kobject_init_and_add(&foo->kobj, &foo_ktype, NULL, "%s",
>> name);
>>        if (retval) {
>>                kobject_put(&foo->kobj);      /*foo->kobj has been freed,
>> oops*/
>>                return NULL;
>>        }
>>
>> Right?
>
>
> No, take a look at kobject_put code, you will see if foo->kobj is NULL,
> kobject_put will do nothing.
> So it's safe for double kobject_put on the register failed path.

You are wrong, foo->kobj  is __not__ NULL.

Can the kobject_init_and_add update the passed pointer of foo->kobj?

No, it can not. Even kobject_init_and_add returns failure, the pointer
of kobject passed does not change, so kobject_put() still can see the
old pointer.

Thanks.
-- 
Lei Ming
