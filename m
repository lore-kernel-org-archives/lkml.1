Return-Path: <linux-kernel-owner+w=401wt.eu-S1753100AbZIYQXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100AbZIYQXv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 12:23:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753159AbZIYQXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 12:23:49 -0400
Received: from smtp110.prem.mail.sp1.yahoo.com ([98.136.44.55]:42856 "HELO
	smtp110.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753112AbZIYQXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 12:23:48 -0400
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: LabqK_EVM1mUeufB5fBD9.Co493ePFdWB1CZSFvql4RCW2LSI_mkwJHlZ.9EJ7ynOj1zHBsgQKGoX_.QSz6DA6VPgOnolN7gswR86Cq.xT8HrsEr2_yILCKHGziiPyaYIo1453rOCBaKFZpoV3FkTGez.GZVHaUZzsmDHB8GX70Vo4UWKY8TT6kHtsjc3ibyWdNDl4kGHoEjZlCJvTBW6g0VRARhNmq6DrFQvKxPTj.85kxDC7LGIoeN19tmKycq5rksjzuSr2gvPqmArbk1YCB2
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4ABCEE71.6060703@schaufler-ca.com>
Date: Fri, 25 Sep 2009 09:23:13 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Andy Spencer <andy753421@gmail.com>
CC: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] Privilege dropping security module
References: <20090923005644.GA28244@c.hsd1.tn.comcast.net> <20090923213109.GA936@c.hsd1.tn.comcast.net> <4ABB9D6D.8000607@schaufler-ca.com> <20090925100630.GD10098@c.hsd1.tn.comcast.net>
In-Reply-To: <20090925100630.GD10098@c.hsd1.tn.comcast.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Spencer wrote:
>> I think I saw this mentioned elsewhere, but you can't put a
>> 4k buffer on the stack.
>> ...
>> "//" comments are not used in the kernel
>> ...
>> Why use a value other than PATH_MAX? If it's arbitrary,
>> go with the "standard" arbitrary.
>> ... 
>> Stick with your namespace.
>>     
>
> Fixed as suggested, thanks.
>   

It's amazing who much of this stuff there is to attend to.
If you haven't, run checkpatch.py on your patches. You'll
need to pass that eventually.

>> The term "privilege" is generally applied to a broader scope
>> than discretionary access controls. You might want to consider
>> using a name that is more precisely descriptive of the feature.
>> It probably isn't that important, but I for one would be happier.
>>
>> You're not dropping privilege, that would imply restricting
>> root and/or capability access. You're masking file permissions.
>>     
>
> I have no objections to changing the name if you have a better
> suggestion. However, I would like to avoid the term "discretionary
> access control" since DACs deal with passing permissions between
> subjects, while in dpriv, the only subject involved is the current
> subject (well, and its children). Also, as pointed out in another
> thread, dpriv will eventually need to support more than just file
> permissions if it wants to be secure.
>   

Hmm. You are working with the Linux DAC mechanism, even if only within
a process tree. You're not dropping privilege, you're applying a mask to
the file permission bits, currently for file system objects, and with
other objects (sysvipc at least) in the future. Hmm. modemask? Something
derived from "restricted process tree?"

>>> +#define pr_fmt(fmt) "%s: " fmt, __func__
>>>       
>> You have defined this in multiple places, which isn't good,
>> and it's a bit of code that obfuscates what's going on. It
>> may seem like a good idea, but you'll be better off if you
>> go ahead and put the code in where you're using it.
>>     
>
> Defining pr_fmt seems to be fairly common in the rest of the kernel, a
> quick grep shows 98 occurrences. If these are all deprecated, I don't
> mind changing it, but it seem worth the bit of obfuscation to me.
>   

Sigh. 98? I guess I'm wrong. Sorry 'bout that.

>>> +u16 flags_to_mode(unsigned int flags)
>>> +int str_to_perm(const char *str)
>>> +void perm_to_str(u16 perm, char *str)
>>>       
>> Definitely namespace. Could this be static?
>>     
>
> I added the namespace, but they're used in a couple other files so they
> can't be static. There are a couple other function in policy.[ch] that
> could be static but I'm leaving them in the header for now in case they
> end up being needed later.
>   

You will need to change that if you want the code upstream. There are
people lurking out there, looking for things that could be static be
aren't and pouncing on unwary developers.

>   
>>> +#define dpriv_cur_task   ((struct dpriv_task *)current_security())
>>> +#define dpriv_cur_stage  ((struct dpriv_policy *)&dpriv_cur_task->stage)
>>> +#define dpriv_cur_policy ((struct dpriv_policy *)&dpriv_cur_task->policy)
>>>       
>> You may get other feedback, but I think that using macros
>> to hide indirections make code harder to understand.
>>     
>
> I think I'd like to keep these as well, although it might be good to
> change them to either `dpriv_current_*()' or `current_dpriv_*()' to
> follow the conventions used in <linux/cred.h>.
>   

Ok. If I get confused in later reviews, don't say I didn't warn you.

>>> +/* Mode conversion functions */
>>> +#define deny(perm, request) \
>>> +	unlikely(perm >= 0 && ~perm & request)
>>>       
>> Keep to your namespace and use static inline functions.
>>     
>
> I changed these to static inline functions, but the one thing I don't
> like about doing so is that I don't think the compiler can't optimize
> the `unlikely()' macro as well. For the time being, I moved the unlikely
> macros to where deny (now dpriv_denied) gets called.
>   

My understanding is that hand optimization of things like this
almost always results in worse results than you get if you let
the compiler work its will, but that's up to you.

>   
>> Function macros are discouraged. If you really want code duplication
>> use static inline functions. And stick with your namespace, use
>> dpriv_strfwd() instead of strfwd().
>> ...
>> String parsing in the kernel is considered harmful.
>> Simplify this.
>>     
>
> I reworked much of the string parsing. I think /some/ parsing is going
> to be necessary no matter what, but hopefully the new way of doing it is
> easier to understand and less likely to contains bugs. As a result those
> macros are no longer needed at all. (Note that this depends on a
> separate patch to sscanf). I've included the new dpriv_stage_write()
> below.
>
> (I can include another full diff against either the previous patch or
> the mainline kernel if anyone would like it.)
>   

Please repost against the mainline.
I will look at the semantics of the code next time around.

Thank you.

