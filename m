Return-Path: <linux-kernel-owner+w=401wt.eu-S1756499AbZAGGeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499AbZAGGeq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 01:34:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752223AbZAGGef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 01:34:35 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:65114 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbZAGGee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 01:34:34 -0500
Message-Id: <200901070634.n076YCxF061022@www262.sakura.ne.jp>
Subject: Re: [PATCH] Add in_execve flag into task_struct.
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: sds@tycho.nsa.gov, serue@us.ibm.com, spotter@cs.columbia.edu
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Wed, 07 Jan 2009 15:34:12 +0900
References: <200901060514.n065E462074929@www262.sakura.ne.jp> <20090106155829.GA9773@us.ibm.com>  <49639039.4060708@cs.columbia.edu> <1231267532.9746.116.camel@localhost.localdomain>
In-Reply-To: <1231267532.9746.116.camel@localhost.localdomain>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 07012009 #1412118, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Smalley wrote:
> As I understand it, they want to apply the exec check against the
> caller's credential as usual but not apply a read check against the
> caller's credential.
Right.

> Note btw that in the DAC case the dumpable flag gets cleared if the
> caller lacks read access to the program, so TOMOYO should do likewise if
> they are going to support this "execute-without-read" mode.
That's this "in_execve" flag.



Shaya Potter wrote:
> I assume this has been asked and answered by whats the advantage of this
> in_exec flag over a single function that set the security domain, oncee
> at the beginning of exec to set the new domain (B) and once in the
> fail/exit path to reset it back (to A) in case of failure.
Old implementation (where security_bprm_alloc() and security_bprm_free()
were available) used that approach.
But new implementation (where security_bprm_alloc() and security_bprm_free()
are no longer available) uses an approach which won't rollback.

> it just seems weird to say that we are technically in security domain A,
> but are going to treat the process as if its in security domain B when
> you can just as easily put it in security domain B and put it back in
> security domain A if the operation fails.
A LSM hook for doing rollback operation no longer exists.
If we can introduce security_start_execve()/security_finish_execve() hooks
in place of security_bprm_alloc() and security_bprm_free(),
TOMOYO can use that approach.

But by utilizing existing LSM hooks, TOMOYO finally came to the point
where TOMOYO can live without more LSM hooks if current process can
remember "whether I'm doing an execve() operation or not".
David Howells prefers this 'in_execve' approach over introducing
security_start_execve()/security_finish_execve() hooks.



Serge E. Hallyn wrote:
> I still don't like it.  Now I gather the reason for this is that you
> want to allow a less trusted domain to execute a file (in a new domain)
> without giving it the right to read it?  I'd be interested in hearing
> whether others think that's a worthy goal.

I see you don't like 'in_execve' flag.
But, this approach is the result of negotiation with David Howells
and was authorized by him.
Serge, will you please accept this 'in_execve' flag?
