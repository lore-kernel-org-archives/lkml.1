Return-Path: <linux-kernel-owner+w=401wt.eu-S1755713AbYF3Alk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713AbYF3Alk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 20:41:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbYF3Ala
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 20:41:30 -0400
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:37859 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751386AbYF3Al3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 20:41:29 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=MXiKb7BnIadkv4I+1ak+2BNClOvq8qfI/1ZSMJ3H5TX3r++gbNBVxY4iRKs4ZHxgdMq6eLMbbt22ovc5w2Pk3ZbqGjCB/KjDe6PswLtfS0uSO69Ppbt2eXIFeTT2TAPzHLGrpNvkKC1Ty6SlxXDHqbtjCVDo1ldknbRBDACUHCo=  ;
X-YMail-OSG: w00NN5AVM1l4_E.WsX99a93beXR0N.RZ6oKLD.UAztqZUy4xZBHLec0SInmOOrtfz.0fwR1oY01GmVvRxa1FFCm3LZ2AtfaLmKPFMP_LxpBK5NWYICym5D.SJZn0We2paA0-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [patch 2.6.26-rc7] <linux/bcd.h> space reduction
Date: Sun, 29 Jun 2008 17:41:23 -0700
User-Agent: KMail/1.9.9
Cc: lkml <linux-kernel@vger.kernel.org>, rtc-linux@googlegroups.com
References: <200806221954.37088.david-b@pacbell.net> <200806230015.49973.david-b@pacbell.net> <20080624215400.GA18252@cs181140183.pp.htv.fi>
In-Reply-To: <20080624215400.GA18252@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806291741.23711.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 June 2008, Adrian Bunk wrote:
> On Mon, Jun 23, 2008 at 12:15:49AM -0700, David Brownell wrote:
> > Where would that be ... lib/bcd.c, always linked?
> 
> Sounds good.
> 
> > And if it goes
> > that way I'd prefer bcd2bin() and bin2bcd(), not these names.  A
> > small impetus to have LESS SOURCE CODE SHOUTING AT ME.
> 
> Sounds good, but start with SHOUTING COMPATIBILITY #DEFINES FOR THE 
> EXISTING USERS and either clean them up later or let me do the cleanup.

Like this then (against RC8)?

========= CUT HERE
This updates <linux/bcd.h> to define the key routines as constant
functions, which the macros will then call.  Newer code can now
call bcd2bin() instead of SCREAMING BCD2BIN() TO THE FOUR WINDS.

This lets each driver shrink their codespace by using N function
calls to a single (global) copy of those routines, instead of N
inlined copies of these functions per driver.

These routines aren't used in speed-critical code.  Almost all
callers are in the RTC framework.  Typical per-driver savings is
near 300 bytes.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 include/linux/bcd.h |    9 +++++++--
 lib/Makefile        |    2 +-
 lib/bcd.c           |   14 ++++++++++++++
 3 files changed, 22 insertions(+), 3 deletions(-)

--- a/include/linux/bcd.h	2008-06-28 22:21:37.000000000 -0700
+++ b/include/linux/bcd.h	2008-06-29 15:16:48.000000000 -0700
@@ -10,8 +10,13 @@
 #ifndef _BCD_H
 #define _BCD_H
 
-#define BCD2BIN(val)	(((val) & 0x0f) + ((val)>>4)*10)
-#define BIN2BCD(val)	((((val)/10)<<4) + (val)%10)
+#include <linux/compiler.h>
+
+unsigned bcd2bin(unsigned char val) __attribute_const__;
+unsigned char bin2bcd(unsigned val) __attribute_const__;
+
+#define BCD2BIN(val)	bcd2bin(val)
+#define BIN2BCD(val)	bin2bcd(val)
 
 /* backwards compat */
 #define BCD_TO_BIN(val) ((val)=BCD2BIN(val))
--- a/lib/Makefile	2008-06-29 15:17:22.000000000 -0700
+++ b/lib/Makefile	2008-06-29 15:21:44.000000000 -0700
@@ -13,7 +13,7 @@ lib-$(CONFIG_SMP) += cpumask.o
 
 lib-y	+= kobject.o kref.o klist.o
 
-obj-y += div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
+obj-y += bcd.o div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
 	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o
 
 ifeq ($(CONFIG_DEBUG_KOBJECT),y)
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ b/lib/bcd.c	2008-06-29 15:27:31.000000000 -0700
@@ -0,0 +1,14 @@
+#include <linux/bcd.h>
+#include <linux/module.h>
+
+unsigned bcd2bin(unsigned char val)
+{
+	return (val & 0x0f) + (val >> 4) * 10;
+}
+EXPORT_SYMBOL(bcd2bin);
+
+unsigned char bin2bcd(unsigned val)
+{
+	return ((val / 10) << 4) + val % 10;
+}
+EXPORT_SYMBOL(bin2bcd);
