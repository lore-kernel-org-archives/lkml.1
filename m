Return-Path: <linux-kernel-owner+w=401wt.eu-S1754169AbYI3PkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169AbYI3PkW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 11:40:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753044AbYI3PkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 11:40:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52321 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753047AbYI3PkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 11:40:01 -0400
Message-ID: <48E2480A.9090003@linux-foundation.org>
Date: Tue, 30 Sep 2008 10:38:50 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Richard Kennedy <richard@rsk.demon.co.uk>
CC: penberg <penberg@cs.helsinki.fi>, mpm <mpm@selenic.com>,
       linux-mm <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] slub: reduce total stack usage of slab_err & object_err
References: <1222787736.2995.24.camel@castor.localdomain>
In-Reply-To: <1222787736.2995.24.camel@castor.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Kennedy wrote:
> reduce the total stack usage of slab_err & object_err.
> 
> Introduce a new function to display a simple slab bug message, and call
> this when vprintk is not needed.

You could simply get rid of the 100 byte buffer by using vprintk? Same method
could be used elsewhere in the kernel and does not require additional
functions. Compiles, untestted.




Subject: Slub reduce slab_bug stack usage by using vprintk

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2008-09-30 10:34:40.000000000 -0500
+++ linux-2.6/mm/slub.c	2008-09-30 10:36:10.000000000 -0500
@@ -422,15 +422,14 @@
 static void slab_bug(struct kmem_cache *s, char *fmt, ...)
 {
 	va_list args;
-	char buf[100];

 	va_start(args, fmt);
-	vsnprintf(buf, sizeof(buf), fmt, args);
-	va_end(args);
 	printk(KERN_ERR "========================================"
 			"=====================================\n");
-	printk(KERN_ERR "BUG %s: %s\n", s->name, buf);
-	printk(KERN_ERR "----------------------------------------"
+	printk(KERN_ERR "BUG %s: ", s->name);
+	vprintk(fmt, args);
+	va_end(args);
+	printk(KERN_ERR "\n----------------------------------------"
 			"-------------------------------------\n\n");
 }

