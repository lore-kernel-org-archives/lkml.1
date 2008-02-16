Return-Path: <linux-kernel-owner+w=401wt.eu-S1758251AbYBPS71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758251AbYBPS71 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 13:59:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757236AbYBPS7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 13:59:06 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:19716 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756701AbYBPS7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 13:59:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:user-agent:mime-version:content-type:from;
        b=xHE9TiG4TDlSKM5JSr7MdhiDNsAuJjfpfdWHO7L9VxYgZJMPed4gh9p7PbJy/MtXEiYZNCCPQYEAg36mQgtovQ78korFCt/lzJdRonQPE3s2m9yKK12uq2pzT6rhkM18K+H7XeeKqkm33rQQBMJPUcarGiBBIobyr14WAcIAuB8=
Date: Sat, 16 Feb 2008 18:58:51 +0000 (GMT)
To: thomas.petazzoni@free-electrons.com, akpm@linux-foundation.org
cc: linux-kernel@vger.kernel.org
Subject: 2.6.25-rc2-mm1: ARM build fail due to
 inflate-refactor-inflate-malloc-code
Message-ID: <alpine.DEB.1.00.0802161845570.26291@git.byronbradley.co.uk>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
From: Byron Bradley <byron.bbradley@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 0ad34f5f5f12861d4a18542c1a26284023b07a8d produces the following
build failure on ARM:

  CC      arch/arm/boot/compressed/misc.o
In file included from /home/bb3081/project/kernel/orion/arch/arm/boot/compressed/misc.c:242:
/home/bb3081/project/kernel/orion/arch/arm/boot/compressed/../../../../lib/inflate.c: In function 'malloc':
/home/bb3081/project/kernel/orion/arch/arm/boot/compressed/../../../../lib/inflate.c:255: error: 'free_mem_end_ptr' undeclared (first use in this function)
/home/bb3081/project/kernel/orion/arch/arm/boot/compressed/../../../../lib/inflate.c:255: error: (Each undeclared identifier is reported only once
/home/bb3081/project/kernel/orion/arch/arm/boot/compressed/../../../../lib/inflate.c:255: error: for each function it appears in.)
make[3]: *** [arch/arm/boot/compressed/misc.o] Error 1
make[2]: *** [arch/arm/boot/compressed/vmlinux] Error 2
make[1]: *** [zImage] Error 2
make: *** [sub-make] Error 2

free_mem_end_ptr is only defined on a few different architectures so this
commit probably effects others. After reverting this commit (below)
2.6.25-rc2-mm1 seems fine on two Marvell Orion based ARM boards.



commit 0ad34f5f5f12861d4a18542c1a26284023b07a8d
Author: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Date:   Fri Feb 15 21:35:37 2008 +0000

    inflate-refactor-inflate-malloc-code

    Inflate requires some dynamic memory allocation very early in the boot
    process and this is provided with a set of four functions:
    malloc/free/gzip_mark/gzip_release.

    The old inflate code used a mark/release strategy rather than implement
    free.  This new version instead keeps a count on the number of outstanding
    allocations and when it hits zero, it resets the malloc arena.

    This allows removing all the mark and release implementations and unifying
    all the malloc/free implementations.

    Work initially done by Matt Mackall, updated to a recent version of the
    kernel by me.
