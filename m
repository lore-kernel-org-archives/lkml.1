Return-Path: <linux-kernel-owner+w=401wt.eu-S1757301AbZFDLVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757301AbZFDLVQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 07:21:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751710AbZFDLVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 07:21:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47636 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753580AbZFDLVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 07:21:04 -0400
Date: Thu, 4 Jun 2009 04:20:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Florian Fainelli <florian@openwrt.org>
Cc: linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 2/9] add support for the TI VLYNQ bus
Message-Id: <20090604042032.51ece7a9.akpm@linux-foundation.org>
In-Reply-To: <200906041252.19613.florian@openwrt.org>
References: <200906011358.28359.florian@openwrt.org>
	<20090601220854.a9ddd5ce.akpm@linux-foundation.org>
	<200906041252.19613.florian@openwrt.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Jun 2009 12:52:18 +0200 Florian Fainelli <florian@openwrt.org> wrote:

> Le Tuesday 02 June 2009 07:08:54 Andrew Morton, vous avez __crit__:
> > On Mon, 1 Jun 2009 13:58:27 +0200 Florian Fainelli <florian@openwrt.org> 
> wrote:
> > > This patch adds support for the TI VLYNQ high-speed,
> > > serial and packetized bus. This bus allows external
> > > devices to be connected to the System-on-Chip and
> > > appear in the main system memory just like any memory
> > > mapped peripheral. It is widely used in TI's networking
> > > and mutlimedia SoC, including the AR7 SoC.
> > >
> > >
> > > ...
> > >
> > > +struct vlynq_regs {
> > > +	u32 revision;
> > > +	u32 control;
> > > +	u32 status;
> > > +	u32 int_prio;
> > > +	u32 int_status;
> > > +	u32 int_pending;
> > > +	u32 int_ptr;
> > > +	u32 tx_offset;
> > > +	struct vlynq_mapping rx_mapping[4];
> > > +	u32 chip;
> > > +	u32 autonego;
> > > +	u32 unused[6];
> > > +	u32 int_device[8];
> > > +};
> > > +
> > > +#define vlynq_reg_read(reg) readl(&(reg))
> > > +#define vlynq_reg_write(reg, val)  writel(val, &(reg))
> >
> > grumble.  These just make the code harder to follow.  it'd be better to
> > open-code readl() and writel() at the callsites.
> 
> I do not understand how to fix this. Would an inlined accessors be a better 
> solution for you?

Just remove the accessors altogether.  Each place where there is a call
to vlynq_reg_read(), replace that with a call to readl().

Unless there's a reason not to do this.  For example, some hardware
might require a udelay(1) before each writel(), or some platforms might
want to use outl()/inl().  In cases like these, sure, standalone
functions are needed to handle them.

But if vlynq_reg_read() and vlynq_reg_write() will never do anything
apart from a bare readl()/writel() then let's just remove them
altogether, as they add nothing.

