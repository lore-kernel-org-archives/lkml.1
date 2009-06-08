Return-Path: <linux-kernel-owner+w=401wt.eu-S1754010AbZFHRjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010AbZFHRjx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 13:39:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751565AbZFHRjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 13:39:46 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44426 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753217AbZFHRjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 13:39:45 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Q: PTRACE_ATTACH && -EINTR
In-Reply-To: Oleg Nesterov's message of  Monday, 8 June 2009 18:12:04 +0200 <20090608161204.GA3986@redhat.com>
References: <20090608161204.GA3986@redhat.com>
X-Windows: a mistake carried out to perfection.
Message-Id: <20090608173944.B57EBFC3C6@magilla.sf.frob.com>
Date: Mon,  8 Jun 2009 10:39:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Or even -ERESTARTNOINTR ? Or just mutex_lock() ?

-ERESTARTNOINTR is right.  

There is nothing wrong with making it interruptible, and that might help
something or other overall, or even be important to avoid a deadlock or
something in some strange situation.  But since the call could never return
-EINTR before, we can't make it start now.

> Or ignore this problem since nobody complained?

There has barely been time for anyone to do something strange enough to hit
it, and they would probably not have realized what was going on even if it
did hit.  We know we broke the ABI contract, we have to fix it.

Note that every use of mutex_lock_interruptible and also down_interruptible
can return -EINTR.  This means these really should never be used in the way
where their return value is returned directly from some system call.  Every
user-visible call that gets interrupted needs to return some -ERESTART*
code and never -EINTR directly.


Thanks,
Roland
