Return-Path: <linux-kernel-owner+w=401wt.eu-S932896AbXBTLfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932896AbXBTLfV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 06:35:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964821AbXBTLfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 06:35:21 -0500
Received: from pxy2nd.nifty.com ([202.248.175.14]:23247 "HELO pxy2nd.nifty.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932900AbXBTLfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 06:35:18 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=pxy2nd-default; d=mbf.nifty.com;
  b=2OhqchC9nyfSPbdKp9U+bhs53AuKUPeqjQ8YDOhVNvduBBn2W4eBGM4Hsq1YD3Nl6CoJdVOHRPZf9sraY881ug==  ;
Date: Tue, 20 Feb 2007 20:34:13 +0900 (JST)
Message-Id: <20070220.203413.260790539.takada@mbf.nifty.com>
To: lsorense@csclub.uwaterloo.ca
Cc: rdreier@cisco.com, pcnet32@verizon.net, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: MediaGX/GeodeGX1 requires X86_OOSTORE.
From: takada <takada@mbf.nifty.com>
In-Reply-To: <20070220000231.GM7585@csclub.uwaterloo.ca>
References: <ada3b5253p0.fsf@cisco.com>
	<20070220.085639.260788422.takada@mbf.nifty.com>
	<20070220000231.GM7585@csclub.uwaterloo.ca>
X-Mailer: Mew version 5.1 on Emacs 22.0.92 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Subject: Re: MediaGX/GeodeGX1 requires X86_OOSTORE.
Date: Mon, 19 Feb 2007 19:02:31 -0500

> On Tue, Feb 20, 2007 at 08:56:39AM +0900, takada wrote:
> > /proc/cpuinfo with MediaGXm :

  :

> > flags		: fpu tsc msr cx8 cmov mmx cxmmx
> > bogomips	: 401.00
> > clflush size	: 32
> 
> Hmm with 2.6.18 I am seeing:

I posted with 2.6.20 + enabled X86_OOSTORE.
The clflush sze line is in /proc/cpuinfo. but clfush is not in flags line.

BTW, can we use WBINVD instruction? I tested compile only.
Do you know a method to change dynamically without #ifdef when it works
with MediaGX/GeodeGX.

diff -Narup a/include/asm-i386/io.h b/include/asm-i386/io.h
--- a/include/asm-i386/io.h	2007-02-20 16:23:25.000000000 +0900
+++ b/include/asm-i386/io.h	2007-02-20 17:07:14.000000000 +0900
@@ -232,7 +232,19 @@ static inline void memcpy_toio(volatile 
  *	2. Accidentally out of order processors (PPro errata #51)
  */
  
-#if defined(CONFIG_X86_OOSTORE) || defined(CONFIG_X86_PPRO_FENCE)
+#ifdef CONFIG_MGEODEGX1
+
+static inline void dma_flush_cache(void)
+{
+	__asm__ __volatile__ ("wbinvd": : :"memory");
+}
+
+#define dma_cache_inv(_start,_size)		dma_flush_cache()
+#define dma_cache_wback(_start,_size)		dma_flush_cache()
+#define dma_cache_wback_inv(_start,_size)	dma_flush_cache()
+#define flush_write_buffers()
+
+#elif defined(CONFIG_X86_OOSTORE) || defined(CONFIG_X86_PPRO_FENCE)
 
 static inline void flush_write_buffers(void)
 {
