Return-Path: <linux-kernel-owner+w=401wt.eu-S1751687AbZIJPJH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751687AbZIJPJH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 11:09:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751502AbZIJPJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 11:09:06 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:60595 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbZIJPJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 11:09:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Subject: Re: [RFC][v6][PATCH 8/9]: Define clone_with_pids() syscall
Date: Thu, 10 Sep 2009 09:31:25 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-9-generic; KDE/4.3.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Oren Laadan <orenl@cs.columbia.edu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       torvalds@linux-foundation.org, mikew@google.com, mingo@elte.hu,
       hpa@zytor.com, Nathan Lynch <nathanl@austin.ibm.com>,
       Containers <containers@lists.linux-foundation.org>, sukadev@us.ibm.com
References: <20090910060627.GA24343@us.ibm.com> <20090910061301.GG25883@us.ibm.com>
In-Reply-To: <20090910061301.GG25883@us.ibm.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909100931.25585.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/ALZciqBNVA9Fa674M8L08U5BItLvQwsf+YZt
 0B3aJ3gWib2HcfJr/Xg3aYvshW5GtTHkpFgrv02OF23W/vaojj
 CpLr9mj+sQMNsQAA2vaPA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 September 2009, Sukadev Bhattiprolu wrote:
> 
> +int sys_clone_with_pids(struct pt_regs *regs)
> +{
> +       unsigned long clone_flags;
> +       unsigned long newsp;
> +       int __user *parent_tidptr;
> +       int __user *child_tidptr;
> +       struct pid_set __user *upid_setp;
> +
> +       clone_flags = regs->bx;
> +       newsp = regs->cx;
> +       parent_tidptr = (int __user *)regs->dx;
> +       child_tidptr = (int __user *)regs->di;
> +       upid_setp = (struct pid_set __user *)regs->bp;
> +
> +       if (!newsp)
> +               newsp = regs->sp;
> +
> +       return do_fork_with_pids(clone_flags, newsp, regs, 0, parent_tidptr,
> +                       child_tidptr, upid_setp);
> +}

I wonder if we can avoid spreading copies of this function across
all architectures.

Would it be possible to define it like this?

asmlinkage long
clone_with_pids(int flags, unsigned long child_stack_base, int __user *parent_tid_ptr,
                       int __user *child_tid_ptr, struct pid_set __user *pid_setp)
{
	if (!child_stack_base) {
		struct pt_regs *regs;

		regs = task_pt_regs(current);
		child_stack_base = user_stack_pointer(regs);
	}

	return do_fork_with_pids(clone_flags, child_stack_base, 0,
		parent_tid_ptr, child_tid_ptr, pid_setp);
}

	Arnd <><

