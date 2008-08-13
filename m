Return-Path: <linux-kernel-owner+w=401wt.eu-S1754979AbYHMBWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979AbYHMBWn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 21:22:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753609AbYHMBWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 21:22:35 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56303
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753465AbYHMBWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 21:22:34 -0400
Date: Tue, 12 Aug 2008 18:22:35 -0700 (PDT)
Message-Id: <20080812.182235.153778437.davem@davemloft.net>
To: mpatocka@redhat.com
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: console handover badness
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0808122053280.31704@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0806211542050.21474@engineering.redhat.com>
	<20080811.233013.49328708.davem@davemloft.net>
	<Pine.LNX.4.64.0808122053280.31704@hs20-bc2-1.build.redhat.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>
Date: Tue, 12 Aug 2008 21:11:53 -0400 (EDT)

> 
> 
> On Mon, 11 Aug 2008, David Miller wrote:
> 
> > From: Mikulas Patocka <mpatocka@redhat.com>
> > Date: Sat, 21 Jun 2008 15:42:56 -0400 (EDT)
> > 
> > > On Fri, 20 Jun 2008, David Miller wrote:
> > > 
> > > > giving a try.
> > > >
> > > > sparc64: Implement support for IRQ stacks.
> > > 
> > > For me it doesn't work. Locked up after "console: colour dummy device 
> > > 80x25".
> > 
> > Are you sure you didn't see a "Stack overflow" message on the
> > screen? :-)
> > 
> > That's what I get when I try to boot with your provided
> > kernel config.
> 
> I think no, it just locked-up solid. There is a problem with console 
> handover. See this dmesg that I get on boot.
> 
> Notice the lines:
> (1) console handover: boot [earlyprom0] -> real [tty0]
> and
> (2) Console: switching to colour frame buffer device 128x48
> 
> At line (1), the kernel disables the PROM console. At line (2) it enables 
> framebuffer. Between these lines, the kernel runs with no console at all. 
> Everything that is printk'ed between these lines doesn't go to the screen.

Yes, I know, this is such an incredible pain and it bothers
me a lot as it makes diagnosing bugs that trigger in between
these two points very difficult to diagnose.

The VT layer should not register it's console until an upper level
provider (such as an fbdev driver or the plain VGA console) really has
their driver attached.

> I hit already three crashes that happened between these lines and didn't 
> generate any output: this one with interrupt stacks that you have just 
> fixed,

The interrupt stacks one would show up on the console, because it
uses prom_printf() to use the firmware console directly.

Actually, I bet it got printed, but you didn't see it, because
the framebuffer driver changed the console palette, resulting in
the pixels the PROM console writes being black on the black
background :-/

> CONFIG_LOCKDEP+CONFIG_DEBUG_PAGEALLOC crash that I will send you 
> patch for, and then boot failure of 2.6.27-rc[12] because of bad memory 
> migratetype. Is this migratetype crash a known problem? --- the problem is 
> that starting with 2.6.27rc1, I'm getting crash with this backtrace:
> __list_add
> __free_pages_ok
> __free_pages
> __free_pages_bootmem
> __free_all_bootmem
> mem_init
> start_kernel_tlb_fixup_code
> --- the crash is due to migratetype == 5 in __free_one_page (inlined into 
> __free_pages_ok) and because there are only 5 migratettypes, it attempts 
> to add to a non-existent list.

We have another report of this, thanks for grabbing the extra
information.

> The trace can be obtained if I disable console handover in kernel/printk. 
> But it should really be somehow rewritten so that the kernel can write 
> crashes during boot on console without extra patching --- the PROM console 
> is disabled just before the framebuffer is registered and not too early.

Another way to capture this is to remove the CON_BOOT thing from
the prom console struct in arch/sparc64/kernel/setup.c

I am probably going to make the old "-p" boot command line option do
this dynamically.
