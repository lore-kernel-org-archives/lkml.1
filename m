Return-Path: <linux-kernel-owner+w=401wt.eu-S1758280AbZEAAo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758280AbZEAAo7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 20:44:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752209AbZEAAov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 20:44:51 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59835 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751234AbZEAAou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 20:44:50 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090501000222.8BACEFC3BF@magilla.sf.frob.com>
References: <20090501000222.8BACEFC3BF@magilla.sf.frob.com> <20090428223025.GA11997@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: dhowells@redhat.com, Oleg Nesterov <oleg@redhat.com>,
       Eric Paris <eparis@parisplace.org>, James Morris <jmorris@namei.org>,
       Stephen Smalley <sds@tycho.nsa.gov>, linux-kernel@vger.kernel.org
Subject: Re: Q: selinux_bprm_committed_creds() && signals/do_wait
Date: Fri, 01 May 2009 01:44:34 +0100
Message-ID: <18312.1241138674@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath <roland@redhat.com> wrote:

> There is a wrinkle here I don't like.  The fatal signal is "committed to"
> (sender approved by security modules, etc.) "before" the exec, but gets
> delivered "after" the exec.

That's because the signal is delivered between the system call function
returning to entry.S and userspace resuming.  We could put a lot of
check...abort clauses in exec.c and the binfmts, but is it worth the hassle?

> I don't understand why install_exec_creds() is called as late as it is.
> Can't we do that in flush_old_exec()--you know, where it says:
> 	/* install the new credentials */
> ?

I believe it's something to do with the binfmt driver needing to access files
in the old security context between calling flush_old_exec() and calling
install_exec_creds() [compute_creds() as was].  It can't do some of the
accesses before calling flush_old_exec() because it has to do funky things
with mmap().

Actually, that comment should probably be removed.  IIRC, at one time I was
trying to set all the credentials there, but was told I couldn't do that.

David
