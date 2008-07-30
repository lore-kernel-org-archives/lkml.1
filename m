Return-Path: <linux-kernel-owner+w=401wt.eu-S1762862AbYGaAPQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762862AbYGaAPQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 20:15:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762130AbYGaAON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 20:14:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36734 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761877AbYGaAOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 20:14:12 -0400
Date: Wed, 30 Jul 2008 16:58:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
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
       alan@lxorguk.ukuu.org.uk, Jan Beulich <jbeulich@novell.com>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [patch 28/62] vmlinux.lds: move __attribute__((__cold__))
	functions back into final .text section
Message-ID: <20080730235850.GB12896@suse.de>
References: <20080730233050.332789722@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="vmlinux.lds-move-__attribute__-functions-back-into-final-.text-section.patch"
In-Reply-To: <20080730234915.GA12426@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26 -stable review patch.  If anyone has any objections, please let
us know.

------------------
From: Jan Beulich <jbeulich@novell.com>

commit fb5e2b379732e1a6ea32392980bb42e0212db842 upstream

Due to the addition of __attribute__((__cold__)) to a few symbols
without adjusting the linker scripts, those symbols currently may end
up outside the [_stext,_etext) range, as they get placed in
.text.unlikely by (at least) gcc 4.3.0. This may confuse code not only
outside of the kernel, symbol_put_addr()'s BUG() could also trigger.
Hence we need to add .text.unlikely (and for future uses of
__attribute__((__hot__)) also .text.hot) to the TEXT_TEXT() macro.

Issue observed by Lukas Lipavsky.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Tested-by: Lukas Lipavsky <llipavsky@suse.cz>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/asm-generic/vmlinux.lds.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -204,6 +204,7 @@
  * during second ld run in second ld pass when generating System.map */
 #define TEXT_TEXT							\
 		ALIGN_FUNCTION();					\
+		*(.text.hot)						\
 		*(.text)						\
 		*(.ref.text)						\
 		*(.text.init.refok)					\
@@ -213,7 +214,8 @@
 	CPU_KEEP(init.text)						\
 	CPU_KEEP(exit.text)						\
 	MEM_KEEP(init.text)						\
-	MEM_KEEP(exit.text)
+	MEM_KEEP(exit.text)						\
+		*(.text.unlikely)
 
 
 /* sched.text is aling to function alignment to secure we have same

-- 
