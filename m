Return-Path: <linux-kernel-owner+w=401wt.eu-S1760425AbZEFU13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760425AbZEFU13 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 16:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753437AbZEFU1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 16:27:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58178 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753358AbZEFU1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 16:27:19 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
Subject: Re: [FOR REVIEW, PATCH 0/2] do_wait() cleanups.
In-Reply-To: Oleg Nesterov's message of  Wednesday, 6 May 2009 07:33:18 +0200 <20090506053318.GA31977@redhat.com>
References: <20090506053318.GA31977@redhat.com>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20090506202718.1B908FC39E@magilla.sf.frob.com>
Date: Wed,  6 May 2009 13:27:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Also. This is completely off-topic wrt ptrace cleanups, but if we
> change do_wait() now perhaps it makes sense to optimize do_wait()
> in PIDTYPE_PID case. In this case we do not need to scan the lists,
> we can inspect the task directly. This change should be simple, but
> it will increase .text. Do you think it makes sense?

Yes, I think that's a worthwhile optimization in its own right.  In waitpid
calls using an explicit PID, it will be a huge help for both applications
with many other children and for applications with many threads (when the
waitpid caller does not happen to be the fork caller).  It looks like it
would be simple and cheap enough.

I doubt this would need much restructuring of the code (just a
short-circuit path that calls wait_consider_task from do_wait after
checking !task_detached(p) && !task_ptrace(p) && __WNOTHREAD ?
p->real_parent == current : same_thread_group(,p->real_parent)).
If that's true, then we can do this later after settling these
cleanups and ptrace stuff, perhaps along with the wakeup-avoidance
hack that never got finished.  That stuff is really just pure optimization
not inherently apropos to anything else.


Thanks,
Roland
