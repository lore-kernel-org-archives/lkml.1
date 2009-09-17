Return-Path: <linux-kernel-owner+w=401wt.eu-S1759622AbZIQCao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759622AbZIQCao (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 22:30:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759347AbZIQCam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 22:30:42 -0400
Received: from mail-pz0-f190.google.com ([209.85.222.190]:37485 "EHLO
	mail-pz0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757171AbZIQCak convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 22:30:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=F7PPeYnbA8hFiPRXNNnX5orCg41Om8tfoe5pIEaFglAhOaublVO7SskGfuYoXcNOBT
         aa/SwHKUtrskCV6FurUgX0yppuUTCxkxz8nSnX8Nf7SOG2jXAXERsB6ttFobkjRb9Eif
         Qv7P0FtocMiOyFoeJBqE/s9NHjpng5IOVr9To=
MIME-Version: 1.0
Date: Wed, 16 Sep 2009 19:30:43 -0700
Message-ID: <830a8fa70909161930r518a9644ja954ced2ae5814b4@mail.gmail.com>
Subject: [patch] Makefile: can't build modules outside the kernel tree if it 
	was built using O=
From: Caveh Jalali <ecaveh@gmail.com>
To: sam@ravnborg.org
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

in 2.6.31, it is no longer possible to build kernel modules for some platforms
(the ones that need include2) outside the kernel src tree if the
src tree was built using O= to specify an alternate directory for the
build output.

i think this broke with the following commit:

commit b8b572e1015f81b4e748417be2629dfe51ab99f9
Author: Stephen Rothwell <sfr@canb.auug.org.au>
Date:   Fri Aug 1 15:20:30 2008 +1000

   powerpc: Move include files to arch/powerpc/include/asm


when the platform specific include directories were shuffled around
without updating the
top level Makefile.  however, i think this FAIL is generic, and not
limited to powerpc.
here's a patch to the top level Makefile to teach it about the shuffled files:


--- /local/caveh/linux/linux-2.6.31/Makefile    2009-09-09
15:13:59.000000000 -0700
+++ Makefile    2009-09-16 12:23:05.000000000 -0700
@@ -958,9 +958,9 @@ ifneq ($(KBUILD_SRC),)
                echo "  in the '$(srctree)' directory.";\
                /bin/false; \
        fi;
-       $(Q)if [ ! -d include2 ]; then                                  \
-           mkdir -p include2;                                          \
-           ln -fsn $(srctree)/include/asm-$(SRCARCH) include2/asm;     \
+       $(Q)if [ ! -d include2 ]; then                                   \
+           mkdir -p include2;                                           \
+           ln -fsn $(srctree)/arch/$(SRCARCH)/include/asm include2/asm; \
        fi
 endif
