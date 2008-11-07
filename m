Return-Path: <linux-kernel-owner+w=401wt.eu-S1753856AbYKGRF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbYKGRF2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 12:05:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751016AbYKGRFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 12:05:16 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:52005 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbYKGRFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 12:05:14 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com, viro@ZenIV.linux.org.uk,
       containers@lists.osdl.org
References: <m1ej1p2l6u.fsf@frodo.ebiederm.org>
	<m1abcd2kqk.fsf@frodo.ebiederm.org>
	<20081106172617.dd51d0af.akpm@linux-foundation.org>
	<m1abccxpc5.fsf@frodo.ebiederm.org>
	<20081106184945.179c248a.akpm@linux-foundation.org>
	<m1iqr0urb8.fsf@frodo.ebiederm.org>
	<20081106202822.a1af8a6e.akpm@linux-foundation.org>
	<m1d4h7v8jf.fsf@frodo.ebiederm.org>
	<20081107080529.6f4de3ad.akpm@linux-foundation.org>
Date: Fri, 07 Nov 2008 08:58:34 -0800
In-Reply-To: <20081107080529.6f4de3ad.akpm@linux-foundation.org> (Andrew
	Morton's message of "Fri, 7 Nov 2008 08:05:29 -0800")
Message-ID: <m1mygbqxqd.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, containers@lists.osdl.org, viro@ZenIV.linux.org.uk, adobriyan@gmail.com, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 2/7] proc: Implement support for automounts in task directories
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> I was thinking more along the lines of some repeated operation which
> generates reclaimable storage, only nothing reclaims that storage
> sufficiently promptly (the 500 second delay, perhaps).
>
> Like the problem we had with SLAB_DESTROY_BY_RCU and, umm, I think it
> was route cache entries increasing like mad and not getting reaped.

Well what happens is I run reclaim that chain whenever a process
exits or every 500s.  The 500s is really the backup in case
we don't have any processes exiting, which is a really
strange workload.

Now maybe there is an extremely perverse case out there that
can trigger some bad behavior.  But I can't think of anything
like that at the moment.  It would require accessing a lot
of /proc/<pid>/net directories and holding them open even after
their files were gone, pinning a lot of mounts, and then
use a lot of memory elsewhere.  Where the problem would
be that the code is not well tied in with memory reclaim.

A mount is not a big or expensive structure and it requires
a fd somewhere to keep it alive past exit.  Thinking back
to my analysis on /proc a few years ago where I introduced
struct pid to prevent lowmem exhaustion.  I can't think of
a case where it would be a problem or user triggerable.
Basically you have to have a fd open for every proc inode
that lives past process exit.  And we have hard limits on
the number of fds a process can open and limits on the
number of processes we can have.

One of the things on my todo list to look at sometime is the issue
that mounts can deny you the permission to delete a file or directory
when the mount is in another mount namespace.  It is a pretty nasty
DOS from my opinion.  Especially when the last process holding open
the mount namespace oopses and there is no way to remove the mount.
However that DOS is only available to root today so it doesn't feel
like a huge danger.  To fix that we would need to introduce some
better mount reaping logic.  Which I expect would remove the need for
the proc_automounts.   That is tricky subtle vfs logic and I don't
plan to rush into it.

Eric
