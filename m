Return-Path: <linux-kernel-owner+w=401wt.eu-S1755136AbYJWJzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136AbYJWJzi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 05:55:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751873AbYJWJza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 05:55:30 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:31334 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275AbYJWJza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 05:55:30 -0400
From: Andrey Mirkin <major@openvz.org>
To: Cedric Le Goater <clg@fr.ibm.com>
Subject: Re: [Devel] Re: [PATCH 08/10] Introduce functions to restart a process
Date: Thu, 23 Oct 2008 13:54:45 +0400
User-Agent: KMail/1.8.2
Cc: devel@openvz.org, Pavel Emelyanov <xemul@openvz.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <1224285098-573-1-git-send-email-major@openvz.org> <200810221249.55600.major@openvz.org> <48FF20F6.1040505@fr.ibm.com>
In-Reply-To: <48FF20F6.1040505@fr.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810231354.47033.major@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 October 2008 16:47 Cedric Le Goater wrote:
> >>> +ENTRY(i386_ret_from_resume)
> >>> +	CFI_STARTPROC
> >>> +	pushl %eax
> >>> +	CFI_ADJUST_CFA_OFFSET 4
> >>> +	call schedule_tail
> >>> +	GET_THREAD_INFO(%ebp)
> >>> +	popl %eax
> >>> +	CFI_ADJUST_CFA_OFFSET -4
> >>> +	movl (%esp), %eax
> >>> +	testl %eax, %eax
> >>> +	jz    1f
> >>> +	pushl %esp
> >>> +	call  *%eax
> >>> +	addl  $4, %esp
> >>> +1:
> >>> +	addl  $256, %esp
> >>> +	jmp   ret_from_fork_tail
> >>> +	CFI_ENDPROC
> >>> +END(i386_ret_from_resume)
> >>
> >> Could you explain why you need to do this
> >>
> >> 	call  *%eax
> >>
> >> is it related to the freezer code ?
> >
> > It is not related to the freezer code actually.
> > That is needed to restart syscalls. Right now I don't have a code in my
> > patchset which restarts a syscall, but later I plan to add it.
> > In OpenVZ checkpointing we restart syscalls if process was caught in
> > syscall during checkpointing.
>
> ok. I get it now. why 256 bytes of extra stack ? I'm sure it's not random.
We are putting special structure on stack, which is used at the very end of 
the whole restart procedure to restore complex states (ptrace is one of such 
cases). Right now I don't need to use this structure as we have a deal with 
simple cases, but reservation of 256 bytes on stack is needed for future.

Andrey
