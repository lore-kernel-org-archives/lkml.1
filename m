Return-Path: <linux-kernel-owner+w=401wt.eu-S1754986AbZKIVck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986AbZKIVck (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 16:32:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754706AbZKIVcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 16:32:39 -0500
Received: from fanny.its.uu.se ([130.238.4.241]:59392 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754491AbZKIVcj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 16:32:39 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19192.35446.970229.391493@pilspetsen.it.uu.se>
Date: Mon, 9 Nov 2009 22:32:38 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Helge Deller <deller@gmx.de>, linux-kernel@vger.kernel.org,
       Anton Blanchard <anton@samba.org>, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] Implement prctl(PR_GET_ENDIAN) for all architectures
In-Reply-To: <20091109124618.2aa98630.akpm@linux-foundation.org>
References: <20091022193533.GA5827@p100.box>
	<20091109124618.2aa98630.akpm@linux-foundation.org>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton writes:
 > On Thu, 22 Oct 2009 21:35:33 +0200
 > Helge Deller <deller@gmx.de> wrote:
 > 
 > > The PR_GET_ENDIAN and PR_SET_ENDIAN prctl() calls have been implemented
 > > to allow to switch processes at runtime from big-endian to little-endian
 > > mode (and vice versa) on PowerPC processors. Since the other architectures
 > > don't support this feature, they currently will just fail and return -EINVAL.
 > > 
 > > This patch adds just minimal overhead and implements the PR_GET_ENDIAN
 > > call for all other architectures by returning the native endianess of
 > > the architecture. Furthermore, calling prctl(PR_SET_ENDIAN) with the
 > > native endianess of the architecture will succeed, while trying to
 > > set another (not-supported) endianess, will fail.
 > > 
 > > The patch can be tested with the following program:
 > > 
 > > #include <stdio.h>
 > > #include <linux/prctl.h>
 > > 
 > > int main(int argc, char **argv)
 > > {
 > > 	int endian, ret;
 > > 
 > > 	ret = prctl(PR_GET_ENDIAN, &endian);
 > > 	if (ret)
 > > 		perror("prctl(PR_GET_ENDIAN) not implemented");
 > > 	printf("current process/machine is running in %s endian mode (%d)\n",
 > > 		endian == PR_ENDIAN_LITTLE ? "little":"big", endian);
 > > 
 > > 	/* setting native endianess should succeed */
 > > 	ret = prctl(PR_SET_ENDIAN, endian);
 > > 	printf("prctl(PR_SET_ENDIAN,%d) should succeed: %s\n",
 > > 		endian, ret == 0 ? "OK":"FAIL");
 > > 
 > > 	/* setting foreign endianess should fail */
 > > 	endian = (endian == PR_ENDIAN_LITTLE) ?
 > > 		PR_ENDIAN_BIG : PR_ENDIAN_LITTLE;
 > > 	ret = prctl(PR_SET_ENDIAN, endian);
 > > 	printf("prctl(PR_SET_ENDIAN,%d) should fail: %s\n",
 > > 		endian, ret == 0 ? "OK":"FAIL");
 > > }
 > > 
 > 
 > The changelog forgot to provide any reason for making this change to
 > the kernel.

Why is PR_GET_ENDIAN needed? Surely user-space can detect the current
endianess for itself?

Also, which endianess does this refer to? ARM has had and continues to
invent bizarre endianess rules, where the endianess of some datum depends
not only on the endianess flag in a core control register but also the
functional unit operating on the data and the ARM ISA version. Some of
these endianess properties are unchangeable, some may be changeable in
specific implementations.

What about archs that always run in one endianess but support other-endian
data accesses via special instruction operands? (I believe SPARC falls into
this category.) PR_SET_ENDIAN on the other-endian value must fail, but what
does that mean to the program? That it can't do other-endian accesses? No.

I think the very concept of flipping a thread-global endianess mode flag
is too architecture specific to be treated as a generic thing.
