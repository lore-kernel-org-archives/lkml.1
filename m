Return-Path: <linux-kernel-owner+w=401wt.eu-S1756002AbYE0Ahr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002AbYE0Ahr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 20:37:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753328AbYE0Ahj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 20:37:39 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49653 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394AbYE0Ahj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 20:37:39 -0400
Date: Mon, 26 May 2008 17:31:41 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: Linux 2.6.26-rc4
Message-ID: <20080526173141.6fc8966e@infradead.org>
In-Reply-To: <20080526172519.10d944ab@infradead.org>
References: <alpine.LFD.1.10.0805261127030.2958@woody.linux-foundation.org>
	<483B2A9B.4050007@krogh.cc>
	<alpine.LFD.1.10.0805261428140.2958@woody.linux-foundation.org>
	<20080526172519.10d944ab@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 May 2008 17:25:19 -0700
Arjan van de Ven <arjan@infradead.org> wrote:

> On Mon, 26 May 2008 14:42:37 -0700 (PDT)
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > 
> > 
> > On Mon, 26 May 2008, Jesper Krogh wrote:
> > > 
> > > I did get this one (which I didn't on 2.6.25.2)
> > > 
> > > [42949399.810959] ck804xrom ck804xrom_init_one(): Unable to
> > > register resource 0x0000000000000000-0x00000000ffffffff - kernel
> > > bug?
> > 
> > Something is trying to register a 4GB resource. That sounds
> > unlikely (possible on a 64-bit PCI setup, but I think it's more
> > likely to be some overflow of 0 in "unsigned int").
> > 
> > In fact, this seems to be due to some driver bug. It looks like we
> > have
> > 
> > 	window->size = 0xffffffffUL - window->phys + 1UL;
> > 
> > and in order for window->size to be 0x100000000, that means that 
> > window->phys has to be 0. Which looks impossible, or at least like 
> > ent->driver_data is neither DEV_CK804 nor DEV_MCP55. Very odd.
> > 
> > The warning:
> > 
> > > [42949399.979924] WARNING: at arch/x86/mm/ioremap.c:159
> > > __ioremap_caller+0x299/0x330()
> > 
> > is then just a result of the driver blindly continuing and trying
> > to "ioremap()" the resource even though it's bogus and the resource 
> > allocation failed.
> > 
> > In other words, that driver init routine is really bad about error 
> > handling. Carl-Daniel? David?
> > 
> 
> btw this guy has shown up on kerneloops.org a lot: 
> http://www.kerneloops.org/searchweek.php?search=__ioremap_caller
> where it's trying to map memory as uncachable, which is.. well nasty
> (it seems to map not just the piece it needs, but more, and then turns
> that "more" uncachable, even if the kernel is using it for "normal"
> things)

one thing to note: it only shows up on 64 bit kernels somehow...
interesting.



-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
