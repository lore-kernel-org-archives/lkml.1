Return-Path: <linux-kernel-owner+w=401wt.eu-S1754658AbZGBUc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658AbZGBUc0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 16:32:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754082AbZGBUcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 16:32:16 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:38865 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706AbZGBUcP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 16:32:15 -0400
MIME-Version: 1.0
In-Reply-To: <20090702181031.GB4122@nb.net.home>
References: <20090702181031.GB4122@nb.net.home>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 2 Jul 2009 22:32:01 +0200
Message-ID: <ac3eb2510907021332l2d0c1908s19d01c994f42b549@mail.gmail.com>
Subject: Re: [ANNOUNCE] util-linux-ng v2.16-rc2
To: Karel Zak <kzak@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       util-linux-ng@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 2, 2009 at 20:10, Karel Zak<kzak@redhat.com> wrote:
>
> The second util-linux-ng 2.16 release candidate is available at
>
>   ftp://ftp.kernel.org/pub/linux/utils/util-linux-ng/v2.16/
>
> Feedback and bug reports, as always, are welcomed.

It builds fine on the host, but fails to build in a clean chroot:

The hack with moving the devel files around to /usr with an install
hook breaks the values stored in the libblkid.la file and relinking
fails, because the lib devel files are now no longer in /lib but
(silently) moved to /usr/lib:

libtool: relink: gcc -std=gnu99 -shared  .libs/cache.o .libs/dev.o
.libs/devname.o .libs/devno.o .libs/getsize.o .libs/llseek.o
.libs/probe.o .libs/read.o .libs/resolve.o .libs/save.o .libs/tag.o
.libs/version.o .libs/verify.o .libs/encode.o .libs/config.o
.libs/evaluate.o .libs/blkdev.o .libs/linux_version.o
.libs/canonicalize.o .libs/md5.o  -Wl,--whole-archive
probers/.libs/libblkid_probers.a -Wl,--no-whole-archive
-L/var/tmp/util-linux-2.16-build/lib64 -L/lib64 -luuid
-Wl,--version-script=../../../shlibs/blkid/src/blkid.sym   -Wl,-soname
-Wl,libblkid.so.1 -o .libs/libblkid.so.1.0.0
/usr/lib64/gcc/x86_64-suse-linux/4.4/../../../../x86_64-suse-linux/bin/ld:
cannot find -luuid
collect2: ld returned 1 exit status

That the .so is installed in the root is really the implementation
detail that should be hidden from anything but the ld loader on the
system. I guess, we want to keep the original --libdir value, and use
a --rootlibdir as it's own parameter, or something similar, and just
move the .so image to the root with the install hook (or the spec
file), instead of moving the devel stuff, faking the .pc files and
patching the .la files. :)

Thanks,
Kay
