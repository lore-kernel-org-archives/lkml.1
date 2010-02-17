Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368Ab0BQQ2U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 11:28:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34213 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807Ab0BQQ2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 11:28:18 -0500
Message-ID: <4B7C19F1.9090106@redhat.com>
Date: Thu, 18 Feb 2010 00:31:45 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: Octavian Purdila <opurdila@ixiacom.com>
CC: David Miller <davem@davemloft.net>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [net-next PATCH v4 1/3] sysctl: refactor integer handling proc
 code
References: <1266271241-6293-1-git-send-email-opurdila@ixiacom.com> <201002161248.56598.opurdila@ixiacom.com> <4B7A98C7.3070107@redhat.com> <201002161600.54975.opurdila@ixiacom.com>
In-Reply-To: <201002161600.54975.opurdila@ixiacom.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Octavian Purdila wrote:
> On Tuesday 16 February 2010 15:08:23 you wrote:
>> Octavian Purdila wrote:
>>> On Tuesday 16 February 2010 10:41:07 you wrote:
>>>>> +
>>>>> +     if (!write && !first && left && !err)
>>>>> +             err = proc_put_newline(&buffer, &left);
>>>>> +     if (write && !err)
>>>>> +             err = proc_skip_wspace(&buffer, &left);
>>>>> +     if (err == -EFAULT /* do we really need to check for -EFAULT? */
>>>>> || +         (write && first))
>>>>> +             return err ? : -EINVAL;
>>>> The logic here seems messy, adding one or two goto's may help?
>>> OK, I'll give it a try.
>>>
>>> What about the EFAULT check, is that really required?
>> I think so, it means to keep the errno to user-space when it is EFAULT,
>> right? This seems reasonable.
>>
> 
> The problem I see is that this way we don't actually acknowledge some of the 
> set values, e.g. say that we have buffer="1 2 3" and length = 100. Although we 
> do accept values 1, 2 and 3 we don't acknowledge that to the user (as we would 
> do for, say "1 2 3 4a"), but return -EFAULT.
> 
> I think it would be better to skip this check. That means that the user will 
> get the ack for the 1, 2 and 3 values and next time it continues the write it 
> will get -EFAULT.
> 
> This will of course change the userspace ABI, albeit in a minor way, and it is 
> not clear to me if doing this is allowed (even if this new approach would be 
> the correct one).
> 

I think the right behavior is accept "1 2 3" and return the number of
bytes that we accept.
