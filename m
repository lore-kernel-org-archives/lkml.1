Return-Path: <linux-kernel-owner+w=401wt.eu-S1755989AbYIIAH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989AbYIIAH6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 20:07:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755785AbYIIAHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 20:07:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53170 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755339AbYIIAHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 20:07:46 -0400
Date: Mon, 8 Sep 2008 17:04:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pierre Morel <pmorel@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, oleg@tv-sign.ru, roland@redhat.com,
       heicars2@linux.vnet.ibm.com, sameske@linux.vnet.ibm.com,
       schwidefsky@de.ibm.com, mingo@elte.hu, gregkh@suse.de,
       user-mode-linux-devel@lists.sourceforge.net, dave@linux.vnet.ibm.com,
       clg@fr.ibm.com, dlezcano@fr.ibm.com,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 1/1] system call notification with self_ptrace
Message-Id: <20080908170427.c8bf38f5.akpm@linux-foundation.org>
In-Reply-To: <48C51439.7000706@linux.vnet.ibm.com>
References: <48C51439.7000706@linux.vnet.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 08 Sep 2008 14:02:01 +0200
Pierre Morel <pmorel@linux.vnet.ibm.com> wrote:

> Subject: [PATCH] system call notification with self_ptrace
> 
> From: Pierre Morel <pmorel@fr.ibm.com>
> 
> 
> PTRACE SELF
> 
> This patch adds a new functionality to ptrace: system call notification to
> the current process.
> When a process requests self ptrace, with the new request PTRACE_SELF_ON:
> 
>  1.  the next system call performed by the process will not be executed
>  2.  self ptrace will be disabled for the process
>  3.  a SIGSYS signal will be sent to the process.
> 
> With an appropriate SIGSYS signal handler, the process can access its own
> data structures to
> 
>  1.  get the system call number from the siginfo structure
>  2.  get the system call arguments from the stack
>  3.  instrument the system call with other system calls
>  4.  emulate the system call with other system calls
>  5.  change the arguments of the system call
>  6.  perform the system call for good
>  7.  change the return value of the system call
>  8.  request self ptrace again before returning.
> 
> The new request PTRACE_SELF_OFF disables self ptrace.
> 

It sounds like it might be useful.

Are there any userspace tools available with which people can utilise
this new functionality?  Or plans to release them?

> arch/s390/kernel/ptrace.c     |   16 ++++++++++++++++
> arch/s390/kernel/signal.c     |    5 +++++
> arch/x86/kernel/ptrace.c      |   29 +++++++++++++++++++++++++++++
> arch/x86/kernel/signal_32.c   |    5 +++++
> arch/x86/kernel/signal_64.c   |    5 +++++

Maintainers of the other 30-odd architectures would appreciate a test
application which they can use to develop and test their ports, please.

Michael Kerrisk will no doubt be looking for manpage assistance. 
Please cc him on this material.

It would be good to get suitable testcases integrated into LTP (if LTP
has ptrace tests).

The patch title uses the term "self_ptrace", but the patch itself uses
the term "ptrace_self".  Let's get it consistent everywhere.

The patch adds a

+	u64	instrumentation;

to the task_struct but no explanation is provided as to why this was
added, why it is a 64-bit field, what its locking rules are, etc. 
Please fix this.


