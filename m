Return-Path: <linux-kernel-owner+w=401wt.eu-S1758222AbXHKHYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758222AbXHKHYj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 03:24:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754073AbXHKHY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 03:24:29 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:56291 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830AbXHKHY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 03:24:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=pdQUMOZ/n4/HahSxczonSJv8NTjHBMZbESdjieXvOgGfwmaTsmoB4WMLuX5B4R8H3PQuZT3ql1/wkZxnorYwvIb4bYhqQEpT/knphfaFZSa3oDjkc03qO3JA+L9LGfWpJAEkzIN5yZIU+4c6KhM2l0E6KrUH0t32lGKD4MEdMEA=
Date: Sat, 11 Aug 2007 11:24:22 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       josh@freedesktop.org, linux-kernel@vger.kernel.org,
       "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: 2.6.23-rc2-mm1: sleeping function called from invalid context at kernel/mutex.c:86
Message-ID: <20070811072422.GA5893@martell.zuzino.mipt.ru>
References: <20070809015106.cd0bfc53.akpm@linux-foundation.org> <200708100123.07762.m.kozlowski@tuxland.pl> <20070809171128.03f40dff.akpm@linux-foundation.org> <20070810074000.GA28264@elte.hu> <20070810005517.5c336be1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070810005517.5c336be1.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2007 at 12:55:17AM -0700, Andrew Morton wrote:
> On Fri, 10 Aug 2007 09:40:00 +0200 Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > We seem to have made a mess in there.  timer_list_show() ends up 
> > > calling lookup_module_symbol_name(), which takes a mutex.  However 
> > > print_symbol() (which is called at oops time, interrupt time, etc) 
> > > calls module_address_lookup(), which is basically the same, only it 
> > > doesn't take the mutex.
> > 
> > hm, current upstream does:
> > 
> >  static void print_name_offset(struct seq_file *m, void *sym)
> >  {
> >          char symname[KSYM_NAME_LEN];
> > 
> >          if (lookup_symbol_name((unsigned long)sym, symname) < 0)
> > 
> > why was that changed?
> 
> It wasn't.

Oh no, it was! commit 9d65cb4a1718a072898c7a57a3bc61b2dc4bcd4d

	Fix race between cat /proc/*/wchan and rmmod et al

	kallsyms_lookup() can go iterating over modules list unprotected which is OK
	for emergency situations (oops), but not OK for regular stuff like
	/proc/*/wchan.

> lookup_symbol_name() calls lookup_module_symbol_name() which
> calls mutex_lock().
> 
> > I think symbol lookups for debug purposes have to 
> > be lockless, fundamentally.
> > 
> 
> Sure, especially a sysrq thingy.

I imagine user running powertop which IIRC trolls /proc/timer_list and
doing rmmod following powertop instructions.

> It's a bit nasty to just go in there and start walking data structures
> without holding the needed lock though.

Yep.

