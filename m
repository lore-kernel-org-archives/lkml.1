Return-Path: <linux-kernel-owner+w=401wt.eu-S1757576AbYCMWJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757576AbYCMWJZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 18:09:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751756AbYCMWJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 18:09:18 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:57701 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbYCMWJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 18:09:17 -0400
Date: Thu, 13 Mar 2008 18:09:12 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: whose job is it to include various header files?
Message-ID: <alpine.LFD.1.00.0803131802020.20317@localhost.localdomain>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1083589936-1205446155=:20317"
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1083589936-1205446155=:20317
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: QUOTED-PRINTABLE


  more a philosophy question than anything but, while poking around
the percpu stuff today, i noticed in the header file linux/percpu.h
the opening snippet:

 #include <linux/preempt.h>
 #include <linux/slab.h> /* For kmalloc() */
 #include <linux/smp.h>
 #include <linux/string.h> /* For memset() */
 #include <linux/cpumask.h>
 ...

hmmm, i thought to myself (because that's how i refer to myself), i
wonder why this header file is including headers for kmalloc() and
memset() when this header file makes no reference to those routines.
let's see what happens if i remove them and:

  $ make distclean
  $ make defconfig    [x86]
  $ make

=2E.. chug chug chug ...

  CC      arch/x86/kernel/nmi_32.o
arch/x86/kernel/nmi_32.c: In function =A1check_nmi_watchdog=A2:
arch/x86/kernel/nmi_32.c:81: error: implicit declaration of function =A1kma=
lloc=A2
arch/x86/kernel/nmi_32.c:81: error: =A1GFP_KERNEL=A2 undeclared (first use =
in this function)
arch/x86/kernel/nmi_32.c:81: error: (Each undeclared identifier is reported=
 only once
arch/x86/kernel/nmi_32.c:81: error: for each function it appears in.)
arch/x86/kernel/nmi_32.c:81: warning: assignment makes pointer from integer=
 without a cast
arch/x86/kernel/nmi_32.c:118: error: implicit declaration of function =A1kf=
ree=A2
make[1]: *** [arch/x86/kernel/nmi_32.o] Error 1
make: *** [arch/x86/kernel] Error 2
$

  ok, now i know.  but that means, of course, that nmi_32.c is
invoking kmalloc() without ever having included the necessary header
file for it -- it's just inheriting that from linux/percpu.h.

  doesn't that (sort of) violate the kernel coding style?  if a file
somewhere needs the contents of some header file, isn't it that file's
responsibility to explicitly include it, and not quietly realize it's
getting it from elsewhere?

rday
--


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--8323328-1083589936-1205446155=:20317--
