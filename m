Return-Path: <linux-kernel-owner+w=401wt.eu-S1030202AbXCVHtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030202AbXCVHtw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 03:49:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030234AbXCVHtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 03:49:52 -0400
Received: from ozlabs.org ([203.10.76.45]:35894 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030228AbXCVHtv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 03:49:51 -0400
Subject: Re: [PATCH] make KVM conform to sucky rdmsr interface
From: Rusty Russell <rusty@rustcorp.com.au>
To: Avi Kivity <avi@qumranet.com>
Cc: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@osdl.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       Jeremy Fitzhardinge <jeremy@goop.org>
In-Reply-To: <46022E40.8080300@qumranet.com>
References: <1174531917.2713.91.camel@localhost.localdomain>
	 <46022E40.8080300@qumranet.com>
Content-Type: text/plain
Date: Thu, 22 Mar 2007 18:49:30 +1100
Message-Id: <1174549770.2713.121.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-22 at 09:20 +0200, Avi Kivity wrote:
> My rdmsr_safe (x86_64, i386 is similar/same) is

Erk.  Andrew, please drop that patch, and take this one.

It was actually Jeremy's paravirt cleanup patch which changed the
calling convention of rdmsr_safe() to match rdmsr().

I went "oh it's that fucking rdmsr interface" and "fixed" kvm.

Sorry for the bad patch,
Rusty.
==
rdmsr_safe() takes pointers.  rdmsr() modifies its arguments.  What a
mess.

Fix rdmsr_safe() with !CONFIG_PARAVIRT.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r a7f78e8eacc8 include/asm-i386/msr.h
--- a/include/asm-i386/msr.h	Thu Mar 22 12:38:35 2007 +1100
+++ b/include/asm-i386/msr.h	Thu Mar 22 18:40:35 2007 +1100
@@ -96,12 +96,12 @@ static inline void wrmsrl (unsigned long
 	(native_write_msr(msr, ((unsigned long long)val2 << 32) | val1))
 
 /* rdmsr with exception handling */
-#define rdmsr_safe(msr,val1,val2)						\
+#define rdmsr_safe(msr,p1,p2)						\
 	({								\
 		int __err;						\
-		unsigned long long __val = native_read_msr(msr, &__err);	\
-		val1 = __val;						\
-		val2 = __val >> 32;					\
+		unsigned long long __val = native_read_msr(msr, &__err);\
+		(*p1) = __val;						\
+		(*p2) = __val >> 32;					\
 		__err;							\
 	})
 


