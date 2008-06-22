Return-Path: <linux-kernel-owner+w=401wt.eu-S1757006AbYFVTGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757006AbYFVTGr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 15:06:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756177AbYFVTE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 15:04:56 -0400
Received: from mx1.suse.de ([195.135.220.2]:43592 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756172AbYFVTEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 15:04:55 -0400
Date: Sun, 22 Jun 2008 12:01:47 -0700
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Jan Beulich <jbeulich@novell.com>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 5/5] x86: set PAE PHYSICAL_MASK_SHIFT to 44 bits.
Message-ID: <20080622190147.GF20141@suse.de>
References: <20080622185327.348377223@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-set-pae-physical_mask_shift-to-44-bits.patch"
In-Reply-To: <20080622190111.GA20141@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
From: gregkh@suse.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Jeremy Fitzhardinge <jeremy@goop.org>

commit ad524d46f36bbc32033bb72ba42958f12bf49b06 upstream

When a 64-bit x86 processor runs in 32-bit PAE mode, a pte can
potentially have the same number of physical address bits as the
64-bit host ("Enhanced Legacy PAE Paging").  This means, in theory,
we could have up to 52 bits of physical address in a pte.

The 32-bit kernel uses a 32-bit unsigned long to represent a pfn.
This means that it can only represent physical addresses up to 32+12=44
bits wide.  Rather than widening pfns everywhere, just set 2^44 as the
Linux x86_32-PAE architectural limit for physical address size.

This is a bugfix for two cases:
1. running a 32-bit PAE kernel on a machine with
  more than 64GB RAM.
2. running a 32-bit PAE Xen guest on a host machine with
  more than 64GB RAM

In both cases, a pte could need to have more than 36 bits of physical,
and masking it to 36-bits will cause fairly severe havoc.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/asm-x86/page_32.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/asm-x86/page_32.h
+++ b/include/asm-x86/page_32.h
@@ -14,7 +14,8 @@
 #define __PAGE_OFFSET		_AC(CONFIG_PAGE_OFFSET, UL)
 
 #ifdef CONFIG_X86_PAE
-#define __PHYSICAL_MASK_SHIFT	36
+/* 44=32+12, the limit we can fit into an unsigned long pfn */
+#define __PHYSICAL_MASK_SHIFT	44
 #define __VIRTUAL_MASK_SHIFT	32
 #define PAGETABLE_LEVELS	3
 

-- 
