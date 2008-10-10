Return-Path: <linux-kernel-owner+w=401wt.eu-S1761638AbYJJRzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761638AbYJJRzu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 13:55:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758844AbYJJRzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 13:55:41 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:37537 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757864AbYJJRzk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 13:55:40 -0400
Date: Sat, 11 Oct 2008 02:55:17 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, David Woodhouse <dwmw2@infradead.org>,
       Li Yang <leoli@freescale.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Tejun Heo <tj@kernel.org>, Jeff Garzik <jgarzik@pobox.com>,
       Wang Jian <lark@linux.net.cn>
Subject: Re: [PATCH] pata_of_platform: fix no irq handling
Message-ID: <20081010175516.GD10579@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	David Woodhouse <dwmw2@infradead.org>,
	Li Yang <leoli@freescale.com>, linux-ide@vger.kernel.org,
	linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
	Tejun Heo <tj@kernel.org>, Jeff Garzik <jgarzik@pobox.com>,
	Wang Jian <lark@linux.net.cn>
References: <20081006172653.GA26427@oksana.dev.rtsoft.ru> <48EA77EF.6080502@genesi-usa.com> <20081006213209.GA13072@oksana.dev.rtsoft.ru> <48EABBD3.1010401@kernel.org> <20081007103723.0224671e@lxorguk.ukuu.org.uk> <1223455254.3145.143.camel@macbook.infradead.org> <20081008100025.1c535401@lxorguk.ukuu.org.uk> <Pine.LNX.4.64.0810081159240.24611@vixen.sonytel.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0810081159240.24611@vixen.sonytel.be>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2008 at 11:59:59AM +0200, Geert Uytterhoeven wrote:
> On Wed, 8 Oct 2008, Alan Cox wrote:
> > On Wed, 08 Oct 2008 09:40:54 +0100
> > David Woodhouse <dwmw2@infradead.org> wrote:
> > 
> > > On Tue, 2008-10-07 at 10:37 +0100, Alan Cox wrote:
> > > > Zero means no IRQ. Any platform with bits of code left over exposing IRQ
> > > > 0 is already not supported by lots of driver code including libata.
> > > 
> > > ...and must implement some kind of interrupt remapping crap just to work
> > > around this bogus design decision.
> > 
> > I'll leave you to argue with Linus about that, but since that was the
> > decision back in 2005 (for good C reasons) we can safely rely on it.
> 
> `git grep NO_IRQ include arch/*/include' is still quite enlightening...
> 
In the case of PCI where IRQ is unsigned int, that's certainly bogus. The
problem originates on platforms where a 1:1 mapping between vector and
IRQ exists, where 0 is a valid value. This then needs to be remapped in
to an IRQ cookie that has a non-0 value in order to be assigned to
dev->irq. Despite whether this is bogus or not, there's not much to be
done about it. Those of us with vectored IRQ platforms generally have
enough sources that the use of IRQ-0 doesn't matter, and it's not worth
the headache of setting up the remapping crap.

As an example, on SH, IRQ-0 is mapped to vector 0x200. It is '0' for
symbolic reasons only. It's just as easy to pad out irq_desc and treat it
as an off-by-1 to work around all of code that assumes NO_IRQ == 0. There
is enough code in the kernel today that makes the non-zero IRQ cookie
assumption that platforms that do otherwise are simply broken.
