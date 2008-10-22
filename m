Return-Path: <linux-kernel-owner+w=401wt.eu-S1753561AbYJVIvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561AbYJVIvV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 04:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752073AbYJVIvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 04:51:13 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:48201 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752061AbYJVIvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 04:51:13 -0400
From: Andrey Mirkin <major@openvz.org>
To: devel@openvz.org, Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [Devel] Re: [PATCH 08/10] Introduce functions to restart a process
Date: Wed, 22 Oct 2008 12:49:54 +0400
User-Agent: KMail/1.8.2
Cc: Cedric Le Goater <clg@fr.ibm.com>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
References: <1224285098-573-1-git-send-email-major@openvz.org> <1224285098-573-9-git-send-email-major@openvz.org> <48FC4E0C.7050008@fr.ibm.com>
In-Reply-To: <48FC4E0C.7050008@fr.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810221249.55600.major@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 20 October 2008 13:23 Cedric Le Goater wrote:
> Hello Andrey !
>
> > diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
> > index 109792b..a4848a3 100644
> > --- a/arch/x86/kernel/entry_32.S
> > +++ b/arch/x86/kernel/entry_32.S
> > @@ -225,6 +225,7 @@ ENTRY(ret_from_fork)
> >  	GET_THREAD_INFO(%ebp)
> >  	popl %eax
> >  	CFI_ADJUST_CFA_OFFSET -4
> > +ret_from_fork_tail:
> >  	pushl $0x0202			# Reset kernel eflags
> >  	CFI_ADJUST_CFA_OFFSET 4
> >  	popfl
> > @@ -233,6 +234,26 @@ ENTRY(ret_from_fork)
> >  	CFI_ENDPROC
> >  END(ret_from_fork)
> >
> > +ENTRY(i386_ret_from_resume)
> > +	CFI_STARTPROC
> > +	pushl %eax
> > +	CFI_ADJUST_CFA_OFFSET 4
> > +	call schedule_tail
> > +	GET_THREAD_INFO(%ebp)
> > +	popl %eax
> > +	CFI_ADJUST_CFA_OFFSET -4
> > +	movl (%esp), %eax
> > +	testl %eax, %eax
> > +	jz    1f
> > +	pushl %esp
> > +	call  *%eax
> > +	addl  $4, %esp
> > +1:
> > +	addl  $256, %esp
> > +	jmp   ret_from_fork_tail
> > +	CFI_ENDPROC
> > +END(i386_ret_from_resume)
>
> Could you explain why you need to do this
>
> 	call  *%eax
>
> is it related to the freezer code ?

It is not related to the freezer code actually.
That is needed to restart syscalls. Right now I don't have a code in my 
patchset which restarts a syscall, but later I plan to add it.
In OpenVZ checkpointing we restart syscalls if process was caught in syscall 
during checkpointing.

Andrey
