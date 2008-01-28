Return-Path: <linux-kernel-owner+w=401wt.eu-S1760266AbYA1Wzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760266AbYA1Wzq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 17:55:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752937AbYA1Wzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 17:55:36 -0500
Received: from py-out-1112.google.com ([64.233.166.180]:19386 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840AbYA1Wza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 17:55:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OgBD6mFT1W52ch+ftrJp2W8pQCYXe7/Am+JcdR6m0lofo5mhF+OwFl/qsncetIcMN2dglj6idsA6LTJmKHiBQm38N7PyWhHnK6qpasmsop4G3EoFstVLYPjq0hEqUMz4+jA1/HSmAreXQthtiemwbF1geg0KhP3t35WsIlLGulY=
Message-ID: <524f69650801281455o4bec839dkcbb47be0b1ba8ccb@mail.gmail.com>
Date: Mon, 28 Jan 2008 16:55:26 -0600
From: "Steve French" <smfrench@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [2.6 patch] remove smbfs
Cc: sfrench@samba.org, samba-technical@lists.samba.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080128220835.GF8767@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080128220835.GF8767@does.not.exist>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That is fine with me since CIFS Kerberos support has made progress
(although Simo and Jeff are still doing more testing on this before
the EXPERIMENTAL config flag on this will go off).

On Jan 28, 2008 4:08 PM, Adrian Bunk <bunk@kernel.org> wrote:
> I remember that there were some small things missing in CIFS for
> completely replacing the unmaintained smbfs when we discussed removing
> smbfs back in 2005 due to smbfs being unmaintained.
>
> CIFS has improved since, smbfs is still unmaintained, and it's becoming
> time to finally remove smbfs.
>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
>
> ---
>
>  Documentation/filesystems/00-INDEX  |    2
>  Documentation/filesystems/cifs.txt  |    4
>  Documentation/filesystems/smbfs.txt |    8
>  fs/Kconfig                          |   56
>  fs/Makefile                         |    1
>  fs/compat.c                         |   32
>  fs/compat_ioctl.c                   |   24
>  fs/smbfs/Makefile                   |   38
>  fs/smbfs/cache.c                    |  209 -
>  fs/smbfs/dir.c                      |  702 -----
>  fs/smbfs/file.c                     |  445 ---
>  fs/smbfs/getopt.c                   |   64
>  fs/smbfs/getopt.h                   |   14
>  fs/smbfs/inode.c                    |  828 ------
>  fs/smbfs/ioctl.c                    |   67
>  fs/smbfs/proc.c                     | 3508 ----------------------------
>  fs/smbfs/proto.h                    |   87
>  fs/smbfs/request.c                  |  818 ------
>  fs/smbfs/request.h                  |   70
>  fs/smbfs/smb_debug.h                |   34
>  fs/smbfs/smbiod.c                   |  345 --
>  fs/smbfs/sock.c                     |  387 ---
>  fs/smbfs/symlink.c                  |   68
>  include/linux/Kbuild                |    4
>  include/linux/smb.h                 |  115
>  include/linux/smb_fs.h              |  158 -
>  include/linux/smb_fs_i.h            |   39
>  include/linux/smb_fs_sb.h           |  101
>  include/linux/smb_mount.h           |   65
>  include/linux/smbno.h               |  363 --
>  30 files changed, 2 insertions(+), 8654 deletions(-)
>
> f2ce9309065099de922ed4eb5a61b4c045d69856
> diff --git a/Documentation/filesystems/00-INDEX b/Documentation/filesystems/00-INDEX
> index 1de155e..c98481c 100644
> --- a/Documentation/filesystems/00-INDEX
> +++ b/Documentation/filesystems/00-INDEX
> @@ -80,8 +80,6 @@ relay.txt
>         - info on relay, for efficient streaming from kernel to user space.
>  romfs.txt
>         - description of the ROMFS filesystem.
> -smbfs.txt
> -       - info on using filesystems with the SMB protocol (Win 3.11 and NT).
>  spufs.txt
>         - info and mount options for the SPU filesystem used on Cell.
>  sysfs-pci.txt
> diff --git a/Documentation/filesystems/cifs.txt b/Documentation/filesystems/cifs.txt
> index 49cc923..723d924 100644
> --- a/Documentation/filesystems/cifs.txt
> +++ b/Documentation/filesystems/cifs.txt
> @@ -6,9 +6,7 @@
>    Windows XP) as well by Samba (which provides excellent CIFS
>    server support for Linux and many other operating systems), so
>    this network filesystem client can mount to a wide variety of
> -  servers.  The smbfs module should be used instead of this cifs module
> -  for mounting to older SMB servers such as OS/2.  The smbfs and cifs
> -  modules can coexist and do not conflict.  The CIFS VFS filesystem
> +  servers.  The CIFS VFS filesystem
>    module is designed to work well with servers that implement the
>    newer versions (dialects) of the SMB/CIFS protocol such as Samba,
>    the program written by Andrew Tridgell that turns any Unix host
> diff --git a/Documentation/filesystems/smbfs.txt b/Documentation/filesystems/smbfs.txt
> deleted file mode 100644
> index f673ef0..0000000
> --- a/Documentation/filesystems/smbfs.txt
> +++ /dev/null
> @@ -1,8 +0,0 @@
> -Smbfs is a filesystem that implements the SMB protocol, which is the
> -protocol used by Windows for Workgroups, Windows 95 and Windows NT.
> -Smbfs was inspired by Samba, the program written by Andrew Tridgell
> -that turns any Unix host into a file server for DOS or Windows clients.
> -
> -Smbfs is a SMB client, but uses parts of samba for it's operation. For
> -more info on samba, including documentation, please go to
> -http://www.samba.org/ and then on to your nearest mirror.
> diff --git a/fs/Kconfig b/fs/Kconfig
> index 487236c..f319303 100644
> --- a/fs/Kconfig
> +++ b/fs/Kconfig
> @@ -1837,62 +1837,6 @@ config RPCSEC_GSS_SPKM3
>
>           If unsure, say N.
>
> -config SMB_FS
> -       tristate "SMB file system support (to mount Windows shares etc.)"
> -       depends on INET
> -       select NLS
> -       help
> -         SMB (Server Message Block) is the protocol Windows for Workgroups
> -         (WfW), Windows 95/98, Windows NT and OS/2 Lan Manager use to share
> -         files and printers over local networks.  Saying Y here allows you to
> -         mount their file systems (often called "shares" in this context) and
> -         access them just like any other Unix directory.  Currently, this
> -         works only if the Windows machines use TCP/IP as the underlying
> -         transport protocol, and not NetBEUI.  For details, read
> -         <file:Documentation/filesystems/smbfs.txt> and the SMB-HOWTO,
> -         available from <http://www.tldp.org/docs.html#howto>.
> -
> -         Note: if you just want your box to act as an SMB *server* and make
> -         files and printing services available to Windows clients (which need
> -         to have a TCP/IP stack), you don't need to say Y here; you can use
> -         the program SAMBA (available from <ftp://ftp.samba.org/pub/samba/>)
> -         for that.
> -
> -         General information about how to connect Linux, Windows machines and
> -         Macs is on the WWW at <http://www.eats.com/linux_mac_win.html>.
> -
> -         To compile the SMB support as a module, choose M here: the module will
> -         be called smbfs.  Most people say N, however.
> -
> -config SMB_NLS_DEFAULT
> -       bool "Use a default NLS"
> -       depends on SMB_FS
> -       help
> -         Enabling this will make smbfs use nls translations by default. You
> -         need to specify the local charset (CONFIG_NLS_DEFAULT) in the nls
> -         settings and you need to give the default nls for the SMB server as
> -         CONFIG_SMB_NLS_REMOTE.
> -
> -         The nls settings can be changed at mount time, if your smbmount
> -         supports that, using the codepage and iocharset parameters.
> -
> -         smbmount from samba 2.2.0 or later supports this.
> -
> -config SMB_NLS_REMOTE
> -       string "Default Remote NLS Option"
> -       depends on SMB_NLS_DEFAULT
> -       default "cp437"
> -       help
> -         This setting allows you to specify a default value for which
> -         codepage the server uses. If this field is left blank no
> -         translations will be done by default. The local codepage/charset
> -         default to CONFIG_NLS_DEFAULT.
> -
> -         The nls settings can be changed at mount time, if your smbmount
> -         supports that, using the codepage and iocharset parameters.
> -
> -         smbmount from samba 2.2.0 or later supports this.
> -
>  config CIFS
>         tristate "CIFS support (advanced network filesystem for Samba, Window and other CIFS compliant servers)"
>         depends on INET
> diff --git a/fs/Makefile b/fs/Makefile
> index 500cf15..59d9217 100644
> --- a/fs/Makefile
> +++ b/fs/Makefile
> @@ -91,7 +91,6 @@ obj-$(CONFIG_NFSD)            += nfsd/
>  obj-$(CONFIG_LOCKD)            += lockd/
>  obj-$(CONFIG_NLS)              += nls/
>  obj-$(CONFIG_SYSV_FS)          += sysv/
> -obj-$(CONFIG_SMB_FS)           += smbfs/
>  obj-$(CONFIG_CIFS)             += cifs/
>  obj-$(CONFIG_NCP_FS)           += ncpfs/
>  obj-$(CONFIG_HPFS_FS)          += hpfs/
> diff --git a/fs/compat.c b/fs/compat.c
> index 15078ce..eeed54a 100644
> --- a/fs/compat.c
> +++ b/fs/compat.c
> @@ -27,8 +27,6 @@
>  #include <linux/vfs.h>
>  #include <linux/ioctl.h>
>  #include <linux/init.h>
> -#include <linux/smb.h>
> -#include <linux/smb_mount.h>
>  #include <linux/ncp_mount.h>
>  #include <linux/nfs4_mount.h>
>  #include <linux/smp_lock.h>
> @@ -616,31 +614,6 @@ static void *do_ncp_super_data_conv(void *raw_data)
>         return raw_data;
>  }
>
> -struct compat_smb_mount_data {
> -       compat_int_t version;
> -       __compat_uid_t mounted_uid;
> -       __compat_uid_t uid;
> -       __compat_gid_t gid;
> -       compat_mode_t file_mode;
> -       compat_mode_t dir_mode;
> -};
> -
> -static void *do_smb_super_data_conv(void *raw_data)
> -{
> -       struct smb_mount_data *s = raw_data;
> -       struct compat_smb_mount_data *c_s = raw_data;
> -
> -       if (c_s->version != SMB_MOUNT_OLDVERSION)
> -               goto out;
> -       s->dir_mode = c_s->dir_mode;
> -       s->file_mode = c_s->file_mode;
> -       s->gid = c_s->gid;
> -       s->uid = c_s->uid;
> -       s->mounted_uid = c_s->mounted_uid;
> - out:
> -       return raw_data;
> -}
> -
>  struct compat_nfs_string {
>         compat_uint_t len;
>         compat_uptr_t data;
> @@ -709,7 +682,6 @@ static int do_nfs4_super_data_conv(void *raw_data)
>         return 0;
>  }
>
> -#define SMBFS_NAME      "smbfs"
>  #define NCPFS_NAME      "ncpfs"
>  #define NFS4_NAME      "nfs4"
>
> @@ -743,9 +715,7 @@ asmlinkage long compat_sys_mount(char __user * dev_name, char __user * dir_name,
>         retval = -EINVAL;
>
>         if (type_page && data_page) {
> -               if (!strcmp((char *)type_page, SMBFS_NAME)) {
> -                       do_smb_super_data_conv((void *)data_page);
> -               } else if (!strcmp((char *)type_page, NCPFS_NAME)) {
> +               if (!strcmp((char *)type_page, NCPFS_NAME)) {
>                         do_ncp_super_data_conv((void *)data_page);
>                 } else if (!strcmp((char *)type_page, NFS4_NAME)) {
>                         if (do_nfs4_super_data_conv((void *) data_page))
> diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
> index da8cb3b..4b74453 100644
> --- a/fs/compat_ioctl.c
> +++ b/fs/compat_ioctl.c
> @@ -46,7 +46,6 @@
>  #include <linux/videodev.h>
>  #include <linux/netdevice.h>
>  #include <linux/raw.h>
> -#include <linux/smb_fs.h>
>  #include <linux/blkdev.h>
>  #include <linux/elevator.h>
>  #include <linux/rtc.h>
> @@ -1194,24 +1193,6 @@ static int do_unimap_ioctl(unsigned int fd, unsigned int cmd, unsigned long arg,
>
>  #endif /* CONFIG_VT */
>
> -static int do_smb_getmountuid(unsigned int fd, unsigned int cmd, unsigned long arg)
> -{
> -       mm_segment_t old_fs = get_fs();
> -       __kernel_uid_t kuid;
> -       int err;
> -
> -       cmd = SMB_IOC_GETMOUNTUID;
> -
> -       set_fs(KERNEL_DS);
> -       err = sys_ioctl(fd, cmd, (unsigned long)&kuid);
> -       set_fs(old_fs);
> -
> -       if (err >= 0)
> -               err = put_user(kuid, (compat_uid_t __user *)compat_ptr(arg));
> -
> -       return err;
> -}
> -
>  struct atmif_sioc32 {
>          compat_int_t   number;
>          compat_int_t   length;
> @@ -2390,8 +2371,6 @@ COMPATIBLE_IOCTL(AUTOFS_IOC_ASKUMOUNT)
>  /* Raw devices */
>  COMPATIBLE_IOCTL(RAW_SETBIND)
>  COMPATIBLE_IOCTL(RAW_GETBIND)
> -/* SMB ioctls which do not need any translations */
> -COMPATIBLE_IOCTL(SMB_IOC_NEWCONN)
>  /* Little a */
>  COMPATIBLE_IOCTL(ATMSIGD_CTRL)
>  COMPATIBLE_IOCTL(ATMARPD_CTRL)
> @@ -2729,9 +2708,6 @@ HANDLE_IOCTL(PIO_UNIMAP, do_unimap_ioctl)
>  HANDLE_IOCTL(GIO_UNIMAP, do_unimap_ioctl)
>  HANDLE_IOCTL(KDFONTOP, do_kdfontop_ioctl)
>  #endif
> -/* One SMB ioctl needs translations. */
> -#define SMB_IOC_GETMOUNTUID_32 _IOR('u', 1, compat_uid_t)
> -HANDLE_IOCTL(SMB_IOC_GETMOUNTUID_32, do_smb_getmountuid)
>  HANDLE_IOCTL(ATM_GETLINKRATE32, do_atm_ioctl)
>  HANDLE_IOCTL(ATM_GETNAMES32, do_atm_ioctl)
>  HANDLE_IOCTL(ATM_GETTYPE32, do_atm_ioctl)
> diff --git a/fs/smbfs/Makefile b/fs/smbfs/Makefile
> deleted file mode 100644
> index 6673ee8..0000000
> --- a/fs/smbfs/Makefile
> +++ /dev/null
> @@ -1,38 +0,0 @@
> -#
> -# Makefile for the linux smb-filesystem routines.
> -#
> -
> -obj-$(CONFIG_SMB_FS) += smbfs.o
> -
> -smbfs-objs := proc.o dir.o cache.o sock.o inode.o file.o ioctl.o getopt.o \
> -               symlink.o smbiod.o request.o
> -
> -# If you want debugging output, you may add these flags to the EXTRA_CFLAGS
> -# SMBFS_PARANOIA should normally be enabled.
> -
> -EXTRA_CFLAGS += -DSMBFS_PARANOIA
> -#EXTRA_CFLAGS += -DSMBFS_DEBUG
> -#EXTRA_CFLAGS += -DSMBFS_DEBUG_VERBOSE
> -#EXTRA_CFLAGS += -DDEBUG_SMB_TIMESTAMP
> -#EXTRA_CFLAGS += -Werror
> -
> -#
> -# Maintainer rules
> -#
> -
> -# getopt.c not included. It is intentionally separate
> -SRC = proc.c dir.c cache.c sock.c inode.c file.c ioctl.c smbiod.c request.c \
> -       symlink.c
> -
> -proto:
> -       -rm -f proto.h
> -       @echo >  proto2.h "/*"
> -       @echo >> proto2.h " *  Autogenerated with cproto on: " `date`
> -       @echo >> proto2.h " */"
> -       @echo >> proto2.h ""
> -       @echo >> proto2.h "struct smb_request;"
> -       @echo >> proto2.h "struct sock;"
> -       @echo >> proto2.h "struct statfs;"
> -       @echo >> proto2.h ""
> -       cproto -E "gcc -E" -e -v -I $(TOPDIR)/include -DMAKING_PROTO -D__KERNEL__ $(SRC) >> proto2.h
> -       mv proto2.h proto.h
> diff --git a/fs/smbfs/cache.c b/fs/smbfs/cache.c
> deleted file mode 100644
> index 8182f05..0000000
> --- a/fs/smbfs/cache.c
> +++ /dev/null
> @@ -1,209 +0,0 @@
> -/*
> - *  cache.c
> - *
> - * Copyright (C) 1997 by Bill Hawes
> - *
> - * Routines to support directory cacheing using the page cache.
> - * This cache code is almost directly taken from ncpfs.
> - *
> - * Please add a note about your changes to smbfs in the ChangeLog file.
> - */
> -
> -#include <linux/time.h>
> -#include <linux/errno.h>
> -#include <linux/kernel.h>
> -#include <linux/mm.h>
> -#include <linux/dirent.h>
> -#include <linux/smb_fs.h>
> -#include <linux/pagemap.h>
> -#include <linux/net.h>
> -
> -#include <asm/page.h>
> -
> -#include "smb_debug.h"
> -#include "proto.h"
> -
> -/*
> - * Force the next attempt to use the cache to be a timeout.
> - * If we can't find the page that's fine, it will cause a refresh.
> - */
> -void
> -smb_invalid_dir_cache(struct inode * dir)
> -{
> -       struct smb_sb_info *server = server_from_inode(dir);
> -       union  smb_dir_cache *cache = NULL;
> -       struct page *page = NULL;
> -
> -       page = grab_cache_page(&dir->i_data, 0);
> -       if (!page)
> -               goto out;
> -
> -       if (!PageUptodate(page))
> -               goto out_unlock;
> -
> -       cache = kmap(page);
> -       cache->head.time = jiffies - SMB_MAX_AGE(server);
> -
> -       kunmap(page);
> -       SetPageUptodate(page);
> -out_unlock:
> -       unlock_page(page);
> -       page_cache_release(page);
> -out:
> -       return;
> -}
> -
> -/*
> - * Mark all dentries for 'parent' as invalid, forcing them to be re-read
> - */
> -void
> -smb_invalidate_dircache_entries(struct dentry *parent)
> -{
> -       struct smb_sb_info *server = server_from_dentry(parent);
> -       struct list_head *next;
> -       struct dentry *dentry;
> -
> -       spin_lock(&dcache_lock);
> -       next = parent->d_subdirs.next;
> -       while (next != &parent->d_subdirs) {
> -               dentry = list_entry(next, struct dentry, d_u.d_child);
> -               dentry->d_fsdata = NULL;
> -               smb_age_dentry(server, dentry);
> -               next = next->next;
> -       }
> -       spin_unlock(&dcache_lock);
> -}
> -
> -/*
> - * dget, but require that fpos and parent matches what the dentry contains.
> - * dentry is not known to be a valid pointer at entry.
> - */
> -struct dentry *
> -smb_dget_fpos(struct dentry *dentry, struct dentry *parent, unsigned long fpos)
> -{
> -       struct dentry *dent = dentry;
> -       struct list_head *next;
> -
> -       if (d_validate(dent, parent)) {
> -               if (dent->d_name.len <= SMB_MAXNAMELEN &&
> -                   (unsigned long)dent->d_fsdata == fpos) {
> -                       if (!dent->d_inode) {
> -                               dput(dent);
> -                               dent = NULL;
> -                       }
> -                       return dent;
> -               }
> -               dput(dent);
> -       }
> -
> -       /* If a pointer is invalid, we search the dentry. */
> -       spin_lock(&dcache_lock);
> -       next = parent->d_subdirs.next;
> -       while (next != &parent->d_subdirs) {
> -               dent = list_entry(next, struct dentry, d_u.d_child);
> -               if ((unsigned long)dent->d_fsdata == fpos) {
> -                       if (dent->d_inode)
> -                               dget_locked(dent);
> -                       else
> -                               dent = NULL;
> -                       goto out_unlock;
> -               }
> -               next = next->next;
> -       }
> -       dent = NULL;
> -out_unlock:
> -       spin_unlock(&dcache_lock);
> -       return dent;
> -}
> -
> -
> -/*
> - * Create dentry/inode for this file and add it to the dircache.
> - */
> -int
> -smb_fill_cache(struct file *filp, void *dirent, filldir_t filldir,
> -              struct smb_cache_control *ctrl, struct qstr *qname,
> -              struct smb_fattr *entry)
> -{
> -       struct dentry *newdent, *dentry = filp->f_path.dentry;
> -       struct inode *newino, *inode = dentry->d_inode;
> -       struct smb_cache_control ctl = *ctrl;
> -       int valid = 0;
> -       int hashed = 0;
> -       ino_t ino = 0;
> -
> -       qname->hash = full_name_hash(qname->name, qname->len);
> -
> -       if (dentry->d_op && dentry->d_op->d_hash)
> -               if (dentry->d_op->d_hash(dentry, qname) != 0)
> -                       goto end_advance;
> -
> -       newdent = d_lookup(dentry, qname);
> -
> -       if (!newdent) {
> -               newdent = d_alloc(dentry, qname);
> -               if (!newdent)
> -                       goto end_advance;
> -       } else {
> -               hashed = 1;
> -               memcpy((char *) newdent->d_name.name, qname->name,
> -                      newdent->d_name.len);
> -       }
> -
> -       if (!newdent->d_inode) {
> -               smb_renew_times(newdent);
> -               entry->f_ino = iunique(inode->i_sb, 2);
> -               newino = smb_iget(inode->i_sb, entry);
> -               if (newino) {
> -                       smb_new_dentry(newdent);
> -                       d_instantiate(newdent, newino);
> -                       if (!hashed)
> -                               d_rehash(newdent);
> -               }
> -       } else
> -               smb_set_inode_attr(newdent->d_inode, entry);
> -
> -        if (newdent->d_inode) {
> -               ino = newdent->d_inode->i_ino;
> -               newdent->d_fsdata = (void *) ctl.fpos;
> -               smb_new_dentry(newdent);
> -       }
> -
> -       if (ctl.idx >= SMB_DIRCACHE_SIZE) {
> -               if (ctl.page) {
> -                       kunmap(ctl.page);
> -                       SetPageUptodate(ctl.page);
> -                       unlock_page(ctl.page);
> -                       page_cache_release(ctl.page);
> -               }
> -               ctl.cache = NULL;
> -               ctl.idx  -= SMB_DIRCACHE_SIZE;
> -               ctl.ofs  += 1;
> -               ctl.page  = grab_cache_page(&inode->i_data, ctl.ofs);
> -               if (ctl.page)
> -                       ctl.cache = kmap(ctl.page);
> -       }
> -       if (ctl.cache) {
> -               ctl.cache->dentry[ctl.idx] = newdent;
> -               valid = 1;
> -       }
> -       dput(newdent);
> -
> -end_advance:
> -       if (!valid)
> -               ctl.valid = 0;
> -       if (!ctl.filled && (ctl.fpos == filp->f_pos)) {
> -               if (!ino)
> -                       ino = find_inode_number(dentry, qname);
> -               if (!ino)
> -                       ino = iunique(inode->i_sb, 2);
> -               ctl.filled = filldir(dirent, qname->name, qname->len,
> -                                    filp->f_pos, ino, DT_UNKNOWN);
> -               if (!ctl.filled)
> -                       filp->f_pos += 1;
> -       }
> -       ctl.fpos += 1;
> -       ctl.idx  += 1;
> -       *ctrl = ctl;
> -       return (ctl.valid || !ctl.filled);
> -}
> diff --git a/fs/smbfs/dir.c b/fs/smbfs/dir.c
> deleted file mode 100644
> index 48da4fa..0000000
> --- a/fs/smbfs/dir.c
> +++ /dev/null
> @@ -1,702 +0,0 @@
> -/*
> - *  dir.c
> - *
> - *  Copyright (C) 1995, 1996 by Paal-Kr. Engstad and Volker Lendecke
> - *  Copyright (C) 1997 by Volker Lendecke
> - *
> - *  Please add a note about your changes to smbfs in the ChangeLog file.
> - */
> -
> -#include <linux/time.h>
> -#include <linux/errno.h>
> -#include <linux/kernel.h>
> -#include <linux/smp_lock.h>
> -#include <linux/ctype.h>
> -#include <linux/net.h>
> -#include <linux/sched.h>
> -
> -#include <linux/smb_fs.h>
> -#include <linux/smb_mount.h>
> -#include <linux/smbno.h>
> -
> -#include "smb_debug.h"
> -#include "proto.h"
> -
> -static int smb_readdir(struct file *, void *, filldir_t);
> -static int smb_dir_open(struct inode *, struct file *);
> -
> -static struct dentry *smb_lookup(struct inode *, struct dentry *, struct nameidata *);
> -static int smb_create(struct inode *, struct dentry *, int, struct nameidata *);
> -static int smb_mkdir(struct inode *, struct dentry *, int);
> -static int smb_rmdir(struct inode *, struct dentry *);
> -static int smb_unlink(struct inode *, struct dentry *);
> -static int smb_rename(struct inode *, struct dentry *,
> -                     struct inode *, struct dentry *);
> -static int smb_make_node(struct inode *,struct dentry *,int,dev_t);
> -static int smb_link(struct dentry *, struct inode *, struct dentry *);
> -
> -const struct file_operations smb_dir_operations =
> -{
> -       .read           = generic_read_dir,
> -       .readdir        = smb_readdir,
> -       .ioctl          = smb_ioctl,
> -       .open           = smb_dir_open,
> -};
> -
> -const struct inode_operations smb_dir_inode_operations =
> -{
> -       .create         = smb_create,
> -       .lookup         = smb_lookup,
> -       .unlink         = smb_unlink,
> -       .mkdir          = smb_mkdir,
> -       .rmdir          = smb_rmdir,
> -       .rename         = smb_rename,
> -       .getattr        = smb_getattr,
> -       .setattr        = smb_notify_change,
> -};
> -
> -const struct inode_operations smb_dir_inode_operations_unix =
> -{
> -       .create         = smb_create,
> -       .lookup         = smb_lookup,
> -       .unlink         = smb_unlink,
> -       .mkdir          = smb_mkdir,
> -       .rmdir          = smb_rmdir,
> -       .rename         = smb_rename,
> -       .getattr        = smb_getattr,
> -       .setattr        = smb_notify_change,
> -       .symlink        = smb_symlink,
> -       .mknod          = smb_make_node,
> -       .link           = smb_link,
> -};
> -
> -/*
> - * Read a directory, using filldir to fill the dirent memory.
> - * smb_proc_readdir does the actual reading from the smb server.
> - *
> - * The cache code is almost directly taken from ncpfs
> - */
> -static int
> -smb_readdir(struct file *filp, void *dirent, filldir_t filldir)
> -{
> -       struct dentry *dentry = filp->f_path.dentry;
> -       struct inode *dir = dentry->d_inode;
> -       struct smb_sb_info *server = server_from_dentry(dentry);
> -       union  smb_dir_cache *cache = NULL;
> -       struct smb_cache_control ctl;
> -       struct page *page = NULL;
> -       int result;
> -
> -       ctl.page  = NULL;
> -       ctl.cache = NULL;
> -
> -       VERBOSE("reading %s/%s, f_pos=%d\n",
> -               DENTRY_PATH(dentry),  (int) filp->f_pos);
> -
> -       result = 0;
> -
> -       lock_kernel();
> -
> -       switch ((unsigned int) filp->f_pos) {
> -       case 0:
> -               if (filldir(dirent, ".", 1, 0, dir->i_ino, DT_DIR) < 0)
> -                       goto out;
> -               filp->f_pos = 1;
> -               /* fallthrough */
> -       case 1:
> -               if (filldir(dirent, "..", 2, 1, parent_ino(dentry), DT_DIR) < 0)
> -                       goto out;
> -               filp->f_pos = 2;
> -       }
> -
> -       /*
> -        * Make sure our inode is up-to-date.
> -        */
> -       result = smb_revalidate_inode(dentry);
> -       if (result)
> -               goto out;
> -
> -
> -       page = grab_cache_page(&dir->i_data, 0);
> -       if (!page)
> -               goto read_really;
> -
> -       ctl.cache = cache = kmap(page);
> -       ctl.head  = cache->head;
> -
> -       if (!PageUptodate(page) || !ctl.head.eof) {
> -               VERBOSE("%s/%s, page uptodate=%d, eof=%d\n",
> -                        DENTRY_PATH(dentry), PageUptodate(page),ctl.head.eof);
> -               goto init_cache;
> -       }
> -
> -       if (filp->f_pos == 2) {
> -               if (jiffies - ctl.head.time >= SMB_MAX_AGE(server))
> -                       goto init_cache;
> -
> -               /*
> -                * N.B. ncpfs checks mtime of dentry too here, we don't.
> -                *   1. common smb servers do not update mtime on dir changes
> -                *   2. it requires an extra smb request
> -                *      (revalidate has the same timeout as ctl.head.time)
> -                *
> -                * Instead smbfs invalidates its own cache on local changes
> -                * and remote changes are not seen until timeout.
> -                */
> -       }
> -
> -       if (filp->f_pos > ctl.head.end)
> -               goto finished;
> -
> -       ctl.fpos = filp->f_pos + (SMB_DIRCACHE_START - 2);
> -       ctl.ofs  = ctl.fpos / SMB_DIRCACHE_SIZE;
> -       ctl.idx  = ctl.fpos % SMB_DIRCACHE_SIZE;
> -
> -       for (;;) {
> -               if (ctl.ofs != 0) {
> -                       ctl.page = find_lock_page(&dir->i_data, ctl.ofs);
> -                       if (!ctl.page)
> -                               goto invalid_cache;
> -                       ctl.cache = kmap(ctl.page);
> -                       if (!PageUptodate(ctl.page))
> -                               goto invalid_cache;
> -               }
> -               while (ctl.idx < SMB_DIRCACHE_SIZE) {
> -                       struct dentry *dent;
> -                       int res;
> -
> -                       dent = smb_dget_fpos(ctl.cache->dentry[ctl.idx],
> -                                            dentry, filp->f_pos);
> -                       if (!dent)
> -                               goto invalid_cache;
> -
> -                       res = filldir(dirent, dent->d_name.name,
> -                                     dent->d_name.len, filp->f_pos,
> -                                     dent->d_inode->i_ino, DT_UNKNOWN);
> -                       dput(dent);
> -                       if (res)
> -                               goto finished;
> -                       filp->f_pos += 1;
> -                       ctl.idx += 1;
> -                       if (filp->f_pos > ctl.head.end)
> -                               goto finished;
> -               }
> -               if (ctl.page) {
> -                       kunmap(ctl.page);
> -                       SetPageUptodate(ctl.page);
> -                       unlock_page(ctl.page);
> -                       page_cache_release(ctl.page);
> -                       ctl.page = NULL;
> -               }
> -               ctl.idx  = 0;
> -               ctl.ofs += 1;
> -       }
> -invalid_cache:
> -       if (ctl.page) {
> -               kunmap(ctl.page);
> -               unlock_page(ctl.page);
> -               page_cache_release(ctl.page);
> -               ctl.page = NULL;
> -       }
> -       ctl.cache = cache;
> -init_cache:
> -       smb_invalidate_dircache_entries(dentry);
> -       ctl.head.time = jiffies;
> -       ctl.head.eof = 0;
> -       ctl.fpos = 2;
> -       ctl.ofs = 0;
> -       ctl.idx = SMB_DIRCACHE_START;
> -       ctl.filled = 0;
> -       ctl.valid  = 1;
> -read_really:
> -       result = server->ops->readdir(filp, dirent, filldir, &ctl);
> -       if (result == -ERESTARTSYS && page)
> -               ClearPageUptodate(page);
> -       if (ctl.idx == -1)
> -               goto invalid_cache;     /* retry */
> -       ctl.head.end = ctl.fpos - 1;
> -       ctl.head.eof = ctl.valid;
> -finished:
> -       if (page) {
> -               cache->head = ctl.head;
> -               kunmap(page);
> -               if (result != -ERESTARTSYS)
> -                       SetPageUptodate(page);
> -               unlock_page(page);
> -               page_cache_release(page);
> -       }
> -       if (ctl.page) {
> -               kunmap(ctl.page);
> -               SetPageUptodate(ctl.page);
> -               unlock_page(ctl.page);
> -               page_cache_release(ctl.page);
> -       }
> -out:
> -       unlock_kernel();
> -       return result;
> -}
> -
> -static int
> -smb_dir_open(struct inode *dir, struct file *file)
> -{
> -       struct dentry *dentry = file->f_path.dentry;
> -       struct smb_sb_info *server;
> -       int error = 0;
> -
> -       VERBOSE("(%s/%s)\n", dentry->d_parent->d_name.name,
> -               file->f_path.dentry->d_name.name);
> -
> -       /*
> -        * Directory timestamps in the core protocol aren't updated
> -        * when a file is added, so we give them a very short TTL.
> -        */
> -       lock_kernel();
> -       server = server_from_dentry(dentry);
> -       if (server->opt.protocol < SMB_PROTOCOL_LANMAN2) {
> -               unsigned long age = jiffies - SMB_I(dir)->oldmtime;
> -               if (age > 2*HZ)
> -                       smb_invalid_dir_cache(dir);
> -       }
> -
> -       /*
> -        * Note: in order to allow the smbmount process to open the
> -        * mount point, we only revalidate if the connection is valid or
> -        * if the process is trying to access something other than the root.
> -        */
> -       if (server->state == CONN_VALID || !IS_ROOT(dentry))
> -               error = smb_revalidate_inode(dentry);
> -       unlock_kernel();
> -       return error;
> -}
> -
> -/*
> - * Dentry operations routines
> - */
> -static int smb_lookup_validate(struct dentry *, struct nameidata *);
> -static int smb_hash_dentry(struct dentry *, struct qstr *);
> -static int smb_compare_dentry(struct dentry *, struct qstr *, struct qstr *);
> -static int smb_delete_dentry(struct dentry *);
> -
> -static struct dentry_operations smbfs_dentry_operations =
> -{
> -       .d_revalidate   = smb_lookup_validate,
> -       .d_hash         = smb_hash_dentry,
> -       .d_compare      = smb_compare_dentry,
> -       .d_delete       = smb_delete_dentry,
> -};
> -
> -static struct dentry_operations smbfs_dentry_operations_case =
> -{
> -       .d_revalidate   = smb_lookup_validate,
> -       .d_delete       = smb_delete_dentry,
> -};
> -
> -
> -/*
> - * This is the callback when the dcache has a lookup hit.
> - */
> -static int
> -smb_lookup_validate(struct dentry * dentry, struct nameidata *nd)
> -{
> -       struct smb_sb_info *server = server_from_dentry(dentry);
> -       struct inode * inode = dentry->d_inode;
> -       unsigned long age = jiffies - dentry->d_time;
> -       int valid;
> -
> -       /*
> -        * The default validation is based on dentry age:
> -        * we believe in dentries for a few seconds.  (But each
> -        * successful server lookup renews the timestamp.)
> -        */
> -       valid = (age <= SMB_MAX_AGE(server));
> -#ifdef SMBFS_DEBUG_VERBOSE
> -       if (!valid)
> -               VERBOSE("%s/%s not valid, age=%lu\n",
> -                       DENTRY_PATH(dentry), age);
> -#endif
> -
> -       if (inode) {
> -               lock_kernel();
> -               if (is_bad_inode(inode)) {
> -                       PARANOIA("%s/%s has dud inode\n", DENTRY_PATH(dentry));
> -                       valid = 0;
> -               } else if (!valid)
> -                       valid = (smb_revalidate_inode(dentry) == 0);
> -               unlock_kernel();
> -       } else {
> -               /*
> -                * What should we do for negative dentries?
> -                */
> -       }
> -       return valid;
> -}
> -
> -static int
> -smb_hash_dentry(struct dentry *dir, struct qstr *this)
> -{
> -       unsigned long hash;
> -       int i;
> -
> -       hash = init_name_hash();
> -       for (i=0; i < this->len ; i++)
> -               hash = partial_name_hash(tolower(this->name[i]), hash);
> -       this->hash = end_name_hash(hash);
> -
> -       return 0;
> -}
> -
> -static int
> -smb_compare_dentry(struct dentry *dir, struct qstr *a, struct qstr *b)
> -{
> -       int i, result = 1;
> -
> -       if (a->len != b->len)
> -               goto out;
> -       for (i=0; i < a->len; i++) {
> -               if (tolower(a->name[i]) != tolower(b->name[i]))
> -                       goto out;
> -       }
> -       result = 0;
> -out:
> -       return result;
> -}
> -
> -/*
> - * This is the callback from dput() when d_count is going to 0.
> - * We use this to unhash dentries with bad inodes.
> - */
> -static int
> -smb_delete_dentry(struct dentry * dentry)
> -{
> -       if (dentry->d_inode) {
> -               if (is_bad_inode(dentry->d_inode)) {
> -                       PARANOIA("bad inode, unhashing %s/%s\n",
> -                                DENTRY_PATH(dentry));
> -                       return 1;
> -               }
> -       } else {
> -               /* N.B. Unhash negative dentries? */
> -       }
> -       return 0;
> -}
> -
> -/*
> - * Initialize a new dentry
> - */
> -void
> -smb_new_dentry(struct dentry *dentry)
> -{
> -       struct smb_sb_info *server = server_from_dentry(dentry);
> -
> -       if (server->mnt->flags & SMB_MOUNT_CASE)
> -               dentry->d_op = &smbfs_dentry_operations_case;
> -       else
> -               dentry->d_op = &smbfs_dentry_operations;
> -       dentry->d_time = jiffies;
> -}
> -
> -
> -/*
> - * Whenever a lookup succeeds, we know the parent directories
> - * are all valid, so we want to update the dentry timestamps.
> - * N.B. Move this to dcache?
> - */
> -void
> -smb_renew_times(struct dentry * dentry)
> -{
> -       dget(dentry);
> -       spin_lock(&dentry->d_lock);
> -       for (;;) {
> -               struct dentry *parent;
> -
> -               dentry->d_time = jiffies;
> -               if (IS_ROOT(dentry))
> -                       break;
> -               parent = dentry->d_parent;
> -               dget(parent);
> -               spin_unlock(&dentry->d_lock);
> -               dput(dentry);
> -               dentry = parent;
> -               spin_lock(&dentry->d_lock);
> -       }
> -       spin_unlock(&dentry->d_lock);
> -       dput(dentry);
> -}
> -
> -static struct dentry *
> -smb_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
> -{
> -       struct smb_fattr finfo;
> -       struct inode *inode;
> -       int error;
> -       struct smb_sb_info *server;
> -
> -       error = -ENAMETOOLONG;
> -       if (dentry->d_name.len > SMB_MAXNAMELEN)
> -               goto out;
> -
> -       /* Do not allow lookup of names with backslashes in */
> -       error = -EINVAL;
> -       if (memchr(dentry->d_name.name, '\\', dentry->d_name.len))
> -               goto out;
> -
> -       lock_kernel();
> -       error = smb_proc_getattr(dentry, &finfo);
> -#ifdef SMBFS_PARANOIA
> -       if (error && error != -ENOENT)
> -               PARANOIA("find %s/%s failed, error=%d\n",
> -                        DENTRY_PATH(dentry), error);
> -#endif
> -
> -       inode = NULL;
> -       if (error == -ENOENT)
> -               goto add_entry;
> -       if (!error) {
> -               error = -EACCES;
> -               finfo.f_ino = iunique(dentry->d_sb, 2);
> -               inode = smb_iget(dir->i_sb, &finfo);
> -               if (inode) {
> -       add_entry:
> -                       server = server_from_dentry(dentry);
> -                       if (server->mnt->flags & SMB_MOUNT_CASE)
> -                               dentry->d_op = &smbfs_dentry_operations_case;
> -                       else
> -                               dentry->d_op = &smbfs_dentry_operations;
> -
> -                       d_add(dentry, inode);
> -                       smb_renew_times(dentry);
> -                       error = 0;
> -               }
> -       }
> -       unlock_kernel();
> -out:
> -       return ERR_PTR(error);
> -}
> -
> -/*
> - * This code is common to all routines creating a new inode.
> - */
> -static int
> -smb_instantiate(struct dentry *dentry, __u16 fileid, int have_id)
> -{
> -       struct smb_sb_info *server = server_from_dentry(dentry);
> -       struct inode *inode;
> -       int error;
> -       struct smb_fattr fattr;
> -
> -       VERBOSE("file %s/%s, fileid=%u\n", DENTRY_PATH(dentry), fileid);
> -
> -       error = smb_proc_getattr(dentry, &fattr);
> -       if (error)
> -               goto out_close;
> -
> -       smb_renew_times(dentry);
> -       fattr.f_ino = iunique(dentry->d_sb, 2);
> -       inode = smb_iget(dentry->d_sb, &fattr);
> -       if (!inode)
> -               goto out_no_inode;
> -
> -       if (have_id) {
> -               struct smb_inode_info *ei = SMB_I(inode);
> -               ei->fileid = fileid;
> -               ei->access = SMB_O_RDWR;
> -               ei->open = server->generation;
> -       }
> -       d_instantiate(dentry, inode);
> -out:
> -       return error;
> -
> -out_no_inode:
> -       error = -EACCES;
> -out_close:
> -       if (have_id) {
> -               PARANOIA("%s/%s failed, error=%d, closing %u\n",
> -                        DENTRY_PATH(dentry), error, fileid);
> -               smb_close_fileid(dentry, fileid);
> -       }
> -       goto out;
> -}
> -
> -/* N.B. How should the mode argument be used? */
> -static int
> -smb_create(struct inode *dir, struct dentry *dentry, int mode,
> -               struct nameidata *nd)
> -{
> -       struct smb_sb_info *server = server_from_dentry(dentry);
> -       __u16 fileid;
> -       int error;
> -       struct iattr attr;
> -
> -       VERBOSE("creating %s/%s, mode=%d\n", DENTRY_PATH(dentry), mode);
> -
> -       lock_kernel();
> -       smb_invalid_dir_cache(dir);
> -       error = smb_proc_create(dentry, 0, get_seconds(), &fileid);
> -       if (!error) {
> -               if (server->opt.capabilities & SMB_CAP_UNIX) {
> -                       /* Set attributes for new file */
> -                       attr.ia_valid = ATTR_MODE;
> -                       attr.ia_mode = mode;
> -                       error = smb_proc_setattr_unix(dentry, &attr, 0, 0);
> -               }
> -               error = smb_instantiate(dentry, fileid, 1);
> -       } else {
> -               PARANOIA("%s/%s failed, error=%d\n",
> -                        DENTRY_PATH(dentry), error);
> -       }
> -       unlock_kernel();
> -       return error;
> -}
> -
> -/* N.B. How should the mode argument be used? */
> -static int
> -smb_mkdir(struct inode *dir, struct dentry *dentry, int mode)
> -{
> -       struct smb_sb_info *server = server_from_dentry(dentry);
> -       int error;
> -       struct iattr attr;
> -
> -       lock_kernel();
> -       smb_invalid_dir_cache(dir);
> -       error = smb_proc_mkdir(dentry);
> -       if (!error) {
> -               if (server->opt.capabilities & SMB_CAP_UNIX) {
> -                       /* Set attributes for new directory */
> -                       attr.ia_valid = ATTR_MODE;
> -                       attr.ia_mode = mode;
> -                       error = smb_proc_setattr_unix(dentry, &attr, 0, 0);
> -               }
> -               error = smb_instantiate(dentry, 0, 0);
> -       }
> -       unlock_kernel();
> -       return error;
> -}
> -
> -static int
> -smb_rmdir(struct inode *dir, struct dentry *dentry)
> -{
> -       struct inode *inode = dentry->d_inode;
> -       int error;
> -
> -       /*
> -        * Close the directory if it's open.
> -        */
> -       lock_kernel();
> -       smb_close(inode);
> -
> -       /*
> -        * Check that nobody else is using the directory..
> -        */
> -       error = -EBUSY;
> -       if (!d_unhashed(dentry))
> -               goto out;
> -
> -       smb_invalid_dir_cache(dir);
> -       error = smb_proc_rmdir(dentry);
> -
> -out:
> -       unlock_kernel();
> -       return error;
> -}
> -
> -static int
> -smb_unlink(struct inode *dir, struct dentry *dentry)
> -{
> -       int error;
> -
> -       /*
> -        * Close the file if it's open.
> -        */
> -       lock_kernel();
> -       smb_close(dentry->d_inode);
> -
> -       smb_invalid_dir_cache(dir);
> -       error = smb_proc_unlink(dentry);
> -       if (!error)
> -               smb_renew_times(dentry);
> -       unlock_kernel();
> -       return error;
> -}
> -
> -static int
> -smb_rename(struct inode *old_dir, struct dentry *old_dentry,
> -          struct inode *new_dir, struct dentry *new_dentry)
> -{
> -       int error;
> -
> -       /*
> -        * Close any open files, and check whether to delete the
> -        * target before attempting the rename.
> -        */
> -       lock_kernel();
> -       if (old_dentry->d_inode)
> -               smb_close(old_dentry->d_inode);
> -       if (new_dentry->d_inode) {
> -               smb_close(new_dentry->d_inode);
> -               error = smb_proc_unlink(new_dentry);
> -               if (error) {
> -                       VERBOSE("unlink %s/%s, error=%d\n",
> -                               DENTRY_PATH(new_dentry), error);
> -                       goto out;
> -               }
> -               /* FIXME */
> -               d_delete(new_dentry);
> -       }
> -
> -       smb_invalid_dir_cache(old_dir);
> -       smb_invalid_dir_cache(new_dir);
> -       error = smb_proc_mv(old_dentry, new_dentry);
> -       if (!error) {
> -               smb_renew_times(old_dentry);
> -               smb_renew_times(new_dentry);
> -       }
> -out:
> -       unlock_kernel();
> -       return error;
> -}
> -
> -/*
> - * FIXME: samba servers won't let you create device nodes unless uid/gid
> - * matches the connection credentials (and we don't know which those are ...)
> - */
> -static int
> -smb_make_node(struct inode *dir, struct dentry *dentry, int mode, dev_t dev)
> -{
> -       int error;
> -       struct iattr attr;
> -
> -       attr.ia_valid = ATTR_MODE | ATTR_UID | ATTR_GID;
> -       attr.ia_mode = mode;
> -       attr.ia_uid = current->euid;
> -       attr.ia_gid = current->egid;
> -
> -       if (!new_valid_dev(dev))
> -               return -EINVAL;
> -
> -       smb_invalid_dir_cache(dir);
> -       error = smb_proc_setattr_unix(dentry, &attr, MAJOR(dev), MINOR(dev));
> -       if (!error) {
> -               error = smb_instantiate(dentry, 0, 0);
> -       }
> -       return error;
> -}
> -
> -/*
> - * dentry = existing file
> - * new_dentry = new file
> - */
> -static int
> -smb_link(struct dentry *dentry, struct inode *dir, struct dentry *new_dentry)
> -{
> -       int error;
> -
> -       DEBUG1("smb_link old=%s/%s new=%s/%s\n",
> -              DENTRY_PATH(dentry), DENTRY_PATH(new_dentry));
> -       smb_invalid_dir_cache(dir);
> -       error = smb_proc_link(server_from_dentry(dentry), dentry, new_dentry);
> -       if (!error) {
> -               smb_renew_times(dentry);
> -               error = smb_instantiate(new_dentry, 0, 0);
> -       }
> -       return error;
> -}
> diff --git a/fs/smbfs/file.c b/fs/smbfs/file.c
> deleted file mode 100644
> index efbe29a..0000000
> --- a/fs/smbfs/file.c
> +++ /dev/null
> @@ -1,445 +0,0 @@
> -/*
> - *  file.c
> - *
> - *  Copyright (C) 1995, 1996, 1997 by Paal-Kr. Engstad and Volker Lendecke
> - *  Copyright (C) 1997 by Volker Lendecke
> - *
> - *  Please add a note about your changes to smbfs in the ChangeLog file.
> - */
> -
> -#include <linux/time.h>
> -#include <linux/kernel.h>
> -#include <linux/errno.h>
> -#include <linux/fcntl.h>
> -#include <linux/stat.h>
> -#include <linux/mm.h>
> -#include <linux/slab.h>
> -#include <linux/pagemap.h>
> -#include <linux/smp_lock.h>
> -#include <linux/net.h>
> -#include <linux/aio.h>
> -
> -#include <asm/uaccess.h>
> -#include <asm/system.h>
> -
> -#include <linux/smbno.h>
> -#include <linux/smb_fs.h>
> -
> -#include "smb_debug.h"
> -#include "proto.h"
> -
> -static int
> -smb_fsync(struct file *file, struct dentry * dentry, int datasync)
> -{
> -       struct smb_sb_info *server = server_from_dentry(dentry);
> -       int result;
> -
> -       VERBOSE("sync file %s/%s\n", DENTRY_PATH(dentry));
> -
> -       /*
> -        * The VFS will writepage() all dirty pages for us, but we
> -        * should send a SMBflush to the server, letting it know that
> -        * we want things synchronized with actual storage.
> -        *
> -        * Note: this function requires all pages to have been written already
> -        *       (should be ok with writepage_sync)
> -        */
> -       result = smb_proc_flush(server, SMB_I(dentry->d_inode)->fileid);
> -       return result;
> -}
> -
> -/*
> - * Read a page synchronously.
> - */
> -static int
> -smb_readpage_sync(struct dentry *dentry, struct page *page)
> -{
> -       char *buffer = kmap(page);
> -       loff_t offset = (loff_t)page->index << PAGE_CACHE_SHIFT;
> -       struct smb_sb_info *server = server_from_dentry(dentry);
> -       unsigned int rsize = smb_get_rsize(server);
> -       int count = PAGE_SIZE;
> -       int result;
> -
> -       VERBOSE("file %s/%s, count=%d@%Ld, rsize=%d\n",
> -               DENTRY_PATH(dentry), count, offset, rsize);
> -
> -       result = smb_open(dentry, SMB_O_RDONLY);
> -       if (result < 0)
> -               goto io_error;
> -
> -       do {
> -               if (count < rsize)
> -                       rsize = count;
> -
> -               result = server->ops->read(dentry->d_inode,offset,rsize,buffer);
> -               if (result < 0)
> -                       goto io_error;
> -
> -               count -= result;
> -               offset += result;
> -               buffer += result;
> -               dentry->d_inode->i_atime =
> -                       current_fs_time(dentry->d_inode->i_sb);
> -               if (result < rsize)
> -                       break;
> -       } while (count);
> -
> -       memset(buffer, 0, count);
> -       flush_dcache_page(page);
> -       SetPageUptodate(page);
> -       result = 0;
> -
> -io_error:
> -       kunmap(page);
> -       unlock_page(page);
> -       return result;
> -}
> -
> -/*
> - * We are called with the page locked and we unlock it when done.
> - */
> -static int
> -smb_readpage(struct file *file, struct page *page)
> -{
> -       int             error;
> -       struct dentry  *dentry = file->f_path.dentry;
> -
> -       page_cache_get(page);
> -       error = smb_readpage_sync(dentry, page);
> -       page_cache_release(page);
> -       return error;
> -}
> -
> -/*
> - * Write a page synchronously.
> - * Offset is the data offset within the page.
> - */
> -static int
> -smb_writepage_sync(struct inode *inode, struct page *page,
> -                  unsigned long pageoffset, unsigned int count)
> -{
> -       loff_t offset;
> -       char *buffer = kmap(page) + pageoffset;
> -       struct smb_sb_info *server = server_from_inode(inode);
> -       unsigned int wsize = smb_get_wsize(server);
> -       int ret = 0;
> -
> -       offset = ((loff_t)page->index << PAGE_CACHE_SHIFT) + pageoffset;
> -       VERBOSE("file ino=%ld, fileid=%d, count=%d@%Ld, wsize=%d\n",
> -               inode->i_ino, SMB_I(inode)->fileid, count, offset, wsize);
> -
> -       do {
> -               int write_ret;
> -
> -               if (count < wsize)
> -                       wsize = count;
> -
> -               write_ret = server->ops->write(inode, offset, wsize, buffer);
> -               if (write_ret < 0) {
> -                       PARANOIA("failed write, wsize=%d, write_ret=%d\n",
> -                                wsize, write_ret);
> -                       ret = write_ret;
> -                       break;
> -               }
> -               /* N.B. what if result < wsize?? */
> -#ifdef SMBFS_PARANOIA
> -               if (write_ret < wsize)
> -                       PARANOIA("short write, wsize=%d, write_ret=%d\n",
> -                                wsize, write_ret);
> -#endif
> -               buffer += wsize;
> -               offset += wsize;
> -               count -= wsize;
> -               /*
> -                * Update the inode now rather than waiting for a refresh.
> -                */
> -               inode->i_mtime = inode->i_atime = current_fs_time(inode->i_sb);
> -               SMB_I(inode)->flags |= SMB_F_LOCALWRITE;
> -               if (offset > inode->i_size)
> -                       inode->i_size = offset;
> -       } while (count);
> -
> -       kunmap(page);
> -       return ret;
> -}
> -
> -/*
> - * Write a page to the server. This will be used for NFS swapping only
> - * (for now), and we currently do this synchronously only.
> - *
> - * We are called with the page locked and we unlock it when done.
> - */
> -static int
> -smb_writepage(struct page *page, struct writeback_control *wbc)
> -{
> -       struct address_space *mapping = page->mapping;
> -       struct inode *inode;
> -       unsigned long end_index;
> -       unsigned offset = PAGE_CACHE_SIZE;
> -       int err;
> -
> -       BUG_ON(!mapping);
> -       inode = mapping->host;
> -       BUG_ON(!inode);
> -
> -       end_index = inode->i_size >> PAGE_CACHE_SHIFT;
> -
> -       /* easy case */
> -       if (page->index < end_index)
> -               goto do_it;
> -       /* things got complicated... */
> -       offset = inode->i_size & (PAGE_CACHE_SIZE-1);
> -       /* OK, are we completely out? */
> -       if (page->index >= end_index+1 || !offset)
> -               return 0; /* truncated - don't care */
> -do_it:
> -       page_cache_get(page);
> -       err = smb_writepage_sync(inode, page, 0, offset);
> -       SetPageUptodate(page);
> -       unlock_page(page);
> -       page_cache_release(page);
> -       return err;
> -}
> -
> -static int
> -smb_updatepage(struct file *file, struct page *page, unsigned long offset,
> -              unsigned int count)
> -{
> -       struct dentry *dentry = file->f_path.dentry;
> -
> -       DEBUG1("(%s/%s %d@%lld)\n", DENTRY_PATH(dentry), count,
> -               ((unsigned long long)page->index << PAGE_CACHE_SHIFT) + offset);
> -
> -       return smb_writepage_sync(dentry->d_inode, page, offset, count);
> -}
> -
> -static ssize_t
> -smb_file_aio_read(struct kiocb *iocb, const struct iovec *iov,
> -                       unsigned long nr_segs, loff_t pos)
> -{
> -       struct file * file = iocb->ki_filp;
> -       struct dentry * dentry = file->f_path.dentry;
> -       ssize_t status;
> -
> -       VERBOSE("file %s/%s, count=%lu@%lu\n", DENTRY_PATH(dentry),
> -               (unsigned long) iocb->ki_left, (unsigned long) pos);
> -
> -       status = smb_revalidate_inode(dentry);
> -       if (status) {
> -               PARANOIA("%s/%s validation failed, error=%Zd\n",
> -                        DENTRY_PATH(dentry), status);
> -               goto out;
> -       }
> -
> -       VERBOSE("before read, size=%ld, flags=%x, atime=%ld\n",
> -               (long)dentry->d_inode->i_size,
> -               dentry->d_inode->i_flags, dentry->d_inode->i_atime.tv_sec);
> -
> -       status = generic_file_aio_read(iocb, iov, nr_segs, pos);
> -out:
> -       return status;
> -}
> -
> -static int
> -smb_file_mmap(struct file * file, struct vm_area_struct * vma)
> -{
> -       struct dentry * dentry = file->f_path.dentry;
> -       int     status;
> -
> -       VERBOSE("file %s/%s, address %lu - %lu\n",
> -               DENTRY_PATH(dentry), vma->vm_start, vma->vm_end);
> -
> -       status = smb_revalidate_inode(dentry);
> -       if (status) {
> -               PARANOIA("%s/%s validation failed, error=%d\n",
> -                        DENTRY_PATH(dentry), status);
> -               goto out;
> -       }
> -       status = generic_file_mmap(file, vma);
> -out:
> -       return status;
> -}
> -
> -static ssize_t
> -smb_file_splice_read(struct file *file, loff_t *ppos,
> -                    struct pipe_inode_info *pipe, size_t count,
> -                    unsigned int flags)
> -{
> -       struct dentry *dentry = file->f_path.dentry;
> -       ssize_t status;
> -
> -       VERBOSE("file %s/%s, pos=%Ld, count=%lu\n",
> -               DENTRY_PATH(dentry), *ppos, count);
> -
> -       status = smb_revalidate_inode(dentry);
> -       if (status) {
> -               PARANOIA("%s/%s validation failed, error=%Zd\n",
> -                        DENTRY_PATH(dentry), status);
> -               goto out;
> -       }
> -       status = generic_file_splice_read(file, ppos, pipe, count, flags);
> -out:
> -       return status;
> -}
> -
> -/*
> - * This does the "real" work of the write. The generic routine has
> - * allocated the page, locked it, done all the page alignment stuff
> - * calculations etc. Now we should just copy the data from user
> - * space and write it back to the real medium..
> - *
> - * If the writer ends up delaying the write, the writer needs to
> - * increment the page use counts until he is done with the page.
> - */
> -static int smb_write_begin(struct file *file, struct address_space *mapping,
> -                       loff_t pos, unsigned len, unsigned flags,
> -                       struct page **pagep, void **fsdata)
> -{
> -       pgoff_t index = pos >> PAGE_CACHE_SHIFT;
> -       *pagep = __grab_cache_page(mapping, index);
> -       if (!*pagep)
> -               return -ENOMEM;
> -       return 0;
> -}
> -
> -static int smb_write_end(struct file *file, struct address_space *mapping,
> -                       loff_t pos, unsigned len, unsigned copied,
> -                       struct page *page, void *fsdata)
> -{
> -       int status;
> -       unsigned offset = pos & (PAGE_CACHE_SIZE - 1);
> -
> -       lock_kernel();
> -       status = smb_updatepage(file, page, offset, copied);
> -       unlock_kernel();
> -
> -       if (!status) {
> -               if (!PageUptodate(page) && copied == PAGE_CACHE_SIZE)
> -                       SetPageUptodate(page);
> -               status = copied;
> -       }
> -
> -       unlock_page(page);
> -       page_cache_release(page);
> -
> -       return status;
> -}
> -
> -const struct address_space_operations smb_file_aops = {
> -       .readpage = smb_readpage,
> -       .writepage = smb_writepage,
> -       .write_begin = smb_write_begin,
> -       .write_end = smb_write_end,
> -};
> -
> -/*
> - * Write to a file (through the page cache).
> - */
> -static ssize_t
> -smb_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
> -                              unsigned long nr_segs, loff_t pos)
> -{
> -       struct file * file = iocb->ki_filp;
> -       struct dentry * dentry = file->f_path.dentry;
> -       ssize_t result;
> -
> -       VERBOSE("file %s/%s, count=%lu@%lu\n",
> -               DENTRY_PATH(dentry),
> -               (unsigned long) iocb->ki_left, (unsigned long) pos);
> -
> -       result = smb_revalidate_inode(dentry);
> -       if (result) {
> -               PARANOIA("%s/%s validation failed, error=%Zd\n",
> -                        DENTRY_PATH(dentry), result);
> -               goto out;
> -       }
> -
> -       result = smb_open(dentry, SMB_O_WRONLY);
> -       if (result)
> -               goto out;
> -
> -       if (iocb->ki_left > 0) {
> -               result = generic_file_aio_write(iocb, iov, nr_segs, pos);
> -               VERBOSE("pos=%ld, size=%ld, mtime=%ld, atime=%ld\n",
> -                       (long) file->f_pos, (long) dentry->d_inode->i_size,
> -                       dentry->d_inode->i_mtime.tv_sec,
> -                       dentry->d_inode->i_atime.tv_sec);
> -       }
> -out:
> -       return result;
> -}
> -
> -static int
> -smb_file_open(struct inode *inode, struct file * file)
> -{
> -       int result;
> -       struct dentry *dentry = file->f_path.dentry;
> -       int smb_mode = (file->f_mode & O_ACCMODE) - 1;
> -
> -       lock_kernel();
> -       result = smb_open(dentry, smb_mode);
> -       if (result)
> -               goto out;
> -       SMB_I(inode)->openers++;
> -out:
> -       unlock_kernel();
> -       return result;
> -}
> -
> -static int
> -smb_file_release(struct inode *inode, struct file * file)
> -{
> -       lock_kernel();
> -       if (!--SMB_I(inode)->openers) {
> -               /* We must flush any dirty pages now as we won't be able to
> -                  write anything after close. mmap can trigger this.
> -                  "openers" should perhaps include mmap'ers ... */
> -               filemap_write_and_wait(inode->i_mapping);
> -               smb_close(inode);
> -       }
> -       unlock_kernel();
> -       return 0;
> -}
> -
> -/*
> - * Check whether the required access is compatible with
> - * an inode's permission. SMB doesn't recognize superuser
> - * privileges, so we need our own check for this.
> - */
> -static int
> -smb_file_permission(struct inode *inode, int mask, struct nameidata *nd)
> -{
> -       int mode = inode->i_mode;
> -       int error = 0;
> -
> -       VERBOSE("mode=%x, mask=%x\n", mode, mask);
> -
> -       /* Look at user permissions */
> -       mode >>= 6;
> -       if ((mode & 7 & mask) != mask)
> -               error = -EACCES;
> -       return error;
> -}
> -
> -const struct file_operations smb_file_operations =
> -{
> -       .llseek         = remote_llseek,
> -       .read           = do_sync_read,
> -       .aio_read       = smb_file_aio_read,
> -       .write          = do_sync_write,
> -       .aio_write      = smb_file_aio_write,
> -       .ioctl          = smb_ioctl,
> -       .mmap           = smb_file_mmap,
> -       .open           = smb_file_open,
> -       .release        = smb_file_release,
> -       .fsync          = smb_fsync,
> -       .splice_read    = smb_file_splice_read,
> -};
> -
> -const struct inode_operations smb_file_inode_operations =
> -{
> -       .permission     = smb_file_permission,
> -       .getattr        = smb_getattr,
> -       .setattr        = smb_notify_change,
> -};
> diff --git a/fs/smbfs/getopt.c b/fs/smbfs/getopt.c
> deleted file mode 100644
> index 7ae0f52..0000000
> --- a/fs/smbfs/getopt.c
> +++ /dev/null
> @@ -1,64 +0,0 @@
> -/*
> - * getopt.c
> - */
> -
> -#include <linux/kernel.h>
> -#include <linux/string.h>
> -#include <linux/net.h>
> -
> -#include "getopt.h"
> -
> -/**
> - *     smb_getopt - option parser
> - *     @caller: name of the caller, for error messages
> - *     @options: the options string
> - *     @opts: an array of &struct option entries controlling parser operations
> - *     @optopt: output; will contain the current option
> - *     @optarg: output; will contain the value (if one exists)
> - *     @flag: output; may be NULL; should point to a long for or'ing flags
> - *     @value: output; may be NULL; will be overwritten with the integer value
> - *             of the current argument.
> - *
> - *     Helper to parse options on the format used by mount ("a=b,c=d,e,f").
> - *     Returns opts->val if a matching entry in the 'opts' array is found,
> - *     0 when no more tokens are found, -1 if an error is encountered.
> - */
> -int smb_getopt(char *caller, char **options, struct option *opts,
> -              char **optopt, char **optarg, unsigned long *flag,
> -              unsigned long *value)
> -{
> -       char *token;
> -       char *val;
> -       int i;
> -
> -       do {
> -               if ((token = strsep(options, ",")) == NULL)
> -                       return 0;
> -       } while (*token == '\0');
> -       *optopt = token;
> -
> -       *optarg = NULL;
> -       if ((val = strchr (token, '=')) != NULL) {
> -               *val++ = 0;
> -               if (value)
> -                       *value = simple_strtoul(val, NULL, 0);
> -               *optarg = val;
> -       }
> -
> -       for (i = 0; opts[i].name != NULL; i++) {
> -               if (!strcmp(opts[i].name, token)) {
> -                       if (!opts[i].flag && (!val || !*val)) {
> -                               printk("%s: the %s option requires an argument\n",
> -                                      caller, token);
> -                               return -1;
> -                       }
> -
> -                       if (flag && opts[i].flag)
> -                               *flag |= opts[i].flag;
> -
> -                       return opts[i].val;
> -               }
> -       }
> -       printk("%s: Unrecognized mount option %s\n", caller, token);
> -       return -1;
> -}
> diff --git a/fs/smbfs/getopt.h b/fs/smbfs/getopt.h
> deleted file mode 100644
> index 146219a..0000000
> --- a/fs/smbfs/getopt.h
> +++ /dev/null
> @@ -1,14 +0,0 @@
> -#ifndef _LINUX_GETOPT_H
> -#define _LINUX_GETOPT_H
> -
> -struct option {
> -       const char *name;
> -       unsigned long flag;
> -       int val;
> -};
> -
> -extern int smb_getopt(char *caller, char **options, struct option *opts,
> -                     char **optopt, char **optarg, unsigned long *flag,
> -                     unsigned long *value);
> -
> -#endif /* _LINUX_GETOPT_H */
> diff --git a/fs/smbfs/inode.c b/fs/smbfs/inode.c
> deleted file mode 100644
> index 9416ead..0000000
> --- a/fs/smbfs/inode.c
> +++ /dev/null
> @@ -1,828 +0,0 @@
> -/*
> - *  inode.c
> - *
> - *  Copyright (C) 1995, 1996 by Paal-Kr. Engstad and Volker Lendecke
> - *  Copyright (C) 1997 by Volker Lendecke
> - *
> - *  Please add a note about your changes to smbfs in the ChangeLog file.
> - */
> -
> -#include <linux/module.h>
> -#include <linux/time.h>
> -#include <linux/kernel.h>
> -#include <linux/mm.h>
> -#include <linux/string.h>
> -#include <linux/stat.h>
> -#include <linux/errno.h>
> -#include <linux/slab.h>
> -#include <linux/init.h>
> -#include <linux/file.h>
> -#include <linux/dcache.h>
> -#include <linux/smp_lock.h>
> -#include <linux/nls.h>
> -#include <linux/seq_file.h>
> -#include <linux/mount.h>
> -#include <linux/net.h>
> -#include <linux/vfs.h>
> -#include <linux/highuid.h>
> -#include <linux/sched.h>
> -#include <linux/smb_fs.h>
> -#include <linux/smbno.h>
> -#include <linux/smb_mount.h>
> -
> -#include <asm/system.h>
> -#include <asm/uaccess.h>
> -
> -#include "smb_debug.h"
> -#include "getopt.h"
> -#include "proto.h"
> -
> -/* Always pick a default string */
> -#ifdef CONFIG_SMB_NLS_REMOTE
> -#define SMB_NLS_REMOTE CONFIG_SMB_NLS_REMOTE
> -#else
> -#define SMB_NLS_REMOTE ""
> -#endif
> -
> -#define SMB_TTL_DEFAULT 1000
> -
> -static void smb_delete_inode(struct inode *);
> -static void smb_put_super(struct super_block *);
> -static int  smb_statfs(struct dentry *, struct kstatfs *);
> -static int  smb_show_options(struct seq_file *, struct vfsmount *);
> -
> -static struct kmem_cache *smb_inode_cachep;
> -
> -static struct inode *smb_alloc_inode(struct super_block *sb)
> -{
> -       struct smb_inode_info *ei;
> -       ei = (struct smb_inode_info *)kmem_cache_alloc(smb_inode_cachep, GFP_KERNEL);
> -       if (!ei)
> -               return NULL;
> -       return &ei->vfs_inode;
> -}
> -
> -static void smb_destroy_inode(struct inode *inode)
> -{
> -       kmem_cache_free(smb_inode_cachep, SMB_I(inode));
> -}
> -
> -static void init_once(struct kmem_cache *cachep, void *foo)
> -{
> -       struct smb_inode_info *ei = (struct smb_inode_info *) foo;
> -
> -       inode_init_once(&ei->vfs_inode);
> -}
> -
> -static int init_inodecache(void)
> -{
> -       smb_inode_cachep = kmem_cache_create("smb_inode_cache",
> -                                            sizeof(struct smb_inode_info),
> -                                            0, (SLAB_RECLAIM_ACCOUNT|
> -                                               SLAB_MEM_SPREAD),
> -                                            init_once);
> -       if (smb_inode_cachep == NULL)
> -               return -ENOMEM;
> -       return 0;
> -}
> -
> -static void destroy_inodecache(void)
> -{
> -       kmem_cache_destroy(smb_inode_cachep);
> -}
> -
> -static int smb_remount(struct super_block *sb, int *flags, char *data)
> -{
> -       *flags |= MS_NODIRATIME;
> -       return 0;
> -}
> -
> -static const struct super_operations smb_sops =
> -{
> -       .alloc_inode    = smb_alloc_inode,
> -       .destroy_inode  = smb_destroy_inode,
> -       .drop_inode     = generic_delete_inode,
> -       .delete_inode   = smb_delete_inode,
> -       .put_super      = smb_put_super,
> -       .statfs         = smb_statfs,
> -       .show_options   = smb_show_options,
> -       .remount_fs     = smb_remount,
> -};
> -
> -
> -/* We are always generating a new inode here */
> -struct inode *
> -smb_iget(struct super_block *sb, struct smb_fattr *fattr)
> -{
> -       struct smb_sb_info *server = SMB_SB(sb);
> -       struct inode *result;
> -
> -       DEBUG1("smb_iget: %p\n", fattr);
> -
> -       result = new_inode(sb);
> -       if (!result)
> -               return result;
> -       result->i_ino = fattr->f_ino;
> -       SMB_I(result)->open = 0;
> -       SMB_I(result)->fileid = 0;
> -       SMB_I(result)->access = 0;
> -       SMB_I(result)->flags = 0;
> -       SMB_I(result)->closed = 0;
> -       SMB_I(result)->openers = 0;
> -       smb_set_inode_attr(result, fattr);
> -       if (S_ISREG(result->i_mode)) {
> -               result->i_op = &smb_file_inode_operations;
> -               result->i_fop = &smb_file_operations;
> -               result->i_data.a_ops = &smb_file_aops;
> -       } else if (S_ISDIR(result->i_mode)) {
> -               if (server->opt.capabilities & SMB_CAP_UNIX)
> -                       result->i_op = &smb_dir_inode_operations_unix;
> -               else
> -                       result->i_op = &smb_dir_inode_operations;
> -               result->i_fop = &smb_dir_operations;
> -       } else if (S_ISLNK(result->i_mode)) {
> -               result->i_op = &smb_link_inode_operations;
> -       } else {
> -               init_special_inode(result, result->i_mode, fattr->f_rdev);
> -       }
> -       insert_inode_hash(result);
> -       return result;
> -}
> -
> -/*
> - * Copy the inode data to a smb_fattr structure.
> - */
> -void
> -smb_get_inode_attr(struct inode *inode, struct smb_fattr *fattr)
> -{
> -       memset(fattr, 0, sizeof(struct smb_fattr));
> -       fattr->f_mode   = inode->i_mode;
> -       fattr->f_nlink  = inode->i_nlink;
> -       fattr->f_ino    = inode->i_ino;
> -       fattr->f_uid    = inode->i_uid;
> -       fattr->f_gid    = inode->i_gid;
> -       fattr->f_size   = inode->i_size;
> -       fattr->f_mtime  = inode->i_mtime;
> -       fattr->f_ctime  = inode->i_ctime;
> -       fattr->f_atime  = inode->i_atime;
> -       fattr->f_blocks = inode->i_blocks;
> -
> -       fattr->attr     = SMB_I(inode)->attr;
> -       /*
> -        * Keep the attributes in sync with the inode permissions.
> -        */
> -       if (fattr->f_mode & S_IWUSR)
> -               fattr->attr &= ~aRONLY;
> -       else
> -               fattr->attr |= aRONLY;
> -}
> -
> -/*
> - * Update the inode, possibly causing it to invalidate its pages if mtime/size
> - * is different from last time.
> - */
> -void
> -smb_set_inode_attr(struct inode *inode, struct smb_fattr *fattr)
> -{
> -       struct smb_inode_info *ei = SMB_I(inode);
> -
> -       /*
> -        * A size change should have a different mtime, or same mtime
> -        * but different size.
> -        */
> -       time_t last_time = inode->i_mtime.tv_sec;
> -       loff_t last_sz = inode->i_size;
> -
> -       inode->i_mode   = fattr->f_mode;
> -       inode->i_nlink  = fattr->f_nlink;
> -       inode->i_uid    = fattr->f_uid;
> -       inode->i_gid    = fattr->f_gid;
> -       inode->i_ctime  = fattr->f_ctime;
> -       inode->i_blocks = fattr->f_blocks;
> -       inode->i_size   = fattr->f_size;
> -       inode->i_mtime  = fattr->f_mtime;
> -       inode->i_atime  = fattr->f_atime;
> -       ei->attr = fattr->attr;
> -
> -       /*
> -        * Update the "last time refreshed" field for revalidation.
> -        */
> -       ei->oldmtime = jiffies;
> -
> -       if (inode->i_mtime.tv_sec != last_time || inode->i_size != last_sz) {
> -               VERBOSE("%ld changed, old=%ld, new=%ld, oz=%ld, nz=%ld\n",
> -                       inode->i_ino,
> -                       (long) last_time, (long) inode->i_mtime.tv_sec,
> -                       (long) last_sz, (long) inode->i_size);
> -
> -               if (!S_ISDIR(inode->i_mode))
> -                       invalidate_remote_inode(inode);
> -       }
> -}
> -
> -/*
> - * This is called if the connection has gone bad ...
> - * try to kill off all the current inodes.
> - */
> -void
> -smb_invalidate_inodes(struct smb_sb_info *server)
> -{
> -       VERBOSE("\n");
> -       shrink_dcache_sb(SB_of(server));
> -       invalidate_inodes(SB_of(server));
> -}
> -
> -/*
> - * This is called to update the inode attributes after
> - * we've made changes to a file or directory.
> - */
> -static int
> -smb_refresh_inode(struct dentry *dentry)
> -{
> -       struct inode *inode = dentry->d_inode;
> -       int error;
> -       struct smb_fattr fattr;
> -
> -       error = smb_proc_getattr(dentry, &fattr);
> -       if (!error) {
> -               smb_renew_times(dentry);
> -               /*
> -                * Check whether the type part of the mode changed,
> -                * and don't update the attributes if it did.
> -                *
> -                * And don't dick with the root inode
> -                */
> -               if (inode->i_ino == 2)
> -                       return error;
> -               if (S_ISLNK(inode->i_mode))
> -                       return error;   /* VFS will deal with it */
> -
> -               if ((inode->i_mode & S_IFMT) == (fattr.f_mode & S_IFMT)) {
> -                       smb_set_inode_attr(inode, &fattr);
> -               } else {
> -                       /*
> -                        * Big trouble! The inode has become a new object,
> -                        * so any operations attempted on it are invalid.
> -                        *
> -                        * To limit damage, mark the inode as bad so that
> -                        * subsequent lookup validations will fail.
> -                        */
> -                       PARANOIA("%s/%s changed mode, %07o to %07o\n",
> -                                DENTRY_PATH(dentry),
> -                                inode->i_mode, fattr.f_mode);
> -
> -                       fattr.f_mode = inode->i_mode; /* save mode */
> -                       make_bad_inode(inode);
> -                       inode->i_mode = fattr.f_mode; /* restore mode */
> -                       /*
> -                        * No need to worry about unhashing the dentry: the
> -                        * lookup validation will see that the inode is bad.
> -                        * But we do want to invalidate the caches ...
> -                        */
> -                       if (!S_ISDIR(inode->i_mode))
> -                               invalidate_remote_inode(inode);
> -                       else
> -                               smb_invalid_dir_cache(inode);
> -                       error = -EIO;
> -               }
> -       }
> -       return error;
> -}
> -
> -/*
> - * This is called when we want to check whether the inode
> - * has changed on the server.  If it has changed, we must
> - * invalidate our local caches.
> - */
> -int
> -smb_revalidate_inode(struct dentry *dentry)
> -{
> -       struct smb_sb_info *s = server_from_dentry(dentry);
> -       struct inode *inode = dentry->d_inode;
> -       int error = 0;
> -
> -       DEBUG1("smb_revalidate_inode\n");
> -       lock_kernel();
> -
> -       /*
> -        * Check whether we've recently refreshed the inode.
> -        */
> -       if (time_before(jiffies, SMB_I(inode)->oldmtime + SMB_MAX_AGE(s))) {
> -               VERBOSE("up-to-date, ino=%ld, jiffies=%lu, oldtime=%lu\n",
> -                       inode->i_ino, jiffies, SMB_I(inode)->oldmtime);
> -               goto out;
> -       }
> -
> -       error = smb_refresh_inode(dentry);
> -out:
> -       unlock_kernel();
> -       return error;
> -}
> -
> -/*
> - * This routine is called when i_nlink == 0 and i_count goes to 0.
> - * All blocking cleanup operations need to go here to avoid races.
> - */
> -static void
> -smb_delete_inode(struct inode *ino)
> -{
> -       DEBUG1("ino=%ld\n", ino->i_ino);
> -       truncate_inode_pages(&ino->i_data, 0);
> -       lock_kernel();
> -       if (smb_close(ino))
> -               PARANOIA("could not close inode %ld\n", ino->i_ino);
> -       unlock_kernel();
> -       clear_inode(ino);
> -}
> -
> -static struct option opts[] = {
> -       { "version",    0, 'v' },
> -       { "win95",      SMB_MOUNT_WIN95, 1 },
> -       { "oldattr",    SMB_MOUNT_OLDATTR, 1 },
> -       { "dirattr",    SMB_MOUNT_DIRATTR, 1 },
> -       { "case",       SMB_MOUNT_CASE, 1 },
> -       { "uid",        0, 'u' },
> -       { "gid",        0, 'g' },
> -       { "file_mode",  0, 'f' },
> -       { "dir_mode",   0, 'd' },
> -       { "iocharset",  0, 'i' },
> -       { "codepage",   0, 'c' },
> -       { "ttl",        0, 't' },
> -       { NULL,         0, 0}
> -};
> -
> -static int
> -parse_options(struct smb_mount_data_kernel *mnt, char *options)
> -{
> -       int c;
> -       unsigned long flags;
> -       unsigned long value;
> -       char *optarg;
> -       char *optopt;
> -
> -       flags = 0;
> -       while ( (c = smb_getopt("smbfs", &options, opts,
> -                               &optopt, &optarg, &flags, &value)) > 0) {
> -
> -               VERBOSE("'%s' -> '%s'\n", optopt, optarg ? optarg : "<none>");
> -               switch (c) {
> -               case 1:
> -                       /* got a "flag" option */
> -                       break;
> -               case 'v':
> -                       if (value != SMB_MOUNT_VERSION) {
> -                       printk ("smbfs: Bad mount version %ld, expected %d\n",
> -                               value, SMB_MOUNT_VERSION);
> -                               return 0;
> -                       }
> -                       mnt->version = value;
> -                       break;
> -               case 'u':
> -                       mnt->uid = value;
> -                       flags |= SMB_MOUNT_UID;
> -                       break;
> -               case 'g':
> -                       mnt->gid = value;
> -                       flags |= SMB_MOUNT_GID;
> -                       break;
> -               case 'f':
> -                       mnt->file_mode = (value & S_IRWXUGO) | S_IFREG;
> -                       flags |= SMB_MOUNT_FMODE;
> -                       break;
> -               case 'd':
> -                       mnt->dir_mode = (value & S_IRWXUGO) | S_IFDIR;
> -                       flags |= SMB_MOUNT_DMODE;
> -                       break;
> -               case 'i':
> -                       strlcpy(mnt->codepage.local_name, optarg,
> -                               SMB_NLS_MAXNAMELEN);
> -                       break;
> -               case 'c':
> -                       strlcpy(mnt->codepage.remote_name, optarg,
> -                               SMB_NLS_MAXNAMELEN);
> -                       break;
> -               case 't':
> -                       mnt->ttl = value;
> -                       break;
> -               default:
> -                       printk ("smbfs: Unrecognized mount option %s\n",
> -                               optopt);
> -                       return -1;
> -               }
> -       }
> -       mnt->flags = flags;
> -       return c;
> -}
> -
> -/*
> - * smb_show_options() is for displaying mount options in /proc/mounts.
> - * It tries to avoid showing settings that were not changed from their
> - * defaults.
> - */
> -static int
> -smb_show_options(struct seq_file *s, struct vfsmount *m)
> -{
> -       struct smb_mount_data_kernel *mnt = SMB_SB(m->mnt_sb)->mnt;
> -       int i;
> -
> -       for (i = 0; opts[i].name != NULL; i++)
> -               if (mnt->flags & opts[i].flag)
> -                       seq_printf(s, ",%s", opts[i].name);
> -
> -       if (mnt->flags & SMB_MOUNT_UID)
> -               seq_printf(s, ",uid=%d", mnt->uid);
> -       if (mnt->flags & SMB_MOUNT_GID)
> -               seq_printf(s, ",gid=%d", mnt->gid);
> -       if (mnt->mounted_uid != 0)
> -               seq_printf(s, ",mounted_uid=%d", mnt->mounted_uid);
> -
> -       /*
> -        * Defaults for file_mode and dir_mode are unknown to us; they
> -        * depend on the current umask of the user doing the mount.
> -        */
> -       if (mnt->flags & SMB_MOUNT_FMODE)
> -               seq_printf(s, ",file_mode=%04o", mnt->file_mode & S_IRWXUGO);
> -       if (mnt->flags & SMB_MOUNT_DMODE)
> -               seq_printf(s, ",dir_mode=%04o", mnt->dir_mode & S_IRWXUGO);
> -
> -       if (strcmp(mnt->codepage.local_name, CONFIG_NLS_DEFAULT))
> -               seq_printf(s, ",iocharset=%s", mnt->codepage.local_name);
> -       if (strcmp(mnt->codepage.remote_name, SMB_NLS_REMOTE))
> -               seq_printf(s, ",codepage=%s", mnt->codepage.remote_name);
> -
> -       if (mnt->ttl != SMB_TTL_DEFAULT)
> -               seq_printf(s, ",ttl=%d", mnt->ttl);
> -
> -       return 0;
> -}
> -
> -static void
> -smb_unload_nls(struct smb_sb_info *server)
> -{
> -       if (server->remote_nls) {
> -               unload_nls(server->remote_nls);
> -               server->remote_nls = NULL;
> -       }
> -       if (server->local_nls) {
> -               unload_nls(server->local_nls);
> -               server->local_nls = NULL;
> -       }
> -}
> -
> -static void
> -smb_put_super(struct super_block *sb)
> -{
> -       struct smb_sb_info *server = SMB_SB(sb);
> -
> -       smb_lock_server(server);
> -       server->state = CONN_INVALID;
> -       smbiod_unregister_server(server);
> -
> -       smb_close_socket(server);
> -
> -       if (server->conn_pid)
> -               kill_pid(server->conn_pid, SIGTERM, 1);
> -
> -       kfree(server->ops);
> -       smb_unload_nls(server);
> -       sb->s_fs_info = NULL;
> -       smb_unlock_server(server);
> -       put_pid(server->conn_pid);
> -       kfree(server);
> -}
> -
> -static int smb_fill_super(struct super_block *sb, void *raw_data, int silent)
> -{
> -       struct smb_sb_info *server;
> -       struct smb_mount_data_kernel *mnt;
> -       struct smb_mount_data *oldmnt;
> -       struct inode *root_inode;
> -       struct smb_fattr root;
> -       int ver;
> -       void *mem;
> -
> -       if (!raw_data)
> -               goto out_no_data;
> -
> -       oldmnt = (struct smb_mount_data *) raw_data;
> -       ver = oldmnt->version;
> -       if (ver != SMB_MOUNT_OLDVERSION && cpu_to_be32(ver) != SMB_MOUNT_ASCII)
> -               goto out_wrong_data;
> -
> -       sb->s_flags |= MS_NODIRATIME;
> -       sb->s_blocksize = 1024; /* Eh...  Is this correct? */
> -       sb->s_blocksize_bits = 10;
> -       sb->s_magic = SMB_SUPER_MAGIC;
> -       sb->s_op = &smb_sops;
> -       sb->s_time_gran = 100;
> -
> -       server = kzalloc(sizeof(struct smb_sb_info), GFP_KERNEL);
> -       if (!server)
> -               goto out_no_server;
> -       sb->s_fs_info = server;
> -
> -       server->super_block = sb;
> -       server->mnt = NULL;
> -       server->sock_file = NULL;
> -       init_waitqueue_head(&server->conn_wq);
> -       init_MUTEX(&server->sem);
> -       INIT_LIST_HEAD(&server->entry);
> -       INIT_LIST_HEAD(&server->xmitq);
> -       INIT_LIST_HEAD(&server->recvq);
> -       server->conn_error = 0;
> -       server->conn_pid = NULL;
> -       server->state = CONN_INVALID; /* no connection yet */
> -       server->generation = 0;
> -
> -       /* Allocate the global temp buffer and some superblock helper structs */
> -       /* FIXME: move these to the smb_sb_info struct */
> -       VERBOSE("alloc chunk = %lu\n", sizeof(struct smb_ops) +
> -               sizeof(struct smb_mount_data_kernel));
> -       mem = kmalloc(sizeof(struct smb_ops) +
> -                     sizeof(struct smb_mount_data_kernel), GFP_KERNEL);
> -       if (!mem)
> -               goto out_no_mem;
> -
> -       server->ops = mem;
> -       smb_install_null_ops(server->ops);
> -       server->mnt = mem + sizeof(struct smb_ops);
> -
> -       /* Setup NLS stuff */
> -       server->remote_nls = NULL;
> -       server->local_nls = NULL;
> -
> -       mnt = server->mnt;
> -
> -       memset(mnt, 0, sizeof(struct smb_mount_data_kernel));
> -       strlcpy(mnt->codepage.local_name, CONFIG_NLS_DEFAULT,
> -               SMB_NLS_MAXNAMELEN);
> -       strlcpy(mnt->codepage.remote_name, SMB_NLS_REMOTE,
> -               SMB_NLS_MAXNAMELEN);
> -
> -       mnt->ttl = SMB_TTL_DEFAULT;
> -       if (ver == SMB_MOUNT_OLDVERSION) {
> -               mnt->version = oldmnt->version;
> -
> -               SET_UID(mnt->uid, oldmnt->uid);
> -               SET_GID(mnt->gid, oldmnt->gid);
> -
> -               mnt->file_mode = (oldmnt->file_mode & S_IRWXUGO) | S_IFREG;
> -               mnt->dir_mode = (oldmnt->dir_mode & S_IRWXUGO) | S_IFDIR;
> -
> -               mnt->flags = (oldmnt->file_mode >> 9) | SMB_MOUNT_UID |
> -                       SMB_MOUNT_GID | SMB_MOUNT_FMODE | SMB_MOUNT_DMODE;
> -       } else {
> -               mnt->file_mode = S_IRWXU | S_IRGRP | S_IXGRP |
> -                               S_IROTH | S_IXOTH | S_IFREG;
> -               mnt->dir_mode = S_IRWXU | S_IRGRP | S_IXGRP |
> -                               S_IROTH | S_IXOTH | S_IFDIR;
> -               if (parse_options(mnt, raw_data))
> -                       goto out_bad_option;
> -       }
> -       mnt->mounted_uid = current->uid;
> -       smb_setcodepage(server, &mnt->codepage);
> -
> -       /*
> -        * Display the enabled options
> -        * Note: smb_proc_getattr uses these in 2.4 (but was changed in 2.2)
> -        */
> -       if (mnt->flags & SMB_MOUNT_OLDATTR)
> -               printk("SMBFS: Using core getattr (Win 95 speedup)\n");
> -       else if (mnt->flags & SMB_MOUNT_DIRATTR)
> -               printk("SMBFS: Using dir ff getattr\n");
> -
> -       if (smbiod_register_server(server) < 0) {
> -               printk(KERN_ERR "smbfs: failed to start smbiod\n");
> -               goto out_no_smbiod;
> -       }
> -
> -       /*
> -        * Keep the super block locked while we get the root inode.
> -        */
> -       smb_init_root_dirent(server, &root, sb);
> -       root_inode = smb_iget(sb, &root);
> -       if (!root_inode)
> -               goto out_no_root;
> -
> -       sb->s_root = d_alloc_root(root_inode);
> -       if (!sb->s_root)
> -               goto out_no_root;
> -
> -       smb_new_dentry(sb->s_root);
> -
> -       return 0;
> -
> -out_no_root:
> -       iput(root_inode);
> -out_no_smbiod:
> -       smb_unload_nls(server);
> -out_bad_option:
> -       kfree(mem);
> -out_no_mem:
> -       if (!server->mnt)
> -               printk(KERN_ERR "smb_fill_super: allocation failure\n");
> -       sb->s_fs_info = NULL;
> -       kfree(server);
> -       goto out_fail;
> -out_wrong_data:
> -       printk(KERN_ERR "smbfs: mount_data version %d is not supported\n", ver);
> -       goto out_fail;
> -out_no_data:
> -       printk(KERN_ERR "smb_fill_super: missing data argument\n");
> -out_fail:
> -       return -EINVAL;
> -out_no_server:
> -       printk(KERN_ERR "smb_fill_super: cannot allocate struct smb_sb_info\n");
> -       return -ENOMEM;
> -}
> -
> -static int
> -smb_statfs(struct dentry *dentry, struct kstatfs *buf)
> -{
> -       int result;
> -
> -       lock_kernel();
> -
> -       result = smb_proc_dskattr(dentry, buf);
> -
> -       unlock_kernel();
> -
> -       buf->f_type = SMB_SUPER_MAGIC;
> -       buf->f_namelen = SMB_MAXPATHLEN;
> -       return result;
> -}
> -
> -int smb_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
> -{
> -       int err = smb_revalidate_inode(dentry);
> -       if (!err)
> -               generic_fillattr(dentry->d_inode, stat);
> -       return err;
> -}
> -
> -int
> -smb_notify_change(struct dentry *dentry, struct iattr *attr)
> -{
> -       struct inode *inode = dentry->d_inode;
> -       struct smb_sb_info *server = server_from_dentry(dentry);
> -       unsigned int mask = (S_IFREG | S_IFDIR | S_IRWXUGO);
> -       int error, changed, refresh = 0;
> -       struct smb_fattr fattr;
> -
> -       lock_kernel();
> -
> -       error = smb_revalidate_inode(dentry);
> -       if (error)
> -               goto out;
> -
> -       if ((error = inode_change_ok(inode, attr)) < 0)
> -               goto out;
> -
> -       error = -EPERM;
> -       if ((attr->ia_valid & ATTR_UID) && (attr->ia_uid != server->mnt->uid))
> -               goto out;
> -
> -       if ((attr->ia_valid & ATTR_GID) && (attr->ia_uid != server->mnt->gid))
> -               goto out;
> -
> -       if ((attr->ia_valid & ATTR_MODE) && (attr->ia_mode & ~mask))
> -               goto out;
> -
> -       if ((attr->ia_valid & ATTR_SIZE) != 0) {
> -               VERBOSE("changing %s/%s, old size=%ld, new size=%ld\n",
> -                       DENTRY_PATH(dentry),
> -                       (long) inode->i_size, (long) attr->ia_size);
> -
> -               filemap_write_and_wait(inode->i_mapping);
> -
> -               error = smb_open(dentry, O_WRONLY);
> -               if (error)
> -                       goto out;
> -               error = server->ops->truncate(inode, attr->ia_size);
> -               if (error)
> -                       goto out;
> -               error = vmtruncate(inode, attr->ia_size);
> -               if (error)
> -                       goto out;
> -               refresh = 1;
> -       }
> -
> -       if (server->opt.capabilities & SMB_CAP_UNIX) {
> -               /* For now we don't want to set the size with setattr_unix */
> -               attr->ia_valid &= ~ATTR_SIZE;
> -               /* FIXME: only call if we actually want to set something? */
> -               error = smb_proc_setattr_unix(dentry, attr, 0, 0);
> -               if (!error)
> -                       refresh = 1;
> -
> -               goto out;
> -       }
> -
> -       /*
> -        * Initialize the fattr and check for changed fields.
> -        * Note: CTIME under SMB is creation time rather than
> -        * change time, so we don't attempt to change it.
> -        */
> -       smb_get_inode_attr(inode, &fattr);
> -
> -       changed = 0;
> -       if ((attr->ia_valid & ATTR_MTIME) != 0) {
> -               fattr.f_mtime = attr->ia_mtime;
> -               changed = 1;
> -       }
> -       if ((attr->ia_valid & ATTR_ATIME) != 0) {
> -               fattr.f_atime = attr->ia_atime;
> -               /* Earlier protocols don't have an access time */
> -               if (server->opt.protocol >= SMB_PROTOCOL_LANMAN2)
> -                       changed = 1;
> -       }
> -       if (changed) {
> -               error = smb_proc_settime(dentry, &fattr);
> -               if (error)
> -                       goto out;
> -               refresh = 1;
> -       }
> -
> -       /*
> -        * Check for mode changes ... we're extremely limited in
> -        * what can be set for SMB servers: just the read-only bit.
> -        */
> -       if ((attr->ia_valid & ATTR_MODE) != 0) {
> -               VERBOSE("%s/%s mode change, old=%x, new=%x\n",
> -                       DENTRY_PATH(dentry), fattr.f_mode, attr->ia_mode);
> -               changed = 0;
> -               if (attr->ia_mode & S_IWUSR) {
> -                       if (fattr.attr & aRONLY) {
> -                               fattr.attr &= ~aRONLY;
> -                               changed = 1;
> -                       }
> -               } else {
> -                       if (!(fattr.attr & aRONLY)) {
> -                               fattr.attr |= aRONLY;
> -                               changed = 1;
> -                       }
> -               }
> -               if (changed) {
> -                       error = smb_proc_setattr(dentry, &fattr);
> -                       if (error)
> -                               goto out;
> -                       refresh = 1;
> -               }
> -       }
> -       error = 0;
> -
> -out:
> -       if (refresh)
> -               smb_refresh_inode(dentry);
> -       unlock_kernel();
> -       return error;
> -}
> -
> -static int smb_get_sb(struct file_system_type *fs_type,
> -       int flags, const char *dev_name, void *data, struct vfsmount *mnt)
> -{
> -       return get_sb_nodev(fs_type, flags, data, smb_fill_super, mnt);
> -}
> -
> -static struct file_system_type smb_fs_type = {
> -       .owner          = THIS_MODULE,
> -       .name           = "smbfs",
> -       .get_sb         = smb_get_sb,
> -       .kill_sb        = kill_anon_super,
> -       .fs_flags       = FS_BINARY_MOUNTDATA,
> -};
> -
> -static int __init init_smb_fs(void)
> -{
> -       int err;
> -       DEBUG1("registering ...\n");
> -
> -       err = init_inodecache();
> -       if (err)
> -               goto out_inode;
> -       err = smb_init_request_cache();
> -       if (err)
> -               goto out_request;
> -       err = register_filesystem(&smb_fs_type);
> -       if (err)
> -               goto out;
> -       return 0;
> -out:
> -       smb_destroy_request_cache();
> -out_request:
> -       destroy_inodecache();
> -out_inode:
> -       return err;
> -}
> -
> -static void __exit exit_smb_fs(void)
> -{
> -       DEBUG1("unregistering ...\n");
> -       unregister_filesystem(&smb_fs_type);
> -       smb_destroy_request_cache();
> -       destroy_inodecache();
> -}
> -
> -module_init(init_smb_fs)
> -module_exit(exit_smb_fs)
> -MODULE_LICENSE("GPL");
> diff --git a/fs/smbfs/ioctl.c b/fs/smbfs/ioctl.c
> deleted file mode 100644
> index dbae1f8..0000000
> --- a/fs/smbfs/ioctl.c
> +++ /dev/null
> @@ -1,67 +0,0 @@
> -/*
> - *  ioctl.c
> - *
> - *  Copyright (C) 1995, 1996 by Volker Lendecke
> - *  Copyright (C) 1997 by Volker Lendecke
> - *
> - *  Please add a note about your changes to smbfs in the ChangeLog file.
> - */
> -
> -#include <linux/errno.h>
> -#include <linux/fs.h>
> -#include <linux/ioctl.h>
> -#include <linux/time.h>
> -#include <linux/mm.h>
> -#include <linux/highuid.h>
> -#include <linux/net.h>
> -
> -#include <linux/smb_fs.h>
> -#include <linux/smb_mount.h>
> -
> -#include <asm/uaccess.h>
> -
> -#include "proto.h"
> -
> -int
> -smb_ioctl(struct inode *inode, struct file *filp,
> -         unsigned int cmd, unsigned long arg)
> -{
> -       struct smb_sb_info *server = server_from_inode(inode);
> -       struct smb_conn_opt opt;
> -       int result = -EINVAL;
> -
> -       switch (cmd) {
> -               uid16_t uid16;
> -               uid_t uid32;
> -       case SMB_IOC_GETMOUNTUID:
> -               SET_UID(uid16, server->mnt->mounted_uid);
> -               result = put_user(uid16, (uid16_t __user *) arg);
> -               break;
> -       case SMB_IOC_GETMOUNTUID32:
> -               SET_UID(uid32, server->mnt->mounted_uid);
> -               result = put_user(uid32, (uid_t __user *) arg);
> -               break;
> -
> -       case SMB_IOC_NEWCONN:
> -               /* arg is smb_conn_opt, or NULL if no connection was made */
> -               if (!arg) {
> -                       result = 0;
> -                       smb_lock_server(server);
> -                       server->state = CONN_RETRIED;
> -                       printk(KERN_ERR "Connection attempt failed!  [%d]\n",
> -                              server->conn_error);
> -                       smbiod_flush(server);
> -                       smb_unlock_server(server);
> -                       break;
> -               }
> -
> -               result = -EFAULT;
> -               if (!copy_from_user(&opt, (void __user *)arg, sizeof(opt)))
> -                       result = smb_newconn(server, &opt);
> -               break;
> -       default:
> -               break;
> -       }
> -
> -       return result;
> -}
> diff --git a/fs/smbfs/proc.c b/fs/smbfs/proc.c
> deleted file mode 100644
> index d517a27..0000000
> --- a/fs/smbfs/proc.c
> +++ /dev/null
> @@ -1,3508 +0,0 @@
> -/*
> - *  proc.c
> - *
> - *  Copyright (C) 1995, 1996 by Paal-Kr. Engstad and Volker Lendecke
> - *  Copyright (C) 1997 by Volker Lendecke
> - *
> - *  Please add a note about your changes to smbfs in the ChangeLog file.
> - */
> -
> -#include <linux/types.h>
> -#include <linux/capability.h>
> -#include <linux/errno.h>
> -#include <linux/slab.h>
> -#include <linux/fs.h>
> -#include <linux/file.h>
> -#include <linux/stat.h>
> -#include <linux/fcntl.h>
> -#include <linux/dcache.h>
> -#include <linux/dirent.h>
> -#include <linux/nls.h>
> -#include <linux/smp_lock.h>
> -#include <linux/net.h>
> -#include <linux/vfs.h>
> -#include <linux/smb_fs.h>
> -#include <linux/smbno.h>
> -#include <linux/smb_mount.h>
> -
> -#include <net/sock.h>
> -
> -#include <asm/string.h>
> -#include <asm/div64.h>
> -
> -#include "smb_debug.h"
> -#include "proto.h"
> -#include "request.h"
> -
> -
> -/* Features. Undefine if they cause problems, this should perhaps be a
> -   config option. */
> -#define SMBFS_POSIX_UNLINK 1
> -
> -/* Allow smb_retry to be interrupted. */
> -#define SMB_RETRY_INTR
> -
> -#define SMB_VWV(packet)  ((packet) + SMB_HEADER_LEN)
> -#define SMB_CMD(packet)  (*(packet+8))
> -#define SMB_WCT(packet)  (*(packet+SMB_HEADER_LEN - 1))
> -
> -#define SMB_DIRINFO_SIZE 43
> -#define SMB_STATUS_SIZE  21
> -
> -#define SMB_ST_BLKSIZE (PAGE_SIZE)
> -#define SMB_ST_BLKSHIFT        (PAGE_SHIFT)
> -
> -static struct smb_ops smb_ops_core;
> -static struct smb_ops smb_ops_os2;
> -static struct smb_ops smb_ops_win95;
> -static struct smb_ops smb_ops_winNT;
> -static struct smb_ops smb_ops_unix;
> -static struct smb_ops smb_ops_null;
> -
> -static void
> -smb_init_dirent(struct smb_sb_info *server, struct smb_fattr *fattr);
> -static void
> -smb_finish_dirent(struct smb_sb_info *server, struct smb_fattr *fattr);
> -static int
> -smb_proc_getattr_core(struct smb_sb_info *server, struct dentry *dir,
> -                     struct smb_fattr *fattr);
> -static int
> -smb_proc_getattr_ff(struct smb_sb_info *server, struct dentry *dentry,
> -                   struct smb_fattr *fattr);
> -static int
> -smb_proc_setattr_core(struct smb_sb_info *server, struct dentry *dentry,
> -                     u16 attr);
> -static int
> -smb_proc_setattr_ext(struct smb_sb_info *server,
> -                    struct inode *inode, struct smb_fattr *fattr);
> -static int
> -smb_proc_query_cifsunix(struct smb_sb_info *server);
> -static void
> -install_ops(struct smb_ops *dst, struct smb_ops *src);
> -
> -
> -static void
> -str_upper(char *name, int len)
> -{
> -       while (len--)
> -       {
> -               if (*name >= 'a' && *name <= 'z')
> -                       *name -= ('a' - 'A');
> -               name++;
> -       }
> -}
> -
> -#if 0
> -static void
> -str_lower(char *name, int len)
> -{
> -       while (len--)
> -       {
> -               if (*name >= 'A' && *name <= 'Z')
> -                       *name += ('a' - 'A');
> -               name++;
> -       }
> -}
> -#endif
> -
> -/* reverse a string inline. This is used by the dircache walking routines */
> -static void reverse_string(char *buf, int len)
> -{
> -       char c;
> -       char *end = buf+len-1;
> -
> -       while(buf < end) {
> -               c = *buf;
> -               *(buf++) = *end;
> -               *(end--) = c;
> -       }
> -}
> -
> -/* no conversion, just a wrapper for memcpy. */
> -static int convert_memcpy(unsigned char *output, int olen,
> -                         const unsigned char *input, int ilen,
> -                         struct nls_table *nls_from,
> -                         struct nls_table *nls_to)
> -{
> -       if (olen < ilen)
> -               return -ENAMETOOLONG;
> -       memcpy(output, input, ilen);
> -       return ilen;
> -}
> -
> -static inline int write_char(unsigned char ch, char *output, int olen)
> -{
> -       if (olen < 4)
> -               return -ENAMETOOLONG;
> -       sprintf(output, ":x%02x", ch);
> -       return 4;
> -}
> -
> -static inline int write_unichar(wchar_t ch, char *output, int olen)
> -{
> -       if (olen < 5)
> -               return -ENAMETOOLONG;
> -       sprintf(output, ":%04x", ch);
> -       return 5;
> -}
> -
> -/* convert from one "codepage" to another (possibly being utf8). */
> -static int convert_cp(unsigned char *output, int olen,
> -                     const unsigned char *input, int ilen,
> -                     struct nls_table *nls_from,
> -                     struct nls_table *nls_to)
> -{
> -       int len = 0;
> -       int n;
> -       wchar_t ch;
> -
> -       while (ilen > 0) {
> -               /* convert by changing to unicode and back to the new cp */
> -               n = nls_from->char2uni(input, ilen, &ch);
> -               if (n == -EINVAL) {
> -                       ilen--;
> -                       n = write_char(*input++, output, olen);
> -                       if (n < 0)
> -                               goto fail;
> -                       output += n;
> -                       olen -= n;
> -                       len += n;
> -                       continue;
> -               } else if (n < 0)
> -                       goto fail;
> -               input += n;
> -               ilen -= n;
> -
> -               n = nls_to->uni2char(ch, output, olen);
> -               if (n == -EINVAL)
> -                       n = write_unichar(ch, output, olen);
> -               if (n < 0)
> -                       goto fail;
> -               output += n;
> -               olen -= n;
> -
> -               len += n;
> -       }
> -       return len;
> -fail:
> -       return n;
> -}
> -
> -/* ----------------------------------------------------------- */
> -
> -/*
> - * nls_unicode
> - *
> - * This encodes/decodes little endian unicode format
> - */
> -
> -static int uni2char(wchar_t uni, unsigned char *out, int boundlen)
> -{
> -       if (boundlen < 2)
> -               return -EINVAL;
> -       *out++ = uni & 0xff;
> -       *out++ = uni >> 8;
> -       return 2;
> -}
> -
> -static int char2uni(const unsigned char *rawstring, int boundlen, wchar_t *uni)
> -{
> -       if (boundlen < 2)
> -               return -EINVAL;
> -       *uni = (rawstring[1] << 8) | rawstring[0];
> -       return 2;
> -}
> -
> -static struct nls_table unicode_table = {
> -       .charset        = "unicode",
> -       .uni2char       = uni2char,
> -       .char2uni       = char2uni,
> -};
> -
> -/* ----------------------------------------------------------- */
> -
> -static int setcodepage(struct nls_table **p, char *name)
> -{
> -       struct nls_table *nls;
> -
> -       if (!name || !*name) {
> -               nls = NULL;
> -       } else if ( (nls = load_nls(name)) == NULL) {
> -               printk (KERN_ERR "smbfs: failed to load nls '%s'\n", name);
> -               return -EINVAL;
> -       }
> -
> -       /* if already set, unload the previous one. */
> -       if (*p && *p != &unicode_table)
> -               unload_nls(*p);
> -       *p = nls;
> -
> -       return 0;
> -}
> -
> -/* Handles all changes to codepage settings. */
> -int smb_setcodepage(struct smb_sb_info *server, struct smb_nls_codepage *cp)
> -{
> -       int n = 0;
> -
> -       smb_lock_server(server);
> -
> -       /* Don't load any nls_* at all, if no remote is requested */
> -       if (!*cp->remote_name)
> -               goto out;
> -
> -       /* local */
> -       n = setcodepage(&server->local_nls, cp->local_name);
> -       if (n != 0)
> -               goto out;
> -
> -       /* remote */
> -       if (!strcmp(cp->remote_name, "unicode")) {
> -               server->remote_nls = &unicode_table;
> -       } else {
> -               n = setcodepage(&server->remote_nls, cp->remote_name);
> -               if (n != 0)
> -                       setcodepage(&server->local_nls, NULL);
> -       }
> -
> -out:
> -       if (server->local_nls != NULL && server->remote_nls != NULL)
> -               server->ops->convert = convert_cp;
> -       else
> -               server->ops->convert = convert_memcpy;
> -
> -       smb_unlock_server(server);
> -       return n;
> -}
> -
> -
> -/*****************************************************************************/
> -/*                                                                           */
> -/*  Encoding/Decoding section                                                */
> -/*                                                                           */
> -/*****************************************************************************/
> -
> -static __u8 *
> -smb_encode_smb_length(__u8 * p, __u32 len)
> -{
> -       *p = 0;
> -       *(p+1) = 0;
> -       *(p+2) = (len & 0xFF00) >> 8;
> -       *(p+3) = (len & 0xFF);
> -       if (len > 0xFFFF)
> -       {
> -               *(p+1) = 1;
> -       }
> -       return p + 4;
> -}
> -
> -/*
> - * smb_build_path: build the path to entry and name storing it in buf.
> - * The path returned will have the trailing '\0'.
> - */
> -static int smb_build_path(struct smb_sb_info *server, unsigned char *buf,
> -                         int maxlen,
> -                         struct dentry *entry, struct qstr *name)
> -{
> -       unsigned char *path = buf;
> -       int len;
> -       int unicode = (server->mnt->flags & SMB_MOUNT_UNICODE) != 0;
> -
> -       if (maxlen < (2<<unicode))
> -               return -ENAMETOOLONG;
> -
> -       if (maxlen > SMB_MAXPATHLEN + 1)
> -               maxlen = SMB_MAXPATHLEN + 1;
> -
> -       if (entry == NULL)
> -               goto test_name_and_out;
> -
> -       /*
> -        * If IS_ROOT, we have to do no walking at all.
> -        */
> -       if (IS_ROOT(entry) && !name) {
> -               *path++ = '\\';
> -               if (unicode) *path++ = '\0';
> -               *path++ = '\0';
> -               if (unicode) *path++ = '\0';
> -               return path-buf;
> -       }
> -
> -       /*
> -        * Build the path string walking the tree backward from end to ROOT
> -        * and store it in reversed order [see reverse_string()]
> -        */
> -       dget(entry);
> -       spin_lock(&entry->d_lock);
> -       while (!IS_ROOT(entry)) {
> -               struct dentry *parent;
> -
> -               if (maxlen < (3<<unicode)) {
> -                       spin_unlock(&entry->d_lock);
> -                       dput(entry);
> -                       return -ENAMETOOLONG;
> -               }
> -
> -               len = server->ops->convert(path, maxlen-2,
> -                                     entry->d_name.name, entry->d_name.len,
> -                                     server->local_nls, server->remote_nls);
> -               if (len < 0) {
> -                       spin_unlock(&entry->d_lock);
> -                       dput(entry);
> -                       return len;
> -               }
> -               reverse_string(path, len);
> -               path += len;
> -               if (unicode) {
> -                       /* Note: reverse order */
> -                       *path++ = '\0';
> -                       maxlen--;
> -               }
> -               *path++ = '\\';
> -               maxlen -= len+1;
> -
> -               parent = entry->d_parent;
> -               dget(parent);
> -               spin_unlock(&entry->d_lock);
> -               dput(entry);
> -               entry = parent;
> -               spin_lock(&entry->d_lock);
> -       }
> -       spin_unlock(&entry->d_lock);
> -       dput(entry);
> -       reverse_string(buf, path-buf);
> -
> -       /* maxlen has space for at least one char */
> -test_name_and_out:
> -       if (name) {
> -               if (maxlen < (3<<unicode))
> -                       return -ENAMETOOLONG;
> -               *path++ = '\\';
> -               if (unicode) {
> -                       *path++ = '\0';
> -                       maxlen--;
> -               }
> -               len = server->ops->convert(path, maxlen-2,
> -                                     name->name, name->len,
> -                                     server->local_nls, server->remote_nls);
> -               if (len < 0)
> -                       return len;
> -               path += len;
> -               maxlen -= len+1;
> -       }
> -       /* maxlen has space for at least one char */
> -       *path++ = '\0';
> -       if (unicode) *path++ = '\0';
> -       return path-buf;
> -}
> -
> -static int smb_encode_path(struct smb_sb_info *server, char *buf, int maxlen,
> -                          struct dentry *dir, struct qstr *name)
> -{
> -       int result;
> -
> -       result = smb_build_path(server, buf, maxlen, dir, name);
> -       if (result < 0)
> -               goto out;
> -       if (server->opt.protocol <= SMB_PROTOCOL_COREPLUS)
> -               str_upper(buf, result);
> -out:
> -       return result;
> -}
> -
> -/* encode_path for non-trans2 request SMBs */
> -static int smb_simple_encode_path(struct smb_request *req, char **p,
> -                                 struct dentry * entry, struct qstr * name)
> -{
> -       struct smb_sb_info *server = req->rq_server;
> -       char *s = *p;
> -       int res;
> -       int maxlen = ((char *)req->rq_buffer + req->rq_bufsize) - s;
> -       int unicode = (server->mnt->flags & SMB_MOUNT_UNICODE);
> -
> -       if (!maxlen)
> -               return -ENAMETOOLONG;
> -       *s++ = 4;       /* ASCII data format */
> -
> -       /*
> -        * SMB Unicode strings must be 16bit aligned relative the start of the
> -        * packet. If they are not they must be padded with 0.
> -        */
> -       if (unicode) {
> -               int align = s - (char *)req->rq_buffer;
> -               if (!(align & 1)) {
> -                       *s++ = '\0';
> -                       maxlen--;
> -               }
> -       }
> -
> -       res = smb_encode_path(server, s, maxlen-1, entry, name);
> -       if (res < 0)
> -               return res;
> -       *p = s + res;
> -       return 0;
> -}
> -
> -/* The following are taken directly from msdos-fs */
> -
> -/* Linear day numbers of the respective 1sts in non-leap years. */
> -
> -static int day_n[] =
> -{0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 0, 0, 0, 0};
> -                 /* JanFebMarApr May Jun Jul Aug Sep Oct Nov Dec */
> -
> -
> -static time_t
> -utc2local(struct smb_sb_info *server, time_t time)
> -{
> -       return time - server->opt.serverzone*60;
> -}
> -
> -static time_t
> -local2utc(struct smb_sb_info *server, time_t time)
> -{
> -       return time + server->opt.serverzone*60;
> -}
> -
> -/* Convert a MS-DOS time/date pair to a UNIX date (seconds since 1 1 70). */
> -
> -static time_t
> -date_dos2unix(struct smb_sb_info *server, __u16 date, __u16 time)
> -{
> -       int month, year;
> -       time_t secs;
> -
> -       /* first subtract and mask after that... Otherwise, if
> -          date == 0, bad things happen */
> -       month = ((date >> 5) - 1) & 15;
> -       year = date >> 9;
> -       secs = (time & 31) * 2 + 60 * ((time >> 5) & 63) + (time >> 11) * 3600 + 86400 *
> -           ((date & 31) - 1 + day_n[month] + (year / 4) + year * 365 - ((year & 3) == 0 &&
> -                                                  month < 2 ? 1 : 0) + 3653);
> -       /* days since 1.1.70 plus 80's leap day */
> -       return local2utc(server, secs);
> -}
> -
> -
> -/* Convert linear UNIX date to a MS-DOS time/date pair. */
> -
> -static void
> -date_unix2dos(struct smb_sb_info *server,
> -             int unix_date, __u16 *date, __u16 *time)
> -{
> -       int day, year, nl_day, month;
> -
> -       unix_date = utc2local(server, unix_date);
> -       if (unix_date < 315532800)
> -               unix_date = 315532800;
> -
> -       *time = (unix_date % 60) / 2 +
> -               (((unix_date / 60) % 60) << 5) +
> -               (((unix_date / 3600) % 24) << 11);
> -
> -       day = unix_date / 86400 - 3652;
> -       year = day / 365;
> -       if ((year + 3) / 4 + 365 * year > day)
> -               year--;
> -       day -= (year + 3) / 4 + 365 * year;
> -       if (day == 59 && !(year & 3)) {
> -               nl_day = day;
> -               month = 2;
> -       } else {
> -               nl_day = (year & 3) || day <= 59 ? day : day - 1;
> -               for (month = 0; month < 12; month++)
> -                       if (day_n[month] > nl_day)
> -                               break;
> -       }
> -       *date = nl_day - day_n[month - 1] + 1 + (month << 5) + (year << 9);
> -}
> -
> -/* The following are taken from fs/ntfs/util.c */
> -
> -#define NTFS_TIME_OFFSET ((u64)(369*365 + 89) * 24 * 3600 * 10000000)
> -
> -/*
> - * Convert the NT UTC (based 1601-01-01, in hundred nanosecond units)
> - * into Unix UTC (based 1970-01-01, in seconds).
> - */
> -static struct timespec
> -smb_ntutc2unixutc(u64 ntutc)
> -{
> -       struct timespec ts;
> -       /* FIXME: what about the timezone difference? */
> -       /* Subtract the NTFS time offset, then convert to 1s intervals. */
> -       u64 t = ntutc - NTFS_TIME_OFFSET;
> -       ts.tv_nsec = do_div(t, 10000000) * 100;
> -       ts.tv_sec = t;
> -       return ts;
> -}
> -
> -/* Convert the Unix UTC into NT time */
> -static u64
> -smb_unixutc2ntutc(struct timespec ts)
> -{
> -       /* Note: timezone conversion is probably wrong. */
> -       /* return ((u64)utc2local(server, t)) * 10000000 + NTFS_TIME_OFFSET; */
> -       return ((u64)ts.tv_sec) * 10000000 + ts.tv_nsec/100 + NTFS_TIME_OFFSET;
> -}
> -
> -#define MAX_FILE_MODE  6
> -static mode_t file_mode[] = {
> -       S_IFREG, S_IFDIR, S_IFLNK, S_IFCHR, S_IFBLK, S_IFIFO, S_IFSOCK
> -};
> -
> -static int smb_filetype_to_mode(u32 filetype)
> -{
> -       if (filetype > MAX_FILE_MODE) {
> -               PARANOIA("Filetype out of range: %d\n", filetype);
> -               return S_IFREG;
> -       }
> -       return file_mode[filetype];
> -}
> -
> -static u32 smb_filetype_from_mode(int mode)
> -{
> -       if (S_ISREG(mode))
> -               return UNIX_TYPE_FILE;
> -       if (S_ISDIR(mode))
> -               return UNIX_TYPE_DIR;
> -       if (S_ISLNK(mode))
> -               return UNIX_TYPE_SYMLINK;
> -       if (S_ISCHR(mode))
> -               return UNIX_TYPE_CHARDEV;
> -       if (S_ISBLK(mode))
> -               return UNIX_TYPE_BLKDEV;
> -       if (S_ISFIFO(mode))
> -               return UNIX_TYPE_FIFO;
> -       if (S_ISSOCK(mode))
> -               return UNIX_TYPE_SOCKET;
> -       return UNIX_TYPE_UNKNOWN;
> -}
> -
> -
> -/*****************************************************************************/
> -/*                                                                           */
> -/*  Support section.                                                         */
> -/*                                                                           */
> -/*****************************************************************************/
> -
> -__u32
> -smb_len(__u8 * p)
> -{
> -       return ((*(p+1) & 0x1) << 16L) | (*(p+2) << 8L) | *(p+3);
> -}
> -
> -static __u16
> -smb_bcc(__u8 * packet)
> -{
> -       int pos = SMB_HEADER_LEN + SMB_WCT(packet) * sizeof(__u16);
> -       return WVAL(packet, pos);
> -}
> -
> -/* smb_valid_packet: We check if packet fulfills the basic
> -   requirements of a smb packet */
> -
> -static int
> -smb_valid_packet(__u8 * packet)
> -{
> -       return (packet[4] == 0xff
> -               && packet[5] == 'S'
> -               && packet[6] == 'M'
> -               && packet[7] == 'B'
> -               && (smb_len(packet) + 4 == SMB_HEADER_LEN
> -                   + SMB_WCT(packet) * 2 + smb_bcc(packet)));
> -}
> -
> -/* smb_verify: We check if we got the answer we expected, and if we
> -   got enough data. If bcc == -1, we don't care. */
> -
> -static int
> -smb_verify(__u8 * packet, int command, int wct, int bcc)
> -{
> -       if (SMB_CMD(packet) != command)
> -               goto bad_command;
> -       if (SMB_WCT(packet) < wct)
> -               goto bad_wct;
> -       if (bcc != -1 && smb_bcc(packet) < bcc)
> -               goto bad_bcc;
> -       return 0;
> -
> -bad_command:
> -       printk(KERN_ERR "smb_verify: command=%x, SMB_CMD=%x??\n",
> -              command, SMB_CMD(packet));
> -       goto fail;
> -bad_wct:
> -       printk(KERN_ERR "smb_verify: command=%x, wct=%d, SMB_WCT=%d??\n",
> -              command, wct, SMB_WCT(packet));
> -       goto fail;
> -bad_bcc:
> -       printk(KERN_ERR "smb_verify: command=%x, bcc=%d, SMB_BCC=%d??\n",
> -              command, bcc, smb_bcc(packet));
> -fail:
> -       return -EIO;
> -}
> -
> -/*
> - * Returns the maximum read or write size for the "payload". Making all of the
> - * packet fit within the negotiated max_xmit size.
> - *
> - * N.B. Since this value is usually computed before locking the server,
> - * the server's packet size must never be decreased!
> - */
> -static inline int
> -smb_get_xmitsize(struct smb_sb_info *server, int overhead)
> -{
> -       return server->opt.max_xmit - overhead;
> -}
> -
> -/*
> - * Calculate the maximum read size
> - */
> -int
> -smb_get_rsize(struct smb_sb_info *server)
> -{
> -       /* readX has 12 parameters, read has 5 */
> -       int overhead = SMB_HEADER_LEN + 12 * sizeof(__u16) + 2 + 1 + 2;
> -       int size = smb_get_xmitsize(server, overhead);
> -
> -       VERBOSE("xmit=%d, size=%d\n", server->opt.max_xmit, size);
> -
> -       return size;
> -}
> -
> -/*
> - * Calculate the maximum write size
> - */
> -int
> -smb_get_wsize(struct smb_sb_info *server)
> -{
> -       /* writeX has 14 parameters, write has 5 */
> -       int overhead = SMB_HEADER_LEN + 14 * sizeof(__u16) + 2 + 1 + 2;
> -       int size = smb_get_xmitsize(server, overhead);
> -
> -       VERBOSE("xmit=%d, size=%d\n", server->opt.max_xmit, size);
> -
> -       return size;
> -}
> -
> -/*
> - * Convert SMB error codes to -E... errno values.
> - */
> -int
> -smb_errno(struct smb_request *req)
> -{
> -       int errcls = req->rq_rcls;
> -       int error  = req->rq_err;
> -       char *class = "Unknown";
> -
> -       VERBOSE("errcls %d  code %d  from command 0x%x\n",
> -               errcls, error, SMB_CMD(req->rq_header));
> -
> -       if (errcls == ERRDOS) {
> -               switch (error) {
> -               case ERRbadfunc:
> -                       return -EINVAL;
> -               case ERRbadfile:
> -               case ERRbadpath:
> -                       return -ENOENT;
> -               case ERRnofids:
> -                       return -EMFILE;
> -               case ERRnoaccess:
> -                       return -EACCES;
> -               case ERRbadfid:
> -                       return -EBADF;
> -               case ERRbadmcb:
> -                       return -EREMOTEIO;
> -               case ERRnomem:
> -                       return -ENOMEM;
> -               case ERRbadmem:
> -                       return -EFAULT;
> -               case ERRbadenv:
> -               case ERRbadformat:
> -                       return -EREMOTEIO;
> -               case ERRbadaccess:
> -                       return -EACCES;
> -               case ERRbaddata:
> -                       return -E2BIG;
> -               case ERRbaddrive:
> -                       return -ENXIO;
> -               case ERRremcd:
> -                       return -EREMOTEIO;
> -               case ERRdiffdevice:
> -                       return -EXDEV;
> -               case ERRnofiles:
> -                       return -ENOENT;
> -               case ERRbadshare:
> -                       return -ETXTBSY;
> -               case ERRlock:
> -                       return -EDEADLK;
> -               case ERRfilexists:
> -                       return -EEXIST;
> -               case ERROR_INVALID_PARAMETER:
> -                       return -EINVAL;
> -               case ERROR_DISK_FULL:
> -                       return -ENOSPC;
> -               case ERROR_INVALID_NAME:
> -                       return -ENOENT;
> -               case ERROR_DIR_NOT_EMPTY:
> -                       return -ENOTEMPTY;
> -               case ERROR_NOT_LOCKED:
> -                       return -ENOLCK;
> -               case ERROR_ALREADY_EXISTS:
> -                       return -EEXIST;
> -               default:
> -                       class = "ERRDOS";
> -                       goto err_unknown;
> -               }
> -       } else if (errcls == ERRSRV) {
> -               switch (error) {
> -               /* N.B. This is wrong ... EIO ? */
> -               case ERRerror:
> -                       return -ENFILE;
> -               case ERRbadpw:
> -                       return -EINVAL;
> -               case ERRbadtype:
> -               case ERRtimeout:
> -                       return -EIO;
> -               case ERRaccess:
> -                       return -EACCES;
> -               /*
> -                * This is a fatal error, as it means the "tree ID"
> -                * for this connection is no longer valid. We map
> -                * to a special error code and get a new connection.
> -                */
> -               case ERRinvnid:
> -                       return -EBADSLT;
> -               default:
> -                       class = "ERRSRV";
> -                       goto err_unknown;
> -               }
> -       } else if (errcls == ERRHRD) {
> -               switch (error) {
> -               case ERRnowrite:
> -                       return -EROFS;
> -               case ERRbadunit:
> -                       return -ENODEV;
> -               case ERRnotready:
> -                       return -EUCLEAN;
> -               case ERRbadcmd:
> -               case ERRdata:
> -                       return -EIO;
> -               case ERRbadreq:
> -                       return -ERANGE;
> -               case ERRbadshare:
> -                       return -ETXTBSY;
> -               case ERRlock:
> -                       return -EDEADLK;
> -               case ERRdiskfull:
> -                       return -ENOSPC;
> -               default:
> -                       class = "ERRHRD";
> -                       goto err_unknown;
> -               }
> -       } else if (errcls == ERRCMD) {
> -               class = "ERRCMD";
> -       } else if (errcls == SUCCESS) {
> -               return 0;       /* This is the only valid 0 return */
> -       }
> -
> -err_unknown:
> -       printk(KERN_ERR "smb_errno: class %s, code %d from command 0x%x\n",
> -              class, error, SMB_CMD(req->rq_header));
> -       return -EIO;
> -}
> -
> -/* smb_request_ok: We expect the server to be locked. Then we do the
> -   request and check the answer completely. When smb_request_ok
> -   returns 0, you can be quite sure that everything went well. When
> -   the answer is <=0, the returned number is a valid unix errno. */
> -
> -static int
> -smb_request_ok(struct smb_request *req, int command, int wct, int bcc)
> -{
> -       int result;
> -
> -       req->rq_resp_wct = wct;
> -       req->rq_resp_bcc = bcc;
> -
> -       result = smb_add_request(req);
> -       if (result != 0) {
> -               DEBUG1("smb_request failed\n");
> -               goto out;
> -       }
> -
> -       if (smb_valid_packet(req->rq_header) != 0) {
> -               PARANOIA("invalid packet!\n");
> -               goto out;
> -       }
> -
> -       result = smb_verify(req->rq_header, command, wct, bcc);
> -
> -out:
> -       return result;
> -}
> -
> -/*
> - * This implements the NEWCONN ioctl. It installs the server pid,
> - * sets server->state to CONN_VALID, and wakes up the waiting process.
> - */
> -int
> -smb_newconn(struct smb_sb_info *server, struct smb_conn_opt *opt)
> -{
> -       struct file *filp;
> -       struct sock *sk;
> -       int error;
> -
> -       VERBOSE("fd=%d, pid=%d\n", opt->fd, current->pid);
> -
> -       smb_lock_server(server);
> -
> -       /*
> -        * Make sure we don't already have a valid connection ...
> -        */
> -       error = -EINVAL;
> -       if (server->state == CONN_VALID)
> -               goto out;
> -
> -       error = -EACCES;
> -       if (current->uid != server->mnt->mounted_uid &&
> -           !capable(CAP_SYS_ADMIN))
> -               goto out;
> -
> -       error = -EBADF;
> -       filp = fget(opt->fd);
> -       if (!filp)
> -               goto out;
> -       if (!smb_valid_socket(filp->f_path.dentry->d_inode))
> -               goto out_putf;
> -
> -       server->sock_file = filp;
> -       server->conn_pid = get_pid(task_pid(current));
> -       server->opt = *opt;
> -       server->generation += 1;
> -       server->state = CONN_VALID;
> -       error = 0;
> -
> -       if (server->conn_error) {
> -               /*
> -                * conn_error is the returncode we originally decided to
> -                * drop the old connection on. This message should be positive
> -                * and not make people ask questions on why smbfs is printing
> -                * error messages ...
> -                */
> -               printk(KERN_INFO "SMB connection re-established (%d)\n",
> -                      server->conn_error);
> -               server->conn_error = 0;
> -       }
> -
> -       /*
> -        * Store the server in sock user_data (Only used by sunrpc)
> -        */
> -       sk = SOCKET_I(filp->f_path.dentry->d_inode)->sk;
> -       sk->sk_user_data = server;
> -
> -       /* chain into the data_ready callback */
> -       server->data_ready = xchg(&sk->sk_data_ready, smb_data_ready);
> -
> -       /* check if we have an old smbmount that uses seconds for the
> -          serverzone */
> -       if (server->opt.serverzone > 12*60 || server->opt.serverzone < -12*60)
> -               server->opt.serverzone /= 60;
> -
> -       /* now that we have an established connection we can detect the server
> -          type and enable bug workarounds */
> -       if (server->opt.protocol < SMB_PROTOCOL_LANMAN2)
> -               install_ops(server->ops, &smb_ops_core);
> -       else if (server->opt.protocol == SMB_PROTOCOL_LANMAN2)
> -               install_ops(server->ops, &smb_ops_os2);
> -       else if (server->opt.protocol == SMB_PROTOCOL_NT1 &&
> -                (server->opt.max_xmit < 0x1000) &&
> -                !(server->opt.capabilities & SMB_CAP_NT_SMBS)) {
> -               /* FIXME: can we kill the WIN95 flag now? */
> -               server->mnt->flags |= SMB_MOUNT_WIN95;
> -               VERBOSE("detected WIN95 server\n");
> -               install_ops(server->ops, &smb_ops_win95);
> -       } else {
> -               /*
> -                * Samba has max_xmit 65535
> -                * NT4spX has max_xmit 4536 (or something like that)
> -                * win2k has ...
> -                */
> -               VERBOSE("detected NT1 (Samba, NT4/5) server\n");
> -               install_ops(server->ops, &smb_ops_winNT);
> -       }
> -
> -       /* FIXME: the win9x code wants to modify these ... (seek/trunc bug) */
> -       if (server->mnt->flags & SMB_MOUNT_OLDATTR) {
> -               server->ops->getattr = smb_proc_getattr_core;
> -       } else if (server->mnt->flags & SMB_MOUNT_DIRATTR) {
> -               server->ops->getattr = smb_proc_getattr_ff;
> -       }
> -
> -       /* Decode server capabilities */
> -       if (server->opt.capabilities & SMB_CAP_LARGE_FILES) {
> -               /* Should be ok to set this now, as no one can access the
> -                  mount until the connection has been established. */
> -               SB_of(server)->s_maxbytes = ~0ULL >> 1;
> -               VERBOSE("LFS enabled\n");
> -       }
> -       if (server->opt.capabilities & SMB_CAP_UNICODE) {
> -               server->mnt->flags |= SMB_MOUNT_UNICODE;
> -               VERBOSE("Unicode enabled\n");
> -       } else {
> -               server->mnt->flags &= ~SMB_MOUNT_UNICODE;
> -       }
> -#if 0
> -       /* flags we may test for other patches ... */
> -       if (server->opt.capabilities & SMB_CAP_LARGE_READX) {
> -               VERBOSE("Large reads enabled\n");
> -       }
> -       if (server->opt.capabilities & SMB_CAP_LARGE_WRITEX) {
> -               VERBOSE("Large writes enabled\n");
> -       }
> -#endif
> -       if (server->opt.capabilities & SMB_CAP_UNIX) {
> -               struct inode *inode;
> -               VERBOSE("Using UNIX CIFS extensions\n");
> -               install_ops(server->ops, &smb_ops_unix);
> -               inode = SB_of(server)->s_root->d_inode;
> -               if (inode)
> -                       inode->i_op = &smb_dir_inode_operations_unix;
> -       }
> -
> -       VERBOSE("protocol=%d, max_xmit=%d, pid=%d capabilities=0x%x\n",
> -               server->opt.protocol, server->opt.max_xmit,
> -               pid_nr(server->conn_pid), server->opt.capabilities);
> -
> -       /* FIXME: this really should be done by smbmount. */
> -       if (server->opt.max_xmit > SMB_MAX_PACKET_SIZE) {
> -               server->opt.max_xmit = SMB_MAX_PACKET_SIZE;
> -       }
> -
> -       smb_unlock_server(server);
> -       smbiod_wake_up();
> -       if (server->opt.capabilities & SMB_CAP_UNIX)
> -               smb_proc_query_cifsunix(server);
> -
> -       server->conn_complete++;
> -       wake_up_interruptible_all(&server->conn_wq);
> -       return error;
> -
> -out:
> -       smb_unlock_server(server);
> -       smbiod_wake_up();
> -       return error;
> -
> -out_putf:
> -       fput(filp);
> -       goto out;
> -}
> -
> -/* smb_setup_header: We completely set up the packet. You only have to
> -   insert the command-specific fields */
> -
> -__u8 *
> -smb_setup_header(struct smb_request *req, __u8 command, __u16 wct, __u16 bcc)
> -{
> -       __u32 xmit_len = SMB_HEADER_LEN + wct * sizeof(__u16) + bcc + 2;
> -       __u8 *p = req->rq_header;
> -       struct smb_sb_info *server = req->rq_server;
> -
> -       p = smb_encode_smb_length(p, xmit_len - 4);
> -
> -       *p++ = 0xff;
> -       *p++ = 'S';
> -       *p++ = 'M';
> -       *p++ = 'B';
> -       *p++ = command;
> -
> -       memset(p, '\0', 19);
> -       p += 19;
> -       p += 8;
> -
> -       if (server->opt.protocol > SMB_PROTOCOL_CORE) {
> -               int flags = SMB_FLAGS_CASELESS_PATHNAMES;
> -               int flags2 = SMB_FLAGS2_LONG_PATH_COMPONENTS |
> -                       SMB_FLAGS2_EXTENDED_ATTRIBUTES; /* EA? not really ... */
> -
> -               *(req->rq_header + smb_flg) = flags;
> -               if (server->mnt->flags & SMB_MOUNT_UNICODE)
> -                       flags2 |= SMB_FLAGS2_UNICODE_STRINGS;
> -               WSET(req->rq_header, smb_flg2, flags2);
> -       }
> -       *p++ = wct;             /* wct */
> -       p += 2 * wct;
> -       WSET(p, 0, bcc);
> -
> -       /* Include the header in the data to send */
> -       req->rq_iovlen = 1;
> -       req->rq_iov[0].iov_base = req->rq_header;
> -       req->rq_iov[0].iov_len  = xmit_len - bcc;
> -
> -       return req->rq_buffer;
> -}
> -
> -static void
> -smb_setup_bcc(struct smb_request *req, __u8 *p)
> -{
> -       u16 bcc = p - req->rq_buffer;
> -       u8 *pbcc = req->rq_header + SMB_HEADER_LEN + 2*SMB_WCT(req->rq_header);
> -
> -       WSET(pbcc, 0, bcc);
> -
> -       smb_encode_smb_length(req->rq_header, SMB_HEADER_LEN +
> -                             2*SMB_WCT(req->rq_header) - 2 + bcc);
> -
> -       /* Include the "bytes" in the data to send */
> -       req->rq_iovlen = 2;
> -       req->rq_iov[1].iov_base = req->rq_buffer;
> -       req->rq_iov[1].iov_len  = bcc;
> -}
> -
> -static int
> -smb_proc_seek(struct smb_sb_info *server, __u16 fileid,
> -             __u16 mode, off_t offset)
> -{
> -       int result;
> -       struct smb_request *req;
> -
> -       result = -ENOMEM;
> -       if (! (req = smb_alloc_request(server, 0)))
> -               goto out;
> -
> -       smb_setup_header(req, SMBlseek, 4, 0);
> -       WSET(req->rq_header, smb_vwv0, fileid);
> -       WSET(req->rq_header, smb_vwv1, mode);
> -       DSET(req->rq_header, smb_vwv2, offset);
> -       req->rq_flags |= SMB_REQ_NORETRY;
> -
> -       result = smb_request_ok(req, SMBlseek, 2, 0);
> -       if (result < 0) {
> -               result = 0;
> -               goto out_free;
> -       }
> -
> -       result = DVAL(req->rq_header, smb_vwv0);
> -out_free:
> -       smb_rput(req);
> -out:
> -       return result;
> -}
> -
> -static int
> -smb_proc_open(struct smb_sb_info *server, struct dentry *dentry, int wish)
> -{
> -       struct inode *ino = dentry->d_inode;
> -       struct smb_inode_info *ei = SMB_I(ino);
> -       int mode, read_write = 0x42, read_only = 0x40;
> -       int res;
> -       char *p;
> -       struct smb_request *req;
> -
> -       /*
> -        * Attempt to open r/w, unless there are no write privileges.
> -        */
> -       mode = read_write;
> -       if (!(ino->i_mode & (S_IWUSR | S_IWGRP | S_IWOTH)))
> -               mode = read_only;
> -#if 0
> -       /* FIXME: why is this code not in? below we fix it so that a caller
> -          wanting RO doesn't get RW. smb_revalidate_inode does some
> -          optimization based on access mode. tail -f needs it to be correct.
> -
> -          We must open rw since we don't do the open if called a second time
> -          with different 'wish'. Is that not supported by smb servers? */
> -       if (!(wish & (O_WRONLY | O_RDWR)))
> -               mode = read_only;
> -#endif
> -
> -       res = -ENOMEM;
> -       if (! (req = smb_alloc_request(server, PAGE_SIZE)))
> -               goto out;
> -
> -      retry:
> -       p = smb_setup_header(req, SMBopen, 2, 0);
> -       WSET(req->rq_header, smb_vwv0, mode);
> -       WSET(req->rq_header, smb_vwv1, aSYSTEM | aHIDDEN | aDIR);
> -       res = smb_simple_encode_path(req, &p, dentry, NULL);
> -       if (res < 0)
> -               goto out_free;
> -       smb_setup_bcc(req, p);
> -
> -       res = smb_request_ok(req, SMBopen, 7, 0);
> -       if (res != 0) {
> -               if (mode == read_write &&
> -                   (res == -EACCES || res == -ETXTBSY || res == -EROFS))
> -               {
> -                       VERBOSE("%s/%s R/W failed, error=%d, retrying R/O\n",
> -                               DENTRY_PATH(dentry), res);
> -                       mode = read_only;
> -                       req->rq_flags = 0;
> -                       goto retry;
> -               }
> -               goto out_free;
> -       }
> -       /* We should now have data in vwv[0..6]. */
> -
> -       ei->fileid = WVAL(req->rq_header, smb_vwv0);
> -       ei->attr   = WVAL(req->rq_header, smb_vwv1);
> -       /* smb_vwv2 has mtime */
> -       /* smb_vwv4 has size  */
> -       ei->access = (WVAL(req->rq_header, smb_vwv6) & SMB_ACCMASK);
> -       ei->open = server->generation;
> -
> -out_free:
> -       smb_rput(req);
> -out:
> -       return res;
> -}
> -
> -/*
> - * Make sure the file is open, and check that the access
> - * is compatible with the desired access.
> - */
> -int
> -smb_open(struct dentry *dentry, int wish)
> -{
> -       struct inode *inode = dentry->d_inode;
> -       int result;
> -       __u16 access;
> -
> -       result = -ENOENT;
> -       if (!inode) {
> -               printk(KERN_ERR "smb_open: no inode for dentry %s/%s\n",
> -                      DENTRY_PATH(dentry));
> -               goto out;
> -       }
> -
> -       if (!smb_is_open(inode)) {
> -               struct smb_sb_info *server = server_from_inode(inode);
> -               result = 0;
> -               if (!smb_is_open(inode))
> -                       result = smb_proc_open(server, dentry, wish);
> -               if (result)
> -                       goto out;
> -               /*
> -                * A successful open means the path is still valid ...
> -                */
> -               smb_renew_times(dentry);
> -       }
> -
> -       /*
> -        * Check whether the access is compatible with the desired mode.
> -        */
> -       result = 0;
> -       access = SMB_I(inode)->access;
> -       if (access != wish && access != SMB_O_RDWR) {
> -               PARANOIA("%s/%s access denied, access=%x, wish=%x\n",
> -                        DENTRY_PATH(dentry), access, wish);
> -               result = -EACCES;
> -       }
> -out:
> -       return result;
> -}
> -
> -static int
> -smb_proc_close(struct smb_sb_info *server, __u16 fileid, __u32 mtime)
> -{
> -       struct smb_request *req;
> -       int result = -ENOMEM;
> -
> -       if (! (req = smb_alloc_request(server, 0)))
> -               goto out;
> -
> -       smb_setup_header(req, SMBclose, 3, 0);
> -       WSET(req->rq_header, smb_vwv0, fileid);
> -       DSET(req->rq_header, smb_vwv1, utc2local(server, mtime));
> -       req->rq_flags |= SMB_REQ_NORETRY;
> -       result = smb_request_ok(req, SMBclose, 0, 0);
> -
> -       smb_rput(req);
> -out:
> -       return result;
> -}
> -
> -/*
> - * Win NT 4.0 has an apparent bug in that it fails to update the
> - * modify time when writing to a file. As a workaround, we update
> - * both modify and access time locally, and post the times to the
> - * server when closing the file.
> - */
> -static int
> -smb_proc_close_inode(struct smb_sb_info *server, struct inode * ino)
> -{
> -       struct smb_inode_info *ei = SMB_I(ino);
> -       int result = 0;
> -       if (smb_is_open(ino))
> -       {
> -               /*
> -                * We clear the open flag in advance, in case another
> -                * process observes the value while we block below.
> -                */
> -               ei->open = 0;
> -
> -               /*
> -                * Kludge alert: SMB timestamps are accurate only to
> -                * two seconds ... round the times to avoid needless
> -                * cache invalidations!
> -                */
> -               if (ino->i_mtime.tv_sec & 1) {
> -                       ino->i_mtime.tv_sec--;
> -                       ino->i_mtime.tv_nsec = 0;
> -               }
> -               if (ino->i_atime.tv_sec & 1) {
> -                       ino->i_atime.tv_sec--;
> -                       ino->i_atime.tv_nsec = 0;
> -               }
> -               /*
> -                * If the file is open with write permissions,
> -                * update the time stamps to sync mtime and atime.
> -                */
> -               if ((server->opt.capabilities & SMB_CAP_UNIX) == 0 &&
> -                   (server->opt.protocol >= SMB_PROTOCOL_LANMAN2) &&
> -                   !(ei->access == SMB_O_RDONLY))
> -               {
> -                       struct smb_fattr fattr;
> -                       smb_get_inode_attr(ino, &fattr)...
>
> [Message clipped]



-- 
Thanks,

Steve
