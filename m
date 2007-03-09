Return-Path: <linux-kernel-owner+w=401wt.eu-S2993061AbXCIHht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993061AbXCIHht (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 02:37:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993072AbXCIHhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 02:37:48 -0500
Received: from mx1.redhat.com ([66.187.233.31]:50994 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993067AbXCIHhW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 02:37:22 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: David Howells <dhowells@redhat.com>
X-Fcc: ~/Mail/utrace
Cc: bryan.wu@analog.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] utrace: nommu fixup support utrace 
In-Reply-To: David Howells's message of  Wednesday, 7 March 2007 11:10:37 +0000 <7689.1173265837@redhat.com>
X-Shopping-List: (1) Courteous non-reloading hay
   (2) Religious aspersions
   (3) Neurotic dice
   (4) Delicious expectation hatred
Message-Id: <20070309073711.7105B180063@magilla.sf.frob.com>
Date: Thu,  8 Mar 2007 23:37:11 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I understand the NOMMU situation, and you are already screwed by
PTRACE_ATTACH.  What I meant to suggest is that I would start from a
safety point of view with get_user_pages/access_process_vm refusing to
do force&&write to MAP_PRIVATE pages that are in fact being shared
(ETXTBSY or something).  (When it's not being shared, it should do
whatever is necessary to make sure that page is known dirty and not
hand it out for later mappings.)  Then you can go about trying to make
the safe (no sharing) case come about when you want it.  You still
won't win with PTRACE_ATTACH and the like unless you happen not to
have sharing in the places you insert your breakpoints at the time.
But at least the debugger will just lose, instead of breaking
unsuspecting processes.  With the utrace patches, you can approximate
the ptrace check you had with something like:

	if (tracehook_consider_fatal_signal(current, SIGTRAP))

or whatever signal you think poking text might result in that the
debugger will be looking for (atm it doesn't actually matter what
signo you pass).  This returns true when ptrace is in use, and
probably also for later utrace-based ways a debugger attaches if it is
expecting ahead of time to be debugging heavily as with breakpoints.
(And that's about the best you can do for a single address space system.)


Thanks,
Roland
