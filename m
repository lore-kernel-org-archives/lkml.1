Return-Path: <linux-kernel-owner+w=401wt.eu-S1753362AbYKYJpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362AbYKYJpq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 04:45:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753113AbYKYJpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 04:45:34 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:50077 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899AbYKYJpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 04:45:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=HJ8NrafA9EJiE1qkR3uBBQUOK3KYvBZyhgEFdzZe2xINXhd+z1EgmK/JEmMP+cfKH5
         3FiVkfPJQ57t8HCBTkCBUUA7DvBK8Ao9rrEfjYCSX1JaXK2QoWnLDDVeHYLDzxmW4wmF
         2wjNkFZxMnvamncmiMlNyw/UNlVid6QT0rjhQ=
Message-ID: <ac9c93b10811250145u5742f75as893d99ebe6a1ab05@mail.gmail.com>
Date: Tue, 25 Nov 2008 10:45:30 +0100
From: "Frans Meulenbroeks" <fransmeulenbroeks@gmail.com>
To: linux-kernel@vger.kernel.org, dwmw2@infradead.org, rob@landley.ne
Subject: Re: [PATCH] create option to compress initramfs within the kernel
In-Reply-To: <ac9c93b10811250143u3763a810g1c6211ba9afef531@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.DEB.1.00.0811221817560.3675@frans-desktop>
	 <200811221932.12518.rob@landley.net>
	 <ac9c93b10811250143u3763a810g1c6211ba9afef531@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dang. Did a reply instead of a reply all. Here it is again now also to
lkml and dwmw2.

2008/11/23 Rob Landley <rob@landley.net>:

>> Rationale is that if you create a compressed kernel image (e.g. by
>> make bzImage) it is not very efficient and useful to compress initramfs
>> as the initramfs will be compressed anyway when the kernel image is
>> compressed.
>
> Actually it saves intermediate space (the cpio archive and the decompressed
> ramfs coexist during the decompression, until the kernel can free the cpio
> archive), so it does serve a purpose.  (Given cache effects leaving it
> compressed may actually wind up being faster on modern CPUs because it dirties
> fewer pages.)
>
> It also eats CPU, which is at more of a premium than memory on some little
> battery powered wind-up boxes.  But I'd be happier seeing some actual
> benchmark numbers on a device that would actually _notice_ this change.

I agree that a compressed initramfs image saves intermediate RAM
space. If one cannot afford to use this temporary space, then a
compressed initramfs is definitely better.
Double compression definitely eats CPU. I did not bench the
compression part alone.but I'll try to find some time to bench it in
more detail. Of course it also depends on the size of the initramfs.
For a 300k initramfs this is not going to make much of a difference.
However we once turned our 20MB or so squashfs image into initramfs
and it took about 1.5 seconds to decompress and populate the buffer
cache. (20MB is compressed, uncomressed it is around 50M) (I do not
have exact figures handy, but this is what I recall). CPU is a 180 Mhz
or so MIPS.

>
>> @@ -257,6 +258,9 @@ while [ $# -gt 0 ]; do
>>                       default_list="$arg"
>>                       ${dep_list}default_initramfs
>>                       ;;
>> +             "-c")   # compress
>> +                     compress=1
>> +                     ;;
>
> You're changing the default behavior for people who run this script directly.
> Just FYI.

Do they exist? Actually I went for -c because it is mnemonically easy
to say that c is for compress. If there are better suggestions for an
option that does not compress,. I am more than happy to change things.
(I don't really like things like -n for nocompress).;

>
>> --- a/usr/Kconfig
>> +++ b/usr/Kconfig
>> @@ -44,3 +44,14 @@ config INITRAMFS_ROOT_GID
>>         owned by group root in the initial ramdisk image.
>>
>>         If you are not sure, leave it set to "0".
>> +
>> +config INITRAMFS_COMPRESS
>> +     bool "Compress initramfs image"
>> +     default y
>> +     help
>> +       If you want a compressed initramfs image in your kernel say y
>> +       If you do not want your initramfs image to be compressed say n.
>> +       A compressed initramfs is generally not useful if you also have a
>> +       compressed kernel (vmlinuz, bzImage).
>
> This should probably be in the CONFIG_EMBEDDED menu.

Can be done, but to me it felt it would be better to keep things
together, hence I added to usr/Kconfig.
Is there a policy on this? David, as embedded maintainer, do you have
an opinion?

Thanks for your feedback! Frans.
