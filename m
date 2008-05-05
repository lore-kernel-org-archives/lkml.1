Return-Path: <linux-kernel-owner+w=401wt.eu-S1758396AbYEELCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758396AbYEELCQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 07:02:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759130AbYEELBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 07:01:33 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:35299 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759104AbYEELBc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 07:01:32 -0400
Message-ID: <20080505070128.7i8vmxjq8g8go4ws@imap.linux.ibm.com>
Date: Mon,  5 May 2008 07:01:28 -0400
From: Anoop <acv@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: roland@redhat.com
Subject: ptrace PTRACE_PEEKUSER behavior
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) H3 (4.1.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The call ptrace(PTRACE_PEEKUSER, <pid>, ...) does not work as described in the
man page.

Specifically, the man page states:
PTRACE_PEEKUSER
	Reads a word at offset addr in the child's USER area, which
	holds the registers and other information about the process (see
	<linux/user.h> and <sys/user.h>). The word is returned as the
	result of the ptrace() call. Typically the offset must be word-
	aligned, though this might vary by architecture. (data is
	ignored.)

Using the PTRACE_PEEKUSER action, the "regs" component can be read, but the
values past regs are not obtained. Even the reg values are not  
retrieved from a
'user' structure, but from the 'task_struct' of the process.

linux-2.6.26-rc1/include/asm-x86/user_32.h defines struct user like this.

/* When the kernel dumps core, it starts by dumping the user struct -
this will be used by gdb to figure out where the data and stack segments
are within the file, and what virtual addresses to use. */
struct user{
	/* We start with the registers, to mimic the way that "memory" is returned
	from the ptrace(3,...) function. */
	struct user_regs_struct regs; /* Where the registers are actually stored
	*/
	/* ptrace does not yet supply these. Someday.... */ <===================
	int u_fpvalid; /* True if math co-processor being used. */
	/* for this mess. Not yet used. */
	struct user_i387_struct i387; /* Math Co-processor registers. */
	/* The rest of this junk is to help gdb figure out what goes where */
	unsigned long int u_tsize; /* Text segment size (pages). */
	unsigned long int u_dsize; /* Data segment size (pages). */
	unsigned long int u_ssize; /* Stack segment size (pages). */
	unsigned long start_code; /* Starting virtual address of text. */
	unsigned long start_stack; /* Starting virtual address of stack area.
	This is actually the bottom of the stack, the top of the stack is always
	found in the	esp register. */
	long int signal; /* Signal that caused the core dump. */
	int reserved; /* No longer used */
	struct user_pt_regs * u_ar0; /* Used by gdb to help find the values for */
	/* the registers. */
	struct user_i387_struct* u_fpstate; /* Math Co-processor pointer. */
	unsigned long magic; /* To uniquely identify a core file */
	char u_comm[32]; /* User command that was responsible */
	int u_debugreg[8];
};

Noting the comment after 'struct user_regs_struct regs', is there any specific
reason why ptrace doesn't provide the rest of the members of this  
structure? In
that case shouldn't the man pages be corrected?

- Anoop


