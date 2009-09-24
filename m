Return-Path: <linux-kernel-owner+w=401wt.eu-S1752470AbZIXVr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470AbZIXVr3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 17:47:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752379AbZIXVr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 17:47:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:49584 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334AbZIXVr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 17:47:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Subject: Re: [RFC][v7][PATCH 8/9]: Define clone2() syscall
Date: Thu, 24 Sep 2009 23:43:59 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-10-generic; KDE/4.3.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Oren Laadan <orenl@cs.columbia.edu>,
       serue@us.ibm.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       torvalds@linux-foundation.org, mikew@google.com, mingo@elte.hu,
       hpa@zytor.com, Nathan Lynch <nathanl@austin.ibm.com>,
       peterz@infradead.org,
       Containers <containers@lists.linux-foundation.org>, sukadev@us.ibm.com
References: <20090924165548.GA16586@us.ibm.com> <20090924170308.GH16989@us.ibm.com>
In-Reply-To: <20090924170308.GH16989@us.ibm.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909242343.59903.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19dZDiNQRO+YjEfE7SFpGsPRXwBSXVTL4jEHQL
 ftENG58ZZscrgLJwyL2FBIAQMcgg9N4UVo91HDaA/+zZr4vpCF
 wd5VlJD1MnzCOVfUTo+Eg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 September 2009, Sukadev Bhattiprolu wrote:
> +asmlinkage long
> +sys_clone2(struct clone_struct __user *ucs, pid_t __user *pids)
> +{
> +       int rc;
> +       struct clone_struct kcs;
> +       unsigned long clone_flags;
> +       int __user *parent_tid_ptr;
> +       int __user *child_tid_ptr;
> +       unsigned long __user child_stack_base;
> +       struct pt_regs *regs;
> +
> +       rc = copy_from_user(&ucs, &kcs, sizeof(kcs));
> +       if (rc)
> +               return -EFAULT;
> +
> +       /*
> +        * TODO: Convert clone_flags to 64-bit
> +        */
> +       clone_flags = (unsigned long)kcs.flags;
> +       child_stack_base = (unsigned long)kcs.child_stack;
> +       parent_tid_ptr = &ucs.parent_tid;
> +       child_tid_ptr =  &ucs.child_tid;
> +       regs = task_pt_regs(current);
> +
> +       if (!child_stack_base)
> +               child_stack_base = user_stack_pointer(regs);
> +
> +       return do_fork_with_pids(clone_flags, child_stack_base, regs, 0,
> +                       parent_tid_ptr, child_tid_ptr, kcs.nr_pids, pids);
> +}
> +

The function looks ok, but you have put it into arch/x86/kernel/process_32.c,
which is specific to x86-32. Since the code in this form is generic, why
not just put it into kernel/fork.c? You should probably enclose it within
#ifdef CONFIG_HAVE_ARCH_TRACEHOOK to make sure that user_stack_pointer()
is implemented, but then it would be immediately usable by the nine architectures
implementing that. The other architectures can then decide between adding
their private version of sys_clone2 with an open-coded user_stack_pointer
implementation or alternatively implement the tracehooks.

	Arnd <><
