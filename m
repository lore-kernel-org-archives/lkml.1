Return-Path: <linux-kernel-owner+w=401wt.eu-S1031516AbXFHSbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031516AbXFHSbo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 14:31:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969680AbXFHSbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 14:31:33 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:33867 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S969023AbXFHSbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 14:31:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=njxvA4f+6PJwKg0iJdCX+qmjm7jdLm5piwM1QUi960rq58qa5vo5FWUaPVpdwVov1tUW7mYyq0nGjjSyIEg5HoVJVlq1zpQIUZPCSKFqtALJSHfjgJrZWKifm3Wc3pR7qJD915JLCdrjzLzh3FitTNPXD2FjRSVKCRpj0BSHkIE=
Message-ID: <4669A0BD.8050104@gmail.com>
Date: Fri, 08 Jun 2007 11:32:29 -0700
From: Tom <fivemiletom@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk
Subject: [PATCH 2.6.21.3] kbuild: fix build for cygwin
References: <4660971E.5020609@gmail.com> <12D4B80525C5B744A216276E209921D9CE8016@MIAMI.xi-lite.lan> <46645DC9.8080003@gmail.com> <20070607204707.GB16634@uranus.ravnborg.org>
In-Reply-To: <20070607204707.GB16634@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Enderes <enderes@gmail.com>

The kernel build failed on cygwin hosts, because cygwin has slightly 
different typedefs compared to linux:
scripts/mod/file2alias.c:518: error: dereferencing pointer to incomplete
type
Two files, scripts/mod/file2alias.c and scripts/mod/modpost.h, were 
modified as follows:
Whever __CYGWIN__ is defined, __uint32 is defined as __uint32_t (instead 
of uint_32_t) and the missing ElfxxSection definitions are added.
These changes have been tested both on cygwin 1.5.24, hostcc=gcc 3.4.4 
and on FC5, hostcc=gcc 4.1.1-1. Any tests on cygwin, with and without 
this change, were executed with the following set for make: 
HOST_LOADLIBES="-lcurses -lintl".

Signed-off-by: Tom Enderes <enderes@gmail.com>


diff -Naur -r o21.1/scripts/mod/file2alias.c
2.6.21.1/scripts/mod/file2alias.c
--- o21.1/scripts/mod/file2alias.c    2007-04-27 14:49:26.000000000 -0700
+++ 2.6.21.1/scripts/mod/file2alias.c    2007-05-29 20:35:01.209115300
-0700
@@ -29,7 +29,11 @@

  #include <ctype.h>

+#ifdef __CYGWIN__
+typedef __uint32_t      __u32;
+#else
  typedef uint32_t    __u32;
+#endif
  typedef uint16_t    __u16;
  typedef unsigned char    __u8;

diff -Naur -r o21.1/scripts/mod/modpost.h 2.6.21.1/scripts/mod/modpost.h
--- o21.1/scripts/mod/modpost.h    2007-04-27 14:49:26.000000000 -0700
+++ 2.6.21.1/scripts/mod/modpost.h    2007-05-29 20:35:01.599732800
-0700
@@ -9,6 +9,11 @@
  #include <unistd.h>
  #include <elf.h>

+#ifdef __CYGWIN__
+typedef uint16_t Elf32_Section;
+typedef uint16_t Elf64_Section;
+#endif
+
  #include "elfconfig.h"

  #if KERNEL_ELFCLASS == ELFCLASS32


