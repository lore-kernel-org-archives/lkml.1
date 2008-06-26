Return-Path: <linux-kernel-owner+w=401wt.eu-S1759013AbYFZTGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759013AbYFZTGn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 15:06:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755289AbYFZTGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 15:06:33 -0400
Received: from mxl.seznam.cz ([77.75.72.44]:38894 "EHLO mxl.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755221AbYFZTGc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 15:06:32 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=beta; d=seznam.cz;
	h=Received:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Smtpd:X-Seznam-User:X-QM-Mark;
	b=Z34+VhPib2WOZpAxznJf0vf8w2kMgAzmpJeA94xWpV1jfDW0HHECX5d6gBHy6ZoOZ
	EQeJ12JEsMTd9D+5ScFwsx1p6saaFgWPUQ8ZyTE8jpCmEBIH19fNxQZmu8LvaQbeLT2
	1aqPcVP37bKFYX+pm51WJE6mRgx2FaYHon+ViXo=
Message-ID: <4863E8F2.5080608@seznam.cz>
Date: Thu, 26 Jun 2008 21:07:30 +0200
From: Michal Simek <monstr@seznam.cz>
Reply-To: monstr@seznam.cz
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, linuxppc-dev@ozlabs.org,
       vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk, hpa@zytor.com,
       Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH 58/60] microblaze_v4: sys_microblaze.c
References: <1214483429-32360-1-git-send-email-monstr@seznam.cz> <1214483429-32360-58-git-send-email-monstr@seznam.cz> <1214483429-32360-59-git-send-email-monstr@seznam.cz> <200806261748.30698.arnd@arndb.de>
In-Reply-To: <200806261748.30698.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
X-Smtpd: 1.1.1@13338
X-Seznam-User: monstr@seznam.cz
X-QM-Mark: email-qm2<174336182>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> +
>> +/*
>> + * sys_ipc() is the de-multiplexer for the SysV IPC calls..
>> + *
>> + * This is really horribly ugly.
>> + */
> 
> If it's so horribly ugly, don't do it this way ;-)

:-) this is not my part of code. I'll remove it with syscall changes.

>> +int
>> +sys_ipc(uint call, int first, int second, int third, void *ptr, long fifth)
>> +{
>> +	int version, ret;
>> +
>> +	version = call >> 16; /* hack for backward compatibility */
>> +	call &= 0xffff;
> 
> Backwards compatibility with what?

I don't know.
John: I suppose this is your comment.

>> +static inline unsigned long
>> +do_mmap2(unsigned long addr, size_t len,
>> +	unsigned long prot, unsigned long flags,
>> +	unsigned long fd, unsigned long pgoff)
>> +{
>> +	struct file *file = NULL;
>> +	int ret = -EBADF;
>> +
>> +	flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
>> +	if (!(flags & MAP_ANONYMOUS))
>> +		if (!(file = fget(fd))) {
>> +			printk(KERN_INFO "no fd in mmap\r\n");
>> +			goto out;
>> +		}
>> +
>> +	down_write(&current->mm->mmap_sem);
>> +	ret = do_mmap_pgoff(file, addr, len, prot, flags, pgoff);
>> +	up_write(&current->mm->mmap_sem);
>> +	if (file)
>> +		fput(file);
>> +out:
>> +	return ret;
>> +}
>> +
>> +unsigned long sys_mmap2(unsigned long addr, size_t len,
>> +			unsigned long prot, unsigned long flags,
>> +			unsigned long fd, unsigned long pgoff)
>> +{
>> +	return do_mmap2(addr, len, prot, flags, fd, pgoff);
>> +}
>> +
>> +unsigned long sys_mmap(unsigned long addr, size_t len,
>> +			unsigned long prot, unsigned long flags,
>> +			unsigned long fd, off_t offset)
>> +{
>> +	int err = -EINVAL;
>> +
>> +	if (offset & ~PAGE_MASK) {
>> +		printk(KERN_INFO "no pagemask in mmap\r\n");
>> +		goto out;
>> +	}
>> +
>> +	err = do_mmap2(addr, len, prot, flags, fd, offset >> PAGE_SHIFT);
>> +out:
>> +	return err;
>> +}
> 
> Which mmap is uClibc really using? I suppose you only need mmap2, even for
> compatibility with any binary ever built for microblaze.

I don't know. Microblaze should be compiled with uClibc and glibc. In case you
need mmap2 for uClibc and mmap for glibc it is ok.

M

> 	Arnd <><

