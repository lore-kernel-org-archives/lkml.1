Return-Path: <linux-kernel-owner+w=401wt.eu-S1753897AbZKPU1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbZKPU1S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 15:27:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbZKPU1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 15:27:17 -0500
Received: from tomts5.bellnexxia.net ([209.226.175.25]:35473 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbZKPU1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 15:27:16 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArEEAHc/AUtGGN1W/2dsb2JhbACBTtVqhDwEgW0
Date: Mon, 16 Nov 2009 15:27:20 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: David Miller <davem@davemloft.net>
Cc: nickpiggin@yahoo.com.au, linux-kernel@vger.kernel.org,
       paulmck@linux.vnet.ibm.com, ltt-dev@lists.casi.polymtl.ca,
       rp@svcs.cs.pdx.edu
Subject: Re: Sparc64 support added to Userspace RCU
Message-ID: <20091116202720.GA19798@Krystal>
References: <20091022183242.GA19307@Krystal> <20091022195753.GA27253@Krystal> <20091115.203138.127196997.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20091115.203138.127196997.davem@davemloft.net>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 15:26:26 up 90 days,  7:15,  4 users,  load average: 0.18, 0.12,
	0.16
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Miller (davem@davemloft.net) wrote:
> From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> Date: Thu, 22 Oct 2009 15:57:53 -0400
> 
> > Feedback is welcome,
> 
> __sparc_v8__ does not mean 64-bit longs or pointers as implied here:
> 
> #ifndef __SIZEOF_LONG__
> #if (defined(__sparc_v8__) || defined(__sparc_v9__))
> #define __SIZEOF_LONG__ 8
> #else
> #define __SIZEOF_LONG__ 4
> #endif
> #endif
> 
> "v8" was the last 32-bit standard of the cpu architecture.
> 
> Otherwise looks fine.
> 
> Although this port won't be very useful until it can be built in
> 32-bit mode.  As most applications on sparc64 systems are still
> 32-bit.  Like on powerpc, people only rarely build things 64-bit on
> sparc64.
> 
> You need to build with "-Wa,-Av9a" on the GCC command line for that
> case so that the assembler allows the v9 instructions emitted by your
> macros, even when building for 32-bit.
> 
> Hope this helps.

Yes ! Thanks a lot for this information. I'll push the following fix in
my tree.

Mathieu

diff --git a/README b/README
index 883b808..ca23d43 100644
--- a/README
+++ b/README
@@ -18,11 +18,14 @@ BUILDING
 		Forcing a 32-bit build with 386 backward compatibility:
 		* CFLAGS="-m32 -g -O2" ./configure --host=i386-pc-linux-gnu
 
+		Forcing a 32-bit build for Sparcv9 (typical for Sparc v9)
+		* CFLAGS="-m32 -Wa,-Av9a -g -O2" ./configure
+
 ARCHITECTURES SUPPORTED
 -----------------------
 
 Currently, x86 (i386, i486, i586, i686), x86 64-bit, PowerPC 32/64, S390, S390x
-and Sparc64 are supported. Only tested on Linux so far, but should
+and Sparcv9 32/64 are supported. Only tested on Linux so far, but should
 theoretically work on other operating systems.
 
 QUICK START GUIDE
diff --git a/urcu/uatomic_arch_sparc64.h b/urcu/uatomic_arch_sparc64.h
index 35b9ac2..28829d2 100644
--- a/urcu/uatomic_arch_sparc64.h
+++ b/urcu/uatomic_arch_sparc64.h
@@ -24,7 +24,7 @@
 #include <urcu/system.h>
 
 #ifndef __SIZEOF_LONG__
-#if (defined(__sparc_v8__) || defined(__sparc_v9__))
+#ifdef __LP64__
 #define __SIZEOF_LONG__ 8
 #else
 #define __SIZEOF_LONG__ 4

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
