Return-Path: <linux-kernel-owner+w=401wt.eu-S1756237AbZAJXLu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237AbZAJXLu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 18:11:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753303AbZAJXLl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 18:11:41 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:47953 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbZAJXLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 18:11:41 -0500
X-AuthUser: davidel@xmailserver.org
Date: Sat, 10 Jan 2009 15:11:28 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Scott James Remnant <scott@canonical.com>
cc: Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Casey Dahlin <cdahlin@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RESEND][RFC PATCH v2] waitfd
In-Reply-To: <1231607252.11642.103.camel@quest>
Message-ID: <alpine.DEB.1.10.0901101454110.22208@alien.or.mcafeemobile.com>
References: <49639EB8.40204@redhat.com> <4963ABF0.6070400@redhat.com>  <20090107123457.GB16268@elte.hu>  <20090107205322.5F8C7FC3E0@magilla.sf.frob.com>  <1231598714.11642.53.camel@quest>  <20090110155720.GA10954@redhat.com>
 <1231607252.11642.103.camel@quest>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Jan 2009, Scott James Remnant wrote:

> First, what we have today:
> 
> 	sigemptyset (&mask);
> 	sigaddset (&mask, SIGCHLD);
> 
> 	/* Block normal delivery and receive by sigfd instead */
> 	sigprocmask (SIG_BLOCK, &mask, NULL);
> 	sigfd = signalfd (-1, &mask, 0);
> 
> 	for (;;) {
> 		read (sigfd, &fd_siginfo, sizeof siginfo);
> 
> 		/* throw away fd_siginfo, we're reading SIGCHLD and
> 		 * can't use it :-(
> 		 */
> 
> 		/* SIGCHLD means _at_least_one_ child is pending, there
> 		 * may be more; so we have to loop AND expect to find
> 		 * nothing
> 		 */
> 		for (;;) {
> 			/* ARGH! waitid returns 0 with WNOHANG if there
> 			 * are no children.
> 			 *
> 			 * AND the structure, despite being logically
> 			 * the same, isn't the same as the signalfd
> 			 * one :-/
> 			 */
> 			memset (&w_siginfo, 0, sizeof w_siginfo);
> 
> 			waitid (P_ALL, 0, &w_siginfo,
> 				WEXITED | WNOHANG);
> 
> 			/* Did we find anything? */
> 			if (! w_siginfo.si_pid)
> 				break;
> 
> 			/* NOW we have the siginfo_t for a recently
> 			 * deceased process
> 			 */
> 
> 			mourn (&w_siginfo);
> 		}
> 

That, once all the glamorous comments are removed, can be solved pretty 
much with this much userspace code:

int waitfd(int flags) {
	sigemptyset(&mask);
	sigaddset(&mask, SIGCHLD);
	sigprocmask(SIG_BLOCK, &mask, NULL);

	return signalfd(-1, &mask, flags);
}

int waitfd_read(int fd, siginfo_t *si) {
	for (;;) {
		if (read(sigfd, &fd_siginfo,
		    sizeof fd_siginfo) != sizeof(fd_siginfo)
			retrun 0;
		memset(si, 0, sizeof *si);
		waitid(P_ALL, 0, si, WEXITED | WNOHANG);
		if (si->si_pid)
			break;
	}
	return sizeof *si;
}


About the exit_signal, that would have made probably more sense for 
it to be a parent property, instead of childs one. And be:

	do_notify_parent(p, p->parent->exit_signal);

instead of:

	do_notify_parent(p, p->exit_signal);

After all, is the parent that is going to make use of the notification, 
not the child.



- Davide


