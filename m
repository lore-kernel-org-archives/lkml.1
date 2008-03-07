Return-Path: <linux-kernel-owner+w=401wt.eu-S1764889AbYCGUYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764889AbYCGUYP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 15:24:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757836AbYCGUX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 15:23:59 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:45705 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758278AbYCGUX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 15:23:58 -0500
Date: Fri, 7 Mar 2008 23:23:16 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] signals: do_tkill: don't use tasklist_lock
Message-ID: <20080307202316.GB107@tv-sign.ru>
References: <20080307095813.GA8894@tv-sign.ru> <20080307193159.1AFF127010F@magilla.localdomain> <20080307201346.GA107@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080307201346.GA107@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07, Oleg Nesterov wrote:
>
> Suppose that the main thread is already dead (dequeued SIGKILL), but
> not yet released. This window is not that small. In that window (before
> de_thread() switches pids) any private signal (even SIGKILL) sent to the
> main thread will be silently lost.
> 
> To do a proper fix, we should change de_thread() so that the new leader
> also "inherits" old_leader->pending signals.

Ah, even this is not enough if we want a "perfect" fix. Because the private
SIGKILL will be "ignored" until the main thread dequeues the SIGKILL which
was sent by de_thread().

We can change __group_complete_signal/zap_other_threads so that they won't
do sigaddset(), just signal_wake_up(). But in that case dequeue_signal()
and recalc_signal() should take signal_group_exit into account...

Oleg.

