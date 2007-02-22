Return-Path: <linux-kernel-owner+w=401wt.eu-S932560AbXBVAEG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932560AbXBVAEG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 19:04:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932637AbXBVAEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 19:04:06 -0500
Received: from smtp.osdl.org ([65.172.181.24]:58857 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932560AbXBVAEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 19:04:04 -0500
Date: Wed, 21 Feb 2007 16:03:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Steve Grubb <sgrubb@redhat.com>,
       Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>
Subject: Re: [GIT PULL] audit patches
Message-Id: <20070221160319.6de08b64.akpm@linux-foundation.org>
In-Reply-To: <20070218040127.GA5422@ftp.linux.org.uk>
References: <20070218040127.GA5422@ftp.linux.org.uk>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Feb 2007 04:01:27 +0000 Al Viro <viro@ftp.linux.org.uk> wrote:

> Misc audit patches (resend again...); the most intrusive one is AUDIT_FD_PAIR,
> allowing to log descriptor numbers from syscalls that do not return them in
> usual way (i.e. pipe() and socketpair()).  It took some massage of
> the failure exits in sys_socketpair(); the rest is absolutely trivial.
> Please, pull from
> git.kernel.org/pub/scm/linux/kernel/git/viro/audit-current.git/ audit.b37

Please send patches to the list for review if practical?  In this case it
was.  I trust davem has had a look at the non-trivial changes to
sys_socketpair().



Looking at the changes to audit_receive_msg():


				if (sid) {
					if (selinux_sid_to_string(
							sid, &ctx, &len)) {
						audit_log_format(ab,
							" ssid=%u", sid);
						/* Maybe call audit_panic? */
					} else
						audit_log_format(ab,
							" subj=%s", ctx);
					kfree(ctx);
				}

This is assuming that selinux_sid_to_string() always initialises `ctx'.

But AFAICT there are two error paths in security_sid_to_context() which
forget to do that, so we end up doing kfree(uninitialised-local).

I'd consider that a shortcoming in security_sid_to_context(), so not a
problem in this patch, as long as people agree with my blaming above.


The coding style in there is a bit odd-looking.

The new __audit_fd_pair() has unneeded braces in it.
