Return-Path: <linux-kernel-owner+w=401wt.eu-S932841AbXBXQfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932841AbXBXQfY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 11:35:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932617AbXBXQfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 11:35:24 -0500
Received: from marvin.h-e-r-e-s-y.com ([87.106.62.5]:48264 "EHLO
	marvin.h-e-r-e-s-y.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279AbXBXQfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 11:35:23 -0500
From: Andrew Walrond <andrew@walrond.org>
To: sparclinux@vger.kernel.org
Subject: Re: (Sparc64) 2.6.20 seems to ignore initramfs
Date: Sat, 24 Feb 2007 16:35:20 +0000
User-Agent: KMail/1.9.5
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Tomasz Chmielewski <mangoo@wpkg.org>, linux-kernel@vger.kernel.org
References: <200702231108.10185.andrew@walrond.org> <200702231547.24667.andrew@walrond.org> <Pine.LNX.4.61.0702241622150.16527@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0702241622150.16527@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702241635.21005.andrew@walrond.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 24 February 2007 15:23, Jan Engelhardt wrote:
> On Feb 23 2007 15:47, Andrew Walrond wrote:
> >
> >I have tracked this down to a broken version of gnu cpio (latest release,
> > 2.7) which was used to create the initramfs archive. Bloody annoying
> > since this has bitten me before! Last time I even sent the maintainer a
> > bug report, and apparently a fix is in CVS waiting for the next release.
> > Ho hum.
>
> Forgot the -c flag, right?
>

No, I use '-H newc' as per the instrucions in 
Documentation/filesystems/ramfs-rootfs-initramfs.txt. Does -c do the same 
thing? [checks man cpio...]

But there is a real bug in cpio 2.7 which can break the archive. Its been 
fixed in cpio cvs awaiting the next release.

My report to the cpio ML:

Hello list,

I've been experimenting with large (500Mb) initramfs cpio archives on 
linux, x86_64, using cpio 2.7, compiled 64bit with gcc4.1.1.

If I create a cpio archive, then extract it and compare with the 
original, I see broken symlinks.

I don't know if the archives themselves are corrupt, or whether the 
extraction code is broken, but I guess you guys can work that out.

An example:

root@orac initramfs $ cd rootfs
root@orac rootfs $ find . | cpio -o -H newc > ../rootfs.cpio
857030 blocks
root@orac rootfs $ cd ..
root@orac initramfs $ mkdir tmp
root@orac initramfs $ cd tmp
root@orac tmp $ cpio -i -d -H newc -F ../rootfs.cpio --no-absolute-filenames
857030 blocks
root@orac tmp $ ll ../rootfs/pkg/linux/lib/modules/2.6.19.2/
total 1.1M
lrwxrwxrwx  1 root root   17 Jan 11 13:39 build -> /pkg/linux/source
drwxrwxr-x 11 root root 4.0K Jan 11 11:14 kernel
-rw-rw-r--  1 root root 229K Jan 11 11:14 modules.alias
-rw-rw-r--  1 root root   69 Jan 11 11:14 modules.ccwmap
-rw-rw-r--  1 root root 246K Jan 11 11:14 modules.dep
-rw-rw-r--  1 root root  813 Jan 11 11:14 modules.ieee1394map
-rw-rw-r--  1 root root  788 Jan 11 11:14 modules.inputmap
-rw-rw-r--  1 root root 2.6K Jan 11 11:14 modules.isapnpmap
-rw-rw-r--  1 root root   74 Jan 11 11:14 modules.ofmap
-rw-rw-r--  1 root root 161K Jan 11 11:14 modules.pcimap
-rw-rw-r--  1 root root  967 Jan 11 11:14 modules.seriomap
-rw-rw-r--  1 root root 100K Jan 11 11:14 modules.symbols
-rw-rw-r--  1 root root 306K Jan 11 11:14 modules.usbmap
lrwxrwxrwx  1 root root   17 Jan 11 13:39 source -> /pkg/linux/source
root@orac tmp $ ll pkg/linux/lib/modules/2.6.19.2/
total 1.1M
lrwxrwxrwx  1 root root   23 Jan 12 12:08 build -> /pkg/linux/sourceodules
drwxrwxr-x 11 root root 4.0K Jan 12 12:08 kernel
-rw-rw-r--  1 root root 229K Jan 12 12:08 modules.alias
-rw-rw-r--  1 root root   69 Jan 12 12:08 modules.ccwmap
-rw-rw-r--  1 root root 246K Jan 12 12:08 modules.dep
-rw-rw-r--  1 root root  813 Jan 12 12:08 modules.ieee1394map
-rw-rw-r--  1 root root  788 Jan 12 12:08 modules.inputmap
-rw-rw-r--  1 root root 2.6K Jan 12 12:08 modules.isapnpmap
-rw-rw-r--  1 root root   74 Jan 12 12:08 modules.ofmap
-rw-rw-r--  1 root root 161K Jan 12 12:08 modules.pcimap
-rw-rw-r--  1 root root  967 Jan 12 12:08 modules.seriomap
-rw-rw-r--  1 root root 100K Jan 12 12:08 modules.symbols
-rw-rw-r--  1 root root 306K Jan 12 12:08 modules.usbmap
lrwxrwxrwx  1 root root   23 Jan 12 12:08 source -> /pkg/linux/sourceodules
root@orac tmp $

The extra 'odules' is suspiciously like 'modules'...

I am now using version 2.6 with debian patches to 2.6-17, and this works 
fine. I've tried making a small test case, but it only seems to occur 
with my large (500Mb) root filesystem archives. If I just archive the 
modules directory in the example above, the corruption does not occur.

Anyhow; if I can do anything to chase this down further, let me know. I 
have joined the ML.

Andrew Walrond
