Return-Path: <linux-kernel-owner+w=401wt.eu-S1759200AbYLDTE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759200AbYLDTE6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 14:04:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756809AbYLDTEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 14:04:45 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:58682 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756320AbYLDTEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 14:04:44 -0500
Date: Thu, 4 Dec 2008 13:04:30 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: mtk.manpages@gmail.com
Cc: ebiederm@xmission.com, lkml <linux-kernel@vger.kernel.org>,
       linux-man@vger.kernel.org, clg@fr.ibm.com, herbert@13thfloor.at,
       dev@sw.ru, Subrata Modak <subrata@linux.vnet.ibm.com>,
       David Howells <dhowells@redhat.com>
Subject: Re: Could you write some CLONE_NEWUSER?
Message-ID: <20081204190430.GA16026@us.ibm.com>
References: <cfd18e0f0812040720y5cabd2aarbf3912644dea42c4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfd18e0f0812040720y5cabd2aarbf3912644dea42c4@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Michael Kerrisk (mtk.manpages@googlemail.com):
> Hi Serge,
> 
> Thanks for CCing me on recent CLONE_NEWUSER patches.
> 
> Would you be will to write some documentation for this flag?  (It's
> the only remaining undocumented flag in clone(2).)  Plain text would
> be fine -- I'll integrate it into the man page with suitable macros.

Well here is a start.  David, writing this actually reminded me that
the per-user keys still aren't per-namespace.  Did you say you were
looking at that, or should I send a patch (starting at
security/keys/key.c:key_user_lookup())?

Eric, if you get a second, could you please review?

thanks,
-serge


CLONE_NEWUSER
	Start the child in a new user namespace.

	User namespaces are very incomplete.  When complete, they
	will implement hierarchical userid namespaces designed to
	be safely used without privilege.  User namespaces are
	unnamed, but for the sake of this explanation we will give
	them a single-letter ID.  Let us refer to userid 500 in user
	namespace B  as (B, 500).  Assume a process owned by (B, 500)
	passes CLONE_NEWUSER to clone(2).  A new user namespace, C,
	will be created.  The new task will be owned by user
	(C, 0).  No userid in user namespace C will be able to
	gain more access than (B, 500) could obtain.  User (C, 500)
	will be protected from (C, 501) as usual.  Files created
	by (C, 501) are owned by both (C, 501) and (B, 500), so 
	(B, 500) owns all files created in user namespace C.  Likewise
	(B, 500) can kill and ptrace any processes owned by (C, 501).

	In (!SECURE_NOROOT) mode, userid 0 gets privilege when executing
	files.  With user namespaces, userid 0 will still get these
	privileges, but limited to namespaces it owns.  For instance,
	CAP_DAC_OVERRIDE will be targeted to files owned by the user's
	user namespace, while CAP_SETUID is by nature per-namespace
	and hence always safe.

	Most of the permission checks to make this work are currently
	unimplemented.  If your kernel is compiled with CONFIG_USER_NS,
	then you can create a new user namespace if you have
	CAP_SYS_ADMIN, CAP_SETUID and CAP_SETGID capabilities.  The
	new task will be owned by userid and gid 0 in the new user
	namespace.  Current support is sufficient to provide separate
	accounting, since uid 0 in different namespaces are represented by
	different user structs.

	Will return -EINVAL if called on a kernel compiled without
	user namespace support (CONFIG_USER_NS=n), and -EPERM if
	called by a process with insufficient privilege before support
	is complete.
