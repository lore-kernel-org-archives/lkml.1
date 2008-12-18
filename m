Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752935AbYLRD7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935AbYLRD7j (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 22:59:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750797AbYLRD73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 22:59:29 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:51067 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbYLRD72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 22:59:28 -0500
Date: Wed, 17 Dec 2008 19:58:23 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: oleg@redhat.com, ebiederm@xmission.com, roland@redhat.com
Cc: daniel@hozac.com, bastian@waldi.eu.org, xemul@openvz.org,
        containers@lists.osdl.org, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [RFC][PATCH] SEND_SIG_NOINFO: Set si_pid to tgid instead of pid
Message-ID: <20081218035823.GA21062@us.ibm.com>
References: <20081217020601.GB2866@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081217020601.GB2866@us.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ccing linux-api for the user-visible changes per Roland's suggestion.
Not sure if the current behavior is documented somewhere. but should
the new behavior be documented in pipe(7) and prctl(2) ?

This patch was recently added to -mm tree.

Sukadev

Sukadev Bhattiprolu [sukadev@linux.vnet.ibm.com] wrote:
| 
| From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
| Date: Tue, 16 Dec 2008 17:07:17 -0800
| Subject: [PATCH] SEND_SIG_NOINFO: Set si_pid to tgid instead of pid
| 
| POSIX requires the si_pid to be the process id of the sender, so ->si_pid
| should really be set to 'tgid'. This change does have following changes
| in behavior:
| 
| 	- When sending pdeath_signal on re-parent to a sub-thread, ->si_pid
| 	  cannot be used to identify the thread that did the re-parent since
| 	  it will now show the tgid instead of thread id.
| 
| 	- A multi-threaded application that expects to find the specific
| 	  thread that encountered a SIGPIPE using the ->si_pid will now
| 	  break.
| 
| Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
| ---
|  kernel/signal.c |    2 +-
|  1 files changed, 1 insertions(+), 1 deletions(-)
| 
| diff --git a/kernel/signal.c b/kernel/signal.c
| index d11e5f8..700d767 100644
| --- a/kernel/signal.c
| +++ b/kernel/signal.c
| @@ -856,7 +856,7 @@ static int send_signal(int sig, struct siginfo *info, struct task_struct *t,
|  			q->info.si_signo = sig;
|  			q->info.si_errno = 0;
|  			q->info.si_code = SI_USER;
| -			q->info.si_pid = task_pid_nr_ns(current,
| +			q->info.si_pid = task_tgid_nr_ns(current,
|  							task_active_pid_ns(t));
|  			q->info.si_uid = current_uid();
|  			break;
| -- 
| 1.5.2.5
| 
| --
| To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
| the body of a message to majordomo@vger.kernel.org
| More majordomo info at  http://vger.kernel.org/majordomo-info.html
| Please read the FAQ at  http://www.tux.org/lkml/
