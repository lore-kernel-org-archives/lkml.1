Return-Path: <linux-kernel-owner+w=401wt.eu-S1761427AbXGCRpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761427AbXGCRpm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 13:45:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756029AbXGCRpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 13:45:33 -0400
Received: from mail.screens.ru ([213.234.233.54]:43550 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757269AbXGCRpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 13:45:32 -0400
Date: Tue, 3 Jul 2007 21:45:03 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Uli Luckas <u.luckas@road.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] PM: Prevent frozen user mode helpers from failing the freezing of tasks (rev. 2)
Message-ID: <20070703174503.GB108@tv-sign.ru>
References: <200706252352.24137.rjw@sisk.pl> <20070625215527.GE2051@elf.ucw.cz> <200706260027.02396.rjw@sisk.pl> <1183440646.10386.66.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1183440646.10386.66.camel@localhost.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03, Benjamin Herrenschmidt wrote:
>
> On Tue, 2007-06-26 at 00:27 +0200, Rafael J. Wysocki wrote:
> > > >     case PM_HIBERNATION_PREPARE:
> > > >     case PM_SUSPEND_PREPARE:
> > > >             usermodehelper_disabled = 1;
> > > > -           return NOTIFY_OK;
> > > > +           smp_mb();
> > > 
> > > usermodehelper_disabled should be atomic variable, too, so we don't
> > > have to play these ugly tricks by hand? This should not be
> > > performance-critical, right?
> > 
> > Well, I think we'd need to add the barriers anyway.
> > 
> > The problem, as far as I understand it, is that the instructions can
> > get
> > reordered if there are no barriers in there.
> 
> That seems dodgy either way to me :-)
> 
> Just use a spinlock.

Actually, spinlock_t is not suitable. Because spin_unlcok() does NOT imply
mb(). The subsequent wait_event_timeout()->atomic_read() may leak into the
critical section.

We can use set_mb(), if we don't want to play with smp_mb() by hand :)

Oleg.

