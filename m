Return-Path: <linux-kernel-owner+w=401wt.eu-S1752517AbYKNOdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517AbYKNOdV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 09:33:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751295AbYKNOdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 09:33:09 -0500
Received: from yw-out-2122.google.com ([74.125.46.25]:43555 "EHLO
	yw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbYKNOdF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 09:33:05 -0500
MIME-Version: 1.0
Date: Fri, 14 Nov 2008 06:21:14 -0800 (PST)
In-Reply-To: <0311a600-49da-455a-b9a8-8102f49d4a9d@r15g2000prh.googlegroups.com>
X-IP: 131.220.98.28
References: <fa.hrjidQWwenpjwA7kZ7QRvpW96sA@ifi.uio.no> <fa.mliWgRv8sNLFopazZE711AU1pDU@ifi.uio.no> 
	<fa.9NVuHB+o1qjENxCitXgbGMAyH3o@ifi.uio.no> <fa.Xqznm+gGizSvfohUyup0OM2bT3o@ifi.uio.no> 
	<0311a600-49da-455a-b9a8-8102f49d4a9d@r15g2000prh.googlegroups.com>
User-Agent: G2/1.0
X-HTTP-UserAgent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.0.3) 
	Gecko/2008101315 Ubuntu/8.10 (intrepid) Firefox/3.0.3,gzip(gfe),gzip(gfe)
Message-ID: <015b62a8-8b51-45e4-9286-96879162b705@r15g2000prh.googlegroups.com>
Subject: Re: build error with 2.6.27.6+reiser4+ehci-hub patch. ERROR: 
	"mii_ethtool_gset" [drivers/net/r8169.ko] undefined!
From: mmetz <manuel.metz@googlemail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I think I have figured out what happened here. I updated sources from
2.6.27.4 to 2.6.27.6 (skipping 2.6.27.5). Then I ran

make oldconfig; make

and got the error message

[snip]
  BUILD   arch/x86/boot/bzImage
Root device is (8, 5)
Setup is 12524 bytes (padded to 12800 bytes).
System is 1902 kB
CRC 94b83bc6
Kernel: arch/x86/boot/bzImage is ready  (#2)
  Building modules, stage 2.
  MODPOST 507 modules
ERROR: "mii_ethtool_gset" [drivers/net/r8169.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2

The next step I made was to include the driver for the network device
(SiS190/SiS191 gigabit ethernet support). Then if I look at the output
of make, this forced mii.c to be compiled

scripts/kconfig/conf -s arch/x86/Kconfig
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CHK     include/linux/compile.h
  VDSOSYM arch/x86/vdso/vdso-syms.lds
  VDSOSYM arch/x86/vdso/vdso32-int80-syms.lds
  VDSOSYM arch/x86/vdso/vdso32-syscall-syms.lds
  VDSOSYM arch/x86/vdso/vdso32-sysenter-syms.lds
  VDSOSYM arch/x86/vdso/vdso32-syms.lds
  LD      arch/x86/vdso/built-in.o
  CC [M]  drivers/net/sis190.o
  CC [M]  drivers/net/mii.o
  LD      vmlinux.o
  MODPOST vmlinux.o
[snip]

Now the kernel builds fine. So in conclusion, it seems that there is a
dependency byr8169on mii.o which is not set correctly during the
build process if no other module depends on it.

Manuel
