Return-Path: <linux-kernel-owner+w=401wt.eu-S1753483AbZANSEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483AbZANSEx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 13:04:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752116AbZANSEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 13:04:44 -0500
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:46768 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099AbZANSEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 13:04:43 -0500
Date: Wed, 14 Jan 2009 23:34:41 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-api@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Serge Hallyn <serue@us.ibm.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Mike Waychison <mikew@google.com>
Subject: Re: [RFC v12][PATCH 01/14] Create syscalls: sys_checkpoint,
	sys_restart
Message-ID: <20090114180441.GD21516@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <1230542187-10434-1-git-send-email-orenl@cs.columbia.edu> <1230542187-10434-2-git-send-email-orenl@cs.columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1230542187-10434-2-git-send-email-orenl@cs.columbia.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oren Laadan <orenl@cs.columbia.edu> [2008-12-29 04:16:14]:

> Create trivial sys_checkpoint and sys_restore system calls. They will
> enable to checkpoint and restart an entire container, to and from a
> checkpoint image file descriptor.
> 
> The syscalls take a file descriptor (for the image file) and flags as
> arguments. For sys_checkpoint the first argument identifies the target
> container; for sys_restart it will identify the checkpoint image.
> 
> A checkpoint, much like a process coredump, dumps the state of multiple
> processes at once, including the state of the container. The checkpoint
> image is written to (and read from) the file descriptor directly from
> the kernel. This way the data is generated and then pushed out naturally
> as resources and tasks are scanned to save their state. This is the
> approach taken by, e.g., Zap and OpenVZ.
> 
> By using a return value and not a file descriptor, we can distinguish
> between a return from checkpoint, a return from restart (in case of a
> checkpoint that includes self, i.e. a task checkpointing its own
> container, or itself), and an error condition, in a manner analogous
> to a fork() call.
> 
> We don't use copyin()/copyout() because it requires holding the entire

              ^^^^^^^^^^^^^^^^^^^ Do you mean get_user_pages(),
copy_to/from_user()?

> image in user space, and does not make sense for restart.  Also, we
> don't use a pipe, pseudo-fs file and the like, because they work by
> generating data on demand as the user pulls it (unless the entire
> image is buffered in the kernel) and would require more complex logic.
> They also would significantly complicate checkpoint that includes self.
> 
> Changelog[v5]:
>   - Config is 'def_bool n' by default
> 
> Signed-off-by: Oren Laadan <orenl@cs.columbia.edu>
> Acked-by: Serge Hallyn <serue@us.ibm.com>
> Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
> ---
>  arch/x86/include/asm/unistd_32.h   |    2 +
>  arch/x86/kernel/syscall_table_32.S |    2 +
>  checkpoint/Kconfig                 |   11 +++++++++
>  checkpoint/Makefile                |    5 ++++
>  checkpoint/sys.c                   |   41 ++++++++++++++++++++++++++++++++++++
>  include/linux/syscalls.h           |    2 +
>  init/Kconfig                       |    2 +
>  kernel/sys_ni.c                    |    4 +++
>  8 files changed, 69 insertions(+), 0 deletions(-)
>  create mode 100644 checkpoint/Kconfig
>  create mode 100644 checkpoint/Makefile
>  create mode 100644 checkpoint/sys.c
> 
> diff --git a/arch/x86/include/asm/unistd_32.h b/arch/x86/include/asm/unistd_32.h
> index f2bba78..a5f9e09 100644
> --- a/arch/x86/include/asm/unistd_32.h
> +++ b/arch/x86/include/asm/unistd_32.h
> @@ -338,6 +338,8 @@
>  #define __NR_dup3		330
>  #define __NR_pipe2		331
>  #define __NR_inotify_init1	332
> +#define __NR_checkpoint		333
                           ^^^ extra tab
> +#define __NR_restart		334

-- 
	Balbir
