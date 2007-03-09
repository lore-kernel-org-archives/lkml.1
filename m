Return-Path: <linux-kernel-owner+w=401wt.eu-S1161348AbXCIAOM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161348AbXCIAOM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 19:14:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161349AbXCIAOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 19:14:11 -0500
Received: from mail.screens.ru ([213.234.233.54]:58471 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161348AbXCIAOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 19:14:09 -0500
Date: Fri, 9 Mar 2007 03:14:08 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Avi Kivity <avi@argo.co.il>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/5] signalfd v2 - signalfd core ...
Message-ID: <20070309001408.GA6801@tv-sign.ru>
References: <20070308204353.GA6733@tv-sign.ru> <Pine.LNX.4.64.0703081259560.7515@alien.or.mcafeemobile.com> <20070308215653.GA6744@tv-sign.ru> <Pine.LNX.4.64.0703081459350.4882@alien.or.mcafeemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703081459350.4882@alien.or.mcafeemobile.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08, Davide Libenzi wrote:
>
> On Fri, 9 Mar 2007, Oleg Nesterov wrote:
> 
> > > Logic is, if it's not an RT signal, queue only one, otherwise multiple.
> > > The bit on the ->pending mask is clealer only when the queue slot becomes empty.
> > 
> > Yes, I see what the code does, but I don't undestand why. For example, SIGCHLD was
> > delivered to the process _and_ handled several times, then sys_signalfd_dequeue()
> > comes and finds only one siginfo. Isn't this strange?
> 
> That's the same logic the kernel folows for non-RT signals. 

Yes, specific_send_sig_info/__group_send_sig_info "ignores" the non-RT signal

	- if we already have a pending one (blocked, or not yet handled)

	- the only reason is backward compatibility

signalfd:

	- if the same signr was not fetched via sys_signalfd_dequeue()

	- the reason is ????

Suppose we are doing a simple application which just logs all signals
which were sent to this process. Now, we can miss the signal if the
logging blocks.

Think about sub-threads. We can send the same non-RT signal to T1, T2, T3
via specific_send_sig_info(). All 3 signals will be delivered, but signalfd
(which is process wide) will see only the first.

> > > The two trasports can rely on different masks. The signalfd_notify() does 
> > > not even go in signalfd_deliver() if no signalfds are attached to the 
> > > sighand.
> > 
> > Sorry, I don't understand. The masks are different, yes, but ->sighand is the
> > same? How this can make any difference for "if no signalfds are attached" ?
> 
> The list_empty() che would not make you fall inside signalfd_deliver(), 
> hence the fast path really lives up to its name ;)

Ugh. Still can't understand, probably I missed something or misread this patch.

If we shift signalfd_notify() from specific_send_sig_info/__group_send_sig_info
to send_signal(), we have the same "list_empty()" fastpath if no signalfds are
attached to the sighand. The difference is that we don't count sig_ignored()
signals, which looks right to me.

Oleg.

