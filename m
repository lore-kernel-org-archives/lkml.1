Return-Path: <linux-kernel-owner+w=401wt.eu-S1945924AbXDCUey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945924AbXDCUey (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 16:34:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945916AbXDCUey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 16:34:54 -0400
Received: from smtp.osdl.org ([65.172.181.24]:42529 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945924AbXDCUex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 16:34:53 -0400
Date: Tue, 3 Apr 2007 13:24:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ego@in.ibm.com, Ingo Molnar <mingo@elte.hu>, paulmck@us.ibm.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       vatsa@in.ibm.com, Oleg Nesterov <oleg@tv-sign.ru>, dipankar@in.ibm.com,
       dino@in.ibm.com, masami.hiramatsu.pt@hitachi.com
Subject: Re: [RFC] Cpu-hotplug: Using the Process Freezer (try2)
Message-Id: <20070403132427.88308b59.akpm@linux-foundation.org>
In-Reply-To: <200704032134.29720.rjw@sisk.pl>
References: <20070402053457.GA9076@in.ibm.com>
	<20070402061612.GA7072@elte.hu>
	<20070403120104.GB29308@in.ibm.com>
	<200704032134.29720.rjw@sisk.pl>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Apr 2007 21:34:28 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> > However, the hunk
> > 
> > @@ -1393,7 +1394,9 @@ long do_fork(unsigned long clone_flags,
> > 		tracehook_report_clone_complete(clone_flags, nr, p);
> > 
> > 		if (clone_flags & CLONE_VFORK) {
> > +			freezer_do_not_count();
> > 			wait_for_completion(&vfork);
> > +			freezer_count();
> > 			tracehook_report_vfork_done(p, nr);
> > 		}
> > 	} else {
> > 
> > Seems to be missing in the latest -mm's.
> 
> Good catch!
> 
> > Rafael / Andrew, 
> > 	Any reasons for leaving this hunk out?
> 
> No, absolutely not.  It's needed.
> 
> Moreover, freezer-fix-vfork-problem.patch from the broken-out -rc5-mm3
> contains it, so some other patch must have reverted this change.
> 
> [looks]
> 
> Ah, it's utrace-prep-2.patch .  Andrew?

urgh, I screwed up, sorry.

utrace-prep-2 reverts a bit of the underlying tree so that the utrace
patches (which are against mainline) don't throw a tremendous reject which
has to be fixed each time I pull Roland's tree.  I'm supposed to reapply
that change after the utrace patches but forgot.

--- a/kernel/fork.c~undo-utrace-prep-2
+++ a/kernel/fork.c
@@ -1387,7 +1387,9 @@ long do_fork(unsigned long clone_flags,
 			tracehook_report_clone_complete(clone_flags, nr, p);
 
 		if (clone_flags & CLONE_VFORK) {
+			freezer_do_not_count();
 			wait_for_completion(&vfork);
+			freezer_count();
 			if (likely(is_user))
 				tracehook_report_vfork_done(p, nr);
 		}
_

