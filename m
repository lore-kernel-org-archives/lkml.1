Return-Path: <linux-kernel-owner+w=401wt.eu-S1757514AbXIQVk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514AbXIQVk2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 17:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753797AbXIQVkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 17:40:20 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:41695 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879AbXIQVkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 17:40:18 -0400
X-IronPort-AV: E=Sophos;i="4.20,265,1186383600"; 
   d="scan'208";a="176443163"
To: john.blackwood@ccur.com
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       general@lists.openfabrics.org
Subject: Re: [ofa-general] [PATCH] [WORKAROUND] CONFIG_PREEMPT_RT and ib_umad_close() issue
X-Message-Flag: Warning: May contain useful information
References: <46EEB715.7060509@ccur.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 17 Sep 2007 14:40:08 -0700
In-Reply-To: <46EEB715.7060509@ccur.com> (John Blackwood's message of "Mon, 17 Sep 2007 13:19:17 -0400")
Message-ID: <adair69nf7r.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 17 Sep 2007 21:40:08.0966 (UTC) FILETIME=[51A4D260:01C7F973]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the explanation...

 > But basically, with CONFIG_PREEMPT_RT enabled, the lock points, such as
 > aqcuiring a spinlock, potentially become places where the current task
 > may be context switched out / preempted.
 > 
 > Therefore, when a call is made to lock a spinlock for example, the
 > caller should not currently have irqs disabled, or preemption disabled,
 > since a context switch may occur.

this doesn't seem relevant here...

 > void fastcall rt_downgrade_write(struct rw_semaphore *rwsem)
 > {
 >         BUG();
 > }

this seems to be the problem... the -rt patch turns downgrade_write()
into a BUG().

I need to look at the locking in user_mad.c again, but I think it may
be possible to replace both places that do downgrade_write() with
up_write() followed by down_read().

 - R.
