Return-Path: <linux-kernel-owner+w=401wt.eu-S933131AbZJLTUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933131AbZJLTUS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 15:20:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933053AbZJLTUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 15:20:16 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57389 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932787AbZJLTUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 15:20:14 -0400
Subject: Re: [PATCH] panic.c: export panic_on_oops
From: Dirk Hohndel <hohndel@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Simon Kagstrom <simon.kagstrom@netinsight.net>,
       Artem Bityutskiy <dedekind1@gmail.com>,
       David Woodhouse <dwmw2@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Koskinen Aaro (Nokia-D/Helsinki)" <aaro.koskinen@nokia.com>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.01.0910121130190.3438@localhost.localdomain>
References: <20091012113758.GB11035@elte.hu>
	 <20091012140149.6789efab@marrow.netinsight.se>
	 <20091012120951.GA16799@elte.hu>
	 <1255349748.10605.13.camel@macbook.infradead.org>
	 <20091012122023.GA19365@elte.hu>
	 <20091012150650.51a4b4dc@marrow.netinsight.se>
	 <20091012131528.GC25464@elte.hu>
	 <20091012153937.0dcd73e5@marrow.netinsight.se>
	 <alpine.LFD.2.01.0910120828390.3438@localhost.localdomain>
	 <20091012110954.67d7d8d8.akpm@linux-foundation.org>
	 <20091012182346.GH17138@elte.hu>
	 <alpine.LFD.2.01.0910121130190.3438@localhost.localdomain>
Content-Type: text/plain
Organization: Intel Open Source Technology Center
Date: Mon, 12 Oct 2009 12:18:47 -0700
Message-Id: <1255375128.25106.51.camel@dhohndel-mobl.amr.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hohndel@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's what I get for traveling and not reading mail for two days...

On Mon, 2009-10-12 at 11:45 -0700, Linus Torvalds wrote:
> 
> On Mon, 12 Oct 2009, Ingo Molnar wrote:
> > 
> > * Andrew Morton <akpm@linux-foundation.org> wrote:
> > > 
> > > Perhaps oops_enter() is a good place to mark the start of the log, and 
> > > flush it within oops_exit().
> > 
> > Simplest would be to do the last 2K in oops_exit()? That gives the oops, 
> > and the history leading up to it. Since the blocking is 2K, the extra 
> > log output is for free.
> 
> I agree, except I don't think it should be fixed to 2k.
> 
> We should just dump as much as is "appropriate" for the dump device. It 
> might be the last 2kB, it might be 8kB, it might be 64kB. We don't know, 
> we don't care. The device may have its own per-device limits. Any extra 
> data we get from before the oops is just gravy (often there might be 
> interestign warning messages leadign up to the dump), and if the oops is 
> too big for the dump device, it's not something we can do anything about 
> anyway.

I'm working on something different but related - also using the ring
buffer and just getting as much from its tail as I am able to conserve.

The approach in my case is to write a 2D bar code to the screen and have
the user take a picture / submit the picture to kerneloops.org where it
then gets decoded back into the oops message. This is intended for
situations where you don't have access to other storage / network - or
where a picture of the screen is actually the easiest way to get to the
information.

Right now the project is slightly stalled as I am running into an
unexpected project on the decode side, but I'd love to make sure that
the core changes I'm doing integrate cleanly with this project...

> 
> So the logic should literally be something like this:
> 
>  - kernel/printk.c:
> 
> 	void dump_kmsg(void)
> 	{
> 		unsigned long len = ACCESS_ONCE(log_end);
> 		struct dump_device *dump;
> 		const char *s1, *s2;
> 		unsigned long l1, l2;
> 
> 		s1 = "";
> 		l1 = 0;
> 		s2 = log_buf;
> 		l2 = len;
> 
> 		/* Have we rotated around the circular buffer? */
> 		if (len > log_buf_len) {
> 			unsigned long pos = (len & LOG_BUF_MASK);
> 
> 			s1 = log_buf + pos;
> 			l1 = log_buf_len - pos;
> 
> 			s2 = log_buf;
> 			l2 = pos;
> 		}
> 
> 		list_for_each_entry (dump, dump_list, list) {
> 			dump->fn(s1, l1, s2, l2);
> 		}
> 	}
> 
> ie we just always give the whole buffer (as two "sections", since it's a 
> circular buffer) to the dumper, and then the dumper can decide how much of 
> those buffers it is able to dump sanely.

That's pretty close to what I do - only in my case the information then
doesn't get written to a device but instead gets compressed, encoded and
displayed on the framebuffer...

/D

-- 
Dirk Hohndel
Intel Open Source Technology Center

