Return-Path: <linux-kernel-owner+w=401wt.eu-S1764819AbXLOGwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764819AbXLOGwe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 01:52:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754204AbXLOGwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 01:52:25 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:2849 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763666AbXLOGwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 01:52:24 -0500
Date: Sat, 15 Dec 2007 14:52:11 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Matt Mackall <mpm@selenic.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] Make WARN_ON/WARN_ON_ONCE no-ops when CONFIG_BUG is off
Message-ID: <20071215065211.GA26579@gondor.apana.org.au>
References: <20071214132755.GA18309@gondor.apana.org.au> <20071214180246.GT17536@waste.org> <20071215041659.GB25324@gondor.apana.org.au> <20071215055218.GM19691@waste.org> <20071215060449.GA26199@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071215060449.GA26199@gondor.apana.org.au>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 15, 2007 at 02:04:49PM +0800, Herbert Xu wrote:
>
> I suppose we'll have to either introduce a new primitive or just
> go back to using BUG_ON.

Let's do the conservative thing and add a new primitive.

[PATCH] Added BARF_ON/BARF_ON_ONCE

The description of CONFIG_BUG clearly states that both BUG and
WARN_ON may be skipped.  However, our actual implementation still
checks the condition on WARN_ON if it's used as part of an if
statement or such.

I tried to compile it away but Matt Mackall pointed out that
people may already be using it in ways that were not intended.
In particular, it may have been used for conditions that are
thought to be possible.

So this patch adds a new pair of macros BARF_ON and BARF_ON_ONCE
that are clearly marked as such to prevent abuse.  The intended
usage model is identical to WARN_ON except that they should only
be used for conditions that are thought to be impossible.  In
other words, only use them to replace BUG_ON's that may be called
by an IRQ handler or within locks.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index d56fedb..36e565c 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -43,6 +43,19 @@ struct bug_entry {
 })
 #endif
 
+/*
+ * BARF_ON should only be used in situations which are thought to be
+ * impossible in practice.  In other words, do NOT use it in a place
+ * where you would not use BUG_ON.  It only exists so that the message
+ * gets a chance to be written to disk.
+ *
+ * It should only be used if we can afford to not kill the current
+ * process or the kernel.  So don't use it if we may end up scribbling
+ * over the disk or give people remote root access.
+ */
+#define BARF_ON(condition) WARN_ON(condition)
+#define BARF_ON_ONCE(condition) WARN_ON_ONCE(condition)
+
 #else /* !CONFIG_BUG */
 #ifndef HAVE_ARCH_BUG
 #define BUG()
@@ -58,6 +71,9 @@ struct bug_entry {
 	unlikely(__ret_warn_on);					\
 })
 #endif
+
+#define BARF_ON(condition) ((condition), 0)
+#define BARF_ON_ONCE(condition) BARF_ON(condition)
 #endif
 
 #define WARN_ON_ONCE(condition)	({				\
