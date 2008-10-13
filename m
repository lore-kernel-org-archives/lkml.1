Return-Path: <linux-kernel-owner+w=401wt.eu-S1756623AbYJMVr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623AbYJMVr1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 17:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753756AbYJMVrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 17:47:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60555 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752310AbYJMVrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 17:47:18 -0400
Date: Mon, 13 Oct 2008 14:46:28 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Tony Luck <tony.luck@intel.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       tglx@linutronix.de, jbarnes@virtuousgeek.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: split e820 reserved entries record to late v4 -
 fix v7
In-Reply-To: <48F3BA28.2010605@zytor.com>
Message-ID: <alpine.LFD.2.00.0810131431510.3288@nehalem.linux-foundation.org>
References: <1220254284-29532-1-git-send-email-yhlu.kernel@gmail.com>  <20080904190457.GB24990@elte.hu>  <20080904121627.bc182da7.akpm@linux-foundation.org>  <86802c440809041222q244e1adaj16b80f1590053bcf@mail.gmail.com> <12c511ca0810131332h6e5468abk3dfc511f0b25cbe6@mail.gmail.com>
 <48F3BA28.2010605@zytor.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 13 Oct 2008, H. Peter Anvin wrote:
> 
> Here is a fix... currently running standard tests on it.

Or we could do what Andrew suggested some time ago, and extend %p to do 
resource printing, like %pS and %pF.

TOTALLY UNTESTED! But something like this might allow

	printk(KERN_DEBUG "  reserve_region: (%s) %pR\n"
		res->name, res);

and if I did things right it should print

	reserve_region: (name) [xx-xx]

and maybe it's worth it. We certainly do seem to have a fair number of 
those irritating casts for resource printouts.

		Linus
---
 lib/vsprintf.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index c399bc1..dd62557 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -24,6 +24,7 @@
 #include <linux/kernel.h>
 #include <linux/kallsyms.h>
 #include <linux/uaccess.h>
+#include <linux/ioport.h>
 
 #include <asm/page.h>		/* for PAGE_SIZE */
 #include <asm/div64.h>
@@ -528,6 +529,21 @@ static char *symbol_string(char *buf, char *end, void *ptr, int field_width, int
 #endif
 }
 
+static char *resource_string(char *buf, char *end, struct resource *res, int field_width, int precision, int flags)
+{
+	char sym[4*sizeof(resource_size_t) + 4];
+	char *p = sym, *pend = sym + sizeof(sym);
+
+	*p++ = '[';
+	p = number(p, pend, res->start, 16, -1, -1, 0);
+	*p++ = '-';
+	p = number(p, pend, res->end, 16, -1, -1, 0);
+	*p++ = ']';
+	*p = 0;
+
+	return string(buf, end, sym, field_width, precision, flags);
+}
+
 /*
  * Show a '%p' thing.  A kernel extension is that the '%p' is followed
  * by an extra set of alphanumeric characters that are extended format
@@ -549,6 +565,8 @@ static char *pointer(const char *fmt, char *buf, char *end, void *ptr, int field
 		/* Fallthrough */
 	case 'S':
 		return symbol_string(buf, end, ptr, field_width, precision, flags);
+	case 'R':
+		return resource_string(buf, end, ptr, field_width, precision, flags);
 	}
 	flags |= SMALL;
 	if (field_width == -1) {
