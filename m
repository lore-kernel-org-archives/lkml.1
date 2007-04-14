Return-Path: <linux-kernel-owner+w=401wt.eu-S1754233AbXDNRRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233AbXDNRRd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 13:17:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754231AbXDNRRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 13:17:33 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:33900 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754214AbXDNRRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 13:17:33 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Ingo Molnar <mingo@elte.hu>
Cc: Willy Tarreau <w@1wt.eu>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Jiri Slaby <jirislaby@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
References: <20070413202100.GA9957@elte.hu>
	<20070414020424.GB14544@wotan.suse.de>
	<20070414063254.GB14875@elte.hu> <20070414064334.GA19463@elte.hu>
	<20070414080833.GL943@1wt.eu> <20070414083625.GM943@1wt.eu>
	<20070414105338.GB19454@elte.hu> <20070414130101.GA2538@1wt.eu>
	<20070414132732.GA22103@1wt.eu> <20070414161927.GD3099@elte.hu>
Date: Sat, 14 Apr 2007 11:15:16 -0600
In-Reply-To: <20070414161927.GD3099@elte.hu> (Ingo Molnar's message of "Sat,
	14 Apr 2007 18:19:27 +0200")
Message-ID: <m1abxanahn.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> * Willy Tarreau <w@1wt.eu> wrote:
>
>> On Sat, Apr 14, 2007 at 03:01:01PM +0200, Willy Tarreau wrote:
>> > 
>> > Well, I'll stop heating the room for now as I get out of ideas about how
>> > to defeat it.
>> 
>> Ah, I found something nasty.
>> If I start large batches of processes like this :
>> 
>> $ for i in $(seq 1 1000); do ./scheddos2 4000 4000 & done
>> 
>> the ramp up slows down after 700-800 processes, but something very 
>> strange happens. If I'm under X, I can switch the focus to all xterms 
>> (the WM is still alive) but all xterms are frozen. On the console, 
>> after one moment I simply cannot switch to another VT anymore while I 
>> can still start commands locally. But "chvt 2" simply blocks. SysRq-K 
>> killed everything and restored full control. Dmesg shows lots of :
>
>> SAK: killed process xxxx (scheddos2): process_session(p)==tty->session.

This.  Yes. SAK is noisy and tells you everything it kills.

>> I wonder if part of the problem would be too many processes bound to 
>> the same tty :-/
>
> hm, that's really weird. I've Cc:-ed the tty experts (Erik, Jiri, Alan), 
> maybe this description rings a bell with them?

Is there any swapping going on?

I'm inclined to suspect that it is a problem that has more to do with the
number of processes and has nothing to do with ttys.

Anyway you can easily rule out ttys by having your startup program
detach from a controlling tty before you start everything.

I'm more inclined to guess something is reading /proc a lot, or doing
something that holds the tasklist lock, a lot or something like that,
if the problem isn't that you are being kicked into swap.

Eric


