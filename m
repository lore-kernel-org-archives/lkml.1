Return-Path: <linux-kernel-owner+w=401wt.eu-S1759226AbZAHGTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759226AbZAHGTp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 01:19:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752351AbZAHGTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 01:19:34 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:62230 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbZAHGTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 01:19:32 -0500
Message-Id: <200901080617.n086HtWN019551@www262.sakura.ne.jp>
Subject: Re: [PATCH] Add in_execve flag into task_struct.
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: serue@us.ibm.com
Cc: sds@tycho.nsa.gov, spotter@cs.columbia.edu, dhowells@redhat.com,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Thu, 08 Jan 2009 15:17:55 +0900
References: <200901060514.n065E462074929@www262.sakura.ne.jp> <20090106155829.GA9773@us.ibm.com> <49639039.4060708@cs.columbia.edu> <1231267532.9746.116.camel@localhost.localdomain> <200901070634.n076YCxF061022@www262.sakura.ne.jp> <20090107190652.GA20311@us.ibm.com>
In-Reply-To: <20090107190652.GA20311@us.ibm.com>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 08012009 #1420234, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn wrote:
> > > Note btw that in the DAC case the dumpable flag gets cleared if the
> > > caller lacks read access to the program, so TOMOYO should do likewise if
> > > they are going to support this "execute-without-read" mode.
> > That's this "in_execve" flag.
> 
> So you refuse to dump if in_execve is set?

No. TOMOYO refuses to check read permission in security_dentry_open()
if current->in_execve is set.

To utilize existing LSM hooks as much as possible, TOMOYO uses
security_dentry_open() for checking permissions when a file is opened for
reading and/or writing.

There is one exception. TOMOYO doesn't use security_dentry_open() for checking
permissions when a file is opened for executing.
TOMOYO uses security_bprm_check_security() instead.

Therefore, I need to make it possible to tell whether security_dentry_open()
was called by do_execve() or not.
Unfortunately, as I describe later, there are no LSM hooks which receive
sufficient information for telling whether security_dentry_open() was called by
do_execve() or not. As a result, I'm proposing 'in_execve' flag.

In TOMOYO, security_dentry_open() becomes a no-op function if
current->in_execve flag is set.

If you want TOMOYO not to access current->in_execve flag, it will be possible
to store "whether I'm inside do_execve() or not" into a private hash; but that
will require introduction of new LSM hooks for recording and erasing.

> There is already a security_bprm_committed_creds() hook.  So you
> could  hook abort_creds() and prepare_exec_creds(), and use them
> to set a flag in your tomoyo task->security state.  Is that what
> David nacked in favor of this flag?

First of all, task->security no longer exists, and I'm not allowed to
set a flag in task->cred->security because task->cred is shared.

Next, I have no methods for knowing whether security_creds_prepare() was
called from prepare_exec_creds() or not. Examining function call stack is
far from clean approach. Introducing security_prepare_exec_creds() hook makes
no difference from introducing security_start_execve() hook.

Also, I have no methods for knowing whether security_creds_free() was called
by failure of an execve() operation or not. Introducing
security_free_exec_creds() hook makes no difference from introducing
security_finish_execve() hook.

So, I still believe this 'in_execve' flag is the tops.

> It's ugly, you can't get me to say it isn't ugly  :) , and it sets a scary
> bad precedent.  But if David insists (in a reply to this msg) that this
> flag really is tops, then just ignore me.  Anyway my point wasn't to
> block the patch but to raise discussion (so someone else could decide to
> block it  :)  on both the flag and security implications of these
> semantics.

I'd like to listen to the David's opinion.
