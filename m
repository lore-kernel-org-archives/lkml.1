Return-Path: <linux-kernel-owner+w=401wt.eu-S1756096AbYLJVaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096AbYLJVaj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 16:30:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755218AbYLJVab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 16:30:31 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46085 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754762AbYLJVaa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 16:30:30 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>
X-Fcc: ~/Mail/linus
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Ulrich Weigand <ulrich.weigand@de.ibm.com>
Subject: Re: [PATCH, RFC] revert breakage from "tracehook: exec"
In-Reply-To: Arnd Bergmann's message of  Tuesday, 9 December 2008 15:33:09 +0100 <200812091533.10628.arnd@arndb.de>
References: <200812091533.10628.arnd@arndb.de>
X-Zippy-Says: This ASEXUAL PIG really BOILS my BLOOD...  He's so..so.....URGENT!!
Message-Id: <20081210040417.4EBBFFC362@magilla.sf.frob.com>
Date: Tue,  9 Dec 2008 20:04:17 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the report, good catch.  I've written a test case for the bug
(I'll include it with the patch I post momentarily).  (Note to testers:
this bug does not manifest on Fedora kernels.)

I still think it's preferable to have the only tracehook calls be in core
code, rather than in binfmt modules.  It seems much less error-prone in the
long run.  Also, since we no longer export ptrace_notify(), we'd have to
revert that as well to move the calls into binfmt modules when built as
modules (I think your patch will barf on CONFIG_BINFMT_AOUT=m, e.g.).

One option would be to move the call further out, to do_execve (and
compat_do_execve).  But I would like to keep the binfmt and bprm pointers
available in tracehook_report_exec() with full information about the binfmt
and bprm->file still available.  Even though that's not currently used, it
will clearly be desireable for future tracing facilities to be able to
scavenge details from there.

My fix (next posting) leaves the call in search_binary_handler(),
but makes it only on the outermost call (using bprm->recursion_depth).


Thanks,
Roland
