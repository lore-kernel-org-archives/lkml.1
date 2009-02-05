Return-Path: <linux-kernel-owner+w=401wt.eu-S1754484AbZBEWMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484AbZBEWMa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 17:12:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752678AbZBEWMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 17:12:22 -0500
Received: from mx2.redhat.com ([66.187.237.31]:37350 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528AbZBEWMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 17:12:21 -0500
Message-ID: <498B6457.20302@redhat.com>
Date: Thu, 05 Feb 2009 17:12:39 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Nick Piggin <npiggin@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       systemtap-ml <systemtap@sources.redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: [BUGFIX][PATCH -rc/-mm] prevent kprobes from catching spurious page
 faults
References: <497FC3B1.7050805@redhat.com> <497FE895.1080708@redhat.com> <20090128154824.GA6025@Krystal> <49808EEF.1020700@redhat.com> <20090128171331.GA9006@Krystal> <49809CCE.40409@redhat.com> <20090128181053.GC9908@Krystal>
In-Reply-To: <20090128181053.GC9908@Krystal>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prevent kprobes from catching spurious faults which will cause infinite
recursive page-fault and memory corruption by stack overflow.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
---
 This patch solves memory corruption bug which I reported last week.
 http://lkml.org/lkml/2009/1/27/428
 Since 2.6.28 kernel also has same bug, I think it should be applied
 to 2.6.28.y too.

 Thanks,

 arch/x86/mm/fault.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/mm/fault.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/fault.c
+++ linux-2.6/arch/x86/mm/fault.c
@@ -603,8 +603,6 @@ void __kprobes do_page_fault(struct pt_r

 	si_code = SEGV_MAPERR;

-	if (notify_page_fault(regs))
-		return;
 	if (unlikely(kmmio_fault(regs, address)))
 		return;

@@ -634,6 +632,9 @@ void __kprobes do_page_fault(struct pt_r
 		if (spurious_fault(address, error_code))
 			return;

+		/* kprobes don't want to hook the spurious faults. */
+		if (notify_page_fault(regs))
+			return;
 		/*
 		 * Don't take the mm semaphore here. If we fixup a prefetch
 		 * fault we could otherwise deadlock.
@@ -641,6 +642,9 @@ void __kprobes do_page_fault(struct pt_r
 		goto bad_area_nosemaphore;
 	}

+	/* kprobes don't want to hook the spurious faults. */
+	if (notify_page_fault(regs))
+		return;

 	/*
 	 * It's safe to allow irq's after cr2 has been saved and the

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

