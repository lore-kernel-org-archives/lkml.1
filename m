Return-Path: <linux-kernel-owner+w=401wt.eu-S1763132AbYB0HFI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763132AbYB0HFI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 02:05:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754237AbYB0HEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 02:04:55 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:58069 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754130AbYB0HEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 02:04:54 -0500
Date: Tue, 26 Feb 2008 22:47:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, Martin Michlmayr <tbm@cyrius.com>,
       linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
       Ralf Baechle <ralf@linux-mips.org>, linux-crypto@vger.kernel.org
Subject: Re: [2.6.25 patch] drivers/crypto/hifn_795x.c: fix 64bit division
Message-Id: <20080226224719.6994a3bf.akpm@linux-foundation.org>
In-Reply-To: <20080227062207.GB10603@cs181133002.pp.htv.fi>
References: <20080226122100.GB22699@deprecation.cyrius.com>
	<20080226153421.GB10717@cs181133002.pp.htv.fi>
	<20080226185240.GA2521@2ka.mipt.ru>
	<20080226160439.5941cc31.akpm@linux-foundation.org>
	<20080227062207.GB10603@cs181133002.pp.htv.fi>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2008 08:22:07 +0200 Adrian Bunk <bunk@kernel.org> wrote:

> On Tue, Feb 26, 2008 at 04:04:39PM -0800, Andrew Morton wrote:
> > On Tue, 26 Feb 2008 21:52:40 +0300 Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> > 
> > > Hi Adrian.
> > > 
> > > On Tue, Feb 26, 2008 at 05:34:21PM +0200, Adrian Bunk (bunk@kernel.org) wrote:
> > > > Using ndelay() with a 64bit variable as parameter can result in build 
> > > > errors like the following on some 32bit systems when it results in a 
> > > > 64bit division:
> > > > 
> > > > <--  snip  -->
> > > > 
> > > >  ...
> > > >   MODPOST 759 modules
> > > > ERROR: "__divdi3" [drivers/crypto/hifn_795x.ko] undefined!
> > > > 
> > > > <--  snip  -->
> > > > 
> > > > Reported by Martin Michlmayr.
> > > > 
> > > > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> > > 
> > > Yep, ndelay() uses division, thanks a lot Adrian for spotting this.
> > 
> > hm.  Where?
> >...
> 
> include/linux/delay.h:35
> 

well found.

Something like this:


--- a/include/linux/delay.h~a
+++ a/include/linux/delay.h
@@ -7,10 +7,12 @@
  * Delay routines, using a pre-computed "loops_per_jiffy" value.
  */
 
-extern unsigned long loops_per_jiffy;
+#include <linux/kernel.h>
 
 #include <asm/delay.h>
 
+extern unsigned long loops_per_jiffy;
+
 /*
  * Using udelay() for intervals greater than a few milliseconds can
  * risk overflow for high loops_per_jiffy (high bogomips) machines. The
@@ -32,7 +34,11 @@ extern unsigned long loops_per_jiffy;
 #endif
 
 #ifndef ndelay
-#define ndelay(x)	udelay(((x)+999)/1000)
+static inline void ndelay(unsigned long x)
+{
+	udelay(DIV_ROUND_UP(x, 1000));
+}
+#define ndelay(x) ndelay(x)
 #endif
 
 void calibrate_delay(void);
_


