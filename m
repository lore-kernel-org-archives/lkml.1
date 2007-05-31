Return-Path: <linux-kernel-owner+w=401wt.eu-S1758745AbXEaHHQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758745AbXEaHHQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 03:07:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755846AbXEaHHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 03:07:04 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:59440 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755552AbXEaHHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 03:07:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Michal Marek <mmarek@suse.cz>
Subject: Re: [patch 3/3] Fix XFS_IOC_FSBULKSTAT{,_SINGLE} and XFS_IOC_FSINUMBERS in compat mode
Date: Thu, 31 May 2007 09:06:49 +0200
User-Agent: KMail/1.9.6
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org
References: <20070530125954.706423971@suse.cz> <20070530143044.060544510@suse.cz>
In-Reply-To: <20070530143044.060544510@suse.cz>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705310906.50434.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+9P4TcH7DVdMb+R8mU/rjkJkPWTSZloTTFace
 X2Vi89dI2fHJeJHQUNHybyc72UzwEYtNL+mDdSw1u2FX0G/vyj
 jKvuKyuX6Y3AclwrpAFAw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 May 2007, Michal Marek wrote:
> --- linux-2.6.orig/fs/xfs/linux-2.6/xfs_ioctl32.c
> +++ linux-2.6/fs/xfs/linux-2.6/xfs_ioctl32.c
> @@ -109,35 +109,249 @@ STATIC unsigned long xfs_ioctl32_geom_v1
>  	return (unsigned long)p;
>  }
>  
> -#else
> +typedef struct xfs_inogrp32 {
> +	__u64		xi_startino;	/* starting inode number	*/
> +	__s32		xi_alloccount;	/* # bits set in allocmask	*/
> +	__u64		xi_allocmask;	/* mask of allocated inodes	*/
> +} __attribute__((packed)) xfs_inogrp32_t;

__attribute__((packed)) isn't entirely correct here. You don't really
want to have the whole structure to have byte alignment, you only
want to reduce the alignment o fthe 64 bit members to 32 bit.

It would be more appropriate to define a separate type

#if defined(__x86_64__) || defined(__ia64__)
typedef unsigned long long __compat_u64 __attribute__((aligned(4)));
#else
typedef unsigned long long __compat_u64;
#endif

and use that in the data structures.

> +STATIC int xfs_inogrp_store_compat(
> +	xfs_inogrp32_t __user  *p32,
> +	xfs_inogrp_t __user *p)
> +{
> +#define copy(memb) copy_in_user(&p32->memb, &p->memb, sizeof(p32->memb))
> +	if (copy(xi_startino) ||
> +	    copy(xi_alloccount) ||
> +	    copy(xi_allocmask))
> +		return -EFAULT;
> +	return 0;
> +#undef copy
> +}

Your copy() operation looks really dangerous, it will break as soon as someone
tries to use it on a member that is actually variable length, like a pointer.
A better way would be

#define move_user(p32, p64, memb) ({ \
	typeof(p32->memb) data; \
	get_user(data, &p64->memb) || \
	put_user(data, &p32->memb); \
})

Actually, even better would be not to use the compat_alloc_userspace trick
at all, but to just interpret the 32 bit data structure directly in the
implementation instead of converting it to the 64 bit structure, whereever
that's possible.

	Arnd <><
