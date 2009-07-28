Return-Path: <linux-kernel-owner+w=401wt.eu-S1753560AbZG1HRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560AbZG1HRi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 03:17:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753497AbZG1HRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 03:17:38 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:35481 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018AbZG1HRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 03:17:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=O8+S1aYFior9DtdfpDlMfjYCjgfL7BfavR4LKnAfKtgCWtYjmRX8D+eSk7ZOZn8tFX
         bxtZIfbhe3gMYfEt2Ah6bs1jiQ0FJGaqS9D1ngkBfuc4FpCAjE6ESThlYuBnptVtB05V
         Tjij06rq9q3VrS/fdgOVJY2WswlgctiCRHC34=
Date: Tue, 28 Jul 2009 15:19:49 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
       Roland McGrath <roland@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] exec: fix set_binfmt() vs sys_delete_module() race
Message-ID: <20090728071949.GD6036@cr0.nay.redhat.com>
References: <20090724171943.GA10778@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090724171943.GA10778@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 24, 2009 at 07:19:43PM +0200, Oleg Nesterov wrote:
>sys_delete_module() can set MODULE_STATE_GOING after search_binary_handler()
>does try_module_get(). In this case set_binfmt()->try_module_get() fails but
>since none of the callers check the returned error, the task will run with
>the wrong old ->binfmt.
>
>The proper fix should change all ->load_binary() methods, but we can rely
>on fact that the caller must hold a reference to binfmt->module and use
>__module_get() which never fails.
>

Sounds reasonable.

Would like to put the last words as comments into code below?


>Signed-off-by: Oleg Nesterov <oleg@redhat.com>
>
>--- WAIT/include/linux/binfmts.h~SET_BINFMT	2009-05-03 17:15:27.000000000 +0200
>+++ WAIT/include/linux/binfmts.h	2009-07-24 19:02:19.000000000 +0200
>@@ -119,7 +119,7 @@ extern int bprm_mm_init(struct linux_bin
> extern int copy_strings_kernel(int argc,char ** argv,struct linux_binprm *bprm);
> extern void install_exec_creds(struct linux_binprm *bprm);
> extern void do_coredump(long signr, int exit_code, struct pt_regs *regs);
>-extern int set_binfmt(struct linux_binfmt *new);
>+extern void set_binfmt(struct linux_binfmt *new);
> extern void free_bprm(struct linux_binprm *);
> 
> #endif /* __KERNEL__ */
>--- WAIT/fs/exec.c~SET_BINFMT	2009-07-02 19:27:36.000000000 +0200
>+++ WAIT/fs/exec.c	2009-07-24 19:00:40.000000000 +0200
>@@ -1377,18 +1377,14 @@ out_ret:
> 	return retval;
> }
> 
>-int set_binfmt(struct linux_binfmt *new)
>+void set_binfmt(struct linux_binfmt *new)
> {
>-	struct linux_binfmt *old = current->binfmt;
>+	if (current->binfmt)
>+		module_put(current->binfmt->module);
> 
>-	if (new) {
>-		if (!try_module_get(new->module))
>-			return -1;
>-	}
> 	current->binfmt = new;
>-	if (old)
>-		module_put(old->module);
>-	return 0;
>+	if (new)
>+		__module_get(new->module);


I prefer to put the 'current->binfmt = new;' line as the last
statement within this function, since this is more readable for me.


> }
> 
> EXPORT_SYMBOL(set_binfmt);

