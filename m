Return-Path: <linux-kernel-owner+w=401wt.eu-S1756947AbZCaS3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756947AbZCaS3p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 14:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751019AbZCaS3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 14:29:34 -0400
Received: from mail-qy0-f118.google.com ([209.85.221.118]:56317 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbZCaS3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 14:29:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MpQBI/7k8aFvd/BQVLN4grFTPiyS4I5Kx1gPQPxzxP2fipWnB2vtde3gwziK3r4atz
         gVGKu0m/xN+57Pv8gyV14YXql5ER1kEhatFxvL3VJMf8SMSYMGi+UhtEpADTmBpsacsz
         EuWnlGCKGwfEzgVzTcnONujbAmtSh44yxYV/s=
MIME-Version: 1.0
In-Reply-To: <200903311251.04746.arnd@arndb.de>
References: <a95a62fe0903301814k75ce56f5xef0a04c5c188012@mail.gmail.com>
	 <200903311251.04746.arnd@arndb.de>
Date: Tue, 31 Mar 2009 11:29:31 -0700
Message-ID: <a95a62fe0903311129g7ecf6997k2f06f6d9a2abe2c@mail.gmail.com>
Subject: Re: [PATCHv4] MTD: New ioctl calls for >4GiB device support
From: Kevin Cernekee <kpc.mtd@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org,
       linux-mtd@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 31, 2009 at 3:51 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 31 March 2009, Kevin Cernekee wrote:
>> +struct mtd_oob_buf64 {
>> +       uint64_t start;
>> +       uint32_t res0;
>> +       uint32_t length;
>> +       unsigned char __user *ptr;
>> +       uint32_t res1[8];
>> +};
>
> Does this have to use an indirect pointer? We normally try to avoid
> ioctl interfaces like this, because they are hard to trace and you
> need a compat wrapper. You might be able to at least avoid the wrapper
> by defining the data structure with a __u64 to take the pointer.

Could you please point out another ioctl that is set up this way, so
that I can follow the same conventions?

Are we ever worried about pointers that are larger than 64 bits, or
ints that are larger than 32 bits?  Or is it generally OK to assume
this will never happen?

> If you leave the data structure the way it is, you should at least
> move the compat_ioctl handling into mtdchar.c from compat_ioctl.c.
> It will simplify your code and help reduce the size of the common
> ioctl handling.

Is this what you are recommending?

1) Leave existing MTD COMPATIBLE_IOCTLs in fs/compat_ioctl.c

2) Implement compat_ioctl handler in mtdchar.c for MEMREADOOB64_32 and
MEMWRITEOOB64_32

3) For all other commands, the new handler should return -ENOIOCTLCMD
and let fs/compat_ioctl.c handle them

Would it be a good idea to move MTDREADOOB32 / MEMWRITEOOB32 out of
fs/compat_ioctl.c at the same time, so that everything is in one
place?

If the compat wrappers are moved to mtdchar.c , does that imply that
they should be reimplemented "natively" instead of using
compat_alloc_user_space(), copy_in_user(), and sys_ioctl() to cause
them to reinvoke the 64-bit versions?

Thanks.
