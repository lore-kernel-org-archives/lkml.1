Return-Path: <linux-kernel-owner+w=401wt.eu-S1757107AbZKSPfJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757107AbZKSPfJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 10:35:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756862AbZKSPfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 10:35:07 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:47551 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754290AbZKSPfG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 10:35:06 -0500
MIME-Version: 1.0
In-Reply-To: <200911181433.30967.sgrubb@redhat.com>
References: <20091110140739.GA15534@us.ibm.com>
	 <200911181249.29140.sgrubb@redhat.com>
	 <551280e50911181036q1b186b8ei2cea995d2543c125@mail.gmail.com>
	 <200911181433.30967.sgrubb@redhat.com>
Date: Thu, 19 Nov 2009 07:35:12 -0800
X-Google-Sender-Auth: 1ae43cc1b7e152b2
Message-ID: <551280e50911190735u210e2c60xc944c333b122d22d@mail.gmail.com>
Subject: Re: drop SECURITY_FILE_CAPABILITIES?
From: "Andrew G. Morgan" <morgan@kernel.org>
To: Steve Grubb <sgrubb@redhat.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org,
       Kees Cook <kees.cook@canonical.com>,
       Andreas Gruenbacher <agruen@suse.de>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       George Wilson <gcwilson@us.ibm.com>, KaiGai Kohei <kaigai@kaigai.gr.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steve,

[We chatted offline. I'm still not sure I agree with the "now we have
the problem" bit since what is there today does work... However,
you've persuaded me that the system call error is ugly/noisy and not a
compatibility requirement of pre-existing code, provided that a NULL
is passed for dataptr -- that is, I've gone back and looked at older
libcaps and older kernels and checked. So...]

How about this change?

@@ -169,8 +169,11 @@ SYSCALL_DEFINE2(capget, cap_user_header_
       kernel_cap_t pE, pI, pP;

       ret = cap_validate_magic(header, &tocopy);
-       if (ret != 0)
+       if ((ret != 0) || (dataptr == NULL)) {
+               if ((ret == -EINVAL) && (dataptr == NULL))
+                       return 0;
               return ret;
+       }

       if (get_user(pid, &header->pid))
               return -EFAULT;

? This is a slightly modified version of what you posted before.
Specifically, in the case that the user guessed a compatible version
this NULL call will succeed and not EFAULT.

Cheers

Andrew

On Wed, Nov 18, 2009 at 11:33 AM, Steve Grubb <sgrubb@redhat.com> wrote:
> On Wednesday 18 November 2009 01:36:20 pm Andrew G. Morgan wrote:
>> On Wed, Nov 18, 2009 at 9:49 AM, Steve Grubb <sgrubb@redhat.com> wrote:
>> > On Wednesday 18 November 2009 11:40:13 am Andrew G. Morgan wrote:
>> >> >> But back to detecting the capability version number...if I pass 0 as
>> >> >> the version in the header, why can't the kernel just say oh you want
>> >> >> the preferred version number, stuff it in the header, and return the
>> >> >> syscall with success and not EINVAL?
>> >>
>> >> This is so a library can understand that it doesn't understand the
>> >> current ABI.
>> >
>> > If user space is passing a NULL for the cap_user_data_t argument, user
>> > space has a pretty good idea that its not expecting actual capabilities
>> > to be filled in. My basic point is that there is no way to "correctly"
>> > use the capabilities API to determine what the preferred version is.
>>
>> But older kernels didn't do that.
>
> True, but now we have the problem.
>
>
>> >> The intention is for it to fail safe and not blunder on doing
>> >> "security" related operations with an imperfect idea of the current
>> >> kernel interface.
>> >>
>> >> This is how libcap figures out it can work with the hosting kernel:
>> >
>> > capget(0x20080522, 0, NULL)             = -1 EFAULT (Bad address)
>>
>> I'm not sure what this is supposed to do. This system call takes two
>> arguments and none of them work as your above snippet suggests.
>
> This is from running "strace /usr/sbin/getcap libcap.h". I think strace is
> splitting arg 1 into its 2 elements within the structure for display purposes.
> You can strace it yourself and see. :)
>
>
>> SYSCALL_DEFINE2(capget, cap_user_header_t, header, cap_user_data_t,
>>  dataptr) 165 {
>>  166         int ret = 0;
>>  167         pid_t pid;
>>  168         unsigned tocopy;
>>  169         kernel_cap_t pE, pI, pP;
>>  170
>>  171         ret = cap_validate_magic(header, &tocopy);
>>  172         if (ret != 0)
>>  173                 return ret;
>>
>> ie., two arguments, both of which are pointers. dataptr is not touched
>> if you supply incorrect magic... The return at line 173 is taken if
>> header is explored and does not contain the correct magic (ie.
>> Invalid) - which it overwrites with the kernel-preferred value in the
>> header, and returns EINVAL...
>
> OK, this is the right place to make a fix. Something along the lines of:
>
> @@ -169,8 +169,11 @@ SYSCALL_DEFINE2(capget, cap_user_header_
>        kernel_cap_t pE, pI, pP;
>
>        ret = cap_validate_magic(header, &tocopy);
> -       if (ret != 0)
> +       if (ret != 0) {
> +               if (ret == -EINVAL && dataptr == NULL)
> +                       return 0;
>                return ret;
> +       }
>
>        if (get_user(pid, &header->pid))
>                return -EFAULT;
>
>
>> I don't see an EFAULT problem here.
>
> It comes when get_user fails above.
>
> -Steve
>
