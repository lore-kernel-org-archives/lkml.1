Return-Path: <linux-kernel-owner+w=401wt.eu-S1755560AbYEELzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560AbYEELzv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 07:55:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751379AbYEELzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 07:55:42 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:36722 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbYEELzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 07:55:41 -0400
To: Anoop <acv@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, roland@redhat.com,
       mtk.manpages@googlemail.com
Subject: Re: ptrace PTRACE_PEEKUSER behavior
From: Andi Kleen <andi@firstfloor.org>
References: <20080505070128.7i8vmxjq8g8go4ws@imap.linux.ibm.com>
Date: Mon, 05 May 2008 13:55:12 +0200
In-Reply-To: <20080505070128.7i8vmxjq8g8go4ws@imap.linux.ibm.com> (acv@linux.vnet.ibm.com's message of "Mon,  5 May 2008 07:01:28 -0400")
Message-ID: <87hcddc6e7.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 05 May 2008 11:48:16.0764 (UTC) FILETIME=[E82513C0:01C8AEA5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anoop <acv@linux.vnet.ibm.com> writes:

[intentional fullquote]

> The call ptrace(PTRACE_PEEKUSER, <pid>, ...) does not work as described in the
> man page.
>
> Specifically, the man page states:
> PTRACE_PEEKUSER
> 	Reads a word at offset addr in the child's USER area, which
> 	holds the registers and other information about the process (see
> 	<linux/user.h> and <sys/user.h>). The word is returned as the
> 	result of the ptrace() call. Typically the offset must be word-
> 	aligned, though this might vary by architecture. (data is
> 	ignored.)
>
> Using the PTRACE_PEEKUSER action, the "regs" component can be read, but the
> values past regs are not obtained. Even the reg values are not  
> retrieved from a
> 'user' structure, but from the 'task_struct' of the process.
>
> linux-2.6.26-rc1/include/asm-x86/user_32.h defines struct user like this.

[..]
>
> /* When the kernel dumps core, it starts by dumping the user struct -

[..]
> 	*/
> 	/* ptrace does not yet supply these. Someday.... */ <===================
> 	/* for this mess. Not yet used. */
> 	struct user_i387_struct i387; /* Math Co-processor registers. */
> 	/* The rest of this junk is to help gdb figure out what goes where */
> 	unsigned long int u_tsize; /* Text segment size (pages). */
> 	unsigned long int u_dsize; /* Data segment size (pages). */
> 	unsigned long int u_ssize; /* Stack segment size (pages). */
> 	unsigned long start_code; /* Starting virtual address of text. */
> 	unsigned long start_stack; /* Starting virtual address of stack area.
> 	This is actually the bottom of the stack, the top of the stack is always
> 	found in the	esp register. */
> 	long int signal; /* Signal that caused the core dump. */
> 	int reserved; /* No longer used */
> 	struct user_pt_regs * u_ar0; /* Used by gdb to help find the values for */
> 	/* the registers. */
> 	struct user_i387_struct* u_fpstate; /* Math Co-processor pointer. */
> 	unsigned long magic; /* To uniquely identify a core file */
> 	char u_comm[32]; /* User command that was responsible */
> 	int u_debugreg[8];
> };
>
> Noting the comment after 'struct user_regs_struct regs', is there any specific
> reason why ptrace doesn't provide the rest of the members of this  
> structure?

Since Linux internally has no "struct user" all of this has to be
implemented by special case code (in particularly a big switch statement)
While that could be done if nobody uses it (and that seems
to be the case) it would be just a waste of code.

> In
> that case shouldn't the man pages be corrected?

Probably. cc mtk.

-Andi
