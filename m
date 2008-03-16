Return-Path: <linux-kernel-owner+w=401wt.eu-S1753977AbYCPWU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977AbYCPWU3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 18:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752622AbYCPWUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 18:20:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58638 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752546AbYCPWUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 18:20:21 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Laurent Riffard <laurent.riffard@free.fr>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] don't panic if /sbin/init exits or killed
In-Reply-To: Oleg Nesterov's message of  Sunday, 16 March 2008 18:54:53 +0300 <20080316155453.GA20845@tv-sign.ru>
References: <20080316155453.GA20845@tv-sign.ru>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20080316221938.D217026F995@magilla.localdomain>
Date: Sun, 16 Mar 2008 15:19:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BUG() does not seem right to me.  This does not diagnose any kernel bug.
The kernel source location and backtrace are not useful.  In fact, they
are likely to mislead the user into reporting the bug to the wrong place
(because it will look like a kernel bug).

I gather your motivation is to get something "recoverable" rather than
always rebooting.  This might be useful for developers like you and me.
I suspect that conservative administrators of production systems prefer
the current behavior.  If the boot init dies, that is reasonably likely
to be a "catastrophic" failure of the system as a whole as far as the
proprietor of a production system is concerned.  That is, the system may
no longer behave as expected in ways essential for its normal operation.
If it sticks around in that condition, appearing to be available but not
doing everything it should, that is usually worse than a quick and
orderly crash (which the installation's procedures and monitoring
infrastructure are often prepared to handle).

panic is a bit extreme for the situation, where we have no reason yet to
think kernel data structures are inconsistent.  A sync+reboot or sync+crash
without bust_spinlocks et al might be better.

For letting init die and calling it recoverable for hacking purposes, a
sysctl to disable the panic/crash makes sense.  But I don't think we
should change the default setting.

Have you tested how recoverable it really is?  I wonder what happens
with init having exited when things get reparented to it.  Don't the
zombies just pile up?


Thanks,
Roland
