Return-Path: <linux-kernel-owner+w=401wt.eu-S1753365AbYLZGu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365AbYLZGu7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 01:50:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750810AbYLZGuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 01:50:50 -0500
Received: from ti-out-0910.google.com ([209.85.142.187]:4529 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbYLZGut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 01:50:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=plthILm3E879nXE+a0Mjf/RS3AlInY5Au2OCORmxocLHnRCooKnvQc2RlF+/zUbx22
         O05/13pvShIlcWncOK5GJE2BeFVB63ApYPFqGql85eYbtX4f/ECiV7X8qVaiYIOrG28F
         qW3uJQ8P8kpB8JWsb7mUdd4m5jg5qeUGq21nQ=
Date: Fri, 26 Dec 2008 14:49:28 +0000
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [Patch] signal: let valid_signal() check more
Message-ID: <20081226144928.GC3156@hack.private>
References: <20081226012612.GI3130@hack.private> <20081225180054.GA24116@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081225180054.GA24116@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 25, 2008 at 07:00:54PM +0100, Oleg Nesterov wrote:
>On 12/26, Américo Wang wrote:
>>
>> Teach valid_signal() to check sig > 0 case.
>
>Why?

Just to simplify the checking.

>
>> @@ -727,7 +727,7 @@ int vt_ioctl(struct tty_struct *tty, struct file * file,
>>  	{
>>  		if (!perm || !capable(CAP_KILL))
>>  			goto eperm;
>> -		if (!valid_signal(arg) || arg < 1 || arg == SIGKILL)
>> +		if (!valid_signal((int)arg) || arg == SIGKILL)
>                                  ^^^^^
>
>The patch adds a lot of unnecessary typecasts like this.


because it's inline?

>
>> -static inline int valid_signal(unsigned long sig)
>> +static inline int valid_signal(int sig)
>>  {
>> -	return sig <= _NSIG ? 1 : 0;
>> +	return sig <= _NSIG ? (sig > 0) : 0;
>>  }
>
>This looks a bit strange, why not
>
>	return sig > 0 && sig <= _NSIG;
>
>?


Yes, this one is better.

>
>But, more importantly, I don't think the patch is correct.
>
>Unless I misread the patch, now kill(pid, 0) returns -EINVAL, no?
>
>And we have other users of valid_signal() which assume that sig == 0
>is OK, for example arch_ptrace().


Oh, thanks for pointing this out. I didn't know this. Sorry.

>
>Imho, the patch has a point, but perhaps it is better to add the
>new helper and then convert the users which do something like
>
>	if (valid_signal(sig) && sig)
>		...
>
>What do you think?

I think this is a good idea. I will do it.

Thanks.

-- 
"Against stupidity, the gods themselves, contend in vain."

