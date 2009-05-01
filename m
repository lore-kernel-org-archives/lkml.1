Return-Path: <linux-kernel-owner+w=401wt.eu-S1755573AbZEAAP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573AbZEAAP3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 20:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754819AbZEAACk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 20:02:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44118 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762923AbZEAACi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 20:02:38 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: David Howells <dhowells@redhat.com>, Eric Paris <eparis@parisplace.org>,
       James Morris <jmorris@namei.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       linux-kernel@vger.kernel.org
Subject: Re: Q: selinux_bprm_committed_creds() && signals/do_wait
In-Reply-To: Oleg Nesterov's message of  Wednesday, 29 April 2009 00:30:25 +0200 <20090428223025.GA11997@redhat.com>
References: <20090428223025.GA11997@redhat.com>
X-Shopping-List: (1) Pink eggs
   (2) Torrential configuration abolitionists
   (3) Scratch 'n' Snot Hootenanny wavechords
Message-Id: <20090501000222.8BACEFC3BF@magilla.sf.frob.com>
Date: Thu, 30 Apr 2009 17:02:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SIGNAL_GROUP_EXIT check is fine for now.  But we should revisit this
area more thoroughly at some point.  (That is a low-priority thing.)

There is a wrinkle here I don't like.  The fatal signal is "committed to"
(sender approved by security modules, etc.) "before" the exec, but gets
delivered "after" the exec.  e.g., acct_process() writes a record for the
killed process showing the uid/gid from after the setuid/setgid exec, when
security would not have allowed the killing signal to be sent after the
exec, only before.  Obviously this is a minor quirk (not to be worried
about today), but it points to a deeper kind of "wrong" that troubles me.
I can't think of any other similar wrinkles that could be observable at
all (or matter more than that one), but there might be another.

This is related to the issue of racing stop signals lost by de_thread().
That is still on our back-burner list to think about more deeply one day.
We don't need to contemplate any of this much more right now, but I would
like to address the whole mess better later on.

I don't understand why install_exec_creds() is called as late as it is.
Can't we do that in flush_old_exec()--you know, where it says:
	/* install the new credentials */
?

What I think would be best is if flush_old_exec() does all the "point of no
return" logic and that includes the credentials changes.  Then we can
define this as the point of transition from "before exec" to "after exec".
It would do the final check for signals interrupting the exec, and if
flush_old_exec() returned 0, then any "new" signals are "after exec".
We'd reorganize things so the final creds switch is under siglock.
Then either a sender precedes the exec and any security module's flushing
logic wipes the pre-exec state as it wants to, or the sender follows the
exec and is subject to signal security checks based on the new credentials.


Thanks,
Roland
