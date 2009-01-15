Return-Path: <linux-kernel-owner+w=401wt.eu-S1758948AbZAOQev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758948AbZAOQev (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 11:34:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752735AbZAOQen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 11:34:43 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:55625 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbZAOQem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 11:34:42 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: dedekind@infradead.org
Subject: Re: [PATCH] UBI: add ioctl compatibility
Date: Thu, 15 Jan 2009 17:34:23 +0100
User-Agent: KMail/1.9.9
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <1232036381.25068.10.camel@localhost.localdomain>
In-Reply-To: <1232036381.25068.10.camel@localhost.localdomain>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901151734.23870.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/PhNWn/Q1QOjiiSnIydvhygF7/RPVvepbpWUw
 RZ4RjbTJjAmc80W2n1E3lhMGsYGDz1kXlzDNgungtXFzMSH41b
 v9Osy6/wqdFniIbOuaYOg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 January 2009, Artem Bityutskiy wrote:

> would you please glance if this patch all-right?

No, it's not. New ioctl numbers should not be added to fs/compat_ioctl.c
but rather to the file that implements the file operations (ubi/cdev.c).

The best way to do it would be to add functions that do

static long compat_vol_cdev_ioctl(struct file *file,
		unsigned int cmd, unsigned long arg)
{
	int ret;

	arg = (unsigned long)compat_ptr(arg);

	lock_kernel();
	ret = vol_cdev_locked_ioctl(file->f_inode, file, cmd, arg);
	unlock_kernel();

	return ret;
}

static long vol_cdev_ioctl(struct file *file,
		unsigned int cmd, unsigned long arg)
{
	int ret;

	lock_kernel();
	ret = vol_cdev_locked_ioctl(file->f_inode, file, cmd, arg);
	unlock_kernel();

	return ret;
}

and then use these two functions as your unlocked_ioctl and compat_ioctl
methods in file_operations.

If you can prove that you don't rely on the BKL, you can also drop the
{un,}lock_kernel() calls.


>  COMPATIBLE_IOCTL(MEMGETREGIONINFO)
>  COMPATIBLE_IOCTL(MEMGETBADBLOCK)
>  COMPATIBLE_IOCTL(MEMSETBADBLOCK)
> +/* UBI */
> +COMPATIBLE_IOCTL(UBI_IOCMKVOL)
> +ULONG_IOCTL(UBI_IOCRMVOL)
> +COMPATIBLE_IOCTL(UBI_IOCRSVOL)
> +COMPATIBLE_IOCTL(UBI_IOCRNVOL)
> +COMPATIBLE_IOCTL(UBI_IOCATT)
> +ULONG_IOCTL(UBI_IOCDET)
> +ULONG_IOCTL(UBI_IOCVOLUP)
> +ULONG_IOCTL(UBI_IOCEBER)
> +ULONG_IOCTL(UBI_IOCEBCH)
> +ULONG_IOCTL(UBI_IOCEBMAP)
> +ULONG_IOCTL(UBI_IOCEBUNMAP)
> +ULONG_IOCTL(UBI_IOCEBISMAP)

ULONG_IOCTL() would be wrong here, all your ioctl handlers expect
a pointer, not an unsigned long

	Arnd <><
