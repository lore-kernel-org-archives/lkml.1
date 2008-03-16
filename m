Return-Path: <linux-kernel-owner+w=401wt.eu-S1752962AbYCPXEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962AbYCPXEr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 19:04:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752818AbYCPXEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 19:04:39 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:45330 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752817AbYCPXEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 19:04:39 -0400
Date: Mon, 17 Mar 2008 02:03:46 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Laurent Riffard <laurent.riffard@free.fr>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] don't panic if /sbin/init exits or killed
Message-ID: <20080316230346.GA379@tv-sign.ru>
References: <20080316155453.GA20845@tv-sign.ru> <20080316221938.D217026F995@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080316221938.D217026F995@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16, Roland McGrath wrote:
>

(re-ordered)

> Have you tested how recoverable it really is?  I wonder what happens
> with init having exited when things get reparented to it.  Don't the
> zombies just pile up?

Yes sure, we leak the re-parented zombies, and nobody can take care of
/etc/inittab. As expected.

But otherwise the system runs fine.

> BUG() does not seem right to me.  This does not diagnose any kernel bug.
> The kernel source location and backtrace are not useful.  In fact, they
> are likely to mislead the user into reporting the bug to the wrong place
> (because it will look like a kernel bug).

But panic() isn't better? It doesn't provide any useful info.

> I gather your motivation is to get something "recoverable" rather than
> always rebooting.  This might be useful for developers like you and me.
> I suspect that conservative administrators of production systems prefer
> the current behavior.  If the boot init dies, that is reasonably likely
> to be a "catastrophic" failure of the system as a whole as far as the
> proprietor of a production system is concerned.  That is, the system may
> no longer behave as expected in ways essential for its normal operation.
> If it sticks around in that condition, appearing to be available but not
> doing everything it should, that is usually worse than a quick and
> orderly crash (which the installation's procedures and monitoring
> infrastructure are often prepared to handle).

Well, I think the generic "if we have a chance to survive, we should try
to survive" rule is good.

If the boot init dies, at least the admin has a chance to figure out what
has happened, and -o remount,ro /.

Every BUG/BUG_ON in fact means the system is not useable, but still it does
not panic(), but tries to proceed.

In short, I can't see why panic() is better. Except we have panic_timeout,
but we can take it into account if init exits.

> panic is a bit extreme for the situation, where we have no reason yet to
> think kernel data structures are inconsistent.  A sync+reboot or sync+crash
> without bust_spinlocks et al might be better.
> 
> For letting init die and calling it recoverable for hacking purposes, a
> sysctl to disable the panic/crash makes sense.  But I don't think we
> should change the default setting.

OK, I won't argue (not that I agree ;).

Oleg.

