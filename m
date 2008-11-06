Return-Path: <linux-kernel-owner+w=401wt.eu-S1754676AbYKFKcE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676AbYKFKcE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 05:32:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752589AbYKFKby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 05:31:54 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:34949 "EHLO
	gwia-smtp.id2.novell.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751166AbYKFKbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 05:31:53 -0500
X-Greylist: delayed 1233 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Nov 2008 05:31:53 EST
Subject: Problem with PTRACE_EVENT_CLONE in 2.6.27
From: Martin Baulig <martin@novell.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Organization: Novell, Inc.
Date: Thu, 06 Nov 2008 11:10:58 +0100
Message-Id: <1225966258.5765.6.camel@rivendell.trier.ximian.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am developing a debugger and recently run into a strange problem
with ptrace() which showed up between 2.6.25.16 and 2.6.28-rc3.

I'm using

	int flags = PTRACE_O_TRACECLONE | PTRACE_O_TRACEFORK |
PTRACE_O_TRACEVFORK |
		PTRACE_O_TRACEEXEC;

	ptrace (PTRACE_SETOPTIONS, pid, 0, flags);

after starting the target application and then do a

	ret = waitpid (pid, status, WUNTRACED | __WALL | __WCLONE);

in a special worker thread.

My problem is that with recent kernels, I sometimes get the initial
SIGSTOP event for a newly created thread before the `PTRACE_EVENT_CLONE'
event for that thread.

This causes two problems for me:

a) I'm getting a SIGSTOP for an unknown PID, so I have to decide what
   to do with it.

   It seems that ptrace (PT_GETRETGS) on that PID sometimes works and
   sometimes doesn't - what's going on here ?  Can I debug the new
   thread just after receiving its initial SIGSTOP or do I need to
   wait until the `PTRACE_EVENT_CLONE' ?


b) After getting the PTRACE_EVENT_CLONE, there seems to be no reliable
   way for me to wait until this new thread has stopped.

   If I understand things correctly, you can't waitpid() on a thread
   which is already stopped, so how do I check whether the newly
   created thread has already stopped ?

I put some really bad hack to work around this problem into the
development version of our product, but I'd be very happy to hear about
an official solution.

I'm not subscribed to the list, so please Cc: me on all replies.

Thanks,
Martin Baulig

-- 
Martin Baulig - martin@novell.com
Novell GmbH, Düsseldorf
GF: Volker Smid, Djamel Souici; HRB 21108 (AG Düsseldorf)


