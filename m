Return-Path: <linux-kernel-owner+w=401wt.eu-S1756086AbXEJNge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086AbXEJNge (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 09:36:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752097AbXEJNg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 09:36:28 -0400
Received: from outbound-cpk.frontbridge.com ([207.46.163.16]:64782 "EHLO
	outbound1-cpk-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752043AbXEJNg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 09:36:27 -0400
X-BigFish: VP
X-Server-Uuid: 89466532-923C-4A88-82C1-66ACAA0041DF
Date: Thu, 10 May 2007 15:35:56 +0200
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: "Andi Kleen" <andi@firstfloor.org>
cc: "Pete Zaitcev" <zaitcev@redhat.com>, ak@suse.de,
       linux-kernel@vger.kernel.org, "Benny Halevy" <bhalevy@panasas.com>,
       akpm@linux-foundation.org
Subject: Re: Andi, you broke my laptop :-)
Message-ID: <20070510133555.GA5705@amd.com>
References: <20070509125616.cde56b8e.zaitcev@redhat.com>
 <20070510130144.GI14898@one.firstfloor.org>
MIME-Version: 1.0
In-Reply-To: <20070510130144.GI14898@one.firstfloor.org>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 10 May 2007 13:36:00.0363 (UTC)
 FILETIME=[25A043B0:01C79308]
X-WSS-ID: 6A5DC05A1OC1568140-01-01
Content-Type: multipart/mixed;
 boundary="bp/iNruPH9dso1Pn"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--bp/iNruPH9dso1Pn
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

On Thu, May 10, 2007 at 03:01:44PM +0200, Andi Kleen wrote:
> On Wed, May 09, 2007 at 12:56:16PM -0700, Pete Zaitcev wrote:
> > Hi, Andi:
> > 
> > The attached patch (actually, git show output) makes my Dell 1501 to hang
> > on boot. Sorry, I have no clue why... The culprit is found with git bisect.
> > But yes, it's an AMD MK-36. I use an x86_64 kernel. It is 100% reproducible.
> 
> MK-36? Does it have SVM? 
> 
> Anyways we previously had issues with this being miscompiled, but 
> I thought the latest patch should have been ok. What compiler do you use?
> 
> Can you send me a disassembly listing of arch/x86_64/kernel/time.o?

I debugged this problem a bit and my compiler[1]interprets the =A
constraint as %rax instead of %edx:%eax on x86_64 which causes the
problem. The appended patch provides a workaround for this and fixed the
hang on my machine.

[1] gcc version 4.1.3 20070429 (prerelease) (Debian 4.1.2-5)

Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

--bp/iNruPH9dso1Pn
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: attachment;
 filename=x86_64_get_cycles_sync_fix.patch
Content-Transfer-Encoding: 7bit

diff --git a/include/asm-i386/alternative.h b/include/asm-i386/alternative.h
index 0f70b37..eb7da54 100644
--- a/include/asm-i386/alternative.h
+++ b/include/asm-i386/alternative.h
@@ -98,6 +98,12 @@ static inline void alternatives_smp_switch(int smp) {}
 		      ".previous" : output : [feat] "i" (feature), ##input)
 
 /*
+ * use this macro(s) if you need more than one output parameter
+ * in alternative_io
+ */
+#define ASM_OUTPUT2(a, b) a, b
+
+/*
  * Alternative inline assembly for SMP.
  *
  * The LOCK_PREFIX macro defined here replaces the LOCK and
diff --git a/include/asm-i386/tsc.h b/include/asm-i386/tsc.h
index 3f3c1fa..62c091f 100644
--- a/include/asm-i386/tsc.h
+++ b/include/asm-i386/tsc.h
@@ -35,14 +35,16 @@ static inline cycles_t get_cycles(void)
 static __always_inline cycles_t get_cycles_sync(void)
 {
 	unsigned long long ret;
-	unsigned eax;
+	unsigned eax, edx;
 
 	/*
   	 * Use RDTSCP if possible; it is guaranteed to be synchronous
  	 * and doesn't cause a VMEXIT on Hypervisors
 	 */
 	alternative_io(ASM_NOP3, ".byte 0x0f,0x01,0xf9", X86_FEATURE_RDTSCP,
-			 	 "=A" (ret), "0" (0ULL) : "ecx", "memory");
+		       ASM_OUTPUT2("=a" (eax), "=d" (edx)),
+		       "a" (0U), "d" (0U) : "ecx", "memory");
+	ret = (((unsigned long long)edx) << 32) | ((unsigned long long)eax);
 	if (ret)
 		return ret;
 
diff --git a/include/asm-x86_64/alternative.h b/include/asm-x86_64/alternative.h
index a09fe85..a094276 100644
--- a/include/asm-x86_64/alternative.h
+++ b/include/asm-x86_64/alternative.h
@@ -103,6 +103,12 @@ static inline void alternatives_smp_switch(int smp) {}
 		      ".previous" : output : [feat] "i" (feature), ##input)
 
 /*
+ * use this macro(s) if you need more than one output parameter
+ * in alternative_io
+ */
+#define ASM_OUTPUT2(a, b) a, b
+
+/*
  * Alternative inline assembly for SMP.
  *
  * The LOCK_PREFIX macro defined here replaces the LOCK and

--bp/iNruPH9dso1Pn--


