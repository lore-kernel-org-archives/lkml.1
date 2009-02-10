Return-Path: <linux-kernel-owner+w=401wt.eu-S1756514AbZBJTFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756514AbZBJTFt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 14:05:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754727AbZBJTDb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 14:03:31 -0500
Received: from kroah.org ([198.145.64.141]:53636 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754619AbZBJTDa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 14:03:30 -0500
Date: Tue, 10 Feb 2009 10:59:52 -0800
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
       alan@lxorguk.ukuu.org.uk, Masami Hiramatsu <mhiramat@redhat.com>
Subject: [patch 06/53] prevent kprobes from catching spurious page faults
Message-ID: <20090210185952.GG14308@kroah.com>
References: <20090210185337.000769713@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="prevent-kprobes-from-catching-spurious-page-faults.patch"
In-Reply-To: <20090210185924.GA14308@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Masami Hiramatsu <mhiramat@redhat.com>

commit 9be260a646bf76fa418ee519afa10196b3164681 upstream.

Prevent kprobes from catching spurious faults which will cause infinite
recursive page-fault and memory corruption by stack overflow.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/mm/fault.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -601,8 +601,6 @@ void __kprobes do_page_fault(struct pt_r
 
 	si_code = SEGV_MAPERR;
 
-	if (notify_page_fault(regs))
-		return;
 	if (unlikely(kmmio_fault(regs, address)))
 		return;
 
@@ -632,6 +630,9 @@ void __kprobes do_page_fault(struct pt_r
 		if (spurious_fault(address, error_code))
 			return;
 
+		/* kprobes don't want to hook the spurious faults. */
+		if (notify_page_fault(regs))
+			return;
 		/*
 		 * Don't take the mm semaphore here. If we fixup a prefetch
 		 * fault we could otherwise deadlock.
@@ -639,6 +640,9 @@ void __kprobes do_page_fault(struct pt_r
 		goto bad_area_nosemaphore;
 	}
 
+	/* kprobes don't want to hook the spurious faults. */
+	if (notify_page_fault(regs))
+		return;
 
 	/*
 	 * It's safe to allow irq's after cr2 has been saved and the

