Return-Path: <linux-kernel-owner+w=401wt.eu-S1757259AbZJLPiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259AbZJLPiV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 11:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756809AbZJLPiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 11:38:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40719 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756780AbZJLPiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 11:38:20 -0400
Date: Mon, 12 Oct 2009 08:36:38 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Simon Kagstrom <simon.kagstrom@netinsight.net>
cc: Ingo Molnar <mingo@elte.hu>, Artem Bityutskiy <dedekind1@gmail.com>,
       David Woodhouse <dwmw2@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Koskinen Aaro (Nokia-D/Helsinki)" <aaro.koskinen@nokia.com>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] panic.c: export panic_on_oops
In-Reply-To: <20091012153937.0dcd73e5@marrow.netinsight.se>
Message-ID: <alpine.LFD.2.01.0910120828390.3438@localhost.localdomain>
References: <1255241458-11665-1-git-send-email-dedekind1@gmail.com> <20091012111545.GB8857@elte.hu> <1255346731.9659.31.camel@localhost> <20091012113758.GB11035@elte.hu> <20091012140149.6789efab@marrow.netinsight.se> <20091012120951.GA16799@elte.hu>
 <1255349748.10605.13.camel@macbook.infradead.org> <20091012122023.GA19365@elte.hu> <20091012150650.51a4b4dc@marrow.netinsight.se> <20091012131528.GC25464@elte.hu> <20091012153937.0dcd73e5@marrow.netinsight.se>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 12 Oct 2009, Simon Kagstrom wrote:
> 
> Well, this is what my patch [1] aims to fix. What it does is to put all
> messages in a circular buffer, and when an oops or panic occurs it
> writes them out.

Umm. That's wrong. We already _have_ the circular buffer.

It's called 'log_buf'.

I agree with the "save kernel buffer on panic" thing, but I disagree with 
making it anything new, and hooking into "printk()" or the console 
subsystem AT ALL. That's just bogus, stupid, and WRONG.

What you can do is to just flush the 'log_buf' buffer (or as much of it as 
you want - the buffer may be a megabyte in size, and maybe you only want 
to flush the last 8kB or something like that) on oops. And _not_ mix this 
up with anything else. It's a really simple circular buffer, which just 
has

 - log_buf: buffer start
 - log_end: number of characters ever seen
 - log_buf_len: size of buffer (guaranteed to be a power-of-2)

so it's literally as easy as looking at those three values (there's a few 
more that you _can_ look at, but they'd not likely be relevant for a 
"panic_on_oops" thing)

> The current version only collects messages _during_ an
> oops. I'll rework it with using kfifo as per Alans suggestion though.

Don't. kfifo's aren't going to help. You're doing this at all the wrong 
levels ENTIRELY, and we already have the buffer you want to flush.

			Linus
