Return-Path: <linux-kernel-owner+w=401wt.eu-S1756943AbZKUWXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943AbZKUWXV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 17:23:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756913AbZKUWXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 17:23:20 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:48099 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756857AbZKUWXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 17:23:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:reply-to:mime-version:content-type
         :content-disposition:user-agent;
        b=nB+JqGvmv9ekjN+WR/low20T75/sQB8mjGYrte43kAwqNyd0FhCVhAzU3kkZpATj/y
         8WF2ov29KujiZa2+AQtc/5Y5+6/pj4Ml0g/3DfanQpJfu8kYhM3sa9U/2K5dzhoAKB6d
         CX4DCSoBdfq/gCrBkvZkTWs0Ke+uXhWPt9yTo=
Date: Sun, 22 Nov 2009 09:23:19 +1100
From: Robert Swan <swan.r.l@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [bisected] pty performance problem
Message-ID: <20091121222319.GA3905@swanrl.gmail.com>
Reply-To: swan.r.l@gmail.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I posted this to the kernel-newbies list, but have graduated to the
adults forum:

! Two C programs are having a query-response conversation through a
! pseudo terminal:
! 
! A (client) -- forever { send query; read response }
! B (server) -- forever { read query; send response }
! 
! Neither has any I/O apart from the pty conversation, so I'd expect to
! see CPU usage at 100%. When I ran it, the CPU was pretty well idle.
! After a fair bit of fiddling, it turned out that both sides were
! taking about 8ms for their read() calls. At that point it seemed
! pretty clear that this was a delay in the kernel, not the code.
! 
[snip]

2.6.31-rc2-00205-gb4b21ca good
2.6.31-rc2-00206-gd945cb9 bad

and still bad with the latest: 2.6.32-rc8-00011-ga8a8a66

the git log says:
! commit d945cb9cce20ac7143c2de8d88b187f62db99bdc
! Author: Alan Cox <alan@linux.intel.com>
! Date:   Tue Jul 7 16:39:41 2009 +0100
! 
!     pty: Rework the pty layer to use the normal buffering logic
!     
!     This fixes the ppp problems and various other issues with call locking
!     caused by one side of a pty called in one locking context trying to match
!     another with differing rules on the other side. We also get a big slack
!     space to work with that means we can bury the flow control deadlock case
!     for any conceivable real world situation.
!     
!     Signed-off-by: Alan Cox <alan@linux.intel.com>
!     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

I can provide reasonably stripped down code which demonstrates the
problem.  It has been reproduced by one other person, though his delay
was about 2ms.

Have fun,

Rob.
