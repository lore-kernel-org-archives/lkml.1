Return-Path: <linux-kernel-owner+w=401wt.eu-S1756578AbZJLNHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578AbZJLNHo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 09:07:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756563AbZJLNHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 09:07:43 -0400
Received: from ernst.netinsight.se ([194.16.221.21]:41704 "HELO
	ernst.netinsight.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755618AbZJLNHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 09:07:42 -0400
Date: Mon, 12 Oct 2009 15:06:50 +0200
From: Simon Kagstrom <simon.kagstrom@netinsight.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Woodhouse <dwmw2@infradead.org>,
       Artem Bityutskiy <dedekind1@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Koskinen Aaro (Nokia-D/Helsinki)" <aaro.koskinen@nokia.com>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] panic.c: export panic_on_oops
Message-ID: <20091012150650.51a4b4dc@marrow.netinsight.se>
In-Reply-To: <20091012122023.GA19365@elte.hu>
References: <1255241458-11665-1-git-send-email-dedekind1@gmail.com>
	<20091012111545.GB8857@elte.hu>
	<1255346731.9659.31.camel@localhost>
	<20091012113758.GB11035@elte.hu>
	<20091012140149.6789efab@marrow.netinsight.se>
	<20091012120951.GA16799@elte.hu>
	<1255349748.10605.13.camel@macbook.infradead.org>
	<20091012122023.GA19365@elte.hu>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Oct 2009 14:20:23 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> * David Woodhouse <dwmw2@infradead.org> wrote:
> 
> > On Mon, 2009-10-12 at 14:09 +0200, Ingo Molnar wrote:
> > > Also, would it be possible to just simplify the thing and not do any 
> > > buffering at all? Extra buffering complexity in a console driver is only 
> > > asking for trouble. Or is flash storage write cycles optimization that 
> > > important in this case?
> > 
> > That and the fact that on NAND flash you have to write full pages at a 
> > time -- that's 512 bytes, 2KiB or 4KiB depending on the type of chip. 
> > So we really do want to buffer it where we can.
> > 
> > We don't want to write a 2KiB page for every line of printk output.
> 
> Then i think the buffering is at the wrong place: we should instead 
> buffer in the generic layer and pass it to lowlevel if we know that we 
> have gone past a 2K boundary.
>
> The size of the generic log buffer is always a power of two so detecting 
> 2K boundaries is very easy. On any emergency the generic console layer 
> will do faster flushes - this is nothing the console driver itself 
> should bother with.

But this is only part of the mtdoops problem (the reason why we don't
write all the time). The current code only stores messages printed
during an oops, and this behavior will surely change if the console
driver gets large buffers of output - or it would have to take in the
output unbuffered anyway.

My patch changes this behavior, and with that I don't think buffered
output would be a problem - it would indeed make it more simple as you
say - assuming there is something like ->kernel_bug() that would flush
the last 4KiB or so of messages to mtdoops when there is an oops or
panic.

> And that would avoid the whole workqueue logic - which is fragile to be 
> done in a printk to begin with.

I'm afraid I don't really see this issue. The workqueue is used to
write the buffer to the mtd device if we are not in a panic or
interrupt context - in which case we do it directly.

So it's only used when an oops is ongoing.

// Simon
