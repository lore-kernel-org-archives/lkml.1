Return-Path: <linux-kernel-owner+w=401wt.eu-S1757693AbZBBRus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757693AbZBBRus (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 12:50:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753169AbZBBRui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 12:50:38 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:62546 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181AbZBBRuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 12:50:37 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Subject: Re: [git-pull -tip] fix headers_check warnings
Date: Mon, 2 Feb 2009 18:49:56 +0100
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, David Miller <davem@davemloft.net>,
       LKML <linux-kernel@vger.kernel.org>, reiserfs-devel@vger.kernel.org
References: <1233593765.3244.14.camel@localhost.localdomain>
In-Reply-To: <1233593765.3244.14.camel@localhost.localdomain>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902021849.58209.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19hotUc70r942XfAAbPtkx3E/c0qkowzz8QinG
 WVY9SYcN+S/Jof7lshKo9TlMK27X5KVyHeYbbpsPAI0IF4TSL8
 VUoJRPCZcJhZvCCsp49Sg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 February 2009, Jaswinder Singh Rajput wrote:

> @@ -6,8 +6,10 @@
>  #define ARCH_GET_FS 0x1003
>  #define ARCH_GET_GS 0x1004
>  
> -#ifdef CONFIG_X86_64
> +#ifdef __KERNEL__
> +# ifdef CONFIG_X86_64
>  extern long sys_arch_prctl(int, unsigned long);
> -#endif /* CONFIG_X86_64 */
> +# endif /* CONFIG_X86_64 */
> +#endif /* __KERNEL__ */

The prototype declares a system call and should consequently
be moved to arch/x86/include/syscalls.h, without the #ifdef.
Generally, prototypes do not need to be put into #ifdef.

> diff --git a/include/linux/coda_psdev.h b/include/linux/coda_psdev.h
> index 07ae8f8..6f06352 100644
> --- a/include/linux/coda_psdev.h
> +++ b/include/linux/coda_psdev.h
> @@ -24,7 +24,7 @@ static inline struct venus_comm *coda_vcp(struct super_block *sb)
>  	return (struct venus_comm *)((sb)->s_fs_info);
>  }
>  
> -
> +#ifdef __KERNEL__
>  /* upcalls */
>  int venus_rootfid(struct super_block *sb, struct CodaFid *fidp);
>  int venus_getattr(struct super_block *sb, struct CodaFid *fid,

The definitions preceeding this also should not get exported: struct venus_comm
and coda_vcp use kernel internal types so they cannot be part of the public
interface. kstatfs is another internal type.

> --- a/include/linux/nubus.h
> +++ b/include/linux/nubus.h
> @@ -296,6 +296,7 @@ struct nubus_dev {
>  	struct nubus_board* board;
>  };
>  
> +#ifdef __KERNEL__
>  /* This is all NuBus devices (used to find devices later on) */
>  extern struct nubus_dev* nubus_devices;
>  /* This is all NuBus cards */

struct nubus_board and struct nubus_dev are clearly kernel internal,
as they reference a proc_dir_ent.

> --- a/include/linux/reiserfs_fs.h
> +++ b/include/linux/reiserfs_fs.h

The reiserfs_fs.h file is still such a mess that I would think it's
impossible anyone actually used this from a program. Just try
gcc -xc -S -o /dev/null -I. -Wall --std=c99 linux/reiserfs_fs.h
from your usr/include directory!

It would be possible to use it to describe the on-disk data layout
to user space, but that is obviously done elsewhere already, so
I'd think the cleanest way would be to #ifdef __KERNEL__ everything
except for the REISERFS_IOC_ definitions  (but not REISERFS_IOC32).
Even that can be argued is pointless because these ioctl numbers are
now generic across file systems.

>  
> +#ifdef __KERNEL__
>  /* used to keep track of ordered and tail writes, attached to the buffer
>   * head through b_journal_head.
>   */
> @@ -2203,4 +2210,5 @@ int reiserfs_unpack(struct inode *inode, struct file *filp);
>  /* xattr stuff */
>  #define REISERFS_XATTR_DIR_SEM(s) (REISERFS_SB(s)->xattr_dir_sem)
>  
> +#endif /* __KERNEL__ */
>  #endif				/* _LINUX_REISER_FS_H */

Here you accidentally removed the ioctl definitions from reiserfs.h,
removing the only reason we were exporting it in the first place.

> diff --git a/include/linux/socket.h b/include/linux/socket.h
> index 20fc4bb..afc0190 100644
> --- a/include/linux/socket.h
> +++ b/include/linux/socket.h
> @@ -24,10 +24,12 @@ struct __kernel_sockaddr_storage {
>  #include <linux/types.h>		/* pid_t			*/
>  #include <linux/compiler.h>		/* __user			*/
>  
> -#ifdef CONFIG_PROC_FS
> +#ifdef __KERNEL__
> +# ifdef CONFIG_PROC_FS
>  struct seq_file;
>  extern void socket_seq_show(struct seq_file *seq);
> -#endif
> +# endif
> +#endif /* __KERNEL__ */
>  

You can drop the #ifdef CONFIG_PROC_FS here, the prototype does not hurt.

	Arnd <><
