Return-Path: <linux-kernel-owner+w=401wt.eu-S1758052AbZAMBfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052AbZAMBfY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 20:35:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758226AbZAMB3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 20:29:12 -0500
Received: from kroah.org ([198.145.64.141]:36069 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758181AbZAMB3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 20:29:08 -0500
Date: Mon, 12 Jan 2009 17:27:24 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Kyle McMartin <kyle@mcmartin.ca>
Subject: [patch 16/21] parisc: disable UP-optimized flush_tlb_mm
Message-ID: <20090113012724.GQ4512@kroah.com>
References: <20090113012006.063755472@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="parisc-disable-up-optimized-flush_tlb_mm.patch"
In-Reply-To: <20090113012633.GA4512@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Kyle McMartin <kyle@infradead.org>

commit 5289f46b9de04bde181d833d48df9671b69c4b08 upstream.

flush_tlb_mm's "optimized" uniprocessor case of allocating a new
context for userspace is exposing a race where we can suddely return
to a syscall with the protection id and space id out of sync, trapping
on the next userspace access.

Debugged-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Tested-by: Helge Deller <deller@gmx.de>
Signed-off-by: Kyle McMartin <kyle@mcmartin.ca>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/asm-parisc/tlbflush.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/include/asm-parisc/tlbflush.h
+++ b/include/asm-parisc/tlbflush.h
@@ -44,9 +44,12 @@ static inline void flush_tlb_mm(struct m
 {
 	BUG_ON(mm == &init_mm); /* Should never happen */
 
-#ifdef CONFIG_SMP
+#if 1 || defined(CONFIG_SMP)
 	flush_tlb_all();
 #else
+	/* FIXME: currently broken, causing space id and protection ids
+	 *  to go out of sync, resulting in faults on userspace accesses.
+	 */
 	if (mm) {
 		if (mm->context != 0)
 			free_sid(mm->context);

