Return-Path: <linux-kernel-owner+w=401wt.eu-S1161532AbXDXKKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161532AbXDXKKc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 06:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161659AbXDXKKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 06:10:32 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45932 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161532AbXDXKKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 06:10:31 -0400
Date: Tue, 24 Apr 2007 03:09:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Davide Libenzi <davidel@xmailserver.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Roland McGrath <roland@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       <linux-arch@vger.kernel.org>
Subject: Re: [PATCH] kthread: Enhance kthread_stop to abort interruptible
 sleeps
Message-Id: <20070424030924.be44ebfa.akpm@linux-foundation.org>
In-Reply-To: <m1zm5bmywm.fsf@ebiederm.dsl.xmission.com>
References: <20070413130236.GA173@tv-sign.ru>
	<m1zm5bmywm.fsf@ebiederm.dsl.xmission.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Apr 2007 21:13:13 -0600 ebiederm@xmission.com (Eric W. Biederman) wrote:

> This patch reworks kthread_stop so it is more flexible and it causes
> the target kthread to abort interruptible sleeps.  Allowing a larger
> class of kernel threads to use to the kthread API.
> 
> The changes start by defining TIF_KTHREAD_STOP on all architectures.
> TIF_KTHREAD_STOP is a per process flag that I can set from another
> process to indicate that a kernel thread should stop.
> 
> wake_up_process in kthread_stop has been replaced by signal_wake_up
> ensuring that the kernel thread if sleeping is woken up in a timely
> manner and with TIF_SIGNAL_PENDING set, which causes us to break out
> of interruptible sleeps.
> 
> recalc_signal_pending was modified to keep TIF_SIGNAL_PENDING set for
> as long as TIF_KTHREAD_STOP is set.
> 
> Arbitrary paths to do_exit are now allowed.  I have placed a
> completion on the thread stack and pointed vfork_done at it, when the
> mm_release is called from do_exit the completion will be called.
> Since the completion is stored on the stack it is important that
> kthread() now calls do_exit ensuring the stack frame that holds the
> completion is never released, and so that our exit_code is certain to
> make it unchanged all the way to do_exit.
> 
> To allow kthread_stop to read the process exit code when exit_mm wakes
> it up  I have moved the setting of exit_code to the beginning of
> do_exit. 

This patch causes this oops: http://userweb.kernel.org/~akpm/s5000508.jpg
with this config: http://userweb.kernel.org/~akpm/config-x.txt
