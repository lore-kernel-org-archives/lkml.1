Return-Path: <linux-kernel-owner+w=401wt.eu-S1753157AbYH0RCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157AbYH0RCf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 13:02:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751223AbYH0RCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 13:02:09 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:60706 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866AbYH0RCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 13:02:08 -0400
Date: Wed, 27 Aug 2008 21:06:48 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: sukadev@us.ibm.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>, Robert Rex <robert.rex@exasol.com>,
       Roland McGrath <roland@redhat.com>, Serge Hallyn <serue@us.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] pid_ns: (BUG 11391) change ->child_reaper when init->group_leader exits
Message-ID: <20080827170648.GC97@tv-sign.ru>
References: <20080824154912.GA3780@tv-sign.ru> <20080826233353.GA21052@us.ibm.com> <20080827003524.GA22580@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080827003524.GA22580@us.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26, sukadev@us.ibm.com wrote:
>
> sukadev@us.ibm.com [sukadev@us.ibm.com] wrote:
> | I was able to repro the problem without the patchset and could  not
> | reproduce  with the patchset. But just had a quick question while
> | reviewing the patches.
> |
> | Oleg Nesterov [oleg@tv-sign.ru] wrote:
> | | We don't change pid_ns->child_reaper when the main thread of the
> | | subnamespace init exits. As Robert Rex <robert.rex@exasol.com>
> | | pointed out this is wrong.
> | |
> | | Yes, the re-parenting itself works correctly, but if the reparented
> | | task exits it needs ->parent->nsproxy->pid_ns in do_notify_parent(),
> |
> | If the task was reparented, then with patch 1/4 its parent would be
> | the global init (init_pid_ns.child_reaper) right ?
> |
> | | and if the main thread is zombie its ->nsproxy was already cleared
> | | by exit_task_namespaces().
> |
> | If above is true, then even if the main thread's nsproxy is NULL, does
> | it affect the reparented task ?
>
> never mind. I see it now. The group_dead check in current code is not
> sufficient (and the zap_pid_ns() may not have been called when main
> thread is exiting).

Yes.

BTW, your original patch (which introduced zap_pid_ns()) was correct ;)
The code was broken later, during the s/->pid/vpid/ conversion.

The group_dead check _is_ sufficient (and correct) for zap_pid_ns(),
but we all missed the simple fact: if we continue to re-parent to
some task, it must have the valid ->nsproxy->pid_ns. Thanks to Robert
again.

Oleg.

