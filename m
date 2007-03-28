Return-Path: <linux-kernel-owner+w=401wt.eu-S1752032AbXC1GIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032AbXC1GIe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 02:08:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751326AbXC1GIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 02:08:34 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:12037 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbXC1GId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 02:08:33 -0400
X-IronPort-AV: i="4.14,336,1170651600"; 
   d="scan'208"; a="25688309:sNHT126968002"
Subject: Re: revoke: no revoke for nommu
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       bryan.wu@analog.com, dhowells@redhat.com, alan@lxorguk.ukuu.org.uk
In-Reply-To: <Pine.LNX.4.64.0703261512120.13921@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0703261512120.13921@sbz-30.cs.Helsinki.FI>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Wed, 28 Mar 2007 14:09:07 +0800
Message-Id: <1175062147.15391.14.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-26 at 15:12 +0300, Pekka J Enberg wrote:
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> There's just no sane way to revoke shared memory mappings for NOMMU so lets
> disable the thing completely when CONFIG_MMU=n.
> 
> Cc: Bryan Wu <bryan.wu@analog.com> 
> Cc: David Howells <dhowells@redhat.com>
> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> ---
>  fs/Makefile |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> Index: uml-2.6/fs/Makefile
> ===================================================================
> --- uml-2.6.orig/fs/Makefile	2007-03-26 15:08:42.000000000 +0300
> +++ uml-2.6/fs/Makefile	2007-03-26 15:09:03.000000000 +0300
> @@ -11,7 +11,7 @@ obj-y :=	open.o read_write.o file_table.
>  		attr.o bad_inode.o file.o filesystems.o namespace.o aio.o \
>  		seq_file.o xattr.o libfs.o fs-writeback.o \
>  		pnode.o drop_caches.o splice.o sync.o utimes.o \
> -		stack.o revoke.o revoked_inode.o
> +		stack.o
>  
>  ifeq ($(CONFIG_BLOCK),y)
>  obj-y +=	buffer.o bio.o block_dev.o direct-io.o mpage.o ioprio.o
> @@ -19,6 +19,7 @@ else
>  obj-y +=	no-block.o
>  endif
>  
> +obj-$(CONFIG_MMU)		+= revoke.o revoked_inode.o
>  obj-$(CONFIG_INOTIFY)		+= inotify.o
>  obj-$(CONFIG_INOTIFY_USER)	+= inotify_user.o
>  obj-$(CONFIG_EPOLL)		+= eventpoll.o

This solution is not completed in NOMMU.
at least ext2 fs can't find generic_file_revoke():

Log from 2.6.21-rc5-mm2
---
  LD      init/built-in.o
  LD      .tmp_vmlinux1
fs/built-in.o:(.rodata+0x2c1c): undefined reference to `generic_file_revoke'
make[1]: *** [.tmp_vmlinux1] Error 1
make[1]: Leaving directory `/opt/git-tree/linux-2.6'
make: *** [linux] Error 1

$ grep -r generic_file_revoke fs/
fs/ext2/file.c: .revoke         = generic_file_revoke,
Binary file fs/ext2/file.o matches
Binary file fs/ext2/ext2.o matches
Binary file fs/ext2/built-in.o matches
fs/ext3/file.c: .revoke         = generic_file_revoke,
fs/revoke.c:int generic_file_revoke(struct file *file)
fs/revoke.c:EXPORT_SYMBOL(generic_file_revoke);
fs/ext4/file.c: .revoke         = generic_file_revoke,
Binary file fs/built-in.o matches
_

Thanks
-Bryan Wu
