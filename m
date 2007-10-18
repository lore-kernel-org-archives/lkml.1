Return-Path: <linux-kernel-owner+w=401wt.eu-S1763235AbXJRQud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763235AbXJRQud (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 12:50:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756991AbXJRQuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 12:50:25 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:41324 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836AbXJRQuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 12:50:24 -0400
Date: Thu, 18 Oct 2007 09:49:56 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Deepak Gaur" <dgaur@cdotd.ernet.in>
Cc: linux-kernel@vger.kernel.org
Subject: Re: post_coreinitcall and module_init() in tty_io.c linux kernel
 2.6.10
Message-Id: <20071018094956.fc05dc14.randy.dunlap@oracle.com>
In-Reply-To: <20071018101047.M27270@cdotd.ernet.in>
References: <20071018095424.M580@cdotd.ernet.in>
	<20071018101047.M27270@cdotd.ernet.in>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Oct 2007 16:41:06 +0630 Deepak Gaur wrote:

> Hi all,
> 
> I am novice in field of linux device drivers. I have a small question regarding module
> _init() call in file drivers/char/tty_io.c. In this file there are two init calls mentioned
> 
> (a) postcore_initcall(tty_class_init);
> (b) module_init(tty_init);
> 
> The postcore_initcall is defined in include/linux/init.h as
> -----------------------------------------------------------------------
> /**
>  * module_init() - driver initialization entry point
>  * @x: function to be run at kernel boot time or module insertion
>  *
>  * module_init() will either be called during do_initcalls (if
>  * builtin) or at module insertion time (if a module).  There can only
>  * be one per module.
>  */
> #define module_init(x)  __initcall(x);
> 
> /**
>  * module_exit() - driver exit entry point
>  * @x: function to be run when driver is removed
>  *
>  * module_exit() will wrap the driver clean-up code
>  * with cleanup_module() when used with rmmod when
>  * the driver is a module.  If the driver is statically
>  * compiled into the kernel, module_exit() has no effect.
>  * There can only be one per module.
>  */
> #define module_exit(x)  __exitcall(x);
> 
> #else /* MODULE */
> 
> /* Don't use these in modules, but some people do... */
> #define core_initcall(fn)               module_init(fn)
> #define postcore_initcall(fn)           module_init(fn)
> #define arch_initcall(fn)               module_init(fn)
> #define subsys_initcall(fn)             module_init(fn)
> #define fs_initcall(fn)                 module_init(fn)
> #define device_initcall(fn)             module_init(fn)
> #define late_initcall(fn)               module_init(fn)
> 
> ---------------------------------------------------------
> 
> It's written in quoted text that "There can only be one per module". But in tty_io.c
> there are two; postcore_initcall also maps to module_init. Each call is using different
> init functions and both functions seems to be required to be executed for proper
> functioning of module.

First, note that tty_io.c cannot be built as a loadable module;
it is always built into the kernel build image (see
drivers/char/Makefile).

The quoted text really means "There can only be one module_init()
per loadable module."  It does not apply to code that is built into
the kernel image proper.  In fact, I count 105 source files that
contain >= 2 initcalls.


> So my query is
> 
> (1) Which one of the two (postcore_initcall/module_init) get executed and when?

For code that is built into the kernel (i.e., not loadable modules),
the order of initcalls in defined in include/linux/init.h:

 * This only exists for built-in code, not for modules.
 */
#define pure_initcall(fn)		__define_initcall("0",fn,0)

#define core_initcall(fn)		__define_initcall("1",fn,1)
#define core_initcall_sync(fn)		__define_initcall("1s",fn,1s)
#define postcore_initcall(fn)		__define_initcall("2",fn,2)
#define postcore_initcall_sync(fn)	__define_initcall("2s",fn,2s)
#define arch_initcall(fn)		__define_initcall("3",fn,3)
#define arch_initcall_sync(fn)		__define_initcall("3s",fn,3s)
#define subsys_initcall(fn)		__define_initcall("4",fn,4)
#define subsys_initcall_sync(fn)	__define_initcall("4s",fn,4s)
#define fs_initcall(fn)			__define_initcall("5",fn,5)
#define fs_initcall_sync(fn)		__define_initcall("5s",fn,5s)
#define rootfs_initcall(fn)		__define_initcall("rootfs",fn,rootfs)
#define device_initcall(fn)		__define_initcall("6",fn,6)
#define device_initcall_sync(fn)	__define_initcall("6s",fn,6s)
#define late_initcall(fn)		__define_initcall("7",fn,7)
#define late_initcall_sync(fn)		__define_initcall("7s",fn,7s)


> (2) If both get executed does it not break the rule that a kernel module should have
> only one module_init() and one module_exit()?

That rule applies to loadable modules only.  They can have only
one entry/init point (and zero or one exit point :).

---
~Randy
