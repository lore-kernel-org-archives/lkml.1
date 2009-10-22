Return-Path: <linux-kernel-owner+w=401wt.eu-S1756827AbZJVTfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827AbZJVTfh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 15:35:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756669AbZJVTfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 15:35:37 -0400
Received: from mail.gmx.net ([213.165.64.20]:37702 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756215AbZJVTfg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 15:35:36 -0400
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX1/8nDIk8cr8hGTB2wduq4r/O2maV3ANC5RxLkltSP
	X0aljLUM50Acr/
Date: Thu, 22 Oct 2009 21:35:33 +0200
From: Helge Deller <deller@gmx.de>
To: linux-kernel@vger.kernel.org, Anton Blanchard <anton@samba.org>,
       Paul Mackerras <paulus@samba.org>, Andrew Morton <akpm@osdl.org>
Subject: [PATCH] Implement prctl(PR_GET_ENDIAN) for all architectures
Message-ID: <20091022193533.GA5827@p100.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PR_GET_ENDIAN and PR_SET_ENDIAN prctl() calls have been implemented
to allow to switch processes at runtime from big-endian to little-endian
mode (and vice versa) on PowerPC processors. Since the other architectures
don't support this feature, they currently will just fail and return -EINVAL.

This patch adds just minimal overhead and implements the PR_GET_ENDIAN
call for all other architectures by returning the native endianess of
the architecture. Furthermore, calling prctl(PR_SET_ENDIAN) with the
native endianess of the architecture will succeed, while trying to
set another (not-supported) endianess, will fail.

The patch can be tested with the following program:

#include <stdio.h>
#include <linux/prctl.h>

int main(int argc, char **argv)
{
	int endian, ret;

	ret = prctl(PR_GET_ENDIAN, &endian);
	if (ret)
		perror("prctl(PR_GET_ENDIAN) not implemented");
	printf("current process/machine is running in %s endian mode (%d)\n",
		endian == PR_ENDIAN_LITTLE ? "little":"big", endian);

	/* setting native endianess should succeed */
	ret = prctl(PR_SET_ENDIAN, endian);
	printf("prctl(PR_SET_ENDIAN,%d) should succeed: %s\n",
		endian, ret == 0 ? "OK":"FAIL");

	/* setting foreign endianess should fail */
	endian = (endian == PR_ENDIAN_LITTLE) ?
		PR_ENDIAN_BIG : PR_ENDIAN_LITTLE;
	ret = prctl(PR_SET_ENDIAN, endian);
	printf("prctl(PR_SET_ENDIAN,%d) should fail: %s\n",
		endian, ret == 0 ? "OK":"FAIL");
}

Signed-off-by: Helge Deller <deller@gmx.de>



diff --git a/kernel/sys.c b/kernel/sys.c
index 255475d..bd71dcb 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -46,6 +46,15 @@
 #include <asm/io.h>
 #include <asm/unistd.h>
 
+#if defined(__BIG_ENDIAN)
+# define PRCTL_ENDIAN_DEFAULT	(PR_ENDIAN_BIG)
+#elif defined(__LITTLE_ENDIAN)
+# define PRCTL_ENDIAN_DEFAULT	(PR_ENDIAN_LITTLE)
+#else
+# error "No endianess?"
+#endif
+
+
 #ifndef SET_UNALIGN_CTL
 # define SET_UNALIGN_CTL(a,b)	(-EINVAL)
 #endif
@@ -65,10 +74,12 @@
 # define GET_FPEXC_CTL(a,b)	(-EINVAL)
 #endif
 #ifndef GET_ENDIAN
-# define GET_ENDIAN(a,b)	(-EINVAL)
+# define GET_ENDIAN(task,addr)	\
+	put_user(PRCTL_ENDIAN_DEFAULT, (int __user *) (addr))
 #endif
 #ifndef SET_ENDIAN
-# define SET_ENDIAN(a,b)	(-EINVAL)
+# define SET_ENDIAN(task,value)	\
+	( (value) == PRCTL_ENDIAN_DEFAULT ? 0 : -EINVAL )
 #endif
 #ifndef GET_TSC_CTL
 # define GET_TSC_CTL(a)		(-EINVAL)
