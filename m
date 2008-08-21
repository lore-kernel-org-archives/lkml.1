Return-Path: <linux-kernel-owner+w=401wt.eu-S1760642AbYHUPuB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760642AbYHUPuB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 11:50:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760140AbYHUPtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 11:49:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:52466 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760081AbYHUPts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 11:49:48 -0400
Date: Thu, 21 Aug 2008 11:49:45 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: ftraced and suspend to ram
Message-ID: <alpine.DEB.1.10.0808211139420.3947@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In latest 2.6.27(git) enabling dynamic ftrace makes resume from a suspend 
to ram reboot instead of resuming. Queued for 2.6.28 is a new method of 
recording mcount callers at compile time that does not have this issue.

But the new method is still too "green" to be pulled into 27, so the old 
ftraced (daemon method) needs to be fixed for 27.

The way dynamic ftrace works with the daemon method is this. On boot up 
the mcount function simply returns. When ftrace is initialized, it calls 
kstop_machine to modify the mcount function to call another function 
called "ftrace_record_ip". This new function will record in a preallocated 
hash (allocated by the ftrace initializer) all the callers of mcount. A 
check is made to see if the caller has already been put into the hash, and 
if so, it is not recorded again.

Later on a kernel thread ftraced is created. This kernel thread wakes up 
once a second and checks to see if any new functions were added to the 
hash. If so, it then calls kstop_machine and modifies those callers to 
mcount into nops.

Again, this daemon method makes resume from suspend to ram reboot instead 
of resuming. Now, I'm asking the s2r gurus, what did I miss? Do I need to 
add a "NO_FREEZE" flag or something to the "ftraced" kernel thread?

Just asking for some advice.

Thanks,

-- Steve

