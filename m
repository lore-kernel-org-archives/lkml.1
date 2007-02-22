Return-Path: <linux-kernel-owner+w=401wt.eu-S1750911AbXBVN1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750911AbXBVN1p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 08:27:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750914AbXBVN1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 08:27:44 -0500
Received: from zombie.ncsc.mil ([144.51.88.131]:59240 "EHLO jazzdrum.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750911AbXBVN1o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 08:27:44 -0500
Subject: Re: [GIT PULL] audit patches
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@ftp.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Steve Grubb <sgrubb@redhat.com>,
       James Morris <jmorris@namei.org>
In-Reply-To: <20070221160319.6de08b64.akpm@linux-foundation.org>
References: <20070218040127.GA5422@ftp.linux.org.uk>
	 <20070221160319.6de08b64.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: National Security Agency
Date: Thu, 22 Feb 2007 08:22:47 -0500
Message-Id: <1172150567.14363.337.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-21 at 16:03 -0800, Andrew Morton wrote:
> On Sun, 18 Feb 2007 04:01:27 +0000 Al Viro <viro@ftp.linux.org.uk> wrote:
> 
> > Misc audit patches (resend again...); the most intrusive one is AUDIT_FD_PAIR,
> > allowing to log descriptor numbers from syscalls that do not return them in
> > usual way (i.e. pipe() and socketpair()).  It took some massage of
> > the failure exits in sys_socketpair(); the rest is absolutely trivial.
> > Please, pull from
> > git.kernel.org/pub/scm/linux/kernel/git/viro/audit-current.git/ audit.b37
> 
> Please send patches to the list for review if practical?  In this case it
> was.  I trust davem has had a look at the non-trivial changes to
> sys_socketpair().
> 
> 
> 
> Looking at the changes to audit_receive_msg():
> 
> 
> 				if (sid) {
> 					if (selinux_sid_to_string(
> 							sid, &ctx, &len)) {
> 						audit_log_format(ab,
> 							" ssid=%u", sid);
> 						/* Maybe call audit_panic? */
> 					} else
> 						audit_log_format(ab,
> 							" subj=%s", ctx);
> 					kfree(ctx);
> 				}
> 
> This is assuming that selinux_sid_to_string() always initialises `ctx'.
> 
> But AFAICT there are two error paths in security_sid_to_context() which
> forget to do that, so we end up doing kfree(uninitialised-local).
> 
> I'd consider that a shortcoming in security_sid_to_context(), so not a
> problem in this patch, as long as people agree with my blaming above.

I wouldn't assume that the function initializes an argument if it
returns an error, and at least some of the callers (in auditsc.c) appear
to correctly initialize ctx to NULL themselves before calling
selinux_sid_to_string().  But if you'd prefer the function to always
handle it, we can do that.

> 
> The coding style in there is a bit odd-looking.
> 
> The new __audit_fd_pair() has unneeded braces in it.
-- 
Stephen Smalley
National Security Agency

