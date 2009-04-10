Return-Path: <linux-kernel-owner+w=401wt.eu-S1763659AbZDJTVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763659AbZDJTVn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 15:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756502AbZDJTVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 15:21:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56204 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751449AbZDJTVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 15:21:32 -0400
Date: Fri, 10 Apr 2009 12:17:41 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: linux-pm@lists.linux-foundation.org, Takashi Iwai <tiwai@suse.de>,
       Arjan van de Ven <arjan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [linux-pm] [2.6.30-rc1-git2 regressions] Hibernation broken and
 (minor but annoying) audio problem
In-Reply-To: <200904102058.36018.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0904101204350.4583@localhost.localdomain>
References: <200904100057.43827.rjw@sisk.pl> <alpine.LFD.2.00.0904091605080.4583@localhost.localdomain> <200904101439.43480.rjw@sisk.pl> <200904102058.36018.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 10 Apr 2009, Rafael J. Wysocki wrote:
> 
> I've just verified that the resume-after-hibernation issue goes away after
> reverting commit 9710794383ee5008d67f1a6613a4717bf6de47bc
> (async: remove the temporary (2.6.29) "async is off by default" code) , so it
> is async-related.

Arjan? Clearly all the necessary fixes weren't found..

There _is_ a module loading problem wrt initmem - I think you found that 
and we added a hack for it for the ACPI battery driver. I wonder if we're 
hitting a similar issue now with module discovery: modules that use 
"async_schedule()" to do their discovery asynchronously are now not 
necessarily fully "done" when the module is loaded. 

And so, anything that expected the devices to be available after module 
load (like they used to) would be screwed.

IOW, maybe something like the totally untested patch appended here (that 
should also allow us to make the ACPI battery code to go back to using 
__init).

As usual, I'm not using modules, so what do I know.

> The audio issue still remains after the revert, so it is really different.

Ok, probably something from Takashi..

		Linus

---
 kernel/module.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 05f014e..e797812 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2388,6 +2388,9 @@ SYSCALL_DEFINE3(init_module, void __user *, umod,
 	blocking_notifier_call_chain(&module_notify_list,
 				     MODULE_STATE_LIVE, mod);
 
+	/* We need to finish all async code before the module init sequence is done */
+	async_synchronize_full();
+
 	mutex_lock(&module_mutex);
 	/* Drop initial reference. */
 	module_put(mod);
