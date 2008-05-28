Return-Path: <linux-kernel-owner+w=401wt.eu-S1754116AbYE1DeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbYE1DeX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 23:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750757AbYE1DeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 23:34:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54723 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750722AbYE1DeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 23:34:09 -0400
Date: Tue, 27 May 2008 20:33:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Andrew G. Morgan" <morgan@kernel.org>
Cc: Chris Wright <chrisw@sous-sol.org>, Dave Jones <davej@codemonkey.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>, bojan@rexursive.com,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Linux Security Modules List 
	<linux-security-module@vger.kernel.org>
Subject: Re: [PATCH] security: was "Re: capget() overflows buffers."
Message-Id: <20080527203312.411de6c3.akpm@linux-foundation.org>
In-Reply-To: <483B611B.6040006@kernel.org>
References: <20080522140402.GB2071@codemonkey.org.uk>
	<20080522175744.GE4018@sequoia.sous-sol.org>
	<20080522205341.GA30402@sequoia.sous-sol.org>
	<4835F929.7010200@kernel.org>
	<20080522233757.GD30402@sequoia.sous-sol.org>
	<48366D9A.70806@kernel.org>
	<20080523155718.GI30402@sequoia.sous-sol.org>
	<4837B4F5.4000100@kernel.org>
	<20080524080734.GV30402@sequoia.sous-sol.org>
	<483B611B.6040006@kernel.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 May 2008 18:17:15 -0700 "Andrew G. Morgan" <morgan@kernel.org> wrote:

> Source code out there hard-codes a notion of what the
> _LINUX_CAPABILITY_VERSION #define means in terms of the semantics of the
> raw capability system calls capget() and capset().  Its unfortunate, but
> true.
> 
> Since the confusing header file has been in a released kernel, there is
> software that is erroneously using 64-bit capabilities with the semantics
> of 32-bit compatibilities.  These recently compiled programs may suffer
> corruption of their memory when sys_getcap() overwrites more memory than
> they are coded to expect, and the raising of added capabilities when using
> sys_capset().
> 
> As such, this patch does a number of things to clean up the situation
> for all. It
> 
>   1. forces the _LINUX_CAPABILITY_VERSION define to always retain its
>      legacy value.
> 
>   2. adopts a new #define strategy for the kernel's internal
>      implementation of the preferred magic.
> 
>   3. depreciates v2 capability magic in favor of a new (v3) magic
>      number. The functionality of v3 is entirely equivalent to v2,
>      the only difference being that the v2 magic causes the kernel
>      to log a "depreciated" warning so the admin can find applications
>      that may be using v2 inappropriately.
> 
> [User space code continues to be encouraged to use the libcap API which
> protects the application from details like this.  libcap-2.10 is the first
> to support v3 capabilities.]
> 
> ...
>
> + * Version 2 capabilities worked fine, but the linux/capability.h file
> + * that accompanied their introduction encouraged their use without
> + * the necessary user-space source code changes. As such, we have
> + * created a version 3 with equivalent functionality to version 2, but
> + * with a header change to protect legacy source code from using
> + * version 2 when it wanted to use version 1. If your system has code
> + * that trips the following warning, it is using version 2 specific
> + * capabilities and may be doing so insecurely.
> + *
> + * The remedy is to either upgrade your version of libcap (to 2.10+,
> + * if the application is linked against it), or recompile your
> + * application with modern kernel headers and this warning will go
> + * away.
> + */
> +
> +static void warn_depreciated_v2(void)

"deprecated", please.  "depreciated" is where you don't want your
investments to be.

--- a/include/linux/capability.h~capabilities-remain-source-compatible-with-32-bit-raw-legacy-capability-support-fix
+++ a/include/linux/capability.h
@@ -31,7 +31,7 @@ struct task_struct;
 #define _LINUX_CAPABILITY_VERSION_1  0x19980330
 #define _LINUX_CAPABILITY_U32S_1     1
 
