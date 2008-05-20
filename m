Return-Path: <linux-kernel-owner+w=401wt.eu-S1765952AbYETLIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765952AbYETLIf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 07:08:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760019AbYETLI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 07:08:26 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:26625 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758071AbYETLIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 07:08:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=ullAE8Enbjpa0JrRWW05JKchwk/yloc9UmtnO8F8+4xGoE2/gXAeML00/9XtaheNMc57LI/pG6G2XYSQpjykP5tP5CMlCk0tHoRKcKUVKHuAMk/LkMDSzEXVYb865vLmu6bcZuwxE09rnSvmAvrkO/yDGq12F9T2tIpq1uyH1VU=
Message-ID: <7b9198260805200408k1d6b70a8xc7e4c24106e5020f@mail.gmail.com>
Date: Tue, 20 May 2008 12:08:24 +0100
From: "Tom Spink" <tspink@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: UML fails to locate address space
Cc: "Jeff Dike" <jdike@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've just recently pulled the latest GIT and compiled UML, however,
when I run it a message appears saying "Locating the top of the
address space... Address 0x0 no good?" and the program exits.

After some digging, it appears that page_ok is returning false when
checking 'bottom', in os_get_task_size
(arch/um/os-Linux/sys-i386/task_size.c:96).  After running through
GDB, it seems that in line 31 of that file is where the segfault
occurs:

n = *address;

i.e. when trying to read from the address space (at address zero).

Here is GDB's output:

Program received signal SIGSEGV, Segmentation fault.
0x0806d993 in page_ok (page=0) at arch/um/os-Linux/sys-i386/task_size.c:31
31			n = *address;
(gdb) bt
#0  0x0806d993 in page_ok (page=0) at arch/um/os-Linux/sys-i386/task_size.c:31
#1  0x0806daf8 in os_get_task_size () at
arch/um/os-Linux/sys-i386/task_size.c:96
#2  0x0804ac7f in linux_main (argc=5, argv=0xbfe438a4) at
arch/um/kernel/um_arch.c:277
#3  0x0804b82f in main (argc=5, argv=0xbfe438a4, envp=0xbfe438bc) at
arch/um/os-Linux/main.c:150

As I mentioned, this is the latest git, running on a 32-bit x86 with
Ubuntu stock kernel 2.6.24-17.  As a quick hack, I manually got the
function to return ~3Gb, and UML continued to boot.  Any ideas, or any
more information you need?

(I've CCed Jeff Dike, as I saw it was his patch that introduced this code)

-- 
Regards,
Tom Spink
