Return-Path: <linux-kernel-owner+w=401wt.eu-S1755383AbZBCOiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383AbZBCOiX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 09:38:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752166AbZBCOiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 09:38:13 -0500
Received: from hera.kernel.org ([140.211.167.34]:45566 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409AbZBCOiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 09:38:12 -0500
Subject: Re: [git-pull -tip] fix headers_check warnings
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, David Miller <davem@davemloft.net>,
       LKML <linux-kernel@vger.kernel.org>, reiserfs-devel@vger.kernel.org
In-Reply-To: <200902021849.58209.arnd@arndb.de>
References: <1233593765.3244.14.camel@localhost.localdomain>
	 <200902021849.58209.arnd@arndb.de>
Content-Type: text/plain
Date: Tue, 03 Feb 2009 20:07:08 +0530
Message-Id: <1233671828.27322.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-02 at 18:49 +0100, Arnd Bergmann wrote:
> On Monday 02 February 2009, Jaswinder Singh Rajput wrote:
> 
> > @@ -6,8 +6,10 @@
> >  #define ARCH_GET_FS 0x1003
> >  #define ARCH_GET_GS 0x1004
> >  
> > -#ifdef CONFIG_X86_64
> > +#ifdef __KERNEL__
> > +# ifdef CONFIG_X86_64
> >  extern long sys_arch_prctl(int, unsigned long);
> > -#endif /* CONFIG_X86_64 */
> > +# endif /* CONFIG_X86_64 */
> > +#endif /* __KERNEL__ */
> 
> The prototype declares a system call and should consequently
> be moved to arch/x86/include/syscalls.h, without the #ifdef.
> Generally, prototypes do not need to be put into #ifdef.
> 

This is already fixed as suggested by Peter.

> > diff --git a/include/linux/coda_psdev.h b/include/linux/coda_psdev.h
> > index 07ae8f8..6f06352 100644
> > --- a/include/linux/coda_psdev.h
> > +++ b/include/linux/coda_psdev.h
> > @@ -24,7 +24,7 @@ static inline struct venus_comm *coda_vcp(struct super_block *sb)
> >  	return (struct venus_comm *)((sb)->s_fs_info);
> >  }
> >  
> > -
> > +#ifdef __KERNEL__
> >  /* upcalls */
> >  int venus_rootfid(struct super_block *sb, struct CodaFid *fidp);
> >  int venus_getattr(struct super_block *sb, struct CodaFid *fid,
> 
> The definitions preceeding this also should not get exported: struct venus_comm
> and coda_vcp use kernel internal types so they cannot be part of the public
> interface. kstatfs is another internal type.
> 

Fixed.

> > --- a/include/linux/nubus.h
> > +++ b/include/linux/nubus.h
> > @@ -296,6 +296,7 @@ struct nubus_dev {
> >  	struct nubus_board* board;
> >  };
> >  
> > +#ifdef __KERNEL__
> >  /* This is all NuBus devices (used to find devices later on) */
> >  extern struct nubus_dev* nubus_devices;
> >  /* This is all NuBus cards */
> 
> struct nubus_board and struct nubus_dev are clearly kernel internal,
> as they reference a proc_dir_ent.
> 
> > --- a/include/linux/reiserfs_fs.h
> > +++ b/include/linux/reiserfs_fs.h
> 
> The reiserfs_fs.h file is still such a mess that I would think it's
> impossible anyone actually used this from a program. Just try
> gcc -xc -S -o /dev/null -I. -Wall --std=c99 linux/reiserfs_fs.h
> from your usr/include directory!
> 
> It would be possible to use it to describe the on-disk data layout
> to user space, but that is obviously done elsewhere already, so
> I'd think the cleanest way would be to #ifdef __KERNEL__ everything
> except for the REISERFS_IOC_ definitions  (but not REISERFS_IOC32).
> Even that can be argued is pointless because these ioctl numbers are
> now generic across file systems.
> 

Fixed.

> > diff --git a/include/linux/socket.h b/include/linux/socket.h
> > index 20fc4bb..afc0190 100644
> > --- a/include/linux/socket.h
> > +++ b/include/linux/socket.h
> > @@ -24,10 +24,12 @@ struct __kernel_sockaddr_storage {
> >  #include <linux/types.h>		/* pid_t			*/
> >  #include <linux/compiler.h>		/* __user			*/
> >  
> > -#ifdef CONFIG_PROC_FS
> > +#ifdef __KERNEL__
> > +# ifdef CONFIG_PROC_FS
> >  struct seq_file;
> >  extern void socket_seq_show(struct seq_file *seq);
> > -#endif
> > +# endif
> > +#endif /* __KERNEL__ */
> >  
> 
> You can drop the #ifdef CONFIG_PROC_FS here, the prototype does not hurt.

Even using #ifdef CONFIG_PROC_FS will not hurt, I want to stay in safe
side ;-)

Thanks,

--
JSR


