Return-Path: <linux-kernel-owner+w=401wt.eu-S932669AbZJLPqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932669AbZJLPqt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 11:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932653AbZJLPqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 11:46:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38369 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932637AbZJLPqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 11:46:47 -0400
Date: Mon, 12 Oct 2009 08:44:30 -0700 (PDT)
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
In-Reply-To: <alpine.LFD.2.01.0910120828390.3438@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0910120837030.3438@localhost.localdomain>
References: <1255241458-11665-1-git-send-email-dedekind1@gmail.com> <20091012111545.GB8857@elte.hu> <1255346731.9659.31.camel@localhost> <20091012113758.GB11035@elte.hu> <20091012140149.6789efab@marrow.netinsight.se> <20091012120951.GA16799@elte.hu>
 <1255349748.10605.13.camel@macbook.infradead.org> <20091012122023.GA19365@elte.hu> <20091012150650.51a4b4dc@marrow.netinsight.se> <20091012131528.GC25464@elte.hu> <20091012153937.0dcd73e5@marrow.netinsight.se>
 <alpine.LFD.2.01.0910120828390.3438@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 12 Oct 2009, Linus Torvalds wrote:
> 
> Don't. kfifo's aren't going to help. You're doing this at all the wrong 
> levels ENTIRELY, and we already have the buffer you want to flush.

Btw, a few simple rules:

 - if you need to make your device look like a "console device" for 
   dumping at oops time, you're doing things wrong. You don't want line 
   buffered output to begin with, and you don't want to see each line, you 
   only want this at exceptional points.

 - if you need to look at "in_interrupt()" or "panic_on_oops", you're 
   doing things wrong.

 - if you add your own buffers, you're doing things wrong. I have 
   CONFIG_LOG_BUF_SHIFT=18 in my kernel, so I've already got 256kB worth 
   of memory allocated for kernel messages. Sometimes I increase that 
   further, just because I do some silly printk debugging.

IOW, just add a very simple "flush the dmesg buffer on oops" callback to 
the end of the oops printout code (just a single call after the oops thing 
is now known to be in the dmesg buffers!)

It's not just oopses, btw. Maybe people would like to do this as the last 
stage of a reboot/shutdown too. Because some of the final printouts from 
the shutdown will never make it to disk, because 'ksyslogd' has been 
killed, and the root filesystem has been turned read-only.

			Linus
