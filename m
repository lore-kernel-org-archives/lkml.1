Return-Path: <linux-kernel-owner+w=401wt.eu-S1759328AbZAHNGL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759328AbZAHNGL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 08:06:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754760AbZAHNF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 08:05:57 -0500
Received: from twin.jikos.cz ([213.151.79.26]:59101 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754570AbZAHNF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 08:05:56 -0500
Date: Thu, 8 Jan 2009 14:05:48 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Adam Osuchowski <adwol@zonk.pl>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: Is 386 processor still supported?
In-Reply-To: <20090108120338.6b8b4567@zonk.pl>
Message-ID: <alpine.LRH.1.10.0901081359520.24105@twin.jikos.cz>
References: <20090108120338.6b8b4567@zonk.pl>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ CCs added ]

On Thu, 8 Jan 2009, Adam Osuchowski wrote:

> Recently, I found such piece of code in kernel 2.6.28 compiled for 386
> processor:
> 
> # grep M386 .config
> CONFIG_M386=y
> # objdump -d vmlinux | grep -A11 '<_spin_lock>:'
> c0321827 <_spin_lock>:
> c0321827:	89 e2                	mov    %esp,%edx
> c0321829:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
> c032182f:	ff 42 14             	incl   0x14(%edx)
> c0321832:	ba 00 01 00 00       	mov    $0x100,%edx
> c0321837:	f0 66 0f c1 10       	lock xadd %dx,(%eax)
> c032183c:	38 f2                	cmp    %dh,%dl
> c032183e:	74 06                	je     c0321846 <_spin_lock+0x1f>
> c0321840:	f3 90                	pause  
> c0321842:	8a 10                	mov    (%eax),%dl
> c0321844:	eb f6                	jmp    c032183c <_spin_lock+0x15>
> c0321846:	c3                   	ret    
> 
> But there is no xadd instruction on 386 processors. It is available on
> 486+ only. I have no chance to run this kernel on real 386 box, so I can't
> check it in practice, but I think it will not run.
> 
> It is not compiler problem because it is explicitly written in assembly
> in __raw_spin_lock() function (include/asm-x86/spinlock.h) and there is
> no alternative code depending on CONFIG_M386.

Hmm, this really looks like a bug to me. How about something like this 
(untested).


From: Jiri Kosina <jkosina@suse.cz>
Subject: x86: make spinlocks available on machines without xadd insn

Current kernel wouldn't compile on ancient x86 machines that don't support 
xadd instruction, as ticket spinlocks implementation unconditionally uses 
it.

On machines without CONFIG_X86_XADD, use old-style byte spinlock 
implementation instead.

Reported-by: Adam Osuchowski <adwol@zonk.pl>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>

diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index d17c919..b3bc71b 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -236,6 +236,40 @@ static inline void __byte_spin_unlock(raw_spinlock_t *lock)
 	bl->lock = 0;
 }
 #else  /* !CONFIG_PARAVIRT */
+
+/* old x86 machines do not have xadd insns, use old-style locks for them */
+#ifndef CONFIG_X86_XADD
+static inline int __raw_spin_is_locked(raw_spinlock_t *lock)
+{
+	return __byte_spin_is_locked(lock);
+}
+
+static inline int __raw_spin_is_contended(raw_spinlock_t *lock)
+{
+	return __byte_spin_is_contended(lock);
+}
+
+static __always_inline void __raw_spin_lock(raw_spinlock_t *lock)
+{
+	__byte_spin_lock(lock);
+}
+
+static __always_inline int __raw_spin_trylock(raw_spinlock_t *lock)
+{
+	return __byte_spin_trylock(lock);
+}
+
+static __always_inline void __raw_spin_unlock(raw_spinlock_t *lock)
+{
+	__byte_spin_unlock(lock);
+}
+
+static __always_inline void __raw_spin_lock_flags(raw_spinlock_t *lock,
+						  unsigned long flags)
+{
+	__raw_spin_lock(lock);
+}
+#else /* CONFIG_X86_XADD */
 static inline int __raw_spin_is_locked(raw_spinlock_t *lock)
 {
 	return __ticket_spin_is_locked(lock);
@@ -267,6 +301,7 @@ static __always_inline void __raw_spin_lock_flags(raw_spinlock_t *lock,
 	__raw_spin_lock(lock);
 }
 
+#endif  /* CONFIG_X86_XADD */
 #endif	/* CONFIG_PARAVIRT */
 
 static inline void __raw_spin_unlock_wait(raw_spinlock_t *lock)
