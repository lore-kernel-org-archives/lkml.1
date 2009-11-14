Return-Path: <linux-kernel-owner+w=401wt.eu-S1754700AbZKNImb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700AbZKNImb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 03:42:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754482AbZKNIma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 03:42:30 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:34964 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbZKNIm2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 03:42:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=SEuBQmyXz+V7gSeKe7z9G2XHxMgvOhKCyTHPpXtxqdMhiihZxiTFvnOmjVRjeJmbtZ
         XJk1Q/Alov9jJI3eLH7DO5RGUZ+HxERocJjSeR3RlUqK5tXwFu+6FP55fyM/RG3UHL6s
         tZ+5mZWJZvwx+YG3JdZ+4qprUSumh3+DUf1HE=
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <alpine.LRH.2.00.0910300851470.25970@tundra.namei.org>
References: <20091029164016.GA21797@us.ibm.com>
	 <alpine.LRH.2.00.0910300851470.25970@tundra.namei.org>
Date: Sat, 14 Nov 2009 09:42:33 +0100
Message-ID: <cfd18e0f0911140042n265b95adve2121e143c21c8ad@mail.gmail.com>
Subject: Re: [PATCH] define convenient securebits masks for prctl users (v2)
From: Michael Kerrisk <mtk.manpages@googlemail.com>
To: James Morris <jmorris@namei.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       linux-security-module@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>,
       "Andrew G. Morgan" <morgan@kernel.org>,
       Ulrich Drepper <drepper@redhat.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 29, 2009 at 10:51 PM, James Morris <jmorris@namei.org> wrote:
> On Thu, 29 Oct 2009, Serge E. Hallyn wrote:
>
>> Hi James, would you mind taking the following into
>> security-testing?
>
>
> Applied to
> git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

It doesn't look like this change is in 2.6.32-rc7. Is it planned to
push this out for 2.6.32?

Cheers,

Michael

>> The securebits are used by passing them to prctl with the
>> PR_{S,G}ET_SECUREBITS commands.  But the defines must be
>> shifted to be used in prctl, which begs to be confused and
>> misused by userspace.  So define some more convenient
>> values for userspace to specify.  This way userspace does
>>
>>       prctl(PR_SET_SECUREBITS, SECBIT_NOROOT);
>>
>> instead of
>>
>>       prctl(PR_SET_SECUREBITS, 1 << SECURE_NOROOT);
>>
>> (Thanks to Michael for the idea)
>>
>> This patch also adds include/linux/securebits to the installed headers.
>> Then perhaps it can be included by glibc's sys/prctl.h.
>>
>> Changelog:
>>       Oct 29: Stephen Rothwell points out that issecure can
>>               be under __KERNEL__.
>>       Oct 14: (Suggestions by Michael Kerrisk):
>>               1. spell out SETUID in SECBIT_NO_SETUID*
>>               2. SECBIT_X_LOCKED does not imply SECBIT_X
>>               3. add definitions for keepcaps
>>         Oct 14: As suggested by Michael Kerrisk, don't
>>               use SB_* as that convention is already in
>>               use.  Use SECBIT_ prefix instead.
>>
>> Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
>> Acked-by: Andrew G. Morgan <morgan@kernel.org>
>> Acked-by: Michael Kerrisk <mtk.manpages@gmail.com>
>> Cc: Ulrich Drepper <drepper@redhat.com>
>> Cc: James Morris <jmorris@namei.org>
>> ---
>>  include/linux/Kbuild       |    1 +
>>  include/linux/securebits.h |   24 ++++++++++++++++++------
>>  2 files changed, 19 insertions(+), 6 deletions(-)
>>
>> diff --git a/include/linux/Kbuild b/include/linux/Kbuild
>> index 1feed71..5a53857 100644
>> --- a/include/linux/Kbuild
>> +++ b/include/linux/Kbuild
>> @@ -330,6 +330,7 @@ unifdef-y += scc.h
>>  unifdef-y += sched.h
>>  unifdef-y += screen_info.h
>>  unifdef-y += sdla.h
>> +unifdef-y += securebits.h
>>  unifdef-y += selinux_netlink.h
>>  unifdef-y += sem.h
>>  unifdef-y += serial_core.h
>> diff --git a/include/linux/securebits.h b/include/linux/securebits.h
>> index d2c5ed8..3340617 100644
>> --- a/include/linux/securebits.h
>> +++ b/include/linux/securebits.h
>> @@ -1,6 +1,15 @@
>>  #ifndef _LINUX_SECUREBITS_H
>>  #define _LINUX_SECUREBITS_H 1
>>
>> +/* Each securesetting is implemented using two bits. One bit specifies
>> +   whether the setting is on or off. The other bit specify whether the
>> +   setting is locked or not. A setting which is locked cannot be
>> +   changed from user-level. */
>> +#define issecure_mask(X)     (1 << (X))
>> +#ifdef __KERNEL__
>> +#define issecure(X)          (issecure_mask(X) & current_cred_xxx(securebits))
>> +#endif
>> +
>>  #define SECUREBITS_DEFAULT 0x00000000
>>
>>  /* When set UID 0 has no special privileges. When unset, we support
>> @@ -12,6 +21,9 @@
>>  #define SECURE_NOROOT                        0
>>  #define SECURE_NOROOT_LOCKED         1  /* make bit-0 immutable */
>>
>> +#define SECBIT_NOROOT                (issecure_mask(SECURE_NOROOT))
>> +#define SECBIT_NOROOT_LOCKED (issecure_mask(SECURE_NOROOT_LOCKED))
>> +
>>  /* When set, setuid to/from uid 0 does not trigger capability-"fixup".
>>     When unset, to provide compatiblility with old programs relying on
>>     set*uid to gain/lose privilege, transitions to/from uid 0 cause
>> @@ -19,6 +31,10 @@
>>  #define SECURE_NO_SETUID_FIXUP               2
>>  #define SECURE_NO_SETUID_FIXUP_LOCKED        3  /* make bit-2 immutable */
>>
>> +#define SECBIT_NO_SETUID_FIXUP       (issecure_mask(SECURE_NO_SETUID_FIXUP))
>> +#define SECBIT_NO_SETUID_FIXUP_LOCKED \
>> +                     (issecure_mask(SECURE_NO_SETUID_FIXUP_LOCKED))
>> +
>>  /* When set, a process can retain its capabilities even after
>>     transitioning to a non-root user (the set-uid fixup suppressed by
>>     bit 2). Bit-4 is cleared when a process calls exec(); setting both
>> @@ -27,12 +43,8 @@
>>  #define SECURE_KEEP_CAPS             4
>>  #define SECURE_KEEP_CAPS_LOCKED              5  /* make bit-4 immutable */
>>
>> -/* Each securesetting is implemented using two bits. One bit specifies
>> -   whether the setting is on or off. The other bit specify whether the
>> -   setting is locked or not. A setting which is locked cannot be
>> -   changed from user-level. */
>> -#define issecure_mask(X)     (1 << (X))
>> -#define issecure(X)          (issecure_mask(X) & current_cred_xxx(securebits))
>> +#define SECBIT_KEEP_CAPS     (issecure_mask(SECURE_KEEP_CAPS))
>> +#define SECBIT_KEEP_CAPS_LOCKED (issecure_mask(SECURE_KEEP_CAPS_LOCKED))
>>
>>  #define SECURE_ALL_BITS              (issecure_mask(SECURE_NOROOT) | \
>>                                issecure_mask(SECURE_NO_SETUID_FIXUP) | \
>> --
>> 1.6.1
>>
>
> --
> James Morris
> <jmorris@namei.org>
>



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface" http://blog.man7.org/
