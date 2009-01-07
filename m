Return-Path: <linux-kernel-owner+w=401wt.eu-S1759720AbZAGTH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759720AbZAGTH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 14:07:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752756AbZAGTHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 14:07:17 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:36066 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284AbZAGTHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 14:07:15 -0500
Date: Wed, 7 Jan 2009 13:06:52 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: sds@tycho.nsa.gov, spotter@cs.columbia.edu,
       David Howells <dhowells@redhat.com>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add in_execve flag into task_struct.
Message-ID: <20090107190652.GA20311@us.ibm.com>
References: <200901060514.n065E462074929@www262.sakura.ne.jp> <20090106155829.GA9773@us.ibm.com> <49639039.4060708@cs.columbia.edu> <1231267532.9746.116.camel@localhost.localdomain> <200901070634.n076YCxF061022@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901070634.n076YCxF061022@www262.sakura.ne.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Tetsuo Handa (penguin-kernel@i-love.sakura.ne.jp):
> Stephen Smalley wrote:
> > As I understand it, they want to apply the exec check against the
> > caller's credential as usual but not apply a read check against the
> > caller's credential.
> Right.
> 
> > Note btw that in the DAC case the dumpable flag gets cleared if the
> > caller lacks read access to the program, so TOMOYO should do likewise if
> > they are going to support this "execute-without-read" mode.
> That's this "in_execve" flag.

So you refuse to dump if in_execve is set?

> Shaya Potter wrote:
> > I assume this has been asked and answered by whats the advantage of this
> > in_exec flag over a single function that set the security domain, oncee
> > at the beginning of exec to set the new domain (B) and once in the
> > fail/exit path to reset it back (to A) in case of failure.
> Old implementation (where security_bprm_alloc() and security_bprm_free()
> were available) used that approach.
> But new implementation (where security_bprm_alloc() and security_bprm_free()
> are no longer available) uses an approach which won't rollback.
> 
> > it just seems weird to say that we are technically in security domain A,
> > but are going to treat the process as if its in security domain B when
> > you can just as easily put it in security domain B and put it back in
> > security domain A if the operation fails.
> A LSM hook for doing rollback operation no longer exists.
> If we can introduce security_start_execve()/security_finish_execve() hooks
> in place of security_bprm_alloc() and security_bprm_free(),
> TOMOYO can use that approach.
> 
> But by utilizing existing LSM hooks, TOMOYO finally came to the point
> where TOMOYO can live without more LSM hooks if current process can
> remember "whether I'm doing an execve() operation or not".
> David Howells prefers this 'in_execve' approach over introducing
> security_start_execve()/security_finish_execve() hooks.

There is already a security_bprm_committed_creds() hook.  So you
could  hook abort_creds() and prepare_exec_creds(), and use them
to set a flag in your tomoyo task->security state.  Is that what
David nacked in favor of this flag?

> Serge E. Hallyn wrote:
> > I still don't like it.  Now I gather the reason for this is that you
> > want to allow a less trusted domain to execute a file (in a new domain)
> > without giving it the right to read it?  I'd be interested in hearing
> > whether others think that's a worthy goal.
> 
> I see you don't like 'in_execve' flag.
> But, this approach is the result of negotiation with David Howells
> and was authorized by him.
> Serge, will you please accept this 'in_execve' flag?

It's ugly, you can't get me to say it isn't ugly :), and it sets a scary
bad precedent.  But if David insists (in a reply to this msg) that this
flag really is tops, then just ignore me.  Anyway my point wasn't to
block the patch but to raise discussion (so someone else could decide to
block it :) on both the flag and security implications of these
semantics.

-serge
