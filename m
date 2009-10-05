Return-Path: <linux-kernel-owner+w=401wt.eu-S1754597AbZJESNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597AbZJESNR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 14:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754586AbZJESNR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 14:13:17 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:56461 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754462AbZJESNQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 14:13:16 -0400
Date: Mon, 5 Oct 2009 11:12:55 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Linux Containers <containers@lists.osdl.org>, roland@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] signals: send_signal: use si_fromuser() to detect
	from_ancestor_ns
Message-ID: <20091005181255.GE30442@us.ibm.com>
References: <4AC608BE.9020805@fr.ibm.com> <20091003171029.GA30442@us.ibm.com> <20091004021844.GA21006@redhat.com> <20091004021954.GC21006@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091004021954.GC21006@redhat.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov [oleg@redhat.com] wrote:
| Change send_signal() to use si_fromuser(). From now SEND_SIG_NOINFO
| triggers the "from_ancestor_ns" check.
| 
| This fixes reparent_thread()->group_send_sig_info(pdeath_signal)
| behaviour, before this patch send_signal() does not detect the
| cross-namespace case when the child of the dying parent belongs
| to the sub-namespace.
| 
| This patch can affect the behaviour of send_sig(), kill_pgrp() and
| kill_pid() when the caller sends the signal to the sub-namespace
| with "priv == 0" but surprisingly all callers seem to use them
| correctly, including disassociate_ctty(on_exit).
| 
| Except: drivers/staging/comedi/drivers/addi-data/*.c incorrectly
| use send_sig(priv => 0). But his is minor and should be fixed
| anyway.
| 
| Reported-by: Daniel Lezcano <dlezcano@fr.ibm.com>
| Signed-off-by: Oleg Nesterov <oleg@redhat.com>
| ---
| 
|  kernel/signal.c |    5 ++---
|  1 file changed, 2 insertions(+), 3 deletions(-)
| 
| --- TTT_32/kernel/signal.c~FU_2_SEND_SIGNAL	2009-10-04 02:21:55.000000000 +0200
| +++ TTT_32/kernel/signal.c	2009-10-04 03:09:44.000000000 +0200
| @@ -928,9 +928,8 @@ static int send_signal(int sig, struct s
|  	int from_ancestor_ns = 0;
| 
|  #ifdef CONFIG_PID_NS
| -	if (!is_si_special(info) && SI_FROMUSER(info) &&
| -			task_pid_nr_ns(current, task_active_pid_ns(t)) <= 0)
| -		from_ancestor_ns = 1;
| +	from_ancestor_ns = si_fromuser(info) &&
| +			   !task_pid_nr_ns(current, task_active_pid_ns(t));

Makes sense. And we had mentioned earlier that container-init is immune
to suicide but should we add a check for 'current == t' above to cover the

	send_sig(SIGKILL, current, 0);

in load_aout_binary() and friends

	from_ancestor_ns = si_fromuser(info) && (current == t ||
				!task_pid_nr_ns(current, task_active_pid_ns(t)));

Sukadev.
