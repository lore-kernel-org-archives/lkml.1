Return-Path: <linux-kernel-owner+w=401wt.eu-S1753939Ab0AZWNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939Ab0AZWNo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 17:13:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751974Ab0AZWNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 17:13:44 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37743 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751392Ab0AZWNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 17:13:43 -0500
Date: Tue, 26 Jan 2010 14:11:28 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       stable-review@kernel.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Al Viro <viro@ZenIV.linux.org.uk>,
       Tavis Ormandy <taviso@google.com>, Jeff Dike <jdike@addtoit.com>,
       Julien Tinnes <jln@google.com>, Matt Mackall <mpm@selenic.com>
Subject: Re: [06/11] tty: fix race in tty_fasync
In-Reply-To: <m1bpggy7bt.fsf@fess.ebiederm.org>
Message-ID: <alpine.LFD.2.00.1001261357390.3574@localhost.localdomain>
References: <20100126191624.538119758@mini.kroah.org> <m1bpggy7bt.fsf@fess.ebiederm.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 26 Jan 2010, Eric W. Biederman wrote:

> Greg KH <gregkh@suse.de> writes:
> 
> > 2.6.27-stable review patch.  If anyone has any objections, please let us know.
> 
> Only that __f_setown by way of f_modown unconditionally enables interrupts.  So
> without touching f_modown as well in mainline we have nasty sounding lockdep warnings.

Hmm. That seems to be true in mainline too, isn't it?

So now we have:
 - tty_fasync() gets tty->ctrl_lock, with spin_lock_irqsave()

 - it then calls __f_setown()

 - which calls f_modown(),

 - which does

	write_lock_irq(&filp->f_owner.lock);
	..
	write_unlock_irq(&filp->f_owner.lock);

   which in turn enables interrupts while we still hold ctrl_lock.

so that whole commit 70362511806 was/is buggy in mainline too. 

The minimal fix is likely to just make f_modown() use 
write_lock_irqsave/restore. Greg?

		Linus
