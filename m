Return-Path: <linux-kernel-owner+w=401wt.eu-S932425AbZKRSgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932425AbZKRSgR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 13:36:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932210AbZKRSgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 13:36:16 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:44305 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932133AbZKRSgP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 13:36:15 -0500
MIME-Version: 1.0
In-Reply-To: <200911181249.29140.sgrubb@redhat.com>
References: <20091110140739.GA15534@us.ibm.com>
	 <20091111001914.GA30470@us.ibm.com>
	 <551280e50911180840v5c3f2945t253c709ba2d033b2@mail.gmail.com>
	 <200911181249.29140.sgrubb@redhat.com>
Date: Wed, 18 Nov 2009 10:36:20 -0800
X-Google-Sender-Auth: 6963a3edbff4ec65
Message-ID: <551280e50911181036q1b186b8ei2cea995d2543c125@mail.gmail.com>
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

On Wed, Nov 18, 2009 at 9:49 AM, Steve Grubb <sgrubb@redhat.com> wrote:
> On Wednesday 18 November 2009 11:40:13 am Andrew G. Morgan wrote:
>> >> But back to detecting the capability version number...if I pass 0 as the
>> >> version in the header, why can't the kernel just say oh you want the
>> >> preferred version number, stuff it in the header, and return the syscall
>> >> with success and not EINVAL?
>>
>> This is so a library can understand that it doesn't understand the
>> current ABI.
>
> If user space is passing a NULL for the cap_user_data_t argument, user space
> has a pretty good idea that its not expecting actual capabilities to be filled
> in. My basic point is that there is no way to "correctly" use the capabilities
> API to determine what the preferred version is.

But older kernels didn't do that.

>> For example, consider the case of some kernel of the
>> future with a different ABI meeting an old library.
>
> Right. Either user space checks version numbers to verify it knows what its
> doing and errors out, or it blindly tries to set capabilities and gets an
> error. Either way, if user space is *really* using the API to do work, it
> won't be passing NULL as the user data argument.
>
> Maybe if version is set to 0 and NULL is being passed for arg 2 to getcap,
> that would be the secret handshake that lets the kernel know all I want is the
> preferred version number and nothing else since there is no data structure to
> fill in.
>
>
>> The intention is for it to fail safe and not blunder on doing
>> "security" related operations with an imperfect idea of the current
>> kernel interface.
>>
>> This is how libcap figures out it can work with the hosting kernel:
>
> capget(0x20080522, 0, NULL)             = -1 EFAULT (Bad address)

I'm not sure what this is supposed to do. This system call takes two
arguments and none of them work as your above snippet suggests.

http://git.kernel.org/?p=libs/libcap/libcap.git;a=blob;f=libcap/cap_alloc.c;h=5fa5e9305c146529e297285befa03e7c5521e9ba;hb=HEAD

SYSCALL_DEFINE2(capget, cap_user_header_t, header, cap_user_data_t, dataptr)
 165 {
 166         int ret = 0;
 167         pid_t pid;
 168         unsigned tocopy;
 169         kernel_cap_t pE, pI, pP;
 170
 171         ret = cap_validate_magic(header, &tocopy);
 172         if (ret != 0)
 173                 return ret;

ie., two arguments, both of which are pointers. dataptr is not touched
if you supply incorrect magic... The return at line 173 is taken if
header is explored and does not contain the correct magic (ie.
Invalid) - which it overwrites with the kernel-preferred value in the
header, and returns EINVAL...

I don't see an EFAULT problem here.

> Still an error.

Could you clarify? Perhaps with some actual code?

Thanks

Andrew

>
> -Steve
>
