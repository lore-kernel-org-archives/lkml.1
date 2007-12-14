Return-Path: <linux-kernel-owner+w=401wt.eu-S934050AbXLNQ4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934050AbXLNQ4M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 11:56:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751410AbXLNQz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 11:55:58 -0500
Received: from smtp.silicomp.fr ([194.51.78.40]:39240 "EHLO smtp.silicomp.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758AbXLNQz5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 11:55:57 -0500
X-Greylist: delayed 2051 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Dec 2007 11:55:56 EST
Date: Fri, 14 Dec 2007 17:21:31 +0100 (CET)
From: Jean-Marc Saffroy <jean-marc.saffroy@orange-ftgroup.com>
X-X-Sender: saffroy@brutus.ri.silicomp.fr
To: daniel.pirkl@email.cz, dushistov@mail.ru
cc: linux-kernel@vger.kernel.org
Subject: fsx failure on ufs2
Message-ID: <Pine.LNX.4.61.0712141649230.10387@brutus.ri.silicomp.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.8 (smtp.silicomp.fr [194.51.78.40]); Fri, 14 Dec 2007 17:20:05 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

For an embedded system, I'm currently evaluating the robustness of ufs2 
write support on Linux, and my very first test, with fsx, shows serious 
problems.

My test bed is a single CPU PC with a single IDE disk, that boots FreeBSD 
6.2 and Ubuntu 7.10. The kernel on Ubuntu is a vanilla 2.6.23.9 with UFS2 
write support. fsx is from the freebsd cvs (with a small patch to build on 
Linux, see after my sig):
   http://www.freebsd.org/cgi/cvsweb.cgi/src/tools/regression/fsx/

The test is as follows:

# mount -t ufs -o ufstype=ufs2 /dev/sda10 /mnt
(Yes, /dev/sda but it's really IDE.)

$ ./fsx -c100 -N 100000 /mnt/test_fsx

fsx exits in error, after producing the following files:

-rw-r--r-- 1 foo foo 196256 2007-12-14 16:56 test_fsx
-rw-r--r-- 1 foo foo 196256 2007-12-14 16:56 test_fsx.fsxgood
-rw-r--r-- 1 foo foo  63167 2007-12-14 16:56 test_fsx.fsxlog

The file test_fsx.fsxgood contains what fsx expected to be in test_fsx; 
the files differ only in the last 4K chunk (it seems there should be only 
zeroes, but it's not so).

There does not seem to be any problem with ext3.

Can anyone else confirm this problem?


Cheers,

-- 
Jean-Marc Saffroy - Silicomp / Orange Business Services
mailto:jean-marc.saffroy@orange-ftgroup.com

Trivial patch for fsx.

diff -r 6888f21e18de -r 1aa7894fc4f8 fsx.c
--- a/fsx.c	Thu Dec 13 17:51:02 2007 +0100
+++ b/fsx.c	Thu Dec 13 17:52:08 2007 +0100
@@ -61,6 +61,8 @@
  #include <unistd.h>
  #include <stdarg.h>
  #include <errno.h>
+#include <stdint.h>
+#include <time.h>

  #define NUMPRINTCOLUMNS 32	/* # columns of data to print on each line */

