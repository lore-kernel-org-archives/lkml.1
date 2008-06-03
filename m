Return-Path: <linux-kernel-owner+w=401wt.eu-S1754920AbYFCDEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920AbYFCDEY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 23:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752231AbYFCDEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 23:04:16 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:3983 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbYFCDEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 23:04:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=OUbRJTS6bFGQje7liyvURDD8lvnJMIhs5TFpcdS26yBW9DFRWNFiSf+NRdoSWQ4OT+o4M6wkj8nwqLDUIaiXE1khVx4xvS7HMEe94Rx22WvZLBNsTug0wEkG0bQZ5YE2WOsT9pDPY1dbmSdtUPWe5FrZYlvlAgtgiKIVZNiZYgI=
Message-ID: <4844B48D.5020509@gmail.com>
Date: Tue, 03 Jun 2008 08:33:41 +0530
From: Abhishek Sagar <sagar.abhishek@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] ftrace: prevent freeing of all failed updates
References: <4842CB9A.1080800@gmail.com> <Pine.LNX.4.58.0806021401340.10366@gandalf.stny.rr.com>
In-Reply-To: <Pine.LNX.4.58.0806021401340.10366@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> If we unload a module and reload it, will it ever get converted again?

The intent was always to filter core kernel functions to prevent their freeing.
Here's a fix which should allow re-recording of module call-sites.

---
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index ec54cb7..77c9392 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -437,7 +437,7 @@ static void ftrace_replace_code(int enable)
 			if (failed && (rec->flags & FTRACE_FL_CONVERTED)) {
 				rec->flags |= FTRACE_FL_FAILED;
 				if ((system_state == SYSTEM_BOOTING) ||
-				    !kernel_text_address(rec->ip)) {
+				    !core_kernel_text(rec->ip)) {
 					ftrace_del_hash(rec);
 					ftrace_free_rec(rec);
 				}
@@ -658,10 +658,9 @@ static int __ftrace_update_code(void *ignore)
 				ftrace_update_cnt++;
 			} else {
 				if ((system_state == SYSTEM_BOOTING) ||
-				    !kernel_text_address(p->ip)) {
+				    !core_kernel_text(p->ip)) {
 					ftrace_del_hash(p);
 					ftrace_free_rec(p);
-
 				}
 			}
 		}
