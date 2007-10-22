Return-Path: <linux-kernel-owner+w=401wt.eu-S1753228AbXJVA6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228AbXJVA6l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 20:58:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751120AbXJVA6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 20:58:35 -0400
Received: from THUNK.ORG ([69.25.196.29]:55533 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098AbXJVA6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 20:58:35 -0400
Date: Sun, 21 Oct 2007 20:58:23 -0400
From: Theodore Tso <tytso@mit.edu>
To: linux-kernel@vger.kernel.org
Cc: "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: Potential regression in -git15: can't resume stopped root
	shell?
Message-ID: <20071022005823.GA13901@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serue@us.ibm.com>
References: <20071020185806.GA6575@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071020185806.GA6575@thunk.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 20, 2007 at 02:58:06PM -0400, Theodore Tso wrote:
> I was testing 2.6.23-git15, and I'm noticing that if I su to root, then
> suspend the root shell, and try continue it via "fg", it hangs.  The ps
> command reports:
> 
> 15806  6386  19   0  4012 wait                 Ss   pts/0    00:00:00 bash
>     0  6444  19   0  1232 finish_stop          T+   pts/0    00:00:00 /bin/su -p
>     0  6445  19   0  3696 finish_stop          T    pts/0    00:00:00 bash
> 15806  6571  19   0   776 pipe_wait            S+   pts/1    00:00:00 grep pts/0
> 
> This works under 2.6.23.  I am running Ubuntu Gutsy running in a
> gnome-terminal, with bash as my login shell.  I can suspend a zsh or
> bash shell where I haven't su'ed to root.  But if the shell is started
> using either su or sudo, when I try to resume it after suspending
> using the "suspend" command via "fg", I get a hung shell.
> 
> I haven't had time to bisect it yet, but I thought I'd throw it out
> there in case this rings a bell with anybody...

OK, I bisected, and it turns out to be a bug, but not a regression.
Turns out the responsible commit is:

commit b53767719b6cd8789392ea3e7e2eb7b8906898f0
Author: Serge E. Hallyn <serue@us.ibm.com>
Date:   Tue Oct 16 23:31:36 2007 -0700

    Implement file posix capabilities
    
    Implement file posix capabilities.  This allows programs to be given a
    subset of root's powers regardless of who runs them, without having to use
    setuid and giving the binary all of root's powers.....

Once I turned this up, I turned went back to -git15, and turned off
CONFIG_SECURITY_FILE_CAPABILITIES, and the problem went away.  Oh,
well, I had wanted to try out file capabilities, which is why I had
turned the option on, but being able to resume suspended root shells
is more important.  :-)

Serge, can you take a look at this, please?  Thanks!!

						- Ted
