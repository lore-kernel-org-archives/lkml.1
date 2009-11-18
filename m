Return-Path: <linux-kernel-owner+w=401wt.eu-S1758353AbZKRTfB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758353AbZKRTfB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 14:35:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756108AbZKRTe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 14:34:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25830 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754561AbZKRTe7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 14:34:59 -0500
From: Steve Grubb <sgrubb@redhat.com>
Organization: Red Hat
To: "Andrew G. Morgan" <morgan@kernel.org>
Subject: Re: drop SECURITY_FILE_CAPABILITIES?
Date: Wed, 18 Nov 2009 14:33:30 -0500
User-Agent: KMail/1.12.2 (Linux/2.6.30.9-96.fc11.x86_64; KDE/4.3.2; x86_64; ; )
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org,
       Kees Cook <kees.cook@canonical.com>,
       Andreas Gruenbacher <agruen@suse.de>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       George Wilson <gcwilson@us.ibm.com>, KaiGai Kohei <kaigai@kaigai.gr.jp>
References: <20091110140739.GA15534@us.ibm.com> <200911181249.29140.sgrubb@redhat.com> <551280e50911181036q1b186b8ei2cea995d2543c125@mail.gmail.com>
In-Reply-To: <551280e50911181036q1b186b8ei2cea995d2543c125@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911181433.30967.sgrubb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 November 2009 01:36:20 pm Andrew G. Morgan wrote:
> On Wed, Nov 18, 2009 at 9:49 AM, Steve Grubb <sgrubb@redhat.com> wrote:
> > On Wednesday 18 November 2009 11:40:13 am Andrew G. Morgan wrote:
> >> >> But back to detecting the capability version number...if I pass 0 as
> >> >> the version in the header, why can't the kernel just say oh you want
> >> >> the preferred version number, stuff it in the header, and return the
> >> >> syscall with success and not EINVAL?
> >>
> >> This is so a library can understand that it doesn't understand the
> >> current ABI.
> >
> > If user space is passing a NULL for the cap_user_data_t argument, user
> > space has a pretty good idea that its not expecting actual capabilities
> > to be filled in. My basic point is that there is no way to "correctly"
> > use the capabilities API to determine what the preferred version is.
> 
> But older kernels didn't do that.

True, but now we have the problem.


> >> The intention is for it to fail safe and not blunder on doing
> >> "security" related operations with an imperfect idea of the current
> >> kernel interface.
> >>
> >> This is how libcap figures out it can work with the hosting kernel:
> >
> > capget(0x20080522, 0, NULL)             = -1 EFAULT (Bad address)
> 
> I'm not sure what this is supposed to do. This system call takes two
> arguments and none of them work as your above snippet suggests.

This is from running "strace /usr/sbin/getcap libcap.h". I think strace is 
splitting arg 1 into its 2 elements within the structure for display purposes. 
You can strace it yourself and see. :)


> SYSCALL_DEFINE2(capget, cap_user_header_t, header, cap_user_data_t,
>  dataptr) 165 {
>  166         int ret = 0;
>  167         pid_t pid;
>  168         unsigned tocopy;
>  169         kernel_cap_t pE, pI, pP;
>  170
>  171         ret = cap_validate_magic(header, &tocopy);
>  172         if (ret != 0)
>  173                 return ret;
> 
> ie., two arguments, both of which are pointers. dataptr is not touched
> if you supply incorrect magic... The return at line 173 is taken if
> header is explored and does not contain the correct magic (ie.
> Invalid) - which it overwrites with the kernel-preferred value in the
> header, and returns EINVAL...

OK, this is the right place to make a fix. Something along the lines of:

@@ -169,8 +169,11 @@ SYSCALL_DEFINE2(capget, cap_user_header_
 	kernel_cap_t pE, pI, pP;
 
 	ret = cap_validate_magic(header, &tocopy);
-	if (ret != 0)
+	if (ret != 0) {
+		if (ret == -EINVAL && dataptr == NULL)
+			return 0;
 		return ret;
+	}
 
 	if (get_user(pid, &header->pid))
 		return -EFAULT;


> I don't see an EFAULT problem here.

It comes when get_user fails above.
 
-Steve
