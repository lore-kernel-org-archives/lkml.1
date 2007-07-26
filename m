Return-Path: <linux-kernel-owner+w=401wt.eu-S1758786AbXGZBpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758786AbXGZBpu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 21:45:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754195AbXGZBpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 21:45:42 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:39649 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754095AbXGZBpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 21:45:41 -0400
Date: Thu, 26 Jul 2007 10:45:10 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, jason.wessel@windriver.com,
       amitkale@linsyssoft.com, linux-kernel@vger.kernel.org,
       kgdb-bugreport@lists.sourceforge.net
Subject: Re: 2.6.23-rc1-mm1: git-kgdb breaks sh compilation
Message-ID: <20070726014510.GA23798@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian Bunk <bunk@stusta.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	jason.wessel@windriver.com, amitkale@linsyssoft.com,
	linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net
References: <20070725040304.111550f4.akpm@linux-foundation.org> <20070725211741.GI3572@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070725211741.GI3572@stusta.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2007 at 11:17:41PM +0200, Adrian Bunk wrote:
> On Wed, Jul 25, 2007 at 04:03:04AM -0700, Andrew Morton wrote:
> >...
> > Changes since 2.6.22-rc6-mm1:
> >...
> >  git-kgdb.patch
> > 
> >  git trees
> >...
> 
> This causes the following compile error on sh:
> 
> <--  snip  -->
> 
> ...
>   CC      drivers/serial/sh-sci.o
> drivers/serial/sh-sci.c: In function 'put_string':
> drivers/serial/sh-sci.c:188: error: 'hexchars' undeclared (first use in this function)
> drivers/serial/sh-sci.c:188: error: (Each undeclared identifier is reported only once
> drivers/serial/sh-sci.c:188: error: for each function it appears in.)
> make[3]: *** [drivers/serial/sh-sci.o] Error 1
> 
> <--  snip  -->
> 
Cool, it's like 5 years ago all over again. It looks like most of
the kgdb stuff is going to need to be re-ported, as it's effectively
thrown out years of changes, and perhaps not surprisingly, blows up quite
spectacularly in the process.

At least this problem with KGDB disabled is an easy fix. I'll see about
getting CONFIG_KGDB=y resynced with the current serial driver and arch
stub.

-----

serial: sh-sci: Fix build failure from kgdb fallout.

  CC      drivers/serial/sh-sci.o
drivers/serial/sh-sci.c: In function 'put_string':
drivers/serial/sh-sci.c:188: error: 'hexchars' undeclared (first use in this function)
drivers/serial/sh-sci.c:188: error: (Each undeclared identifier is reported only once
drivers/serial/sh-sci.c:188: error: for each function it appears in.)
make[3]: *** [drivers/serial/sh-sci.o] Error 1

Reported-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Paul Mundt <lethal@linux-sh.org>

--

 drivers/serial/sh-sci.c |    1 +
 1 file changed, 1 insertion(+)

diff -X linux-2.6.23-rc1-mm1/Documentation/dontdiff -urN linux-2.6.23-rc1-mm1.orig/drivers/serial/sh-sci.c linux-2.6.23-rc1-mm1/drivers/serial/sh-sci.c
--- linux-2.6.23-rc1-mm1.orig/drivers/serial/sh-sci.c	2007-07-26 10:23:51.000000000 +0900
+++ linux-2.6.23-rc1-mm1/drivers/serial/sh-sci.c	2007-07-26 10:34:59.000000000 +0900
@@ -161,6 +161,7 @@
 
 #if defined(CONFIG_SH_STANDARD_BIOS) || defined(CONFIG_SH_KGDB)
 	int checksum;
+	const char hexchars[] = "0123456789abcdef";
 	int usegdb=0;
 
 #ifdef CONFIG_SH_STANDARD_BIOS