-#define _LINUX_CAPABILITY_VERSION_2  0x20071026  /* depreciated - use v3 */
+#define _LINUX_CAPABILITY_VERSION_2  0x20071026  /* deprecated - use v3 */
 #define _LINUX_CAPABILITY_U32S_2     2
 
 #define _LINUX_CAPABILITY_VERSION_3  0x20080522
--- a/kernel/capability.c~capabilities-remain-source-compatible-with-32-bit-raw-legacy-capability-support-fix
+++ a/kernel/capability.c
@@ -68,13 +68,13 @@ static void warn_legacy_capability_use(v
  * away.
  */
 
-static void warn_depreciated_v2(void)
+static void warn_deprecated_v2(void)
 {
 	static int warned = 0;
 	if (!warned) {
 		char name[sizeof(current->comm)];
 
-		printk(KERN_INFO "warning: `%s' uses depreciated v2"
+		printk(KERN_INFO "warning: `%s' uses deprecated v2"
 		       " capabilities in a way that may be insecure.\n",
 		       get_task_comm(name, current));
 		warned = 1;
@@ -98,7 +98,7 @@ static int cap_validate_magic(cap_user_h
 		*tocopy = _LINUX_CAPABILITY_U32S_1;
 		break;
 	case _LINUX_CAPABILITY_VERSION_2:
-		warn_depreciated_v2();
+		warn_deprecated_v2();
 		/*
 		 * fall through - v3 is otherwise equivalent to v2.
 		 */
_

> +{
> +	static int warned = 0;
> +	if (!warned) {

We were going to have a ONCE() macro to do this but that seems to have
not happened.

> +		char name[sizeof(current->comm)];
> +
> +		printk(KERN_INFO "warning: `%s' uses depreciated v2"
> +		       " capabilities in a way that may be insecure.\n",
> +		       get_task_comm(name, current));
> +		warned = 1;
> +	}
> +}
> +
> +/*
> + * Version check. Return the number of u32s in each capability flag
> + * array, or a negative value on error.
> + */
> +static int cap_validate_magic(cap_user_header_t header, unsigned *tocopy)
> +{
> +	__u32 version;
> +
> +	if (get_user(version, &header->version))
> +		return -EFAULT;
> +
> +	switch (version) {
> +	case _LINUX_CAPABILITY_VERSION_1:
> +		warn_legacy_capability_use();
> +		*tocopy = _LINUX_CAPABILITY_U32S_1;
> +		break;
> +	case _LINUX_CAPABILITY_VERSION_2:
> +		warn_depreciated_v2();
> +		/*
> +		 * fall through - v3 is otherwise equivalent to v2.
> +		 */
> +	case _LINUX_CAPABILITY_VERSION_3:
> +		*tocopy = _LINUX_CAPABILITY_U32S_3;
> +		break;
> +	default:
> +		if (put_user(_KERNEL_CAPABILITY_VERSION, &header->version))

This is a bit fragile.  It is dependent upon the compiler's view of
sizeof(_KERNEL_CAPABILITY_VERSION).

And it'll work OK for now:

#define _LINUX_CAPABILITY_VERSION_3  0x20080522
...
#define _KERNEL_CAPABILITY_VERSION _LINUX_CAPABILITY_VERSION_3

but if, for example, someone comes up and accidentally puts an "L" at
the end of that 0x20080522 then whoops, we just broke the ABI.  I think
it would be good to do something a bit more explicit there.

Perhaps:

--- a/kernel/capability.c~capabilities-remain-source-compatible-with-32-bit-raw-legacy-capability-support-fix-fix
+++ a/kernel/capability.c
@@ -106,7 +106,7 @@ static int cap_validate_magic(cap_user_h
 		*tocopy = _LINUX_CAPABILITY_U32S_3;
 		break;
 	default:
-		if (put_user(_KERNEL_CAPABILITY_VERSION, &header->version))
+		if (put_user((u32)_KERNEL_CAPABILITY_VERSION, &header->version))
 			return -EFAULT;
 		return -EINVAL;
 	}
_

?

