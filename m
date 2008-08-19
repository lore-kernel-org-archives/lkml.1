Return-Path: <linux-kernel-owner+w=401wt.eu-S1755868AbYHSKJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868AbYHSKJT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 06:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752952AbYHSKJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 06:09:09 -0400
Received: from sacred.ru ([62.205.161.221]:34851 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752518AbYHSKJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 06:09:08 -0400
Message-ID: <48AA9B96.7000905@openvz.org>
Date: Tue, 19 Aug 2008 14:08:22 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: kirill@shutemov.name, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] binfmt_misc.c: avoid potential kernel stack overflow
References: <20080818112849.GA4951@localhost.localdomain>	<48A98293.5080109@openvz.org> <20080818162046.f6c41e84.akpm@linux-foundation.org>
In-Reply-To: <20080818162046.f6c41e84.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Tue, 19 Aug 2008 14:08:22 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 18 Aug 2008 18:09:23 +0400
> Pavel Emelyanov <xemul@openvz.org> wrote:
> 
>> (Put lkml in Cc. The original message is beyond)
>>
>> Oops! My fault. The problem is that in case of modularized binfmt,
>> the appropriate binary handler gets registered _before_ the script
>> one and sets the misc_bang flag even too early.
>>
>> Thus when we launch a script the load_misc_binary sets this bang,
>> then returns error, since the binary is actually a script, then the
>> load_script_binary successfully loads the script, then it loads the
>> misc binary again, which exits with the -ENOEXEC error due to bang 
>> set.
>>
>> This patch helped my box, what about yours?
>>
>> diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
>> index 7562053..8d7e88e 100644
>> --- a/fs/binfmt_misc.c
>> +++ b/fs/binfmt_misc.c
>> @@ -120,8 +120,6 @@ static int load_misc_binary(struct linux_binprm *bprm, struct pt_regs *regs)
>>  	if (bprm->misc_bang)
>>  		goto _ret;
>>  
>> -	bprm->misc_bang = 1;
>> -
>>  	/* to keep locking time low, we copy the interpreter string */
>>  	read_lock(&entries_lock);
>>  	fmt = check_file(bprm);
>> @@ -199,6 +197,8 @@ static int load_misc_binary(struct linux_binprm *bprm, struct pt_regs *regs)
>>  	if (retval < 0)
>>  		goto _error;
>>  
>> +	bprm->misc_bang = 1;
>> +
>>  	retval = search_binary_handler (bprm, regs);
>>  	if (retval < 0)
>>  		goto _error;
> 
> <scrabble, hunt>
> 
> I put together the below description.  It has no signed-off-by: (yet).

Well, sorry for that, I just wanted to get the Kirill's approval of the
fix, while testing other things myself. I sent the properly formatted
patch later. So can you, please, pick the comment and/or subject from
that one (which is a bit less messy, I think)?

> Has this been sufficiently well tested and checked to be in a merge-ready
> state?

I have checked different combinations, so I believe it has.

> Thanks.

Thanks,
Pavel
