Return-Path: <linux-kernel-owner+w=401wt.eu-S1761441AbXGVIXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761441AbXGVIXf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 04:23:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754554AbXGVIXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 04:23:25 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43545
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753971AbXGVIXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 04:23:22 -0400
Date: Sun, 22 Jul 2007 01:23:21 -0700 (PDT)
Message-Id: <20070722.012321.79430375.davem@davemloft.net>
To: roland@redhat.com
CC: linux-kernel@vger.kernel.org
Subject: "build-id" changes break sparc64
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


(This is in reference to commit 18991197b4b588255ccabf472ebc84db7b66a19c)

When actually used, the build-id linker option causes problems for the
sparc64 kernel in two ways:

1) When building modules we get tons of warnings from the linker
   such as:

  LD [M]  drivers/scsi/sr_mod.o
ld: warning: Cannot create .note.gnu.build-id section, --build-id ignored.

2) The resulting kernel image will not boot.  The SILO boot loader on
   sparc aborts if there are multiple PT_LOAD segments in the ELF
   program header of the kernel image.  The boot loader can only
   handle allocating memory for and setting up mappings via the
   firmware for one one linear PT_LOAD segment.

   build-id puts a second PT_LOAD into the kernel image (albeit a tiny
   one) and as a result it cannot be booted

This is all with the current binutils in Ubuntu gutsy which
is version 2.17.50.20070718

Whilst #1 could be some kind of binutils bug and the warning
is harmless, #2 is an outright show-stopper for sparc32 and
sparc64 and to be honest I would not be surprised if the
boot loader on some other platforms have this limitation too.

My suggestion would be to add this linker option in the various
arch/${FOO}/Makefile files for platforms and situations where it
is known to work properly.

Roland, if you agree could you submit a fix like that?

Alternatively, if you think build-id is so valuable, impress me with
your binutils ninja skills and show me how to perhaps do some objcopy
tricks wherein I could dike out the PT_LOAD segment build-id generates
for the "image" target et al.  in the arch/sparc{,64}/boot/Makefile's
rules.

Thanks a lot.
