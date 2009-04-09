Return-Path: <linux-kernel-owner+w=401wt.eu-S1764021AbZDIQr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764021AbZDIQr1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 12:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936378AbZDIQmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 12:42:55 -0400
Received: from gate.crashing.org ([63.228.1.57]:55380 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936376AbZDIQmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 12:42:53 -0400
Cc: linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Message-Id: <0D4C1952-792C-4AFF-8969-1EF5386FDAB9@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: oleg@redhat.com, sukadev@linux.vnet.ibm.com
In-Reply-To: <0CA2FBE3-C50C-4503-9134-6DA1C6965743@kernel.crashing.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: LTP 20080131 causes defunct processes w/2.6.30-rc1 (possible ptrace issue?)
Date: Thu, 9 Apr 2009 11:41:24 -0500
References: <0CA2FBE3-C50C-4503-9134-6DA1C6965743@kernel.crashing.org>
X-Mailer: Apple Mail (2.930.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 9, 2009, at 10:43 AM, Kumar Gala wrote:

> I'm seeing some weird behavior in 2.6.30-rc1 that didn't exist in  
> 2.6.29.  We have a slightly older LTP version (20080131) that we run  
> on some embedded PPC boards.  If I run the syscall tests on 2.6.29  
> things pass as expected.  W/2.6.30-rc1 I start seeing a slew of  
> processes that are "defunct".  I was able to trim down the tests to  
> the following ones (the recv01 test will become defunct):
>
> ptrace01 ptrace01
> ptrace02 ptrace02
> ptrace03 ptrace03
>
> recv01 recv01
>
> I'm able to reproduce this in a simulator, and am working on  
> bisecting it down now.
>
> Was wondering if there was anything ptrace related that went in that  
> could possible cause this?

So I was able to bisect this down to:

commit b3bfa0cba867f23365b81658b47efd906830879b
Author: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Date:   Thu Apr 2 16:58:08 2009 -0700

     signals: protect cinit from blocked fatal signals

     Normally SIG_DFL signals to global and container-init are dropped  
early.
     But if a signal is blocked when it is posted, we cannot drop the  
signal
     since the receiver may install a handler before unblocking the  
signal.
     Once this signal is queued however, the receiver container-init  
has no way
     of knowing if the signal was sent from an ancestor or descendant
     namespace.  This patch ensures that contianer-init drops all  
SIG_DFL
     signals in get_signal_to_deliver() except SIGKILL/SIGSTOP.

     If SIGSTOP/SIGKILL originate from a descendant of container-init  
they are
     never queued (i.e dropped in sig_ignored() in an earler patch).

     If SIGSTOP/SIGKILL originate from parent namespace, the signal is  
queued
     and container-init processes the signal.

     IOW, if get_signal_to_deliver() sees a sig_kernel_only() signal  
for global
     or container-init, the signal must have been generated internally  
or must
     have come from an ancestor ns and we process the signal.

     Further, the signal_group_exit() check was needed to cover the  
case of a
     multi-threaded init sending SIGKILL to other threads when doing  
an exit()
     or exec().  But since the new sig_kernel_only() check covers the  
SIGKILL,
     the signal_group_exit() check is no longer needed and can be  
removed.

     Finally, now that we have all pieces in place, set  
SIGNAL_UNKILLABLE for
     container-inits.

     Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
     Cc: Oleg Nesterov <oleg@tv-sign.ru>
     Cc: Roland McGrath <roland@redhat.com>
     Cc: "Eric W. Biederman" <ebiederm@xmission.com>
     Cc: Daniel Lezcano <daniel.lezcano@free.fr>
     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

This is highly reproducible for me so I can add any debug code you'd  
like.  I'm not 100% clear on what it is that causes ps to report  
<defunct>:

  2447 ttyS0    00:00:00 recv01 <defunct>
  2449 ttyS0    00:00:00 recvfrom01 <defunct>
  2451 ttyS0    00:00:00 recvmsg01 <defunct>

If I revert the commit on v2.6.30-rc1 these processes die properly and  
things run as expected.

- k
