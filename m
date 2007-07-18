Return-Path: <linux-kernel-owner+w=401wt.eu-S936031AbXGRSIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936031AbXGRSIU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 14:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762792AbXGRSIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 14:08:06 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:55704 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762621AbXGRSIE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 14:08:04 -0400
Date: Wed, 18 Jul 2007 20:07:56 +0200
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: sunrpc-related Oops in latest git
Message-ID: <20070718200756.761e2683@dhcp-255-175.norway.atmel.com>
In-Reply-To: <1184597534.11083.1.camel@heimdal.trondhjem.org>
References: <20070715170523.2bed7110@dhcp-255-175.norway.atmel.com>
	<1184597534.11083.1.camel@heimdal.trondhjem.org>
Organization: Atmel Norway
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jul 2007 10:52:14 -0400
Trond Myklebust <Trond.Myklebust@netapp.com> wrote:

> > Please let me know if there's anything I can do to help debug this.
> > 
> > Håvard  
> 
> So you are saying that if you revert this patch, and only this patch,
> then it fixes nfsroot? (sorry, I tend not to trust git-bisect)

Well, what do you know. My atomics are broken.

The patch below fixes it. I'll include it in my next pull request,
which I'll send in a moment. Sorry to bother you about this.

Håvard

>From 0cb061fcc12ec7811fc7404fda54f9819d6560bd Mon Sep 17 00:00:00 2001
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
Date: Wed, 18 Jul 2007 20:06:04 +0200
Subject: [AVR32] Fix atomic_add_unless() and atomic_sub_unless()

These functions depend on "result" being initalized to 0, but "result"
is not included as an input constraint to the inline assembly block
following its initialization, only as an output constraint. Thus gcc
thinks it doesn't need to initialize it, so result ends up undefined
if the "unless" condition is true.

This fixes an oops in sunrpc where the faulty atomics caused
rpciod_up() to not start the workqueue as it should.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
 include/asm-avr32/atomic.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/asm-avr32/atomic.h b/include/asm-avr32/atomic.h
index b9c2548..7ef3862 100644
--- a/include/asm-avr32/atomic.h
+++ b/include/asm-avr32/atomic.h
@@ -101,7 +101,7 @@ static inline int atomic_sub_unless(atomic_t *v, int a, int u)
 		"	mov	%1, 1\n"
 		"1:"
 		: "=&r"(tmp), "=&r"(result), "=o"(v->counter)
-		: "m"(v->counter), "rKs21"(a), "rKs21"(u)
+		: "m"(v->counter), "rKs21"(a), "rKs21"(u), "1"(result)
 		: "cc", "memory");
 
 	return result;
@@ -137,7 +137,7 @@ static inline int atomic_add_unless(atomic_t *v, int a, int u)
 			"	mov	%1, 1\n"
 			"1:"
 			: "=&r"(tmp), "=&r"(result), "=o"(v->counter)
-			: "m"(v->counter), "r"(a), "ir"(u)
+			: "m"(v->counter), "r"(a), "ir"(u), "1"(result)
 			: "cc", "memory");
 	}
 
-- 
1.5.2.3

