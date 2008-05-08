Return-Path: <linux-kernel-owner+w=401wt.eu-S932509AbYEHUMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932509AbYEHUMj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 16:12:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756223AbYEHUL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 16:11:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35687 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754824AbYEHUL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 16:11:56 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: wenji huang <wenji.huang@oracle.com>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
Subject: Re: possible regression of ptrace on 2.6.26-rc1
In-Reply-To: wenji huang's message of  Wednesday, 7 May 2008 17:20:12 +0800 <4821744C.9070805@oracle.com>
References: <481FCE51.7060604@oracle.com>
	<20080506080159.0638E26FA20@magilla.localdomain>
	<4821744C.9070805@oracle.com>
Emacs: more boundary conditions than the Middle East.
Message-Id: <20080508201150.AEEEE26FA85@magilla.localdomain>
Date: Thu,  8 May 2008 13:11:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The test is racy.  I don't think the behavior that affects this has really
changed between kernel versions, you're just seeing timing effects.

When you finish the loop, you've just done a PTRACE_SYSCALL to resume
the child, but have not done a wait for it.  You then do PTRACE_CONT on
it.  If the child has stopped at its next syscall report by the time
that ptrace call checks the child, it works.  If not, it sees the child
is not yet stopped and ptrace fails with ESRCH.  

Due to hysterical raisins, PTRACE_KILL skips the "child is stopped"
check, so it will never return that error.  However, a PTRACE_KILL
request made before the child has actually stopped will not reliably do
anything (it will set child->exit_code = SIGKILL in a race with the
child itself setting current->exit_code before it stops).


Thanks,
Roland
