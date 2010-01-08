Return-Path: <linux-kernel-owner+w=401wt.eu-S1751123Ab0AHGYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751123Ab0AHGYh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 01:24:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750843Ab0AHGYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 01:24:37 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:28263 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800Ab0AHGYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 01:24:36 -0500
X-IronPort-AV: E=Sophos;i="4.49,240,1262581200"; 
   d="scan'208";a="9886133"
Subject: Re: [PATCH] Ftrace: irqsoff tracer may cause stack overflow
From: Li Yi <yi.li@analog.com>
To: Mike Frysinger <vapier.adi@gmail.com>
CC: Arnd Bergmann <arnd@arndb.de>, rostedt@goodmis.org,
       linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
In-Reply-To: <8bd0f97a1001072054y798833dftdb1b2a744ad52969@mail.gmail.com>
References: <1262925925.27700.15.camel@adam-desktop>
	 <8bd0f97a1001072054y798833dftdb1b2a744ad52969@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 8 Jan 2010 14:26:11 +0800
Message-ID: <1262931971.27700.128.camel@adam-desktop>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Jan 2010 06:24:31.0027 (UTC) FILETIME=[3CB99830:01CA902B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-07 at 23:54 -0500, Mike Frysinger wrote:
> > @@ -60,11 +60,11 @@ static inline int atomic_add_return(int i, atomic_t
> > *v)
> > @@ -82,11 +82,11 @@ static inline int atomic_sub_return(int i, atomic_t
> > *v)
> > @@ -139,9 +139,9 @@ static inline void atomic_clear_mask(unsigned long
> > mask, unsigned long *addr)
> 
> looks like your mailer has line wrapping problems ... might want to
> fix that.  maybe just find a smtp server in ADI shanghai's office to
> send to and use sendemail.smtpersver in your ~/.gitconfig ?
> -mike
> 

Thanks. Disabled auto-wrap and resend:

"irqsoff" tracer may cause stack overflow on architectures using asm-generic/atomic.h, due to recursive invoking of trace_hardirqs_off().

trace_hardirqs_off() -> start_critical_timing() -> atomic_inc() -> atomic_add_return() -> local_irq_save() -> trace_hardirqs_off()

Signed-off-by: Yi Li <yi.li@analog.com>
---
 include/asm-generic/atomic.h |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/asm-generic/atomic.h b/include/asm-generic/atomic.h
index c99c64d..c3e5f4b 100644
--- a/include/asm-generic/atomic.h
+++ b/include/asm-generic/atomic.h
@@ -60,11 +60,11 @@ static inline int atomic_add_return(int i, atomic_t *v)
 	unsigned long flags;
 	int temp;
 
-	local_irq_save(flags);
+	raw_local_irq_save(flags);
 	temp = v->counter;
 	temp += i;
 	v->counter = temp;
-	local_irq_restore(flags);
+	raw_local_irq_restore(flags);
 
 	return temp;
 }
@@ -82,11 +82,11 @@ static inline int atomic_sub_return(int i, atomic_t *v)
 	unsigned long flags;
 	int temp;
 
-	local_irq_save(flags);
+	raw_local_irq_save(flags);
 	temp = v->counter;
 	temp -= i;
 	v->counter = temp;
-	local_irq_restore(flags);
+	raw_local_irq_restore(flags);
 
 	return temp;
 }
@@ -139,9 +139,9 @@ static inline void atomic_clear_mask(unsigned long mask, unsigned long *addr)
 	unsigned long flags;
 
 	mask = ~mask;
-	local_irq_save(flags);
+	raw_local_irq_save(flags);
 	*addr &= mask;
-	local_irq_restore(flags);
+	raw_local_irq_restore(flags);
 }
 
 #define atomic_xchg(ptr, v)		(xchg(&(ptr)->counter, (v)))
-- 
1.6.0.4


