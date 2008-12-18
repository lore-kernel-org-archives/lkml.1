Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752875AbYLRMfE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875AbYLRMfE (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 07:35:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751575AbYLRMeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 07:34:50 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:64027 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbYLRMet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 07:34:49 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: [PATCH v4 2/3] Add preadv and pwritev system calls.
Date: Thu, 18 Dec 2008 13:34:33 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-api@vger.kernel.org, aarcange@redhat.com
References: <1229600542-11585-1-git-send-email-kraxel@redhat.com> <1229600542-11585-3-git-send-email-kraxel@redhat.com>
In-Reply-To: <1229600542-11585-3-git-send-email-kraxel@redhat.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812181334.33719.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19cE34Eqc6eiqAQBE8uLvHm+idlPgIWhWTND6Q
 pHiBfpfA8Rm40hL4/f4WkKZPPPer8BgY50us8ad9nGssbKwOLZ
 fplH6nSl61XfrZbO04FUA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 December 2008, Gerd Hoffmann wrote:
> This prototype has one problem though:  On 32bit archs is the (64bit)
> offset argument unaligned, which the syscall ABI of several archs
> doesn't allow to do.  At least s390 needs a wrapper in glibc to handle
> this.  As we'll need a wrappers in glibc anyway I've decided to push
> problem to glibc entriely and use a syscall prototype which works
> without arch-specific wrappers inside the kernel:  The offset argument
> is explicitly splitted into two 32bit values.

Obviously, the interface looks good to me now.

Please remember to add the function prototypes to
include/linux/syscalls.h.

> +asmlinkage ssize_t
> +compat_sys_preadv(unsigned long fd, const struct compat_iovec __user *vec,
> +                  unsigned long vlen, u32 pos_high, u32 pos_low)
> +{
> +        loff_t pos = ((loff_t)pos_high << 32) | pos_low;

This is whitespace damaged, as are the other four functions in the
same place.

> +	struct file *file;
> +	ssize_t ret = -EBADF;
> +
> +	if (pos < 0)
> +		return -EINVAL;
> +
> +	file = fget(fd);
> +	if (!file)
> +		return -EBADF;

Any reason for using fget() here, but fget_light() in sys_preadv?

> +	if (!(file->f_mode & FMODE_READ))
> +		goto out;
> +
> +	ret = -EINVAL;
> +	if (!file->f_op || (!file->f_op->aio_read && !file->f_op->read))
> +		goto out;

Maybe this logic could get moved into a compat_readv() function,
similar to vfs_readv(). The advantage would be that we can make
the native and compat paths more similar.

	Arnd <><
