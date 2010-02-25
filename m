Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932466Ab0BYNOy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 08:14:54 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:36044 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932296Ab0BYNOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 08:14:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=GPq9UPaVtVvtGZ5WMDcAwvBLv7m468S9iv2yop7OVrUpgT/0kgfVi8+c/SlM3EVevA
         ECTFKVKYvQUQzQ5VDkX/W73COEMZPGsDaA345KpwvcW//sAH4i8wdq4jStC+M+lU4msm
         ilXf2AteXmlQq3AoL7Zw/BNN+6C46V4ZtniJ8=
Date: Thu, 25 Feb 2010 21:17:15 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Xiaotian Feng <xtfeng@gmail.com>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       =?utf-8?B?QW5kcsOp?= Goddard Rosa <andre.goddard@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Serge E . Hallyn" <serue@us.ibm.com>,
       Cedric Le Goater <clg@fr.ibm.com>, Al Viro <viro@zeniv.linux.org.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] mqueue: fix mq_open() file descriptor leak on
	user-space processes
Message-ID: <20100225131715.GA3842@hack>
References: <cover.1266907495.git.andre.goddard@gmail.com> <a3a62a6cd7cc0ba011949396a1f2c7f9c32aa4b9.1266907496.git.andre.goddard@gmail.com> <2375c9f91002241935k56dff805q57582d998b660889@mail.gmail.com> <7b6bb4a51002242000x49f0b3bdncb40912bf18f90bb@mail.gmail.com> <2375c9f91002242025n1ab73e18i5950aa4f14ea36db@mail.gmail.com> <2375c9f91002242259n2fabb190ic77d6ca603bd1df7@mail.gmail.com> <7b6bb4a51002250249t7e4f03c9r6b2b9a8f348a29aa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7b6bb4a51002250249t7e4f03c9r6b2b9a8f348a29aa@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 25, 2010 at 06:49:09PM +0800, Xiaotian Feng wrote:
>On Thu, Feb 25, 2010 at 2:59 PM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
>> On Thu, Feb 25, 2010 at 12:25 PM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
>>> On Thu, Feb 25, 2010 at 12:00 PM, Xiaotian Feng <xtfeng@gmail.com> wrote:
>>>> 2010/2/25 Américo Wang <xiyou.wangcong@gmail.com>:
>>>>> On Tue, Feb 23, 2010 at 3:04 PM, André Goddard Rosa
>>>>> <andre.goddard@gmail.com> wrote:
>>>>>> It can be triggered by the following test program:
>>>>>>
>>>>>
>>>>> <snip>
>>>>>
>>>>>>
>>>>>> When not running valgrind, user-space program segfaults trying to execute
>>>>>> strerror(errno). With valgrind, it executes successfully and prints the
>>>>>> 5 open files: stdin, stdout, stderr, pipe[0] and pipe[1].
>>>>>>
>>>>>> Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>
>>>>>> ---
>>>>>
>>>>> The code has more than just this problem, could you please try
>>>>> my patch below?
>>>>>
>>>>> Thanks.
>>>>>
>>>>> ---------------------------->
>>>>>
>>>>> Clean up the failure path of sys_mq_open().
>>>>>
>>>>> Reorder the goto labels;
>>>>> Rename 'upsem' to 'upunlock';
>>>>> Remove some unused labels;
>>>>> Fix some wrong goto path.
>>>>>
>>>>
>>>> I think it's wrong to move dput after mntput
>>>
>>> Oh, this is to say mntget() should be called before lookup_one_len(),
>>> the original code seems wrong again...
>>>
>>
>> How about the one below?
>
>This is definitely wrong,
>
> 	if (IS_ERR(filp)) {
> 		error = PTR_ERR(filp);
>-		goto out_putfd;
>+		goto out;
> 	}
>
>filp is assigned by do_open or do_create in mqueue.c, take a look at
>the code, if do_open/do_create is failed, kernel is already dput &
>mntput...
>

Clearly the original code is a piece of sh*t.

