Return-Path: <linux-kernel-owner+w=401wt.eu-S1754944AbZAFSsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944AbZAFSsi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 13:48:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751586AbZAFSs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 13:48:28 -0500
Received: from mummy.ncsc.mil ([144.51.88.129]:35528 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751200AbZAFSs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 13:48:27 -0500
Subject: Re: [PATCH] Add in_execve flag into task_struct.
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Shaya Potter <spotter@cs.columbia.edu>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <49639039.4060708@cs.columbia.edu>
References: <200901060514.n065E462074929@www262.sakura.ne.jp>
	 <20090106155829.GA9773@us.ibm.com>  <49639039.4060708@cs.columbia.edu>
Content-Type: text/plain
Organization: National Security Agency
Date: Tue, 06 Jan 2009 13:45:32 -0500
Message-Id: <1231267532.9746.116.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 (2.24.2-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-06 at 12:09 -0500, Shaya Potter wrote:
> Serge E. Hallyn wrote:
> > Quoting Tetsuo Handa (penguin-kernel@i-love.sakura.ne.jp):
> >> Serge,
> >>
> >> James is now reviewing TOMOYO Linux patch and he is caring about
> >> your comment below.
> >>
> >> Serge E. Hallyn wrote:
> >>> I don't like the 'in_exec' bit in the task_struct, but adding LSM hooks
> >>> to let just TOMOYO mark whether you're in exec seems even uglier.
> >> Let me (once again) ask your comment on 'in_exec' approach
> >> originally suggested by David Howells ( http://lkml.org/lkml/2008/10/2/127 ).
> > 
> > I still don't like it.  Now I gather the reason for this is that you
> > want to allow a less trusted domain to execute a file (in a new domain)
> > without giving it the right to read it?  I'd be interested in hearing
> > whether others think that's a worthy goal.
> 
> I assume this has been asked and answered by whats the advantage of this
> in_exec flag over a single function that set the security domain, oncee
> at the beginning of exec to set the new domain (B) and once in the
> fail/exit path to reset it back (to A) in case of failure.
> 
> the only difference I can see is that you want what is basically a 3rd
> security domain of "execing B".
> 
> The question would then be, why is "execing B" different than B itself?
> 
> otherwise, the same changes you do to set/unset the in_exec flag could
> be used to set and reset the security domains.
> 
> it just seems weird to say that we are technically in security domain A,
> but are going to treat the process as if its in security domain B when
> you can just as easily put it in security domain B and put it back in
> security domain A if the operation fails.
> 
> but again, I could very well be missing something.

As I understand it, they want to apply the exec check against the
caller's credential as usual but not apply a read check against the
caller's credential.  This is just like the existing DAC checking (read
access to a program is not required to execute it under DAC, and you can
likely find examples of such programs in a /usr/bin near you - Xorg and
sudo are examples on a recent Fedora).  The reason it doesn't work for
them at present is that they are applying their check from the
dentry_open hook (in order to have the vfsmount available) rather than
from the inode_permission hook.

Note that they would have the same issue if they implemented
file_permission or mmap hooks that revalidate read permission (as in
SELinux).

Note btw that in the DAC case the dumpable flag gets cleared if the
caller lacks read access to the program, so TOMOYO should do likewise if
they are going to support this "execute-without-read" mode.

-- 
Stephen Smalley
National Security Agency

