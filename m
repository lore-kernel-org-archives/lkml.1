Return-Path: <linux-kernel-owner+w=401wt.eu-S1756335AbYFJKwD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756335AbYFJKwD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 06:52:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751557AbYFJKvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 06:51:54 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:14584 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbYFJKvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 06:51:53 -0400
Message-ID: <484E5CBB.2040203@de.ibm.com>
Date: Tue, 10 Jun 2008 12:51:39 +0200
From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: akpm@linuxfoundation.org, jdike@addtoit.com, linux-kernel@vger.kernel.org,
       Peter Oberparleiter <oberparleiter@googlemail.com>
Subject: Re: 2.6.26-rc5-mm1: uml link error
References: <E1K5oBn-0006v4-KJ@pomaz-ex.szeredi.hu>
In-Reply-To: <E1K5oBn-0006v4-KJ@pomaz-ex.szeredi.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:
> I get this error on linking uml:
> 
> /usr/lib64/gcc/x86_64-suse-linux/4.2.1/../../../../x86_64-suse-linux/bin/ld:arch/um/kernel/vmlinux.lds:267: syntax error
> 
> Reverting 'kernel-call-constructors.patch' fixes it.

Should be fixed with the patch below (applies on top of
kernel-call-constructors.patch):

--

From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>

Fix for linker error on UML:

/usr/lib64/gcc/x86_64-suse-linux/4.2.1/../../../../x86_64-suse-linux/bin/ld:arch/um/kernel/vmlinux.lds:267: syntax error

The error is triggered by the use of SORT(CONSTRUCTORS) in the UML
linker script which conflicts with the kernel-call-constructors patch.
Here is what the ld info page says about sorting constructors:

     If you are using the GNU C++ support for initialization priority,
     which provides some control over the order in which global
     constructors are run, you must sort the constructors at link time
     to ensure that they are executed in the correct order.

As there's no C++ code inside the kernel it should be safe to remove
the SORT construct.

Found-by: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
---
 arch/um/kernel/dyn.lds.S |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.26-rc5-mm2/arch/um/kernel/dyn.lds.S
===================================================================
--- linux-2.6.26-rc5-mm2.orig/arch/um/kernel/dyn.lds.S
+++ linux-2.6.26-rc5-mm2/arch/um/kernel/dyn.lds.S
@@ -102,7 +102,7 @@ SECTIONS
     *(.data.init_irqstack)
     DATA_DATA
     *(.data.* .gnu.linkonce.d.*)
-    SORT(CONSTRUCTORS)
+    CONSTRUCTORS
   }
   .data1          : { *(.data1) }
   .tdata	  : { *(.tdata .tdata.* .gnu.linkonce.td.*) }
