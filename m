Return-Path: <linux-kernel-owner+w=401wt.eu-S1754160AbYG1HGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160AbYG1HGS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 03:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752188AbYG1HGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 03:06:08 -0400
Received: from araneidae.co.uk ([62.3.233.233]:2447 "EHLO mail.araneidae.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018AbYG1HGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 03:06:07 -0400
X-Greylist: delayed 1029 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Jul 2008 03:06:07 EDT
Date: Mon, 28 Jul 2008 06:48:52 +0000 (GMT)
From: Michael Abbott <michael@araneidae.co.uk>
To: linux-kernel@vger.kernel.org
Subject: [PATCH]: Make ioctl.h compatible with userland
Message-ID: <20080728063957.J72435@saturn.araneidae.co.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The attached patch seems to already exist in a number of branches -- it 
keeps popping up on Google for me, and is certainly already in Debian -- 
but is strangely absent from mainstream.

The problem appears to be that the patched file ends up as part of the 
target toolchain, but unfortunately the gcc constant folding doesn't 
appear to eliminate the __invalid_size_argument_for_IOC value early 
enough.  Certainly compiling C++ programs which use _IO... macros as 
constants fails without this patch.

No doubt this has been pushed upstream before: this problem seems to date 
from the very early days of 2.6 ... but here it is again.  It makes sense 
to do it.


commit 0df6f37b4e4534f219b5e40cb49ffd9311eb6195
Author: Michael Abbott <michael.abbott@diamond.ac.uk>
Date:   Mon Jul 28 07:32:05 2008 +0100

    Add long established but strangely absent patch to allow ioctl.h to
    work smoothly with userspace program optimisations.

diff --git a/include/asm-generic/ioctl.h b/include/asm-generic/ioctl.h
index 8641813..15828b2 100644
--- a/include/asm-generic/ioctl.h
+++ b/include/asm-generic/ioctl.h
@@ -68,12 +68,16 @@
 	 ((nr)   << _IOC_NRSHIFT) | \
 	 ((size) << _IOC_SIZESHIFT))
 
+#ifdef __KERNEL__
 /* provoke compile error for invalid uses of size argument */
 extern unsigned int __invalid_size_argument_for_IOC;
 #define _IOC_TYPECHECK(t) \
 	((sizeof(t) == sizeof(t[1]) && \
 	  sizeof(t) < (1 << _IOC_SIZEBITS)) ? \
 	  sizeof(t) : __invalid_size_argument_for_IOC)
+#else
+#define _IOC_TYPECHECK(t) (sizeof(t))
+#endif
 
 /* used to create numbers */
 #define _IO(type,nr)		_IOC(_IOC_NONE,(type),(nr),0)
