Return-Path: <linux-kernel-owner+w=401wt.eu-S1754497AbYCaDyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497AbYCaDyj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 23:54:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753342AbYCaDya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 23:54:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35811 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753310AbYCaDy3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 23:54:29 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] do_wait reorganization
In-Reply-To: Oleg Nesterov's message of  Saturday, 29 March 2008 13:35:13 +0300 <20080329103513.GA359@tv-sign.ru>
References: <20080329033412.120EE26FA1D@magilla.localdomain>
	<20080329103513.GA359@tv-sign.ru>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20080331035420.4F66426F8E9@magilla.localdomain>
Date: Sun, 30 Mar 2008 20:54:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Please note that eligible_child() drops tasklist_lock if it returns error
> (ret < 0), so the "read_unlock" above is wrong.

Oops!  Thanks for catching that.  I first got the code into shape before I
noticed your change:

commit f2cc3eb133baa2e9dc8efd40f417106b2ee520f3 "do_wait: fix security checks"

I let that one slip off the end of my queue and never gave it proper review.
I tweaked my patch hastily to keep in line with that change and was careless.

I would have objected to that change at the time had I been up to speed.
AFAICT your objection was based solely on the inconsistent treatment of
children PTRACE_ATTACH'd by another.  That was an inadvertent omission in
my original change in commit 73243284463a761e04d69d22c7516b2be7de096c (and
seems obviously so to me).  That bug in no way invalidates the motivation
for the original change.  But you threw the baby out with the bathwater.

The original change came up in response to an actual problem in the real
world.  There was a bug in SELinux and/or a particular security policy that
made it impossible to debug some daemons with gdb.  The bug was an
internally inconsistent set of security checks, so root running gdb was
allowed to ptrace the daemon process, that process was allowed to send gdb
a SIGCHLD and wake it up, but gdb was not allowed to see it with wait4().

The symptom of this bug was that gdb said "wait: No children".  
The resaonable developer seeing this double-checked by using strace on
gdb, and saw that indeed wait4(-1, ...) had failed with ECHILD even
though ps and /proc/PID/status and everything the developer knew said
wait4() should consider the daemon process a waitable child of gdb
(which had used PTRACE_ATTACH).  The reasonable developer says, "This
is strange bug in ptrace or wait, and I'm just stuck; send it to Roland."

So I debugged the whole thing and fixed an SELinux bug for the SELinux
people.  Then I imagined how it could have been:

The symptom of this bug was that gdb said "wait: Permission denied".
The resaonable developer seeing this double-checked by using strace on
gdb, and saw that indeed wait4(-1, ...) had failed with EACCES.  The
reasonable developer has seen an unreasonable "Permission denied"
error before, and says, "Hmm, maybe I should look in /var/log/secure
or someplace."  The reasonable developer finds a log message about
"avc denied wait for gdb".  The reasonable developer says, "This is
another gosh-darn SELinux issue, so I better report an SELinux bug."
(The reasonably hurried developer then says, "Oh heck, let's just
disable SELinux until I've finished debugging the dag-burn daemon.")

Now try to guess which of these stories I like better.

> If !retval and WNOHANG, we should return -ECHILD, but with this patch
> we return 0.

The meaning of WNOHANG is to return 0 when we would otherwise block.
Returning -ECHILD is wrong.


Thanks,
Roland
