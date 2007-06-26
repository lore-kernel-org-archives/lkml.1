Return-Path: <linux-kernel-owner+w=401wt.eu-S1758501AbXFZQtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758501AbXFZQtd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 12:49:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757029AbXFZQtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 12:49:24 -0400
Received: from ns2.suse.de ([195.135.220.15]:60493 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756978AbXFZQtX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 12:49:23 -0400
Date: Tue, 26 Jun 2007 18:49:07 +0200
From: Andrea Arcangeli <andrea@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jesper Juhl <jesper.juhl@gmail.com>, Roman Zippel <zippel@linux-m68k.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch, v2.6.22-rc6] sys_time() speedup
Message-ID: <20070626164907.GF7059@v2.random>
References: <20070625200601.GA18980@elte.hu> <200706252309.47467.zippel@linux-m68k.org> <9a8748490706251417v10b3f24bwdf7ebd44093eaddf@mail.gmail.com> <Pine.LNX.4.64.0706252356400.1817@scrub.home> <9a8748490706251520g24ff7a9dk716d73e7dbfd9ec3@mail.gmail.com> <20070626161857.GA7178@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070626161857.GA7178@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2007 at 06:18:57PM +0200, Ingo Molnar wrote:
> My patch improves MySQL wall-clock performance by ~10% on a dual-core 
> box [see the numbers i cited in my initial mail, they were ran on a T60 
> with a 1.83 GHz Core2Duo] and by 7% on an 8-way box:

mysql isn't froznen in stone like some commercial db, you can look into its
source, the testsuite isn't either I guess. Did you ask yourself at
least once why it's calling time() so many times per second? The
timestamp sql type should always trigger gettimeofday calls AFIK.

If there's a good reason to call time so frequently in an important
app like mysql, then your patch sure is a good idea, but at first
glance it looks fishy that time is so performance critical.

I'm not objecting the patch itself, if there's a legitimate reason to
call time so frequently that's sure a fine optimization despite the
branch in gettimeofday, but I'm asking why time is called so many
times on this specific workload, because I'm fairly certain that in
average (desktop and server) gettimeofday is called much more
frequently and if it was up to me to tell, I would expect time
microoptimizations to result in irrelevant performance
differences. Infact I seem to recall that even other commercial dbs
calls tends to call floods of gettimeofday while I can't recall any
time in the strace output. So unless there is a legitimate reason to
call time() dozen thousand times per second, if it was my choice, I
would prefer to have gettimeofday as fast as it can be. Not that a
branch will make any measurable difference, but still that would be my
choice.

But perhaps you already know why time is called so frequently, I
certainly don't, nor I would expect it.

Thanks.
