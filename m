Return-Path: <linux-kernel-owner+w=401wt.eu-S1758016AbYE0Rfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016AbYE0Rfu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 13:35:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754459AbYE0Rfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 13:35:42 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:38165 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752636AbYE0Rfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 13:35:41 -0400
Date: Tue, 27 May 2008 21:37:11 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: Re: 2.6.26-rc4: RIP find_pid_ns+0x6b/0xa0
Message-ID: <20080527173711.GA1458@tv-sign.ru>
References: <alpine.LFD.1.10.0805261127030.2958@woody.linux-foundation.org> <20080527052318.GA28301@martell.zuzino.mipt.ru> <20080527090605.GA146@tv-sign.ru> <alpine.LFD.1.10.0805270746090.2958@woody.linux-foundation.org> <20080527164519.GA826@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080527164519.GA826@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27, Oleg Nesterov wrote:
>
> But I agree, this race is pretty much theoretical.

Perhaps we have the unbalanced put_pid(), in that case "struct pid" will
be freed without waiting for a grace period.

Alexey, could you re-test with the patch below?

Oleg.

Add the temporary debugging code to catch the unbalanced put_pid()'s.
At least those which can free the "live" pid.

--- MM/kernel/pid.c~	2008-02-20 18:29:40.000000000 +0300
+++ MM/kernel/pid.c	2008-02-20 18:35:15.000000000 +0300
@@ -208,6 +208,10 @@ void put_pid(struct pid *pid)
 	ns = pid->numbers[pid->level].ns;
 	if ((atomic_read(&pid->count) == 1) ||
 	     atomic_dec_and_test(&pid->count)) {
+		int type = PIDTYPE_MAX;
+		while (--type >= 0)
+			if (WARN_ON(!hlist_empty(&pid->tasks[type])))
+				return;
 		kmem_cache_free(ns->pid_cachep, pid);
 		put_pid_ns(ns);
 	}


