Return-Path: <linux-kernel-owner+w=401wt.eu-S1754560AbXDXCq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560AbXDXCq3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 22:46:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754564AbXDXCq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 22:46:29 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50009 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754560AbXDXCq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 22:46:28 -0400
Date: Mon, 23 Apr 2007 19:45:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] change kernel threads to ignore signals instead of
 blocking them
Message-Id: <20070423194527.ab86799f.akpm@linux-foundation.org>
In-Reply-To: <20070413073116.GA1540@tv-sign.ru>
References: <20070413073116.GA1540@tv-sign.ru>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Apr 2007 11:31:16 +0400 Oleg Nesterov <oleg@tv-sign.ru> wrote:

> On top of Eric's
> 
> 	kthread-dont-depend-on-work-queues-take-2.patch
> 
> Currently kernel threads use sigprocmask(SIG_BLOCK) to protect against signals.
> This doesn't prevent the signal delivery, this only blocks signal_wake_up().
> Every "killall -33 kthreadd" means a "struct siginfo" leak.
> 
> Change kthreadd_setup() to set all handlers to SIG_IGN instead of blocking them
> (make a new helper ignore_signals() for that). If the kernel thread needs some
> signal, it should use allow_signal() anyway, and in that case it should not use
> CLONE_SIGHAND.
> 
> Note that we can't change daemonize() (should die!) in the same way, because
> it can be used along with CLONE_SIGHAND. This means that allow_signal() still
> should unblock the signal to work correctly with daemonize()ed threads.
> 
> However, disallow_signal() doesn't block the signal any longer but ignores it.
> 
> NOTE: with or without this patch the kernel threads are not protected from
> handle_stop_signal(), this seems harmless, but not good.

I'm seeing 500 zombied instances of khelper (from udev startup).  It only
happens when the utrace patches are applied.  Presumably an interaction
between utrace and one of these kthread changes.

I'll drop utrace for now.  I don't think it's getting much help from being
in -mm at present and it's getting increasingly painful to keep it merged
against all the other stuff which is happening.

Roland, I'll squirt all the extra utrace patches which I have in your direction.
Please merge them or hang on to them for later on.
