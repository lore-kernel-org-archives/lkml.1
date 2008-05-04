Return-Path: <linux-kernel-owner+w=401wt.eu-S1754547AbYEDE0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbYEDE0Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 00:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750850AbYEDE0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 00:26:15 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46432
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750790AbYEDE0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 00:26:14 -0400
Date: Sat, 03 May 2008 21:26:07 -0700 (PDT)
Message-Id: <20080503.212607.157994166.davem@davemloft.net>
To: mingo@elte.hu
Cc: a.p.zijlstra@chello.nl, tglx@linutronix.de, guichaz@gmail.com,
       andi@firstfloor.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, efault@gmx.de, dhaval@linux.vnet.ibm.com
Subject: Re: [RFC][PATCH] sched_clock_cpu()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080503170130.GB21967@elte.hu>
References: <1209832169.6929.42.camel@lappy>
	<20080503170130.GB21967@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Sat, 3 May 2008 19:01:30 +0200

> 
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > it _DOESN'T_ boot ;-/ and I seem to have caught a flu that makes my
> > whole body hurt like hell, so I'm not getting anything done.
> 
> i think i see where your boot problem comes from:
> 
> > +struct sched_clock_data {
> > +	spinlock_t lock;
> 
> that wont work very well when sched_clock() is called from within 
> CONFIG_LOCK_STAT instrumentation. Does the patch below solve the boot 
> problems for you?

Also, no platform can set HAVE_STABLE_CLOCK until we instantiate it in
a Kconfig somewhere.  I've choosen to do it in kernel/Kconfig.hz and
here are the sparc/sparc64 bits as well, I've booted this up with
Peter's patch on my 64-cpu niagara2 box and done some basic testing.

It would be nice if a powerpc person could test the trivial
powerpc Kconfig patch.

Possibly this should be HAVE_UNSTABLE_CLOCK, then only one platform
needs to set it :-)

sparc: Instantiate and set HAVE_STABLE_CLOCK

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index d211fdb..c60f5d4 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -69,6 +69,7 @@ config SPARC
 	select HAVE_IDE
 	select HAVE_OPROFILE
 	select HAVE_ARCH_KGDB if !SMP
+	select HAVE_STABLE_CLOCK
 
 # Identify this as a Sparc32 build
 config SPARC32
diff --git a/arch/sparc64/Kconfig b/arch/sparc64/Kconfig
index eb36f3b..711d4b1 100644
--- a/arch/sparc64/Kconfig
+++ b/arch/sparc64/Kconfig
@@ -14,6 +14,7 @@ config SPARC64
 	select HAVE_IDE
 	select HAVE_LMB
 	select HAVE_ARCH_KGDB
+	select HAVE_STABLE_CLOCK
 
 config GENERIC_TIME
 	bool
diff --git a/kernel/Kconfig.hz b/kernel/Kconfig.hz
index 526128a..b88c82a 100644
--- a/kernel/Kconfig.hz
+++ b/kernel/Kconfig.hz
@@ -56,3 +56,6 @@ config HZ
 
 config SCHED_HRTICK
 	def_bool HIGH_RES_TIMERS && X86
+
+config HAVE_STABLE_CLOCK
+	boolean
