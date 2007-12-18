Return-Path: <linux-kernel-owner+w=401wt.eu-S1762133AbXLRE5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762133AbXLRE5x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 23:57:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753402AbXLRE5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 23:57:45 -0500
Received: from ozlabs.org ([203.10.76.45]:55628 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752379AbXLRE5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 23:57:44 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: ananth@in.ibm.com
Subject: Re: [RFC] [patch 1/2] add non_init_kernel_text_address
Date: Tue, 18 Dec 2007 15:57:35 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Srinivasa Ds <srinivasa@in.ibm.com>, linux-kernel@vger.kernel.org,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>
References: <200712141225.30099.srinivasa@in.ibm.com> <20071213230916.cd30de8c.akpm@linux-foundation.org> <20071214075106.GA13249@in.ibm.com>
In-Reply-To: <20071214075106.GA13249@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712181557.35712.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 December 2007 18:51:06 Ananth N Mavinakayanahalli wrote:
> On Thu, Dec 13, 2007 at 11:09:16PM -0800, Andrew Morton wrote:
> > regular_kernel_text_address()?  Dunno.
>
> Sounds better :-)

The better answer was to invert it and use "discarded_kernel_text_address()",
which is what you actually care about (rather than the details of whether it
was init or not).

However, you have, in fact, located a potential bug.  If someone were to
kmalloc module text, then symbol_put() could fail.

How's this?
---
Don't report discarded init pages as kernel text.

In theory this could cause a bug in symbol_put() if an arch used for
a module: we might think the symbol belongs to the core kernel.

The downside is that this might make backtraces through (discarded)
init functions harder to read on some archs.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r 0eabf082c13a kernel/extable.c
--- a/kernel/extable.c	Tue Dec 18 13:51:13 2007 +1100
+++ b/kernel/extable.c	Tue Dec 18 15:53:01 2007 +1100
@@ -46,7 +46,8 @@ int core_kernel_text(unsigned long addr)
 	    addr <= (unsigned long)_etext)
 		return 1;
 
-	if (addr >= (unsigned long)_sinittext &&
+	if (system_state == SYSTEM_BOOTING &&
+	    addr >= (unsigned long)_sinittext &&
 	    addr <= (unsigned long)_einittext)
 		return 1;
 	return 0;
