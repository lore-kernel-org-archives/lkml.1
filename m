Return-Path: <linux-kernel-owner+w=401wt.eu-S1760032AbYEXADB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760032AbYEXADB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 20:03:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752862AbYEXACx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 20:02:53 -0400
Received: from twinlark.arctic.org ([208.69.40.136]:45098 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681AbYEXACv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 20:02:51 -0400
Message-ID: <48375B10.10003@kernel.org>
Date: Fri, 23 May 2008 17:02:24 -0700
From: "Andrew G. Morgan" <morgan@kernel.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
CC: Dave Jones <davej@codemonkey.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>, bojan@rexursive.com,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Security Modules List 
	<linux-security-module@vger.kernel.org>
Subject: Re: capget() overflows buffers.
References: <20080522140402.GB2071@codemonkey.org.uk> <20080522175744.GE4018@sequoia.sous-sol.org> <20080522205341.GA30402@sequoia.sous-sol.org> <4835F929.7010200@kernel.org> <20080522233757.GD30402@sequoia.sous-sol.org> <48366D9A.70806@kernel.org> <20080523182602.GO30402@sequoia.sous-sol.org>
In-Reply-To: <20080523182602.GO30402@sequoia.sous-sol.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Chris Wright wrote:
| * Andrew G. Morgan (morgan@kernel.org) wrote:
|> diff --git a/include/linux/capability.h b/include/linux/capability.h
|> index f4ea0dd..f88b4db 100644
|> --- a/include/linux/capability.h
|> +++ b/include/linux/capability.h
|> @@ -34,9 +34,6 @@ struct task_struct;
|>  #define _LINUX_CAPABILITY_VERSION_2  0x20071026
|>  #define _LINUX_CAPABILITY_U32S_2     2
|>
|> -#define _LINUX_CAPABILITY_VERSION    _LINUX_CAPABILITY_VERSION_2
|> -#define _LINUX_CAPABILITY_U32S       _LINUX_CAPABILITY_U32S_2
|> -
|>  typedef struct __user_cap_header_struct {
|>  	__u32 version;
|>  	int pid;
|> @@ -77,10 +74,23 @@ struct vfs_cap_data {
|>  	} data[VFS_CAP_U32];
|>  };
|>
|> -#ifdef __KERNEL__
|> +#ifndef __KERNEL__
|> +
|> +/*
|> + * Backwardly compatible definition for source code - trapped in a
|> + * 32-bit world. If you find you need this, please consider using
|> + * libcap to untrap yourself...
|> + */
|> +#define _LINUX_CAPABILITY_VERSION  _LINUX_CAPABILITY_VERSION_1
|> +#define _LINUX_CAPABILITY_U32S     _LINUX_CAPABILITY_U32S_1
|
| I'm sure you're painfully aware, but this will need some change
| to libcap as well (to let it handle 64bit caps again).

Not really.

libcap2 (the one with 64-bit capability support) continues to work fine
(it ships with its own copy of a compatible linux/capability.h, and when
I update that, I'll make the corresponding change) but the effect should
be transparent to its users:

http://www.kernel.org/pub/linux/libs/security/linux-privs/kernel-2.6/

| That's what I meant earlier by "And use another mechanism to

| signal the availability of 64bit caps."

There is and has always been a method:

~   head.version = 0;
~   getcap(&head, NULL);
~   switch (head.version) {
~   case _LINUX_...:
~      ...
~      break;
~   case _,,,,:
~      etc...
~      break;
~   default:
~      abort("no idea what to do");
~   }

| All looks good.  I think we need to issue some warnings, because
| at least Fedora 9 and openSUSE 11 are/will be 2.6.25 based.

Do any of the above answers help? (FWIW I attached the patch to the
redhat bug.)

Cheers

Andrew

|
| Something like this:
|
|
| --- a/include/linux/capability.h
| +++ b/include/linux/capability.h
| @@ -31,9 +31,13 @@ struct task_struct;
|  #define _LINUX_CAPABILITY_VERSION_1  0x19980330
|  #define _LINUX_CAPABILITY_U32S_1     1
|
| +/* v2 should be considered broken */
|  #define _LINUX_CAPABILITY_VERSION_2  0x20071026
|  #define _LINUX_CAPABILITY_U32S_2     2
|
| +#define _LINUX_CAPABILITY_VERSION_3  0x20080522
| +#define _LINUX_CAPABILITY_U32S_3     2
| +
|  typedef struct __user_cap_header_struct {
|  	__u32 version;
|  	int pid;
| @@ -86,8 +90,8 @@ struct vfs_cap_data {
|
|  #else
|
| -#define _KERNEL_CAPABILITY_VERSION _LINUX_CAPABILITY_VERSION_2
| -#define _KERNEL_CAPABILITY_U32S    _LINUX_CAPABILITY_U32S_2
| +#define _KERNEL_CAPABILITY_VERSION _LINUX_CAPABILITY_VERSION_3
| +#define _KERNEL_CAPABILITY_U32S    _LINUX_CAPABILITY_U32S_3
|
|  typedef struct kernel_cap_struct {
|  	__u32 cap[_KERNEL_CAPABILITY_U32S];
| --- a/kernel/capability.c
| +++ b/kernel/capability.c
| @@ -39,6 +39,19 @@ EXPORT_SYMBOL(__cap_init_eff_set);
|   *   http://www.kernel.org/pub/linux/libs/security/linux-privs/
|   */
|
| +static void warn_broken_capability_use(void)
| +{
| +	static int warned;
| +	if (!warned) {
| +		char name[sizeof(current->comm)];
| +
| +		printk(KERN_INFO "warning: `%s' uses a capabilities version"
| +		       " which could be broken if it is not using libcap.\n",
| +		       get_task_comm(name, current));
| +		warned = 1;
| +	}
| +}
| +
|  static void warn_legacy_capability_use(void)
|  {
|  	static int warned;
| @@ -85,8 +98,12 @@ asmlinkage long sys_capget(cap_user_head
|  		tocopy = _LINUX_CAPABILITY_U32S_1;
|  		break;
|  	case _LINUX_CAPABILITY_VERSION_2:
| +		warn_broken_capability_use();
|  		tocopy = _LINUX_CAPABILITY_U32S_2;
|  		break;
| +	case _LINUX_CAPABILITY_VERSION_3:
| +		tocopy = _LINUX_CAPABILITY_U32S_3;
| +		break;
|  	default:
|  		if (put_user(_KERNEL_CAPABILITY_VERSION, &header->version))
|  			return -EFAULT;
| @@ -257,8 +274,12 @@ asmlinkage long sys_capset(cap_user_head
|  		tocopy = _LINUX_CAPABILITY_U32S_1;
|  		break;
|  	case _LINUX_CAPABILITY_VERSION_2:
| +		warn_broken_capability_use();
|  		tocopy = _LINUX_CAPABILITY_U32S_2;
|  		break;
| +	case _LINUX_CAPABILITY_VERSION_3:
| +		tocopy = _LINUX_CAPABILITY_U32S_3;
| +		break;
|  	default:
|  		if (put_user(_KERNEL_CAPABILITY_VERSION, &header->version))
|  			return -EFAULT;
|
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQFIN1sQ+bHCR3gb8jsRAgezAJ0ZRuPNENeHTM46u/LC7IU2++yIowCguMwR
GJhKzg7F2p6PcNrKAv9i8Jg=
=Mrri
-----END PGP SIGNATURE-----
