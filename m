Return-Path: <linux-kernel-owner+w=401wt.eu-S1756622AbYJVKO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622AbYJVKO0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 06:14:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753334AbYJVKN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 06:13:56 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:45964 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752085AbYJVKNz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 06:13:55 -0400
From: Andrey Mirkin <major@openvz.org>
To: Louis.Rilling@kerlabs.com
Subject: Re: [Devel] Re: [PATCH 08/10] Introduce functions to restart a process
Date: Wed, 22 Oct 2008 14:12:12 +0400
User-Agent: KMail/1.8.2
Cc: devel@openvz.org, Pavel Emelyanov <xemul@openvz.org>,
       Cedric Le Goater <clg@fr.ibm.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <1224285098-573-1-git-send-email-major@openvz.org> <200810221249.55600.major@openvz.org> <20081022092502.GW15171@hawkmoon.kerlabs.com>
In-Reply-To: <20081022092502.GW15171@hawkmoon.kerlabs.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810221412.14174.major@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 October 2008 13:25 Louis Rilling wrote:
> On Wed, Oct 22, 2008 at 12:49:54PM +0400, Andrey Mirkin wrote:
> > On Monday 20 October 2008 13:23 Cedric Le Goater wrote:
> > > Hello Andrey !
> > >
> > > > diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
> > > > index 109792b..a4848a3 100644
> > > > --- a/arch/x86/kernel/entry_32.S
> > > > +++ b/arch/x86/kernel/entry_32.S
> > > > @@ -225,6 +225,7 @@ ENTRY(ret_from_fork)
> > > >  	GET_THREAD_INFO(%ebp)
> > > >  	popl %eax
> > > >  	CFI_ADJUST_CFA_OFFSET -4
> > > > +ret_from_fork_tail:
> > > >  	pushl $0x0202			# Reset kernel eflags
> > > >  	CFI_ADJUST_CFA_OFFSET 4
> > > >  	popfl
> > > > @@ -233,6 +234,26 @@ ENTRY(ret_from_fork)
> > > >  	CFI_ENDPROC
> > > >  END(ret_from_fork)
> > > >
> > > > +ENTRY(i386_ret_from_resume)
> > > > +	CFI_STARTPROC
> > > > +	pushl %eax
> > > > +	CFI_ADJUST_CFA_OFFSET 4
> > > > +	call schedule_tail
> > > > +	GET_THREAD_INFO(%ebp)
> > > > +	popl %eax
> > > > +	CFI_ADJUST_CFA_OFFSET -4
> > > > +	movl (%esp), %eax
> > > > +	testl %eax, %eax
> > > > +	jz    1f
> > > > +	pushl %esp
> > > > +	call  *%eax
> > > > +	addl  $4, %esp
> > > > +1:
> > > > +	addl  $256, %esp
> > > > +	jmp   ret_from_fork_tail
> > > > +	CFI_ENDPROC
> > > > +END(i386_ret_from_resume)
> > >
> > > Could you explain why you need to do this
> > >
> > > 	call  *%eax
> > >
> > > is it related to the freezer code ?
> >
> > It is not related to the freezer code actually.
> > That is needed to restart syscalls. Right now I don't have a code in my
> > patchset which restarts a syscall, but later I plan to add it.
> > In OpenVZ checkpointing we restart syscalls if process was caught in
> > syscall during checkpointing.
>
> Do you checkpoint uninterruptible syscalls as well? If only interruptible
> syscalls are checkpointed, I'd say that either this syscall uses
> ERESTARTSYS or ERESTART_RESTARTBLOCK, and then signal handling code already
> does the trick, or this syscall does not restart itself when interrupted,
> and well, this is life, userspace just sees -EINTR, which is allowed by the
> syscall spec.
> Actually this is how we checkpoint/migrate tasks in interruptible syscalls
> in Kerrighed and this works.

We checkpoint only interruptible syscalls. Some syscalls do not restart 
themself, that is why after restarting a process we restart syscall to 
complete it.

Andrey
