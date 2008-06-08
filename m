Return-Path: <linux-kernel-owner+w=401wt.eu-S1756917AbYFHNRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917AbYFHNRT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 09:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752300AbYFHNRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 09:17:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51773 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbYFHNRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 09:17:11 -0400
Subject: Re: [PATCH] Speed up "make headers_*"
From: David Woodhouse <dwmw2@infradead.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jan Engelhardt <jengelh@computergmbh.de>, geert@linux-m68k.org,
       zippel@linux-m68k.org
In-Reply-To: <20080608111707.GB10545@uranus.ravnborg.org>
References: <20080608094730.GA30098@uranus.ravnborg.org>
	 <19f34abd0806080312j2b09179cpa384a0460af5874e@mail.gmail.com>
	 <20080608104122.GA10545@uranus.ravnborg.org>
	 <1212922141.32207.495.camel@pmac.infradead.org>
	 <20080608111707.GB10545@uranus.ravnborg.org>
Content-Type: text/plain
Date: Sun, 08 Jun 2008 14:17:04 +0100
Message-Id: <1212931024.32207.546.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-06-08 at 13:17 +0200, Sam Ravnborg wrote:
> #if !defined(CONFIG_M68K) || !defined(__KERNEL__)

That's just scary, and broken for m68k where in userspace neither
CONFIG_M68K nor __KERNEL__ will be defined, so the unwanted ac_ahz
member will actually show up and break the binary compatibility.

Assuming we _don't_ want the ac_ahz member to be included on m68k, this
should fix it (is __mc68000__ the right thing to use?)...

diff --git a/include/linux/acct.h b/include/linux/acct.h
index e8cae54..228473b 100644
--- a/include/linux/acct.h
+++ b/include/linux/acct.h
@@ -58,8 +58,7 @@ struct acct
 	comp_t		ac_minflt;		/* Minor Pagefaults */
 	comp_t		ac_majflt;		/* Major Pagefaults */
 	comp_t		ac_swaps;		/* Number of Swaps */
-/* m68k had no padding here. */
-#if !defined(CONFIG_M68K) || !defined(__KERNEL__)
+#ifndef __mc68000__ /* m68k had no padding here. */
 	__u16		ac_ahz;			/* AHZ */
 #endif
 	__u32		ac_exitcode;		/* Exitcode */




-- 
dwmw2

