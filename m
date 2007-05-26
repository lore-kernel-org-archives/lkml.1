Return-Path: <linux-kernel-owner+w=401wt.eu-S1760717AbXEZOo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760717AbXEZOo6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 10:44:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754915AbXEZOot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 10:44:49 -0400
Received: from wine.ocn.ne.jp ([220.111.47.146]:51126 "EHLO
	smtp.wine.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050AbXEZOos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 10:44:48 -0400
To: agruen@suse.de
Cc: mrmacman_g4@mac.com, casey@schaufler-ca.com, jmorris@namei.org,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: Pass struct vfsmount to the inode_create LSM hook
From: Tetsuo Handa <penguin-fsdevel@I-love.SAKURA.ne.jp>
References: <309300.41401.qm@web36615.mail.mud.yahoo.com>
	<200705261346.20712.agruen@suse.de>
	<200705262109.JJB99189.TFHFGQEOtVOMWJF@I-love.SAKURA.ne.jp>
	<200705261541.09891.agruen@suse.de>
In-Reply-To: <200705261541.09891.agruen@suse.de>
Message-Id: <200705262344.HGG92040.QtGFWFTOJMHOEFV@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50]
X-Accept-Language: ja,en
Date: Sat, 26 May 2007 23:44:46 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Andreas Gruenbacher wrote:
> > Therefore, TOMOYO Linux checks the combination of filename and argv[0]
> > passed to execve().
> So you are indeed trying to control the value of argv[0]? Well, good luck with 
> that, but it's totally insane. You are guaranteed to break some applications.
TOMOYO Linux ristricts argv[0] using allow_argv0 syntax.
"allow_argv0 /bin/bash -bash" to allow passing "/bin/bash" to filename and "-bash" to argv[0] .
"allow_argv0 /bin/gzip gunzip" to allow passing "/bin/gzip" to filename and "gunzip" to argv[0] .
"allow_argv0 /sbin/busybox cat" to allow passing "/sbin/busybox" to filename and "cat" to argv[0] .
No need to use allow_argv0 syntax if the basename of filename and basename of argv[0] are the same
(i.e. "allow_argv0 /bin/bash bash" is not required).
TOMOYO Linux doesn't unconditionally forbid passing different values for filename and argv[0].
TOMOYO Linux allows passing different values for filename and argv[0] only if it is allowed by allow_argv0 syntax.
Could you please explain me why this approach breaks applications?

> If /bin/cat and /bin/rm are binaries or hardlinks to the same busybox binary 
> (rather than symlinks), different profiles could be used for each of them.
It is true if all processes are kept under control (e.g. strict policy in SELinux).
If there is a process that is not kept under control (e.g. targeted policy in SELinux),
you can't protect the application.
For example, an administrator may wish to allow users run /bin/ls without applying profiles
because /bin/ls won't read/write the content of files. But a malicious user may pass
"/bin/ls" to filename and "rm" to argv[0] and "/etc/shadow" to argv[1].
A malicious user may pass "/bin/ls" to filename and "/usr/sbin/httpd" to argv[0],
resulting behave as /usr/sbin/httpd without applying profiles for /usr/sbin/httpd .

Thanks.
