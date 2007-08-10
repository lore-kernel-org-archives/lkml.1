Return-Path: <linux-kernel-owner+w=401wt.eu-S1763545AbXHJHzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763545AbXHJHzx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 03:55:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758644AbXHJHzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 03:55:38 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48040 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754182AbXHJHzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 03:55:37 -0400
Date: Fri, 10 Aug 2007 00:55:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mariusz Kozlowski <m.kozlowski@tuxland.pl>, josh@freedesktop.org,
       linux-kernel@vger.kernel.org, "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: 2.6.23-rc2-mm1: sleeping function called from invalid context
 at kernel/mutex.c:86
Message-Id: <20070810005517.5c336be1.akpm@linux-foundation.org>
In-Reply-To: <20070810074000.GA28264@elte.hu>
References: <20070809015106.cd0bfc53.akpm@linux-foundation.org>
	<200708100123.07762.m.kozlowski@tuxland.pl>
	<20070809171128.03f40dff.akpm@linux-foundation.org>
	<20070810074000.GA28264@elte.hu>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Aug 2007 09:40:00 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > We seem to have made a mess in there.  timer_list_show() ends up 
> > calling lookup_module_symbol_name(), which takes a mutex.  However 
> > print_symbol() (which is called at oops time, interrupt time, etc) 
> > calls module_address_lookup(), which is basically the same, only it 
> > doesn't take the mutex.
> 
> hm, current upstream does:
> 
>  static void print_name_offset(struct seq_file *m, void *sym)
>  {
>          char symname[KSYM_NAME_LEN];
> 
>          if (lookup_symbol_name((unsigned long)sym, symname) < 0)
> 
> why was that changed?

It wasn't.  lookup_symbol_name() calls lookup_module_symbol_name() which
calls mutex_lock().

> I think symbol lookups for debug purposes have to 
> be lockless, fundamentally.
> 

Sure, especially a sysrq thingy.

It's a bit nasty to just go in there and start walking data structures
without holding the needed lock though.

