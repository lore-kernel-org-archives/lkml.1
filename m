Return-Path: <linux-kernel-owner+w=401wt.eu-S1754958AbYJLNx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958AbYJLNx2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 09:53:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760160AbYJLNxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 09:53:15 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:47405 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760091AbYJLNxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 09:53:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=QwX6b+8OonmFhEH5c1/GjnU4pq1b/pLOtc0peVUXK/jB7Msbi2OQ1PaniZAK19es+3
         ClKvW0fd8bU/17C+qzHq7LO+M8qEwtSAqa3+SZSSvbAodr5aIat0Pkx58JzW4wmtPLX5
         GK5Wri3S4zLfIXCka+0ifarlJtXFBYjuXS69M=
Message-ID: <48F20142.3070002@gmail.com>
Date: Sun, 12 Oct 2008 16:53:06 +0300
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
CC: mingo@elte.hu, srostedt@redhat.com, a.p.zijlstra@chello.nl,
       sandmann@daimi.au.dk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] Add support for userspace stacktraces in tracing/iter_ctrl
References: <1223817124-27239-1-git-send-email-edwintorok@gmail.com>	 <1223817124-27239-3-git-send-email-edwintorok@gmail.com> <c62985530810120631g3e464503i8958d160e6b1aa3e@mail.gmail.com>
In-Reply-To: <c62985530810120631g3e464503i8958d160e6b1aa3e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008-10-12 16:31, Frédéric Weisbecker wrote:
> 2008/10/12 Török Edwin <edwintorok@gmail.com>:
>   
>> +static int copy_stack_frame(const void __user *fp, struct stack_frame *frame)
>> +{
>> +       int ret;
>> +
>> +       if (!access_ok(VERIFY_READ, fp, sizeof(*frame)))
>> +               return 0;
>> +
>> +       ret = 1;
>> +       pagefault_disable();
>> +       if (__copy_from_user_inatomic(frame, fp, sizeof(*frame)))
>> +               ret = 0;
>> +       pagefault_enable();
>> +
>> +       return ret;
>> +}
>> +
>>     
>
> Hello Török,
>
> I don't understand why you are using this pagefault disabling and
> atomic copy here.
> Wouldn't a simple copy_from_user actually take of this? You don't seem
> to be in atomic
> context.
>   

Hello,

This function is called from ftrace, as such I could be holding a
spinlock. It can also be called from
__rwsem_do_wake, which takes a spinlock.
This code is from sysprof's copy_stack_frame. Maybe pagefault_disable()
is not needed.

Best regards,
--Edwin
