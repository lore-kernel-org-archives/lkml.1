Return-Path: <linux-kernel-owner+w=401wt.eu-S1030320AbXCVJzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030320AbXCVJzs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 05:55:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030321AbXCVJzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 05:55:47 -0400
Received: from ozlabs.org ([203.10.76.45]:43131 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030320AbXCVJzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 05:55:47 -0400
Subject: Re: [PATCH] Cleanup: rationalize paravirt wrappers
From: Rusty Russell <rusty@rustcorp.com.au>
To: Avi Kivity <avi@qumranet.com>
Cc: Andrew Morton <akpm@osdl.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@muc.de>
In-Reply-To: <460239C3.5000404@qumranet.com>
References: <1174531311.2713.86.camel@localhost.localdomain>
	 <46023096.8060809@qumranet.com>
	 <1174550442.2713.128.camel@localhost.localdomain>
	 <460239C3.5000404@qumranet.com>
Content-Type: text/plain
Date: Thu, 22 Mar 2007 20:55:19 +1100
Message-Id: <1174557319.2713.148.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-22 at 10:09 +0200, Avi Kivity wrote:
> Right, scratch that.  Was confused by rdmsr_safe().

Heh... me too 8)

> > The behaviour change (don't oops when an invalid rdmsr is used) was
> > there with CONFIG_PARAVIRT=y, the cleanup just made !CONFIG_PARAVIRT the
> > same.  Is it important?
> 
> I think so.  A function should either never fail, or indicate that it 
> has failed (panic, error return, debug message).  With the kinder, 
> gentler rdmsr() one can code the wrong msr value and not notice that 
> something is wrong.

This is persuasive.  I think restoring native_read_msr &
native_write_msr make sense, and Jeremy's BUG_ON suggestion will cover
the CONFIG_PARAVIRT case.

Something like this (I'll roll back into the main patch, retest, and
resend tomorrow).

Thanks!
Rusty.

diff -r 3ddb2898e72a include/asm-i386/msr.h
--- a/include/asm-i386/msr.h	Thu Mar 22 19:31:11 2007 +1100
+++ b/include/asm-i386/msr.h	Thu Mar 22 19:42:30 2007 +1100
@@ -3,7 +3,16 @@
 
 #include <asm/errno.h>
 
-static inline unsigned long long native_read_msr(unsigned int msr, int *err)
+static inline unsigned long long native_read_msr(unsigned int msr)
+{
+	unsigned long long val;
+
+	asm volatile("rdmsr" : "=A" (val) : "c" (msr));
+	return val;
+}
+
+static inline unsigned long long native_read_msr_safe(unsigned int msr,
+						      int *err)
 {
 	unsigned long long val;
 
@@ -22,7 +31,13 @@ static inline unsigned long long native_
 	return val;
 }
 
-static inline int native_write_msr(unsigned int msr, unsigned long long val)
+static inline void native_write_msr(unsigned int msr, unsigned long long val)
+{
+	asm volatile("wrmsr" : : "c" (msr), "A"(val));
+}
+
+static inline int native_write_msr_safe(unsigned int msr,
+					unsigned long long val)
 {
 	int err;
 	asm volatile("2: wrmsr ; xorl %0,%0\n"
@@ -66,21 +81,17 @@ static inline unsigned long long native_
 
 #define rdmsr(msr,val1,val2)						\
 	do {								\
-		int __err;						\
-		unsigned long long __val = native_read_msr(msr, &__err);	\
+		unsigned long long __val = native_read_msr(msr);	\
 		val1 = __val;						\
 		val2 = __val >> 32;					\
 	} while(0)
 
 #define wrmsr(msr,val1,val2)						\
-	do {								\
-		native_write_msr(msr, ((unsigned long long)val2 << 32) | val1);	\
-	} while(0)
+	native_write_msr(msr, ((unsigned long long)val2 << 32) | val1)
 
 #define rdmsrl(msr,val)					\
 	do {						\
-		int __err;				\
-		(val) = native_read_msr(msr, &__err);	\
+		(val) = native_read_msr(msr);		\
 	} while(0)
 
 static inline void wrmsrl (unsigned long msr, unsigned long long val)
@@ -93,13 +104,13 @@ static inline void wrmsrl (unsigned long
 
 /* wrmsr with exception handling */
 #define wrmsr_safe(msr,val1,val2)						\
-	(native_write_msr(msr, ((unsigned long long)val2 << 32) | val1))
+	(native_write_msr_safe(msr, ((unsigned long long)val2 << 32) | val1))
 
 /* rdmsr with exception handling */
 #define rdmsr_safe(msr,p1,p2)						\
 	({								\
 		int __err;						\
-		unsigned long long __val = native_read_msr(msr, &__err);\
+		unsigned long long __val = native_read_msr_safe(msr, &__err);\
 		(*p1) = __val;						\
 		(*p2) = __val >> 32;					\
 		__err;							\
diff -r 3ddb2898e72a include/asm-i386/paravirt.h
--- a/include/asm-i386/paravirt.h	Thu Mar 22 19:31:11 2007 +1100
+++ b/include/asm-i386/paravirt.h	Thu Mar 22 19:44:03 2007 +1100
@@ -237,19 +237,26 @@ static inline void halt(void)
 	u64 _l = paravirt_ops.read_msr(msr,&_err);		\
 	val1 = (u32)_l;						\
 	val2 = _l >> 32;					\
+	BUG_ON(_err);						\
 } while(0)
 
 #define wrmsr(msr,val1,val2) do {				\
 	u64 _l = ((u64)(val2) << 32) | (val1);			\
-	paravirt_ops.write_msr((msr), _l);			\
+	int _err = paravirt_ops.write_msr((msr), _l);		\
+	BUG_ON(_err);						\
 } while(0)
 
 #define rdmsrl(msr,val) do {					\
 	int _err;						\
 	val = paravirt_ops.read_msr((msr),&_err);		\
-} while(0)
-
-#define wrmsrl(msr,val) (paravirt_ops.write_msr((msr),(val)))
+	BUG_ON(_err);						\
+} while(0)
+
+#define wrmsrl(msr,val) do {					\
+	int _err = paravirt_ops.write_msr((msr),(val));		\
+	BUG_ON(_err);						\
+} while(0)
+
 #define wrmsr_safe(msr,a,b) ({					\
 	u64 _l = ((u64)(b) << 32) | (a);			\
 	paravirt_ops.write_msr((msr),_l);			\





