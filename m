Return-Path: <linux-kernel-owner+w=401wt.eu-S1753309AbZD2M1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309AbZD2M1U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 08:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751545AbZD2M1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 08:27:09 -0400
Received: from msux-gh1-uea01.nsa.gov ([63.239.67.1]:34239 "EHLO
	msux-gh1-uea01.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbZD2M1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 08:27:08 -0400
Subject: Re: Q: selinux_bprm_committed_creds() && signals/do_wait
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Oleg Nesterov <oleg@redhat.com>
Cc: James Morris <jmorris@namei.org>, David Howells <dhowells@redhat.com>,
       Eric Paris <eparis@parisplace.org>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090429065809.GA477@redhat.com>
References: <20090428223025.GA11997@redhat.com>
	 <alpine.LRH.2.00.0904291024001.5246@tundra.namei.org>
	 <20090429065809.GA477@redhat.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Wed, 29 Apr 2009 08:20:30 -0400
Message-Id: <1241007630.18249.141.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-29 at 08:58 +0200, Oleg Nesterov wrote:
> On 04/29, James Morris wrote:
> >
> > On Wed, 29 Apr 2009, Oleg Nesterov wrote:
> >
> > > selinux_bprm_committed_creds:
> > >
> > > 	rc = avc_has_perm()
> > > 	if (rc) {
> > > 		flush_signals(current);
> > >
> > > This doesn't look right. If the task was SIGKILL'ed we must not proceed,
> > > the task should die. The fix is simple, we should check SIGNAL_GROUP_EXIT
> > > and do nothing in this case, the task will exit before return to user
> > > space. If SIGNAL_GROUP_EXIT is set, it is just wrong to drop SIGKILL and
> > > continue.
> >
> > I'm not quite sure what you're asking.  This is a permission check to see
> > if the new task can inherit the signal state of the parent,
> 
> we can flush the signal which was sent after we changed SID/cred and passed
> the new permission checks,
> 
> > and if not,
> > the new task's signal state is flushed.
> >
> > Where does a consideration of SIGKILL arise?
> 
> It is not possible to flush SIGKILL. Once SIGKILL (or another fatal signal)
> is queued, it sets SIGNAL_GROUP_EXIT which can't be and must not be cleared.
> 
> But, there is no need to flush SIGKILL. The task will exit. If it was sent
> before we changed SID, we can pretend the task has died before exec().
> 
> > > But, before fixing, I'd like to understand why we are doing
> > >
> > > 		flush_signal_handlers(current, 1);
> > > 		sigemptyset(&current->blocked);
> > >
> > > later. Could someone explain ? This looks unneeded.
> >
> > This is part of clearing all the signal state in the child.
> 
> This doesn't explain why we are doing this ;)
> 
> Why do we need to s/IGN/DFL/ and why do we clear ->blocked ? How this can
> help from the security pov?

We don't want the caller to be able to arrange conditions that prevent
correct handling of signals (e.g. SIGHUP) by the callee.  That was
motivated by a specific attack against newrole, but was a general issue
for any program that runs in a more trusted domain than its caller.

As I recall, I based the logic in part on existing logic in
call_usermodehelper().

> In fact this looks a bit wrong. The only way to ensure we can't lose the
> signal during exec() is to block it beforehand, then install the handler
> after exec(). s/IGN/DFL/ doesn't look good too.
> 
> But, if we really need this for security (selinux is a black magic to me),
> then the above doesn't matter. Please help to understand.
> 
> Oleg.
-- 
Stephen Smalley
National Security Agency

