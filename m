Return-Path: <linux-kernel-owner+w=401wt.eu-S1760424AbXEZNlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760424AbXEZNlm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 09:41:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755391AbXEZNld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 09:41:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40687 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754954AbXEZNlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 09:41:32 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell
To: Tetsuo Handa <penguin-fsdevel@i-love.sakura.ne.jp>
Subject: Re: Pass struct vfsmount to the inode_create LSM hook
Date: Sat, 26 May 2007 15:41:09 +0200
User-Agent: KMail/1.9.5
Cc: mrmacman_g4@mac.com, casey@schaufler-ca.com, jmorris@namei.org,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
References: <309300.41401.qm@web36615.mail.mud.yahoo.com> <200705261346.20712.agruen@suse.de> <200705262109.JJB99189.TFHFGQEOtVOMWJF@I-love.SAKURA.ne.jp>
In-Reply-To: <200705262109.JJB99189.TFHFGQEOtVOMWJF@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705261541.09891.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 26 May 2007 14:09, Tetsuo Handa wrote:
> Hello.
>
> Andreas Gruenbacher wrote:
> > > exec { "/usr/bin/gunzip" } "gzip", "-9", "some/file/to.gz";
> >
> > The above Perl code executes /usr/bin/gunzip and sets argv[0] to "gzip",
> > so this confirms that the value of argv[0] is arbitrary. Well great, we
> > already knew.
> >
> > AppArmor does not look at argv[0] for anything, and doing so would be
> > insane. So please don't jump to the wrong conclusions.
>
> I agree that argv[0] checking is different from pathname-based access
> control or label-based access control, but I want to say argv[0] checking
> is still needed.
>
> If you don't check argv[0], an attacker can request everything like
>
> exec { "/bin/ls" } "/sbin/busybox", "cat", "/etc/shadow";
> exec { "/bin/ls" } "/sbin/busybox", "rm", "/etc/shadow";
>
> if /bin/ls and /bin/cat and /bin/rm are hardlinks of /sbin/busybox (e.g.
> embedded systems).
>
> Therefore, TOMOYO Linux checks the combination of filename and argv[0]
> passed to execve().

So you are indeed trying to control the value of argv[0]? Well, good luck with 
that, but it's totally insane. You are guaranteed to break some applications. 
AppArmor is not going to go down that route.

If /bin/cat and /bin/rm are binaries or hardlinks to the same busybox binary 
(rather than symlinks), different profiles could be used for each of them. 
The cat profile could have no more than read access anywhere, so this would 
prevent it from removing files. That's an effective access control mechanism.

Conspiring with busybox in the kernel and making it do the right thing (and 
just that) at the application level is not an effective security mechanism: 
the kernel would still allow busybox to do anything, and there could be bugs 
in the application, busybox's calling convention could change to allow more 
than one command per invocation (e.g., ``cat /etc/shadow ; rm /etc/shadow''), 
etc.

Andreas
