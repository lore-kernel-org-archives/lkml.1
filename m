Return-Path: <linux-kernel-owner+w=401wt.eu-S1757551AbYFZPti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551AbYFZPti (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 11:49:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752567AbYFZPt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 11:49:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:63914 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189AbYFZPt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 11:49:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@seznam.cz
Subject: Re: [PATCH 58/60] microblaze_v4: sys_microblaze.c
Date: Thu, 26 Jun 2008 17:48:29 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, linuxppc-dev@ozlabs.org,
       vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk, hpa@zytor.com,
       Michal Simek <monstr@monstr.eu>
References: <1214483429-32360-1-git-send-email-monstr@seznam.cz> <1214483429-32360-58-git-send-email-monstr@seznam.cz> <1214483429-32360-59-git-send-email-monstr@seznam.cz>
In-Reply-To: <1214483429-32360-59-git-send-email-monstr@seznam.cz>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806261748.30698.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18G9neEH5WDobakhBTZmbFEnidRREyXql6of9R
 34MgkwPKr21a1fzA839ITRpciRBOKGh//57KUnjp3dkwp+JoxL
 5rIMAnkR10qbjtIDaT5iQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 June 2008, monstr@seznam.cz wrote:
> +
> +/*
> + * sys_ipc() is the de-multiplexer for the SysV IPC calls..
> + *
> + * This is really horribly ugly.
> + */

If it's so horribly ugly, don't do it this way ;-)

> +int
> +sys_ipc(uint call, int first, int second, int third, void *ptr, long fifth)
> +{
> +	int version, ret;
> +
> +	version = call >> 16; /* hack for backward compatibility */
> +	call &= 0xffff;

Backwards compatibility with what?


> +static inline unsigned long
> +do_mmap2(unsigned long addr, size_t len,
> +	unsigned long prot, unsigned long flags,
> +	unsigned long fd, unsigned long pgoff)
> +{
> +	struct file *file = NULL;
> +	int ret = -EBADF;
> +
> +	flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
> +	if (!(flags & MAP_ANONYMOUS))
> +		if (!(file = fget(fd))) {
> +			printk(KERN_INFO "no fd in mmap\r\n");
> +			goto out;
> +		}
> +
> +	down_write(&current->mm->mmap_sem);
> +	ret = do_mmap_pgoff(file, addr, len, prot, flags, pgoff);
> +	up_write(&current->mm->mmap_sem);
> +	if (file)
> +		fput(file);
> +out:
> +	return ret;
> +}
> +
> +unsigned long sys_mmap2(unsigned long addr, size_t len,
> +			unsigned long prot, unsigned long flags,
> +			unsigned long fd, unsigned long pgoff)
> +{
> +	return do_mmap2(addr, len, prot, flags, fd, pgoff);
> +}
> +
> +unsigned long sys_mmap(unsigned long addr, size_t len,
> +			unsigned long prot, unsigned long flags,
> +			unsigned long fd, off_t offset)
> +{
> +	int err = -EINVAL;
> +
> +	if (offset & ~PAGE_MASK) {
> +		printk(KERN_INFO "no pagemask in mmap\r\n");
> +		goto out;
> +	}
> +
> +	err = do_mmap2(addr, len, prot, flags, fd, offset >> PAGE_SHIFT);
> +out:
> +	return err;
> +}

Which mmap is uClibc really using? I suppose you only need mmap2, even for
compatibility with any binary ever built for microblaze.

	Arnd <><
