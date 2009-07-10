Return-Path: <linux-kernel-owner+w=401wt.eu-S1752500AbZGJFQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbZGJFQd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 01:16:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750885AbZGJFQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 01:16:26 -0400
Received: from mail-px0-f193.google.com ([209.85.216.193]:48874 "EHLO
	mail-px0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbZGJFQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 01:16:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QROPsfcDY0O1uqBRjq1QiOUHE7JOrLdxJRv9g8MACCDJMwXsjkOWNGVuyl10f2U3Bq
         B22/kggdI1x6x0XOCWEnhC4IXkZR9ZulM5JSRfgco2U01UEiNubFrG+LJE/gjFRiNrmM
         gdsVR6aDPmRxpVAXD9vLu6xgSgPjUIiiZ8TsM=
Date: Fri, 10 Jul 2009 13:18:31 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Geoffrey Thomas <geofft@MIT.EDU>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Return ENOEXEC, not ENOENT, if a binary's or script's
	interpreter doesn't exist.
Message-ID: <20090710051831.GD5694@cr0.nay.redhat.com>
References: <1247125700-12630-1-git-send-email-geofft@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247125700-12630-1-git-send-email-geofft@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 09, 2009 at 03:48:20AM -0400, Geoffrey Thomas wrote:
>If you try to execute a binary compiled for ld-linux.so.1 (libc5) on a machine
>with only ld-linux.so.2 (libc6), your shell will claim "mybinary: No such file
>or directory", even though the binary exists. The ENOENT actually applies to
>the ELF intepreter, not to the file itself. The same happens if you have a
>nonexistent interpreter in a shell script's shebang line.
>
>Give a more helpful and more expected error, "cannot execute binary file", in
>these cases.
>
>Signed-off-by: Geoffrey Thomas <geofft@mit.edu>
>Tested-by: Anders Kaseorg <andersk@mit.edu>

Well, this is arguable... ENOEXEC and ENOENT are hard to choose here,
but *personally* I agree with you according to your description.

And according to execve(2), this change breaks that documentation. If you
really want to fix this, please also update the man page.

/me is also wondering if this change will break any user-space programs?

Thank you!

>---
> fs/binfmt_elf.c       |    5 ++++-
> fs/binfmt_elf_fdpic.c |    2 ++
> fs/binfmt_em86.c      |    8 ++++++--
> fs/binfmt_misc.c      |    5 ++++-
> fs/binfmt_script.c    |    8 ++++++--
> 5 files changed, 22 insertions(+), 6 deletions(-)
>
>diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
>index b7c1603..56954e4 100644
>--- a/fs/binfmt_elf.c
>+++ b/fs/binfmt_elf.c
>@@ -685,8 +685,11 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
> 
> 			interpreter = open_exec(elf_interpreter);
> 			retval = PTR_ERR(interpreter);
>-			if (IS_ERR(interpreter))
>+			if (IS_ERR(interpreter)) {
>+				if (retval == -ENOENT)
>+					retval = -ENOEXEC;
> 				goto out_free_interp;
>+			}
> 
> 			/*
> 			 * If the binary is not readable then enforce
>diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
>index 20fbece..604d117 100644
>--- a/fs/binfmt_elf_fdpic.c
>+++ b/fs/binfmt_elf_fdpic.c
>@@ -232,6 +232,8 @@ static int load_elf_fdpic_binary(struct linux_binprm *bprm,
> 			interpreter = open_exec(interpreter_name);
> 			retval = PTR_ERR(interpreter);
> 			if (IS_ERR(interpreter)) {
>+				if (retval == -ENOENT)
>+					retval = -ENOEXEC;
> 				interpreter = NULL;
> 				goto error;
> 			}
>diff --git a/fs/binfmt_em86.c b/fs/binfmt_em86.c
>index 32fb00b..587e0b9 100644
>--- a/fs/binfmt_em86.c
>+++ b/fs/binfmt_em86.c
>@@ -82,8 +82,12 @@ static int load_em86(struct linux_binprm *bprm,struct pt_regs *regs)
> 	 * space, and we don't need to copy it.
> 	 */
> 	file = open_exec(interp);
>-	if (IS_ERR(file))
>-		return PTR_ERR(file);
>+	if (IS_ERR(file)) {
>+		if (PTR_ERR(file) == -ENOENT)
>+			return -ENOEXEC;
>+		else
>+			return PTR_ERR(file);
>+	}
> 
> 	bprm->file = file;
> 
>diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
>index c4e8353..eecf0db 100644
>--- a/fs/binfmt_misc.c
>+++ b/fs/binfmt_misc.c
>@@ -180,8 +180,11 @@ static int load_misc_binary(struct linux_binprm *bprm, struct pt_regs *regs)
> 
> 	interp_file = open_exec (iname);
> 	retval = PTR_ERR (interp_file);
>-	if (IS_ERR (interp_file))
>+	if (IS_ERR (interp_file)) {
>+		if (retval == -ENOENT)
>+			retval = -ENOEXEC;
> 		goto _error;
>+	}
> 
> 	bprm->file = interp_file;
> 	if (fmt->flags & MISC_FMT_CREDENTIALS) {
>diff --git a/fs/binfmt_script.c b/fs/binfmt_script.c
>index 0834350..738446f 100644
>--- a/fs/binfmt_script.c
>+++ b/fs/binfmt_script.c
>@@ -88,8 +88,12 @@ static int load_script(struct linux_binprm *bprm,struct pt_regs *regs)
> 	 * OK, now restart the process with the interpreter's dentry.
> 	 */
> 	file = open_exec(interp);
>-	if (IS_ERR(file))
>-		return PTR_ERR(file);
>+	if (IS_ERR(file)) {
>+		if (PTR_ERR(file) == -ENOENT)
>+			return -ENOEXEC;
>+		else
>+			return PTR_ERR(file);
>+	}
> 
> 	bprm->file = file;
> 	retval = prepare_binprm(bprm);
>-- 
>1.5.6.5
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
