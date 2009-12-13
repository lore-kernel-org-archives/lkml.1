Return-Path: <linux-kernel-owner+w=401wt.eu-S1753011AbZLMCtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011AbZLMCtq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 21:49:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751912AbZLMCtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 21:49:45 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48197 "HELO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751832AbZLMCtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 21:49:45 -0500
Date: Sat, 12 Dec 2009 18:49:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: vapier@gentoo.org, netdev@vger.kernel.org, nico@fluxnic.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] smc91x: fix unused flags warnings on UP systems
Message-Id: <20091212184938.bd057145.akpm@linux-foundation.org>
In-Reply-To: <20091211.151502.188418417.davem@davemloft.net>
References: <1260366004-27366-1-git-send-email-vapier@gentoo.org>
	<20091211.151502.188418417.davem@davemloft.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Dec 2009 15:15:02 -0800 (PST) David Miller <davem@davemloft.net> wrote:

> From: Mike Frysinger <vapier@gentoo.org>
> Date: Wed,  9 Dec 2009 08:40:04 -0500
> 
> > Local flags variables will be declared whenever these functions get used,
> > but obviously on UP systems the flags parameter won't be touched.  So add
> > some dummy ops that get optimized away anyways to satisfy gcc's warnings.
> > 
> > Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> 
> Applied, although I thought we had a standard macro to handle this
> kind of case.

Nope.

Coverting them to real C functions fixes the warning, and provides
previously-absent typechecking.  ie, (untested):

--- a/drivers/net/smc91x.c~a
+++ a/drivers/net/smc91x.c
@@ -534,9 +534,18 @@ static inline void  smc_rcv(struct net_d
 #define smc_special_lock(lock, flags)		spin_lock_irqsave(lock, flags)
 #define smc_special_unlock(lock, flags) 	spin_unlock_irqrestore(lock, flags)
 #else
-#define smc_special_trylock(lock, flags)	(1)
-#define smc_special_lock(lock, flags)   	do { } while (0)
-#define smc_special_unlock(lock, flags)	do { } while (0)
+static inline int smc_special_trylock(spinlock_t *lock, unsigned long flags)
+{
+	return 1;
+}
+
+static inline void smc_special_lock(spinlock_t *lock, unsigned long flags)
+{
+}
+
+static inline void smc_special_unlock(spinlock_t *lock, unsigned long flags)
+{
+}
 #endif
 
 /*
_


