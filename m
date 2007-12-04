Return-Path: <linux-kernel-owner+w=401wt.eu-S1754375AbXLDPr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375AbXLDPr3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 10:47:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753719AbXLDPrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 10:47:21 -0500
Received: from mail1.asahi-net.or.jp ([202.224.39.197]:47116 "EHLO
	mail.asahi-net.or.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753659AbXLDPrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 10:47:20 -0500
X-Greylist: delayed 1514 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Dec 2007 10:47:20 EST
Message-ID: <4755701C.7070407@ak.jp.nec.com>
Date: Wed, 05 Dec 2007 00:19:56 +0900
From: KaiGai Kohei <kaigai@ak.jp.nec.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Andrew Morgan <morgan@kernel.org>
CC: KaiGai Kohei <kaigai@ak.jp.nec.com>, "Serge E. Hallyn" <serue@us.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org,
       Chris Wright <chrisw@sous-sol.org>,
       Stephen Smalley <sds@epoch.ncsc.mil>, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] capabilities: introduce per-process capability bounding
 set (v10)
References: <20071126200908.GA13287@sergelap.austin.ibm.com> <4754D76B.8080406@ak.jp.nec.com> <4754F053.8060303@kernel.org>
In-Reply-To: <4754F053.8060303@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morgan wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> KaiGai Kohei wrote:
>> Serge,
>>
>> Please tell me the meanings of the following condition.
>>
>>> diff --git a/security/commoncap.c b/security/commoncap.c
>>> index 3a95990..cb71bb0 100644
>>> --- a/security/commoncap.c
>>> +++ b/security/commoncap.c
>>> @@ -133,6 +119,12 @@ int cap_capset_check (struct task_struct *target,
>>> kernel_cap_t *effective,
>>>          /* incapable of using this inheritable set */
>>>          return -EPERM;
>>>      }
>>> +    if (!!cap_issubset(*inheritable,
>>> +               cap_combine(target->cap_inheritable,
>>> +                       current->cap_bset))) {
>>> +        /* no new pI capabilities outside bounding set */
>>> +        return -EPERM;
>>> +    }
>>>  
>>>      /* verify restrictions on target's new Permitted set */
>>>      if (!cap_issubset (*permitted,
>> It seems to me this condition requires the new inheritable capability
>> set must have a capability more than bounding set, at least.
>> What is the purpose of this checking?
> 
> Yes, the !! was a bug. The correct check is a single !.

I was in trouble with getting -EPERM at pam_cap.so :-)

> (Thus, the correct check says no 'new' pI bits can be outside cap_bset.)

If this condition intends to dominate 'new' pI bits by 'old' pI bits masked
with bounding set, we should not apply cap_combine() here.
I think applying cap_intersect() is correct for the purpose.

Thanks,
--
KaiGai Kohei
