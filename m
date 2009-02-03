Return-Path: <linux-kernel-owner+w=401wt.eu-S1754158AbZBCSU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158AbZBCSU7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 13:20:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752429AbZBCSUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 13:20:52 -0500
Received: from moutng.kundenserver.de ([212.227.126.188]:59606 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbZBCSUv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 13:20:51 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: do not expose CONFIG_BSWAP to userspace
Date: Tue, 3 Feb 2009 19:19:55 +0100
User-Agent: KMail/1.9.9
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@kernel.org>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
References: <20090127222825.GA27097@elte.hu> <1233185764.5322.0.camel@brick> <4980EEA0.4050802@zytor.com>
In-Reply-To: <4980EEA0.4050802@zytor.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200902031919.57107.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/OK3rXh7k1jNxaSia00VgahCpSXTwx6iUN2Zn
 AQdQHHbhgHNTpkhZVjOKkf1CcDR/2azGIOuP9WmJ7NBUz0Bc8p
 G6hl4uU7ceOPnFMFrXNkw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 January 2009, H. Peter Anvin wrote:
> Harvey Harrison wrote:
> > On Wed, 2009-01-28 at 15:27 -0800, H. Peter Anvin wrote:
> >> Harvey Harrison wrote:
> >>> Well, that's unfortunate, how about we just export the BSWAP version
> >>> unconditionally and hope pure i386 just goes away someday?
> >>>
> >> Well, we already have MOVBE coming up, too...
> >>
> > 
> > Is someone already working on an __arch_swab{16|32|64}p to use them?
> > 
> 
> Not that I know of, but it's trivial enough.  They can also be used for 
> all-register swapping, too, with the advantage that you get register 
> decoupling.

I just realized that gcc-4.3 and higher have the __builtin_bswap{16,32,64}
functions on x86, which are supposed to do the right thing on any
platform. Maybe a patch like the one below can solve this for both the
kernel and for other users of the byteorder headers. Unfortunately, I
could not find out whether the builtins are available on all other
platforms as well.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

--- a/arch/x86/include/asm/swab.h
+++ b/arch/x86/include/asm/swab.h
@@ -4,9 +4,17 @@
 #include <linux/types.h>
 #include <linux/compiler.h>
 
+#ifdef __CHECKER__
+extern unsigned long __builtin_bswap_32(unsigned long x);
+extern unsigned long long __builtin_bswap_64(unsigned long long x);
+#endif
+
 static inline __attribute_const__ __u32 __arch_swab32(__u32 val)
 {
-#ifdef __i386__
+#if defined(__GNUC__) && ((__GNUC__ > 4) || \
+		((__GNUC__ == 4) && (__GNUC_MINOR__ >= 3)))
+	val = __builtin_bswap32(val);
+#elif defined (__i386__)
 # ifdef CONFIG_X86_BSWAP
 	asm("bswap %0" : "=r" (val) : "0" (val));
 # else
@@ -28,7 +36,10 @@ static inline __attribute_const__ __u32 __arch_swab32(__u32 val)
 
 static inline __attribute_const__ __u64 __arch_swab64(__u64 val)
 {
-#ifdef __i386__
+#if defined(__GNUC__) && ((__GNUC__ > 4) || \
+		((__GNUC__ == 4) && (__GNUC_MINOR__ >= 3)))
+	return __builtin_bswap64(val);
+#elif defined (__i386__)
 	union {
 		struct {
 			__u32 a;
