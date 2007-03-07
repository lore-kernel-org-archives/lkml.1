Return-Path: <linux-kernel-owner+w=401wt.eu-S965607AbXCGUK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965607AbXCGUK7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 15:10:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965597AbXCGUK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 15:10:58 -0500
Received: from ozlabs.org ([203.10.76.45]:52526 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965607AbXCGUK5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 15:10:57 -0500
Date: Wed, 7 Mar 2007 14:10:18 -0600
From: Anton Blanchard <anton@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/12] Syslets, Threadlets, generic AIO support, v5
Message-ID: <20070307201018.GA8485@kryten>
References: <20070228213938.GA945@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070228213938.GA945@elte.hu>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Ingo,

> this is the v5 release of the syslet/threadlet subsystem:
> 
>    http://redhat.com/~mingo/syslet-patches/

Nice!

I tried to port this to ppc64 but found a few problems:

The 64bit powerpc ABI has the concept of a TOC (r2) which is used for
per function data. This means this wont work:

        if (ah->restore_stack) {
                set_task_stack_reg(new_task, ah->restore_stack);
                task_ip_reg(new_task) = ah->restore_ip;
                /*
                 * The return code 0 is needed to tell the
                 * head user-context that the threadlet went async:
                 */
                task_ret_reg(new_task) = 0;
        }

I think we would want to change restore_ip to restore_function, and then
create a per arch helper, perhaps:

void set_user_context(struct task_struct *task, unsigned long stack,
		      unsigned long function, unsigned long retval);

ppc64 could then grab the ip and r2 values from the function descriptor.

The other issue involves the syscall table:

asmlinkage struct syslet_uatom __user *
sys_async_exec(struct syslet_uatom __user *uatom,
               struct async_head_user __user *ahu)
{
        return __sys_async_exec(uatom, ahu, sys_call_table, NR_syscalls);
}

This exposes the layout of the syscall table. Unfortunately it wont work
on ppc64. In arch/powerpc/kernel/systbl.S:

#define COMPAT_SYS(func)        .llong  .sys_##func,.compat_sys_##func

Both syscall tables are overlaid.

Anton
