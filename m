Return-Path: <linux-kernel-owner+w=401wt.eu-S1757391AbYJPVDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391AbYJPVDW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 17:03:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754233AbYJPVDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 17:03:10 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:26196 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754232AbYJPVDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 17:03:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:references;
        b=Kc8PsyRFXxZP1/nor9iw+0Gr+XJ/mFxziSxlCMqhEbQ13O2Qiz/JiLGs275JY4F5m5
         ASyWJxbLHGTzwHwqa0bNmJ7t+pro0ouapz5BhFVmy5cjXXeLzGSPzsfuynzE6qVI6QrU
         HXnrgad+cf5GPRLzeoPX9FJ6ECGjEM8/IoCp4=
Message-ID: <c24352ca0810161403r1842185bg2f8b4f8c067af541@mail.gmail.com>
Date: Thu, 16 Oct 2008 14:03:06 -0700
From: "Jeff Schroeder" <jeffschroed@gmail.com>
Reply-To: jeffschroeder@computer.org
To: "Bodo Eggert" <7eggert@gmx.de>
Subject: Re: [PATCH] use tmpfs for rootfs v2
Cc: "Geert Uytterhoeven" <geert@linux-m68k.org>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LSU.0.999.0810161936590.5051@be1.lrz>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_131433_10735344.1224190986915"
References: <alpine.LSU.0.999.0810161400160.5456@be1.lrz>
	 <Pine.LNX.4.64.0810161507130.25933@anakin>
	 <alpine.LSU.0.999.0810161936590.5051@be1.lrz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_131433_10735344.1224190986915
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thu, Oct 16, 2008 at 10:39 AM, Bodo Eggert <7eggert@gmx.de> wrote:
> This patch allows chosing tmpfs instead of ramfs for the root filesystem.
> Having tmpfs is usefull for running systems from RAM, because it does not
> risk deadlocking the system and possibly allows swapping. Using tmpfs
> increases the kernel by 10 bytes on x86_64.
>
> Having tmpfs as the root filesystem allows you to get rid of the now unused
> ramfs and free some kernel memory. On my system, that's about 5198 bytes
> compared to having a ramfs root.
>
> Off cause you can mount tmpfs and move around the data, but this is slower
> (having to copy around the data), more error-prone and it uses more memory.
> Besides that, I don't see the point in explicitely doing the wrong thing
> and then having everybody fix it.
>
>
> Signed-off-by: Bodo Eggert <7eggert@gmx.de>
>
> ---
> Changes to v1: Include the change to the Makefile.
>
> Some numbers for my system: (from make and from size vmlinux)
>
> Setup is 10716 bytes (padded to 10752 bytes).
> System is 2659 kB
> text    data     bss     dec     hex filename
> 5341667  874212  562992 6778871  676ff7 vmlinux
>
> having TMPFS_IS_ROOT:
> Setup is 10716 bytes (padded to 10752 bytes).
> System is 2659 kB
> text    data     bss     dec     hex filename
> 5341677  874212  562992 6778881  677001 vmlinux
>    +10
>
> not having ramfs:
> Setup is 10716 bytes (padded to 10752 bytes).
> System is 2659 kB
> text    data     bss     dec     hex filename
> 5336733  873948  562992 6773673  675ba9 vmlinux
>  -4934    -264
>
>
>  fs/Kconfig       |   21 +++++++++++++++++++++
>  fs/Makefile      |    2 +-
>  fs/ramfs/inode.c |   39 +++++++++++++++++++++------------------
>  mm/shmem.c       |   26 ++++++++++++++++++++++++++
>  4 files changed, 69 insertions(+), 19 deletions(-)
>
> diff -pruNXdontdiff linux-2.6.27.2-numlock/fs/Kconfig linux-2.6.27.3-tmpfs/fs/Kconfig
> --- linux-2.6.27.2-numlock/fs/Kconfig   2008-10-10 13:18:34.000000000 +0200
> +++ linux-2.6.27.3-tmpfs/fs/Kconfig     2008-10-11 15:42:21.000000000 +0200
> @@ -953,6 +953,27 @@ config TMPFS_POSIX_ACL
>
>          If you don't know what Access Control Lists are, say N.
>
> +config TMPFS_ROOT
> +       bool "Use tmpfs instrad of ramfs for initramfs"
> +       depends on TMPFS && SHMEM
> +       default n
> +       help
> +         This replaces the ramfs used for unpacking the cpio images
> +         with tmpfs.
> +
> +         If unsure, say N
> +
> +config RAMFS
> +       bool "Ramfs file system support" if TMPFS_ROOT
> +       default y
> +       ---help---
> +         Ramfs is a file system which keeps all files in RAM. Unlike tmpfs,
> +         it cannot be swapped to disk, and it has the risk of deadlocking
> +         the system by using all memory.
> +
> +         Ramfs is used for booting the system and unpacking the cpio if
> +         TMPFS_ROOT is not set.
> +
>  config HUGETLBFS
>        bool "HugeTLB file system support"
>        depends on X86 || IA64 || PPC64 || SPARC64 || (SUPERH && MMU) || \
> diff -pruNXdontdiff linux-2.6.27.2-numlock/fs/ramfs/inode.c linux-2.6.27.3-tmpfs/fs/ramfs/inode.c
> --- linux-2.6.27.2-numlock/fs/ramfs/inode.c     2008-07-13 23:51:29.000000000 +0200
> +++ linux-2.6.27.3-tmpfs/fs/ramfs/inode.c       2008-10-11 15:50:03.000000000 +0200
> @@ -190,6 +190,13 @@ int ramfs_get_sb(struct file_system_type
>        return get_sb_nodev(fs_type, flags, data, ramfs_fill_super, mnt);
>  }
>
> +static struct file_system_type ramfs_fs_type = {
> +       .name           = "ramfs",
> +       .get_sb         = ramfs_get_sb,
> +       .kill_sb        = kill_litter_super,
> +};
> +
> +#ifndef CONFIG_TMPFS_ROOT
>  static int rootfs_get_sb(struct file_system_type *fs_type,
>        int flags, const char *dev_name, void *data, struct vfsmount *mnt)
>  {
> @@ -197,30 +204,12 @@ static int rootfs_get_sb(struct file_sys
>                            mnt);
>  }
>
> -static struct file_system_type ramfs_fs_type = {
> -       .name           = "ramfs",
> -       .get_sb         = ramfs_get_sb,
> -       .kill_sb        = kill_litter_super,
> -};
>  static struct file_system_type rootfs_fs_type = {
>        .name           = "rootfs",
>        .get_sb         = rootfs_get_sb,
>        .kill_sb        = kill_litter_super,
>  };
>
> -static int __init init_ramfs_fs(void)
> -{
> -       return register_filesystem(&ramfs_fs_type);
> -}
> -
> -static void __exit exit_ramfs_fs(void)
> -{
> -       unregister_filesystem(&ramfs_fs_type);
> -}
> -
> -module_init(init_ramfs_fs)
> -module_exit(exit_ramfs_fs)
> -
>  int __init init_rootfs(void)
>  {
>        int err;
> @@ -235,5 +224,19 @@ int __init init_rootfs(void)
>
>        return err;
>  }
> +#endif
> +
> +static int __init init_ramfs_fs(void)
> +{
> +       return register_filesystem(&ramfs_fs_type);
> +}
> +
> +static void __exit exit_ramfs_fs(void)
> +{
> +       unregister_filesystem(&ramfs_fs_type);
> +}
> +
> +module_init(init_ramfs_fs)
> +module_exit(exit_ramfs_fs)
>
>  MODULE_LICENSE("GPL");
> diff -pruNXdontdiff linux-2.6.27.2-numlock/mm/shmem.c linux-2.6.27.3-tmpfs/mm/shmem.c
> --- linux-2.6.27.2-numlock/mm/shmem.c   2008-10-10 13:18:47.000000000 +0200
> +++ linux-2.6.27.3-tmpfs/mm/shmem.c     2008-10-11 16:05:52.000000000 +0200
> @@ -2366,6 +2366,10 @@ static void init_once(void *foo)
>
>  static int init_inodecache(void)
>  {
> +#ifdef CONFIG_TMPFS_ROOT
> +       if (shmem_inode_cachep)
> +               return 0;
> +#endif
>        shmem_inode_cachep = kmem_cache_create("shmem_inode_cache",
>                                sizeof(struct shmem_inode_info),
>                                0, SLAB_PANIC, init_once);
> @@ -2583,6 +2587,28 @@ put_memory:
>        return ERR_PTR(error);
>  }
>
> +#ifdef CONFIG_TMPFS_ROOT
> +static int rootfs_get_sb(struct file_system_type *fs_type,
> +       int flags, const char *dev_name, void *data, struct vfsmount *mnt)
> +{
> +       return get_sb_nodev(fs_type, flags, data, shmem_fill_super, mnt);
> +}
> +
> +
> + static struct file_system_type rootfs_fs_type = {
> +       .name           = "rootfs",
> +       .get_sb         = rootfs_get_sb,
> +       .kill_sb        = kill_litter_super,
> + };
> +
> + int __init init_rootfs(void)
> + {
> +       if (init_inodecache())
> +               panic("Can't initialize shm inode cache");
> +       return register_filesystem(&rootfs_fs_type);
> + }
> + #endif
> +
>  /**
>  * shmem_zero_setup - setup a shared anonymous mapping
>  * @vma: the vma to be mmapped is prepared by do_mmap_pgoff
> diff -pruNXdontdiff linux-2.6.27.2-numlock/fs/Makefile linux-2.6.27.3-tmpfs/fs/Makefile
> --- linux-2.6.27.2-numlock/fs/Makefile  2008-10-16 19:25:20.000000000 +0200
> +++ linux-2.6.27.3-tmpfs/fs/Makefile    2008-10-16 19:24:00.000000000 +0200
> @@ -67,6 +67,7 @@ obj-$(CONFIG_PROFILING)               += dcookies.o
>  obj-$(CONFIG_DLM)              += dlm/
>
>  # Do not add any filesystems before this line
> +obj-$(CONFIG_RAMFS)             += ramfs/
>  obj-$(CONFIG_REISERFS_FS)      += reiserfs/
>  obj-$(CONFIG_EXT3_FS)          += ext3/ # Before ext2 so root fs can be ext3
>  obj-$(CONFIG_EXT4DEV_FS)       += ext4/ # Before ext2 so root fs can be ext4dev
> @@ -74,7 +75,6 @@ obj-$(CONFIG_JBD)             += jbd/
>  obj-$(CONFIG_JBD2)             += jbd2/
>  obj-$(CONFIG_EXT2_FS)          += ext2/
>  obj-$(CONFIG_CRAMFS)           += cramfs/
> -obj-y                          += ramfs/
>  obj-$(CONFIG_HUGETLBFS)                += hugetlbfs/
>  obj-$(CONFIG_CODA_FS)          += coda/
>  obj-$(CONFIG_MINIX_FS)         += minix/

Haven't gotten the hang of attaching patches inline using gmail yet.
Here is a patch ontop of the previous one that fixes whitespace problems
pointed out by checkpatch.pl. It is based on 2.7.27
3fa8749e584b55f1180411ab1b51117190bac1e5

It is also available here:
http://www.digitalprognosis.com/opensource/patches/linux-2.6/0001-Cleanup-the-whitespace-to-be-checkpatch-compliant.patch

-- 
Jeff Schroeder

Don't drink and derive, alcohol and analysis don't mix.
http://www.digitalprognosis.com

------=_Part_131433_10735344.1224190986915
Content-Type: text/x-diff;
 name=0001-Cleanup-the-whitespace-to-be-checkpatch-compliant.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fmdve5wo0
Content-Disposition: attachment;
 filename=0001-Cleanup-the-whitespace-to-be-checkpatch-compliant.patch

RnJvbSBlMWZlMGI4MTI5ZDE3NjljODM0YmZmNDI2MmJhYjM1NmU4ZDQ0NGJiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBKZWZmIFNjaHJvZWRlciA8amVmZnNjaHJvZWRlckBjb21wdXRl
ci5vcmc+CkRhdGU6IFRodSwgMTYgT2N0IDIwMDggMTM6NDc6MjAgLTA3MDAKU3ViamVjdDogW1BB
VENIXSBDbGVhbnVwIHRoZSB3aGl0ZXNwYWNlIHRvIGJlIGNoZWNrcGF0Y2ggY29tcGxpYW50CgpB
cHBsaWVzIG9udG9wIG9mOiBodHRwOi8vbGttbC5vcmcvbGttbC9kaWZmLzIwMDgvMTAvMTYvMzg4
LzEKU2lnbmVkLW9mZi1ieTogSmVmZiBTY2hyb2VkZXIgPGplZmZzY2hyb2VkZXJAY29tcHV0ZXIu
b3JnPgotLS0KIG1tL3NobWVtLmMgfCAgIDMwICsrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0t
LQogMSBmaWxlcyBjaGFuZ2VkLCAxNSBpbnNlcnRpb25zKCspLCAxNSBkZWxldGlvbnMoLSkKCmRp
ZmYgLS1naXQgYS9tbS9zaG1lbS5jIGIvbW0vc2htZW0uYwppbmRleCBhMWQyMDQyLi5kMWIzY2Q4
IDEwMDY0NAotLS0gYS9tbS9zaG1lbS5jCisrKyBiL21tL3NobWVtLmMKQEAgLTI1OTQsMjEgKzI1
OTQsMjEgQEAgc3RhdGljIGludCByb290ZnNfZ2V0X3NiKHN0cnVjdCBmaWxlX3N5c3RlbV90eXBl
ICpmc190eXBlLAogCXJldHVybiBnZXRfc2Jfbm9kZXYoZnNfdHlwZSwgZmxhZ3MsIGRhdGEsIHNo
bWVtX2ZpbGxfc3VwZXIsIG1udCk7CiB9CiAKLSAKLSBzdGF0aWMgc3RydWN0IGZpbGVfc3lzdGVt
X3R5cGUgcm9vdGZzX2ZzX3R5cGUgPSB7Ci0gCS5uYW1lCQk9ICJyb290ZnMiLAotIAkuZ2V0X3Ni
CQk9IHJvb3Rmc19nZXRfc2IsCi0gCS5raWxsX3NiCT0ga2lsbF9saXR0ZXJfc3VwZXIsCi0gfTsK
LSAKLSBpbnQgX19pbml0IGluaXRfcm9vdGZzKHZvaWQpCi0gewotIAlpZiAoaW5pdF9pbm9kZWNh
Y2hlKCkpCi0gCQlwYW5pYygiQ2FuJ3QgaW5pdGlhbGl6ZSBzaG0gaW5vZGUgY2FjaGUiKTsKLSAJ
cmV0dXJuIHJlZ2lzdGVyX2ZpbGVzeXN0ZW0oJnJvb3Rmc19mc190eXBlKTsKLSB9Ci0gI2VuZGlm
Ci0gCisKK3N0YXRpYyBzdHJ1Y3QgZmlsZV9zeXN0ZW1fdHlwZSByb290ZnNfZnNfdHlwZSA9IHsK
KwkubmFtZQkJPSAicm9vdGZzIiwKKwkuZ2V0X3NiCQk9IHJvb3Rmc19nZXRfc2IsCisJLmtpbGxf
c2IJPSBraWxsX2xpdHRlcl9zdXBlciwKK307CisKK2ludCBfX2luaXQgaW5pdF9yb290ZnModm9p
ZCkKK3sKKwlpZiAoaW5pdF9pbm9kZWNhY2hlKCkpCisJCXBhbmljKCJDYW4ndCBpbml0aWFsaXpl
IHNobSBpbm9kZSBjYWNoZSIpOworCXJldHVybiByZWdpc3Rlcl9maWxlc3lzdGVtKCZyb290ZnNf
ZnNfdHlwZSk7Cit9CisjZW5kaWYKKwogLyoqCiAgKiBzaG1lbV96ZXJvX3NldHVwIC0gc2V0dXAg
YSBzaGFyZWQgYW5vbnltb3VzIG1hcHBpbmcKICAqIEB2bWE6IHRoZSB2bWEgdG8gYmUgbW1hcHBl
ZCBpcyBwcmVwYXJlZCBieSBkb19tbWFwX3Bnb2ZmCi0tIAoxLjUuNC4zCgo=
------=_Part_131433_10735344.1224190986915--
