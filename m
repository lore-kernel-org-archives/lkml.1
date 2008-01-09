Return-Path: <linux-kernel-owner+w=401wt.eu-S1753460AbYAIG0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460AbYAIG0z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 01:26:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751128AbYAIG0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 01:26:45 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:61509 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbYAIG0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 01:26:44 -0500
Message-Id: <200801090626.m096QWKl016866@www262.sakura.ne.jp>
Subject: Re: [PATCH][RFC] Simple tamper-proof device filesystem.
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: Valdis.Kletnieks@vt.edu
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       serue@us.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Date: Wed, 09 Jan 2008 15:26:31 +0900
References: <200712232344.JBJ90661.FQOFtFOVLJHSOM@I-love.SAKURA.ne.jp> <20071231200247.GA30373@sergelap.austin.ibm.com> <200801011116.AFH73928.MHFLtOSOOVJFQF@I-love.SAKURA.ne.jp> <200801061520.JEF52626.LFHMtSQJOOVFFO@I-love.SAKURA.ne.jp> <6879.1199725780@turing-police.cc.vt.edu> <200801082250.CJH13533.OFSMHFVOLtJQOF@I-love.SAKURA.ne.jp> <10946.1199855042@turing-police.cc.vt.edu>
In-Reply-To: <10946.1199855042@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Valdis.Kletnieks@vt.edu wrote:
> Good summary - probably should add that to the patch, drop it into
> Documentation/syaoran-config.txt or similar...
I see.

> Modification while reading *is* an issue, but can probably be worked around
> with some clever locking.  The race condition I was thinking of was if you
> had the mount and the policy load be 2 separate events, you could see:
> 
> (a) issue mount request
>                         (b) do something malicious in /dev while..
> (c) load the policy that would have prevented (b).
> 
> This is partly why SELinux has init load the policy *very* early on, before
> any other userspace have had a chance to run and do things that would have
> been prevented by policy.
So, you suggested to load policy before mount() request so that
this filesystem can prevent attackers from doing something malicious
by minimizing (i.e. implement as non-blocking operation) the latency
between the userland process's call of mount() and the nodes become visible
to userland process.

I didn't take such cases into account.
My assumed usage of this filesystem is that run a script with

 #!/bin/sh
 mount -t syaoran -o accept=/etc/ccs/syaoran.conf none /dev
 exec /sbin/init "$@"

by passing "init=/path/to/this/script" to the kernel command line
so that /sbin/init can create /dev/initlog on this filesystem.
If you mount this filesystem after /sbin/init starts,
it will shadow /dev/initctl opened by /sbin/init .

> Which basically ends up meaning that anybody who can trick the mount into
> happening can reset the permitted list and create (for example) a mode 666
> entry for a hard drive, and go scribbling around at will.  Note that you
> don't seem to do any sanity checking on the path (for instance, that each
> component is owned by root, and not world-writable) - so anybody who finds
> a way to get the mount to happen can supply their own list in /home/joeuser/blat
> or /tmp/surprise-mount-list  or wherever.
I assume that being able to reach this location means the caller of mount() is root.
But, the patches to allow mount() by non-root is in progress? http://lkml.org/lkml/2008/1/8/131
May be I should add some sanity checking on the path.

Thank you.
