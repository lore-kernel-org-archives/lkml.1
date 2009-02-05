Return-Path: <linux-kernel-owner+w=401wt.eu-S1762154AbZBECkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762154AbZBECkn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 21:40:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752269AbZBECkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 21:40:33 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60983 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751849AbZBECkc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 21:40:32 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] forget_original_parent: cleanup ptrace pathes
In-Reply-To: Oleg Nesterov's message of  Thursday, 29 January 2009 09:06:03 +0100 <20090129080603.GA26882@redhat.com>
References: <20090129080603.GA26882@redhat.com>
X-Shopping-List: (1) Flatulent stone adhesives
   (2) Invidious malnutrition explosions
   (3) Symphonic mathematical bread sand
Message-Id: <20090205024021.04DDDFC381@magilla.sf.frob.com>
Date: Wed,  4 Feb 2009 18:40:20 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> - Fold ptrace_exit() into forget_original_parent(), it is trivial
>   now. More importantly, this makes the code more symmetrical with
>   reparent_thread().

Please don't do this.  The ptrace functions are separated not because they
are large, but because they are the ptrace innards.  We have been moving
away from the core task handling innards having intimate ptrace magic
knowledge directly intertwined, and we don't want to move back the other
way.  In later cleanups, we will eventually separate ptrace linkage from
the tasklist_lock'd parent/child linkage more thoroughly.

> - The same for ptrace_exit_finish(), and "ptrace_" is not correct
>   any longer.
> 
> - "ptrace_dead" doesn't match the reality, rename to "dead_list".

For the same reasons, I am not entirely sanguine about overloading
ptrace_entry for any case not related to ptrace.  We want to be able to
clean up the ptrace data structures in the future such that there may well
not be any such list_head allocated in an untraced task_struct.

This case is sufficiently obscure, I can't see that anyone would really
care about the marginal performance hit for just dropping the lock after
reparent_thread returns true, call release_task(), re-lock and restart the
loop on remaining children.  (And I don't see any atomicity problem with
this unlock/relock.)

> - swap the reparent_thread()'s arguments, just to make it more
>   symmetrical with __ptrace_detach().

No problem there.


Thanks,
Roland
