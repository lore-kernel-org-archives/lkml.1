Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618Ab0BJNTW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 08:19:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6249 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868Ab0BJNTV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 08:19:21 -0500
Date: Wed, 10 Feb 2010 14:18:26 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Roland McGrath <roland@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, hjl.tools@gmail.com
Subject: Re: [patch v2 4/4] ptrace: Add support for generic
	PTRACE_GETREGSET/PTRACE_SETREGSET
Message-ID: <20100210131826.GA21196@redhat.com>
References: <20100209201309.902050211@sbs-t61.sc.intel.com> <20100209202502.406177090@sbs-t61.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100209202502.406177090@sbs-t61.sc.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09, Suresh Siddha wrote:
>
> +#define PTRACE_REGSET_BUF_SIZE(addr)	(addr & 0xfffff)
> +#define PTRACE_REGSET_TYPE(addr)	((addr >> 20) & 0xfff)
> +#define NOTE_TO_REGSET_TYPE(note)	(note & 0xfff)
>
>  /* options set using PTRACE_SETOPTIONS */
>  #define PTRACE_O_TRACESYSGOOD	0x00000001
> @@ -114,6 +126,8 @@ static inline void ptrace_unlink(struct 

Well. Personally, I like Roland's suggestion more.

How about something like the patch below?

I am not sure how should we check the size, see the comment in
ptrace_regset().

What do you think?

And, I don't understand NOTE_TO_REGSET_TYPE() logic. I mean, I don't know
why we should use "->core_note_type & 0xfff".

Oleg.


--- linux-2.6.32.2/include/linux/ptrace.h~REGSET	2009-12-18 23:27:07.000000000 +0100
+++ linux-2.6.32.2/include/linux/ptrace.h	2010-02-10 14:05:31.000000000 +0100
@@ -27,6 +27,9 @@
 #define PTRACE_GETSIGINFO	0x4202
 #define PTRACE_SETSIGINFO	0x4203
 
+#define PTRACE_GETREGSET	0x4204
+#define PTRACE_SETREGSET	0x4205
+
 /* options set using PTRACE_SETOPTIONS */
 #define PTRACE_O_TRACESYSGOOD	0x00000001
 #define PTRACE_O_TRACEFORK	0x00000002
--- linux-2.6.32.2/kernel/ptrace.c~REGSET	2009-12-18 23:27:07.000000000 +0100
+++ linux-2.6.32.2/kernel/ptrace.c	2010-02-10 14:08:12.000000000 +0100
@@ -22,7 +22,7 @@
 #include <linux/pid_namespace.h>
 #include <linux/syscalls.h>
 #include <linux/uaccess.h>
-
+#include <linux/regset.h>
 
 /*
  * ptrace a task: make the debugger its new parent and
@@ -397,6 +397,50 @@ int ptrace_writedata(struct task_struct 
 	return copied;
 }
 
+static const struct user_regset *
+find_regset(const struct user_regset_view *view, unsigned int type)
+{
+	const struct user_regset *regset;
+	int n;
+
+	for (n = 0; n < view->n; ++n) {
+		regset = view->regsets + n;
+		if (regset->core_note_type == type)
+			return regset;
+	}
+
+	return NULL;
+}
+
+static int ptrace_regset(struct task_struct *task, int req, unsigned int type,
+			struct iovec *uiov)
+{
+	const struct user_regset_view *view = task_user_regset_view(task);
+	const struct user_regset *regset = find_regset(view, type);
+	struct iovec kiov;
+
+	if (!regset)
+		return -EIO;
+
+	if (copy_from_user(&kiov, uiov, sizeof kiov))
+		return -EFAULT;
+
+	// I am not sure. Afaics it is OK to pass the
+	// size which is less than n * size. If iov_len
+	// is bigger, we can silently truncate it, or
+	// even write the correct value back.
+
+	if (kiov.iov_len != regset->n * regset->size)
+		return -EINVAL;
+
+	if (req == PTRACE_GETREGSET)
+		return copy_regset_to_user(task, view, type, 0,
+					kiov.iov_len, kiov.iov_base);
+	else
+		return copy_regset_from_user(task, view, type, 0,
+					kiov.iov_len, kiov.iov_base);
+}
+
 static int ptrace_setoptions(struct task_struct *child, long data)
 {
 	child->ptrace &= ~PT_TRACE_MASK;
@@ -525,6 +569,10 @@ int ptrace_request(struct task_struct *c
 	case PTRACE_POKEDATA:
 		return generic_ptrace_pokedata(child, addr, data);
 
+	case PTRACE_GETREGSET:
+	case PTRACE_SETREGSET:
+		return ptrace_regset(child, request, addr, (void*)data);
+
 #ifdef PTRACE_OLDSETOPTIONS
 	case PTRACE_OLDSETOPTIONS:
 #endif

