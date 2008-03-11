Return-Path: <linux-kernel-owner+w=401wt.eu-S1754283AbYCKRr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283AbYCKRr1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 13:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752655AbYCKRrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 13:47:19 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:35385 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752664AbYCKRrS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 13:47:18 -0400
Date: Tue, 11 Mar 2008 20:51:22 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/6] signals: send_signal: factor out SIGNAL_GROUP_EXIT checks
Message-ID: <20080311175122.GA586@tv-sign.ru>
References: <20080309185926.GA5649@tv-sign.ru> <20080311021633.BF1B326F991@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080311021633.BF1B326F991@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10, Roland McGrath wrote:
>
> I don't really like dropping the signal on the floor.

To clarify: my opinion is quite opposite, but it is only based on the
"personal feeling", I don't have any "strong" arguments. If you still
think we shouldn't do this, please nack this change.

> If the posting says
> it succeeded (vs -ESRCH) then I'd like to see it appear later in the
> pending set of the zombie thread, when we look at /proc/pid/status at exit
> tracing or whatnot (and in core dumps).  Seeing those pending signal bits
> is sometimes a useful clue about how something died in a strange scenario.

As for core dumps. Suppose that the task has already started do_coredump()
and another signal comes. Why should fill_prstatus() report this new signal?
This doesn't look exactly right for me. The coredump should try to reflect
the state of the task which it had when it was killed.

Actually, the same for zombies. If the task sits in Z state, one can look
at /proc/pid/status to see what signals it had when exited. To me, it looks
just better if it is visible that a zombie doesn "accept" the new signals,
because it is dead. (offtopic: currently the single-threaded exit doesn't
set SIGNAL_GROUP_EXIT. This doesn't matter now, but I think it would be
nice to be more consistent here).

Now, suppose that due to some kernel bug the running thread/process doesn't
want to die despite of SIGNAL_GROUP_EXIT. In that case another kill() may help
because of additional wakeup, but this will hide the problem which won't be
reported.

But again, I see your point, thanks.

Oleg.

