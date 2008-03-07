Return-Path: <linux-kernel-owner+w=401wt.eu-S1759425AbYCGCko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759425AbYCGCko (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 21:40:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752806AbYCGCke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 21:40:34 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:59584 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289AbYCGCkd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 21:40:33 -0500
Date: Fri, 7 Mar 2008 05:39:38 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Jiri Kosina <jkosina@suse.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC,PATCH 1/2] signals: re-assign CLD_CONTINUED notification from the sender to reciever
Message-ID: <20080307023938.GB149@tv-sign.ru>
References: <20080304185744.GA8479@tv-sign.ru> <20080306105316.631552700FD@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080306105316.631552700FD@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06, Roland McGrath wrote:
>
> I like this version fine, but I would like to see that comment in
> get_signal_to_deliver added in a cleanup patch.

Yes. Will do.

>From another message:
>
> > Perhaps, we can add the new helper which sets SIGNAL_GROUP_EXIT but preserves
> > SIGNAL_CLD_MASK, but I don't think this is really needed.
>
> Actually, I think it is.  This made think of another pedantic concern.
> (Not that I'm sure we get this right now anyway.)

This "I don't think this is really needed" above meant that the patch doesn't
make things worse than we currently have, but

> Say a child was previously stopped, parent had seen CLD_STOPPED and done
> WSTOPPED wait.  Now we send SIGCONT followed shortly by SIGTERM (unhandled
> fatal signal).  In the interval before the SIGTERM has yet been dequeued
> (nor SIGKILLs sent to other threads by __group_complete_signal), the parent
> does waitpid(pid, WSTOPPED|WCONTINUED|WEXITED|WNOHANG).  It should see one
> of: WIFSTOPPED (still); WIFSIGNALED (dead); WIFCONTINUED.  Instead, waitpid
> will return 0 (it's running, not stopped, not continued).  This says
> SIGNAL_STOP_CONTINUED ought to function as normal (i.e. WCONTINUED polling)
> until we're actually ready for wait to report the process as dead.

Good point, completely agreed. (except I think it doesn't matter was that
fatal signal dequeued or not).

> We already break this pedantic nit because flags = SIGNAL_GROUP_EXIT clears
> SIGNAL_STOP_CONTINUED.  But if we clean up all flags usage, I think we
> should make it preserve SIGNAL_STOP_CONTINUED.
>
> But if we were to make wait key on SIGNAL_STOP_STOPPED, as is
> probably necessary to do WSTOPPED waits for processes with a zombie
> group_leader, then this too could be made consistent.  (Leave the
> SIGNAL_STOP_STOPPED bit set throughout, so WSTOPPED|WNOHANG waits continues
> to report it as stopped until it actually dies.)

Yes, thanks. Will try to do a bit later.

Oleg.

