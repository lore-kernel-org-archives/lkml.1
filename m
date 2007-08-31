Return-Path: <linux-kernel-owner+w=401wt.eu-S1759526AbXHaPxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759526AbXHaPxs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 11:53:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757451AbXHaPxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 11:53:41 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49777 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757391AbXHaPxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 11:53:40 -0400
Date: Fri, 31 Aug 2007 21:36:45 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bugme-daemon@kernel-bugs.osdl.org
Subject: Re: [Bugme-new] [Bug 8957] New: Exported functions and variables
In-Reply-To: <469780.175.qm@web52012.mail.re2.yahoo.com>
Message-ID: <alpine.LFD.0.999.0708312126040.9261@enigma.security.iitk.ac.in>
References: <469780.175.qm@web52012.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matti,


On Thu, 30 Aug 2007, Matti Linnanvuori wrote:
> 
> I thought I had seen that bug. Module init function execution does not
> seem serialized enough, so the init function of one module seems to be
> able to be called in parallel with several other modules in turn being
> loaded, executing their init functions and even becoming live first
> class citizens.
> Function sys_init_module in
> Linux 2.6.22.x and 2.6.23-rc4 kernel/module.c does not hold module_mutex
> when executing the init functions of the modules.

Sure, there's nothing to prevent one module's module_init() from being
concurrently executed with the module_init() of another -- but that's OK.
Anyway, I tested this out with:

Module A
========

/***** mod_a.c *****/
#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/delay.h>
#include <linux/module.h>
#include <linux/spinlock.h>

static spinlock_t mylock;

static void mod_a_func(void)
{
        spin_lock(&mylock);
        printk(KERN_INFO "inside mod_a_func\n");
        spin_unlock(&mylock);
}
EXPORT_SYMBOL(mod_a_func);

static int __init mod_a_init(void)
{
        printk(KERN_INFO "module_init begin ...");
        ssleep(10);
        spin_lock_init(&mylock);
        printk(KERN_INFO "... module_init done\n");
        return 0;
}

static void __exit mod_a_exit(void)
{
        printk(KERN_INFO "exiting\n");
}

module_init(mod_a_init);
module_exit(mod_a_exit);
MODULE_LICENSE("GPL");
/***** mod_a.c *****/

Module B
========

/***** mod_b.c *****/
#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/module.h>

extern void mod_a_func(void);

static int __init mod_b_init(void)
{
        mod_a_func();
        return 0;
}

static void __exit mod_b_exit(void)
{
}

module_init(mod_b_init);
module_exit(mod_b_exit);
MODULE_LICENSE("GPL");
/***** mod_b.c *****/

Test result:
============

Module B refuses to load (could not resolve the symbol mod_a_func) unless
the module_init() of Module A has finished completely. The following log
was obtained by running "insmod ./mod_b.ko" repeatedly on one xterm, while
another xterm was then used to do "insmod ./mod_a.ko":

mod_b: Unknown symbol mod_a_func
mod_b: Unknown symbol mod_a_func
module_init begin ...<4>mod_b: Unknown symbol mod_a_func
mod_b: Unknown symbol mod_a_func
last message repeated 4 times
... module_init done
inside mod_a_func


So the title of your bug report "Exported functions and variables should
not be reachable by the outside of the module until module_init finishes"
sounds to be already true to me, so let us know if bugzilla #8957 can be
closed or not ;-)


Thanks,

Satyam
