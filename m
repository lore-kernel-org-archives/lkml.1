Return-Path: <linux-kernel-owner+w=401wt.eu-S1761790AbZE2UCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761790AbZE2UCn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 16:02:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756126AbZE2UCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 16:02:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47128 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755728AbZE2UCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 16:02:35 -0400
Date: Fri, 29 May 2009 13:01:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: greg@kroah.com, mingo@elte.hu, norsk5@yahoo.com, tglx@linutronix.de,
       hpa@zytor.com, mchehab@redhat.com, aris@redhat.com, edt@aei.ca,
       linux-kernel@vger.kernel.org, randy.dunlap@oracle.com
Subject: Re: [PATCH 0/4] amd64_edac: misc fixes
Message-Id: <20090529130115.a44efaee.akpm@linux-foundation.org>
In-Reply-To: <20090529103329.GB23530@aftab>
References: <1242845037-1029-1-git-send-email-borislav.petkov@amd.com>
	<20090528164720.0af5752b.akpm@linux-foundation.org>
	<20090529103329.GB23530@aftab>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 May 2009 12:33:29 +0200
Borislav Petkov <borislav.petkov@amd.com> wrote:

> Hi,
> 
> On Thu, May 28, 2009 at 04:47:20PM -0700, Andrew Morton wrote:
> > On Wed, 20 May 2009 20:43:53 +0200
> > Borislav Petkov <borislav.petkov@amd.com> wrote:
> > 
> > > here are some minor fixlets which came up lately. I'm sending them
> > > separately as an offset from the rest of the patchset since nothing has
> > > changed there. For details, see
> > > 
> > > git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git for-next
> > 
> > My linux-next x86_64 allmodconfig fails to build drivers/edac/amd64_edac.o:
> > 
> > {standard input}: Assembler messages:
> > {standard input}:3026: Error: no such instruction: `popcnt %eax,%ecx'
> 
> I guess this is a rather old(er) toolchain you got there. What do
> 
> as --version
> gcc --version
> 
> say?

gcc-4.0.2, gas-2.16.1

Here's your sent-off-list patch (please don't do that):

diff -puN drivers/edac/amd64_edac.c~edac-build-fix drivers/edac/amd64_edac.c
--- a/drivers/edac/amd64_edac.c~edac-build-fix
+++ a/drivers/edac/amd64_edac.c
@@ -1419,7 +1419,7 @@ static u32 f10_determine_channel(struct 
 		if (dct_sel_interleave_addr(pvt) == 0)
 			cs = sys_addr >> 6 & 1;
 		else if ((dct_sel_interleave_addr(pvt) >> 1) & 1) {
-			temp = popcnt((u32) ((sys_addr >> 16) & 0x1F)) % 2;
+			temp = hweight_long((u32) ((sys_addr >> 16) & 0x1F)) % 2;
 
 			if (dct_sel_interleave_addr(pvt) & 1)
 				cs = (sys_addr >> 9 & 1) ^ temp;
diff -puN drivers/edac/amd64_edac.h~edac-build-fix drivers/edac/amd64_edac.h
--- a/drivers/edac/amd64_edac.h~edac-build-fix
+++ a/drivers/edac/amd64_edac.h
@@ -443,19 +443,6 @@ enum {
 #define K8_MSR_MC4STAT			0x0411
 #define K8_MSR_MC4ADDR			0x0412
 
-/*
- * popcnt - count the set bits in a bit vector.
- * @vec - bit vector
- *
- * This instruction is supported only on F10h and later CPUs.
- */
-#define popcnt(x)						\
-({								\
-	typeof(x) __ret;					\
-	__asm__("popcnt %1, %0" : "=r" (__ret) : "r" (x));	\
-	__ret;							\
-})
-
 /* AMD sets the first MC device at device ID 0x18. */
 static inline int get_mc_node_id_from_pdev(struct pci_dev *pdev)
 {
_

That'll work.

A suitable way to solve all this would be to arrange for x86's hweight()
to use the popcnt instruction, where that makes sense.

