Return-Path: <linux-kernel-owner+w=401wt.eu-S1753348AbZBHJHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348AbZBHJHl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 04:07:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752679AbZBHJHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 04:07:15 -0500
Received: from ag-out-0708.google.com ([72.14.246.251]:42579 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706AbZBHJHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 04:07:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LF2DJPC+ASlWOVBSt3adt5D6UF4KUWAZKxKWuWN6rzsARKsdx1YNQPdK2AR2TubSL2
         kL1QNlxZM+EstzOEdahyeOb9mqYL2s+oo3bDlMBqqm452jU8NhFyG1N4rz7jFmdQAneV
         JfJeGXAq9GZEN0CRlIQSEF9zTKALL+SNARyn0=
Date: Sun, 8 Feb 2009 17:07:10 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Greg KH <gregkh@suse.de>,
       Shane Hathaway <shane@hathawaymix.org>,
       Daolong Wang <ahlongxp@gmail.com>,
       User-mode Linux Kernel Development 
	<user-mode-linux-devel@lists.sourceforge.net>,
       Jeff Dike <jdike@addtoit.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Rob Landley <rob@landley.net>, Am?rico Wang <xiyou.wangcong@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [uml-devel] [Patch] uml: fix a link error
Message-ID: <20090208090642.GA383@hack.private>
References: <200901170328.15178.rob@landley.net> <dc84318c0901172223p57872a8cr227d940b1c0a908a@mail.gmail.com> <20090119152104.GC6432@c2.user-mode-linux.org> <dc84318c0901191746g31d51c23g65da89190dc8bfd2@mail.gmail.com> <49753063.8040007@hathawaymix.org> <alpine.LRH.2.00.0902041803360.7690@vixen.sonytel.be> <Pine.LNX.4.64.0902042115530.25136@anakin> <20090204204009.GA10680@suse.de> <Pine.LNX.4.64.0902042150550.25136@anakin> <20090207125956.110591c9@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090207125956.110591c9@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I am sorry for the delay.

On Sat, Feb 07, 2009 at 12:59:56PM +0100, Heiko Carstens wrote:
>On Wed, 4 Feb 2009 21:54:12 +0100 (CET)
>Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>> I verified that Shane's solution:
>> 
>> #define sys_sigprocmask sys_kernel_sigprocmask
>> 
>> works for me, but that's definitely not the cleanest way.
>> 
>> Al Viro also had a suggestion to rework the SYSCALL_DEFINE* macros, but I
>> haven't tried it yet.
>
>
>Patch below should fix it.
>
>
>Subject: [PATCH] syscall define: fix uml compile bug
>
>From: Heiko Carstens <heiko.carstens@de.ibm.com>
>
>With the new system call defines we get this on uml:
>
>arch/um/sys-i386/built-in.o: In function `sys_call_table':
>(.rodata+0x308): undefined reference to `sys_sigprocmask'
>
>Reason for this is that uml passes the preprocessor option
>-Dsigprocmask=kernel_sigprocmask to gcc when compiling the kernel.
>This causes SYSCALL_DEFINE3(sigprocmask, ...) to be expanded to
>SYSCALL_DEFINEx(3, kernel_sigprocmask, ...) and finally to a system call
>named sys_kernel_sigprocmask. However sys_sigprocmask is missing because
>of this.


Hmmm, thanks for analysis this.

I found my mistake, I thought the Makefile invokes the 'strip' command
to do replacement, but it is not, Makefile has a built-in command named
strip. Sorry for this.

Then the problem is fully from preprocessing.


>To avoid macro expansion for the system call name just concatenate the
>name at first define instead of carrying it through severel levels.
>This was pointed out by Al Viro.
>

Yes, indeed!


>Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>


Your patch should fix this problem. But... see below.


> 	}								\
>-	SYSCALL_ALIAS(sys_##name, SyS_##name);				\
>-	static inline long SYSC_##name(__SC_DECL##x(__VA_ARGS__))
>+	SYSCALL_ALIAS(sys##name, SyS##name);				\
>+	static inline long SYSC##name(__SC_DECL##x(__VA_ARGS__))

So your final actual name for a syscall 'foo' will be 'sysfoo'
instead of 'sys_foo', right?

But we have lots of explicit calls to something like sys_foo,
won't your patch break them?


-- 
"Against stupidity, the gods themselves, contend in vain."

