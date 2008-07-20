Return-Path: <linux-kernel-owner+w=401wt.eu-S1756537AbYGTCdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537AbYGTCdR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 22:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755103AbYGTCdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 22:33:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34022 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754947AbYGTCdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 22:33:05 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] coredump: exit_mm: clear ->mm first, then play with ->core_state
In-Reply-To: Oleg Nesterov's message of  Wednesday, 16 July 2008 17:53:59 +0400 <20080716135359.GA1219@tv-sign.ru>
References: <20080716135359.GA1219@tv-sign.ru>
Emacs: it's like swatting a fly with a supernova.
Message-Id: <20080720023258.26D2015421D@magilla.localdomain>
Date: Sat, 19 Jul 2008 19:32:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> With the previous changes the sub-threads which participate in coredump do
> not need to have the valid ->mm when the coredump is in progress, now we
> can decouple exit_mm() from coredumping code.

I'm all for separating the code more cleanly.  But I don't think it can
work to change the order of the operations, i.e. it is not really true that
core dumps don't need each thread's ->mm link to be valid.  Is there a
benefit to unlinking the mm before waiting for the core dump to finish?

The issue is that the user_regset calls to get "thread state" might
actually read some user memory.  Those calls use a task_struct pointer and
you don't get to separately tell them the mm_struct describing the thread's
address space.  For example, the sparc64 "general registers" note for core
files includes the register window read from user memory.

So, it's not OK to clear the ->mm before everything examining the thread's
machine state is really done, i.e. core dump and anything else.


Thanks,
Roland
