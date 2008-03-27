Return-Path: <linux-kernel-owner+w=401wt.eu-S1758892AbYC0JTB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758892AbYC0JTB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 05:19:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751023AbYC0JSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 05:18:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55960 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758555AbYC0JSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 05:18:48 -0400
Date: Thu, 27 Mar 2008 02:18:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: netdev@vger.kernel.org, bugme-daemon@bugzilla.kernel.org, marcus@better.se,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Bugme-new] [Bug 10326] New: inconsistent lock state in
 net_rx_action
Message-Id: <20080327021812.601776b8.akpm@linux-foundation.org>
In-Reply-To: <20080327085542.GA2778@ami.dom.local>
References: <bug-10326-10286@http.bugzilla.kernel.org/>
	<20080325134320.21525479.akpm@linux-foundation.org>
	<47EAD8A5.3070806@gmail.com>
	<20080326171403.ad186037.akpm@linux-foundation.org>
	<20080327085542.GA2778@ami.dom.local>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Mar 2008 09:55:42 +0100 Jarek Poplawski <jarkao2@gmail.com> wrote:

> On Wed, Mar 26, 2008 at 05:14:03PM -0700, Andrew Morton wrote:
> ...
> > > >> http://bugzilla.kernel.org/show_bug.cgi?id=10326
> ...
> > No, it's not an irq_disable() thing, directly.
> > 
> > What lockdep is saying is that sky2_poll() is taking napi->poll_lock for
> > writing with softirqs enabled, but net_rx_action() takes the same lock from
> > within softirq context.
> > 
> > If sky2_poll() always takes napi->poll_lock under local_irq_disable() then
> > that would be a lockdep bug.
> 
> sky2_poll() doesn't take napi->poll_lock; this lock is taken by
> netpoll_poll() before calling sky2_poll(). And before this hardirqs
> are disabled in write_msg(). So, theoretically lockdep could be right
> if sky2_poll() would enable irqs after this. (If it were done in
> netpoll - lockdep should warn before or after sky2_poll() call.)
> But I really can't see any such possibility in sky2_poll().

I can't spot it from a five-minute read either.  gcc's autoinlining really
makes this sort of thing much harder than it used to be :(

Anyway, the accusation is that lockdep is busted, in that it doesn't realise that
local_irq_disable() blocks softirqs.

I bet the net code is wrong and we missed it ;)
