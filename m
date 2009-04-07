Return-Path: <linux-kernel-owner+w=401wt.eu-S1757313AbZDGBTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313AbZDGBTX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 21:19:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752237AbZDGBTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 21:19:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:37922 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029AbZDGBTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 21:19:12 -0400
Subject: Re: intel-iommu: Add for_each_iommu() and for_each_active_iommu()
 macros
From: David Woodhouse <dwmw2@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <1239066583.22733.258.camel@macbook.infradead.org>
References: <200904062159.n36Lx1OJ001967@hera.kernel.org>
	 <20090406175918.c38654b2.akpm@linux-foundation.org>
	 <1239066583.22733.258.camel@macbook.infradead.org>
Content-Type: text/plain
Date: Mon, 06 Apr 2009 18:19:06 -0700
Message-Id: <1239067146.22733.260.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 (2.26.0-2.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-04-06 at 18:09 -0700, David Woodhouse wrote:
> 
> I'm unconvinced by the fix -- can we find a way to fix the if() macro so
> that normal (if fugly) C code like this doesn't doesn't need this kind
> of workaround?

Something like this perhaps? I'd reformat it but dinner calls...

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 6faa7e5..1da2e72 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -114,7 +114,7 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
  * "Define 'is'", Bill Clinton
  * "Define 'if'", Steven Rostedt
  */
-#define if(cond) if (__builtin_constant_p((cond)) ? !!(cond) :		\
+#define if(cond, ...) if (__builtin_constant_p((cond, ## __VA_ARGS__)) ? !!(cond, ## __VA_ARGS__) : \
 	({								\
 		int ______r;						\
 		static struct ftrace_branch_data			\
@@ -125,7 +125,7 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
 				.file = __FILE__,			\
 				.line = __LINE__,			\
 			};						\
-		______r = !!(cond);					\
+		______r = !!(cond, ## __VA_ARGS__);					\
 		______f.miss_hit[______r]++;					\
 		______r;						\
 	}))

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

