Return-Path: <linux-kernel-owner+w=401wt.eu-S1754151AbXFLKRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151AbXFLKRS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 06:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751572AbXFLKRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 06:17:08 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:57757 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752106AbXFLKRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 06:17:06 -0400
Date: Tue, 12 Jun 2007 12:16:56 +0200
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Christoph Lameter <clameter@sgi.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       David Brownell <david-b@pacbell.net>
Subject: Re: kernel BUG at mm/slub.c:3689!
Message-ID: <20070612121656.00cabc45@dhcp-255-175.norway.atmel.com>
In-Reply-To: <20070612105512.471ec7e6@dhcp-255-175.norway.atmel.com>
References: <20070611161926.2a9f8efd@dhcp-255-175.norway.atmel.com>
	<Pine.LNX.4.64.0706110946430.15910@schroedinger.engr.sgi.com>
	<1defaf580706111011w641b26fbu68d6d34028f6e953@mail.gmail.com>
	<Pine.LNX.4.64.0706111041160.17264@schroedinger.engr.sgi.com>
	<1defaf580706111122n78ab46c3sda05cbd4ace97319@mail.gmail.com>
	<Pine.LNX.4.64.0706111129270.18327@schroedinger.engr.sgi.com>
	<1defaf580706111204v35b4dcc9j5dc68e722bd384b1@mail.gmail.com>
	<Pine.LNX.4.64.0706111208580.19316@schroedinger.engr.sgi.com>
	<1defaf580706111235p7da29d25xc33d221134f3f7a8@mail.gmail.com>
	<Pine.LNX.4.64.0706111239230.19654@schroedinger.engr.sgi.com>
	<1defaf580706111253q2a4910b1v4802436e32e94953@mail.gmail.com>
	<Pine.LNX.4.64.0706112016030.25563@schroedinger.engr.sgi.com>
	<20070612105512.471ec7e6@dhcp-255-175.norway.atmel.com>
Organization: Atmel Norway
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Jun 2007 10:55:12 +0200
Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:

> On Mon, 11 Jun 2007 20:16:31 -0700 (PDT)
> Christoph Lameter <clameter@sgi.com> wrote:
> 
> > > and I can't do that over VPN. I'll test it first thing in the morning.
> > 
> > Here is a more general fix
> 
> Sorry, that didn't work either. One problem is that you're using
> ARCH_KMALLOC_MIN_ALIGN instead of ARCH_KMALLOC_MINALIGN in slub_defs.h
> to determine KMALLOC_MIN_SIZE. After fixing that, it fails with
> undefined references to __kmalloc_size_too_large. It looks like ilog2()
> is behaving strangely; I'll see if I can figure out what's going on.

Looks like gcc didn't recognize max(8, ARCH_KMALLOC_MINALIGN) as a
constant expression, so __kmalloc_size_too_large() got referenced
although it never got called as far as I can tell. Works like a charm
after applying this patch on top of yours.

Tested with CONFIG_SLUB_DEBUG=n, CONFIG_SLUB_DEBUG=y and
CONFIG_SLUB_DEBUG=y with slub_debug set.


diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index 7ef94d4..7fb785f 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -56,8 +56,8 @@ struct kmem_cache {
 /*
  * Kmalloc subsystem.
  */
-#ifdef ARCH_KMALLOC_MIN_ALIGN
-#define KMALLOC_MIN_SIZE max(8, ARCH_KMALLOC_MIN_ALIGN)
+#if defined(ARCH_KMALLOC_MINALIGN) && (ARCH_KMALLOC_MINALIGN > 8)
+#define KMALLOC_MIN_SIZE ARCH_KMALLOC_MINALIGN
 #else
 #define KMALLOC_MIN_SIZE 8
 #endif
