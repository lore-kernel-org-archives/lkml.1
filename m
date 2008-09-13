Return-Path: <linux-kernel-owner+w=401wt.eu-S1758029AbYIMHZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758029AbYIMHZ6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 03:25:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752767AbYIMHZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 03:25:50 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:2090 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745AbYIMHZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 03:25:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=WGnXg3YynTF4foWX0CGma6Of+lig1J7ROdrILAofVXzRFkszP5Coy2tA4opp47h8jf
         xtBfZpOstNdJ4d4S4c368+jSTZq2O9lS8vmwdP5ZHhhK5V8f5+KOeOyLuRO7HvcC0EXy
         9+snrH7mGD5IbJMC8ngvFUOUImh7iExGSfAXw=
Message-ID: <19f34abd0809130025x4901c749u987bc2cd30a1586e@mail.gmail.com>
Date: Sat, 13 Sep 2008 09:25:48 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH] utsname: completely overwrite prior information
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080912151129.1c8d38f8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080912203624.GA25965@damson.getinternet.no>
	 <20080912151129.1c8d38f8.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 13, 2008 at 12:11 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> fair enuf.  Did you check allthe other fields in 'struct new_utsname'?

As far as I can tell, only nodename (hostname) and domainname may be
changed by userspace.

>
>> index 038a7bc..78b4515 100644
>> --- a/kernel/sys.c
>> +++ b/kernel/sys.c
>> @@ -1352,7 +1352,8 @@ asmlinkage long sys_sethostname(char __user *name, int len)
>>       errno = -EFAULT;
>>       if (!copy_from_user(tmp, name, len)) {
>>               memcpy(utsname()->nodename, tmp, len);
>> -             utsname()->nodename[len] = 0;
>> +             memset(utsname()->nodename + len, 0,
>> +                     sizeof(utsname()->nodename) - len);
>
> We could do the memset before the memcpy.  It's more work, but less
> text.  Whatever.

Whatever :-)

> While we're there, the code generation in there is a bit sloppy.  How's
> this look?
>
>
> From: Andrew Morton <akpm@linux-foundation.org>
>
> utsname() is quite expensive to calculate.  Cache it in a local.
>
>          text    data     bss     dec     hex filename
> before:  11136     720      16   11872    2e60 kernel/sys.o
> after:   11096     720      16   11832    2e38 kernel/sys.o
>
> Cc: Vegard Nossum <vegard.nossum@gmail.com>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Cc: "Serge E. Hallyn" <serue@us.ibm.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

I agree with this change. FWIW: Acked-by: Vegard Nossum
<vegard.nossum@gmail.com>

There seems to be a few more places throughout the kernel which
needlessly call utsname() more than once. I will keep it in mind.

Thanks,


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
