Return-Path: <linux-kernel-owner+w=401wt.eu-S937269AbXFHBCC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937269AbXFHBCC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 21:02:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936385AbXFHBBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 21:01:41 -0400
Received: from waste.org ([66.93.16.53]:38588 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936840AbXFHBBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 21:01:40 -0400
Date: Thu, 7 Jun 2007 19:59:32 -0500
From: Matt Mackall <mpm@selenic.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
Message-ID: <20070608005931.GZ11166@waste.org>
References: <send-serie.davidel@xmailserver.org.4625.1181169040.7> <20070606235906.72439d16@the-village.bc.nu> <alpine.LFD.0.98.0706071240150.4205@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0706071240150.4205@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2007 at 01:10:23PM -0700, Linus Torvalds wrote:
> What do people think about that kind of approach? It has the advantage 
> that it does *not* involve multiple kernel entries (just a single entry to 
> a small wrapper that sets some process state temporarily), and that it 
> doesn't have any sticky state that might confuse a library (or a signal 
> handler: even if you end up doing "prctrl(ON) ; syscall(); prctrl(OFF)", a 
> signal handler that happens in between the prctrl's would see unexpected 
> behaviour).

First, how does this work in-kernel? Does it set a flag in the thread
struct that magically gets used in the actual syscall? Or do we pass
flags down to the sys_foo() function in some manner?

If the former, there is potential for interaction with asynchronous
code running on behalf of the thread, no? Especially if we ever adopt
one of the syslet schemes.

Second, I think we're likely to run out of flag bits really quickly as
this is a good dumping spot for patching up our many slightly
brain-damaged APIs (be they POSIX or Linux-specific).

Third, can I do sys_indirect(sys_indirect(foo, args), flags1),
flags2)?

Fourth, can we do sys_indirect(foo, args, flags | ASYNC) and get most
of the way to merging this with the syslet proposal?

-- 
Mathematics is the supreme nostalgia of our time.
