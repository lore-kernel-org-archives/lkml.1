Return-Path: <linux-kernel-owner+w=401wt.eu-S1759023AbYBOSpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759023AbYBOSpR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 13:45:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755776AbYBOSpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 13:45:04 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:2979 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684AbYBOSpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 13:45:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=DuPqvRgJRvKG3TtZTwIqxqZboi7O9wMEjSssQDFWT4m7Zg2t/9rGtxzQyq3ZzxFG0Hs9KGBDr9HHTctYreIsZS51gqOkaSucCKYAavdWk6QLSC4AnpM6IbqPzSWLZULc5Nqpl07Ffwo7+8Mjfy7HPbOuyPytt2C0oeFvZUiK/YU=
Date: Fri, 15 Feb 2008 20:42:28 +0200
To: libc-alpha@sourceware.org, libc-alpha@sources.redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: Linux i386 clone(): %ebx 'frobbing' ?
Message-ID: <20080215184228.GA6687@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

In the clone(int (*fn)(void *arg), void *child_stack, ..., void *arg, ...)
Glibc library function defind in sysdeps/unix/sysv/linux/i386/:

`fn' is saved in 8(child_stack), and `arg' is stored in 12(child_stack):

	movl	STACK(%esp),%ecx
	movl	ARG(%esp),%eax		/* no negative argument counts */
	movl	%eax,12(%ecx)		<---

	/* Save the function pointer as the zeroth argument.
	   It will be popped off in the child in the ebx frobbing below.  */
	movl	FUNC(%esp),%eax
	movl	%eax,8(%ecx)		<---

But after the exectuion of `sys_clone' system call, `fn' is 
called in the child thread by the statement 'call *%ebx' as follows:

	int	$0x80
	[...]

	test	%eax,%eax
	jz	L(thread_start)

/* Parent */
L(pseudo_end):
	ret

/* Child */
L(thread_start):
	/* Note: %esi is zero.  */
	movl	%esi,%ebp	/* terminate the stack frame */
	call	*%ebx

I don't understand how the `fn' argument reached the child thread
in the %ebx register. It's said in the comment that `fn' will be
popped to child 'in the ebx frobbing below'. But what does that mean ?

Thanks in advance

-- 
Ahmed S. Darwish
Homepage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com

