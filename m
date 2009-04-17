Return-Path: <linux-kernel-owner+w=401wt.eu-S1759699AbZDQVP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759699AbZDQVP6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 17:15:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756130AbZDQVPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 17:15:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42876 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752930AbZDQVPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 17:15:46 -0400
Date: Fri, 17 Apr 2009 14:12:00 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #13058] First hibernation attempt fails
In-Reply-To: <200904172258.58783.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0904171408081.4042@localhost.localdomain>
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera> <alpine.LFD.2.00.0904170856460.4042@localhost.localdomain> <49E8C06A.5080605@tuffmail.co.uk> <200904172258.58783.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 17 Apr 2009, Rafael J. Wysocki wrote:
> 
> Can you please try to reproduce the problem with the appended debug patch
> applied and send the output of dmesg to me?

Maybe something like this instead (or in addition to).

It does "show_mem()" when memory shrinking fails. It will show a _lot_ of 
data.

Untested, but trivial.

		Linus
---
 kernel/power/swsusp.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/kernel/power/swsusp.c b/kernel/power/swsusp.c
index 78c3504..6e70efd 100644
--- a/kernel/power/swsusp.c
+++ b/kernel/power/swsusp.c
@@ -207,9 +207,16 @@ void swsusp_show_speed(struct timeval *start, struct timeval *stop,
 #define SHRINK_BITE	10000
 static inline unsigned long __shrink_memory(long tmp)
 {
+	unsigned long ret;
+
 	if (tmp > SHRINK_BITE)
 		tmp = SHRINK_BITE;
-	return shrink_all_memory(tmp);
+	ret = shrink_all_memory(tmp);
+	if (!ret) {
+		printk("shrink_all_memory(%ld) failed\n", tmp);
+		show_mem();
+	}
+	return ret;
 }
 
 int swsusp_shrink_memory(void)
