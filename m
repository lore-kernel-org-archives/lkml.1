Return-Path: <linux-kernel-owner+w=401wt.eu-S1756531AbZJLMeK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531AbZJLMeK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 08:34:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756366AbZJLMeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 08:34:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:34891 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755774AbZJLMeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 08:34:08 -0400
Subject: Re: [PATCH] panic.c: export panic_on_oops
From: David Woodhouse <dwmw2@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Simon Kagstrom <simon.kagstrom@netinsight.net>,
       Artem Bityutskiy <dedekind1@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Koskinen Aaro (Nokia-D/Helsinki)" <aaro.koskinen@nokia.com>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20091012122023.GA19365@elte.hu>
References: <1255241458-11665-1-git-send-email-dedekind1@gmail.com>
	 <20091012111545.GB8857@elte.hu> <1255346731.9659.31.camel@localhost>
	 <20091012113758.GB11035@elte.hu>
	 <20091012140149.6789efab@marrow.netinsight.se>
	 <20091012120951.GA16799@elte.hu>
	 <1255349748.10605.13.camel@macbook.infradead.org>
	 <20091012122023.GA19365@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Oct 2009 13:33:18 +0100
Message-Id: <1255350798.10605.19.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-12 at 14:20 +0200, Ingo Molnar wrote:
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
> 
> And that would avoid the whole workqueue logic - which is fragile to be 
> done in a printk to begin with.
> 
> So what we need is an extension to struct console that sets a buffering 
> limit. Zero (the default) means unbuffered.
> 
> (Btw., things like netconsole might make use of such buffering too.)
> 
> Agreed?

Makes some sense, yes.

We also use the workqueue logic to allow us to co-ordinate access to the
hardware properly -- taking locks where appropriate, etc. We can't do
that directly from a console ->write() method.

Some device drivers do provide a ->panic_write() function which breaks
all the locks and just resets the hardware because it knows we're
panicking, but we don't want to do that in the common case.

-- 
dwmw2

