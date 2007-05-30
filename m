Return-Path: <linux-kernel-owner+w=401wt.eu-S1753202AbXE3MGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202AbXE3MGn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 08:06:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751791AbXE3MGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 08:06:36 -0400
Received: from pollux.ds.pg.gda.pl ([153.19.208.7]:3102 "EHLO
	pollux.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbXE3MGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 08:06:34 -0400
Date: Wed, 30 May 2007 13:06:30 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-mips@linux-mips.org, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH] zs: Move to the serial subsystem
In-Reply-To: <20070530011224.bf36d2df.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64N.0705301136150.27697@blysk.ds.pg.gda.pl>
References: <Pine.LNX.4.64N.0705291258390.14456@blysk.ds.pg.gda.pl>
 <20070530011224.bf36d2df.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew!

 Thanks for the review -- I'll address all the issues below.

> So..  how many people use this, and how do we know when it's been tested
> enough?

 Well, the reality is the current code as in Linus tree is unusable at all 
-- there is no way to build drivers/char/decserial.c whis is the wrapper 
that calls zs_init().  So even a broken driver is probably an improvement 
and it works as a console device for me, so it's not that entirely broken.

 You can actually use the linux-mips.org tree to make the old driver work, 
but given the number of reports about the DECstation I have seen recently 
(none for at least a year or something) the response for a testing request 
may take a long, long time.  If someone complains of the new driver I'll 
take care of investigating the problem.

 One is certain -- at least one person uses it. ;-)

> For starters, let's see what the new checkpatch.pl says:

 Didn't know about this one -- thanks for the point.

> Use #include <linux/bug.h> instead of <asm/bug.h>

 Will fix -- wasn't there in 2.6.18 that I used for testing.

> Use #include <linux/io.h> instead of <asm/io.h>

 Will fix.

> line over 80 characters

 Tricky -- not visible on the terminal, thanks.

> printk() should include KERN_ facility level

 Debugging stuff, not normally build, but could use some annotation for 
purity, indeed.

> Hey, you have volatiles and checkpatch.pl didn't complain.  Andy, a
> reference to Documentation/volatile-considered-harmful.txt would suit.

 Fixed. 

> > +#define RECOVERY_DELAY  udelay(2)
> 
> static inline void recovery_delay(void)
> {
> 	udelay(2);
> }
> 
> ?

 Hmm, maybe...

> > +#define to_zport(uport) container_of(uport, struct zs_port, port)
> 
> This could be a C function too.

 Everybody else seems to use a macro for it.

> > +static u8 zs_init_regs[ZS_NUM_REGS] __initdata = {
> > +	0,				/* write 0 */
> > +	PAR_SPEC,			/* write 1 */
> > +	0,				/* write 2 */
> > +	0,				/* write 3 */
> > +	X16CLK | SB1,			/* write 4 */
> > +	0,				/* write 5 */
> > +	0, 0, 0,			/* write 6, 7, 8 */
> > +	MIE | DLC | NV,			/* write 9 */
> > +	NRZ,				/* write 10 */
> > +	TCBR | RCBR,			/* write 11 */
> > +	0, 0,				/* BRG time constant, write 12 + 13 */
> > +	BRSRC | BRENABL,		/* write 14 */
> > +	0,				/* write 15 */
> > +};
> 
> one could use the [1] = PAR_SPEC, thingy here, but the above seems clear
> enough to me.

 I'd say it would be unnecessary clutter otherwise -- this is not a 
struct!

> This is too large to inline (I suspect) and it has many callsites, and some
> of those callsites are inlined too.
> 
> You'll probably get some nice savings by nuking the lot.

 Yes, probably -- after the fight with the modem lines I forgot to have 
this fixed.  As none of these functions are actually required to be 
inline, I'll just remove the marking entirely and let GCC do its job.

> Make this static?

 Could potentially be called by a debugging module.  Not compiled by 
default anyway.

> > +static inline void zs_spin_lock_cond_irq(spinlock_t* lock, int irq)
> > +{
> > +	if (irq)
> > +		spin_lock_irq(lock);
> > +	else
> > +		spin_lock(lock);
> > +}
> 
> This `irq' thing looks a bit hacky.

 Probably the best solution I could thought of -- I want to relieve the 
system for the duration of the delay, so I want to enable the interrupts 
if possible.  But the callers of this function may be called indirectly 
from outside of the driver with an arbitrary state of the interrupt mask, 
so what else could I do?  At slow bps rates, draining of the transmit 
buffer register may take a looong time.  The chip has a single character 
transmit "FIFO".

> > +	spin_lock_irqsave(&scc->zlock, flags);
> > +	status = read_zsreg(zport, R1);
> > +	spin_unlock_irqrestore(&scc->zlock, flags);
> 
> How come this read_zsreg() needs the lock

 Well, because it is not atomic?  A read of any register but the R0 
consists of a write of the index to the control register and then a read 
of same which retrieves data from the indexed register.  If another 
operation is performed on the control register inbetween, then not only 
the wrong register will be read, but also some internal state will be 
corrupted as the subsequent write to the the control register after the 
first one will actually write the value to the register indexed previously 
rather than selecting a new value of the index.

 And please be kind enough not to curse the design of this chip -- it's 
over 25 years old!  It's a follow-on to the SIO, a member of the family of 
chips surrounding the Z80.

> Actually the callers _do_ seem kinda OK, but please chech that carefully.

 Did already.  All *_raw_* functions assume locking has been done by the 
caller.

> Some of the callers are using spin_lock(zlock) and some others are using
> spin_lock_irq().  Could be deadlocky - please review all of that.

 No need for spin_lock_irq() in the interrupt handler (AFAIK).

> FRM_ERR and PAR_ERR are mutually exclusive, and cannot be set if either
> Rx_SYS or Rx_BRK are set?

 Correct.  FRM_ERR overrules PAR_ERR, because it means the reception was 
completely garbled and as such there was nothing to parity-protect in the 
first place (or, IOW, PAR_ERR == random()).

 The Rx_SYS or Rx_BRK bits are merely software flags -- the chip leaves a 
single null character in its receive buffer with no special conditions by 
definition once the BREAK condition has been removed.  It's a dummy 
reception -- nothing has actually been received, so nothing could have 
been corrupted (OK, I suppose this is just a side effect of how the 
receiver works -- BREAK drives the receive line low and this state is 
being shifted through the receive register for the duration of the 
condition; note that for the purpose of detecting the condition BREAK is 
defined as a null character with a framing error).  The driver records a 
BREAK condition seen (this chip signals it as a status change, not a 
receive condition) and later on when a null character is "received", it is 
discarded according to the chip spec.

> > +static int zs_startup(struct uart_port *uport)
> > +{
> > +	struct zs_port *zport = to_zport(uport);
> > +	struct zs_scc *scc = zport->scc;
> > +	unsigned long flags;
> > +	int ret;
> > +
> > +	if (!scc->irq_guard) {
> > +		ret = request_irq(zport->port.irq, zs_interrupt,
> > +				  IRQF_SHARED, "scc", scc);
> > +		if (ret) {
> > +			printk(KERN_ERR "zs: can't get irq %d\n",
> > +			       zport->port.irq);
> > +			return ret;
> > +		}
> > +	}
> > +	scc->irq_guard++;
> 
> The ->irq_guard handling looks a little racy?
> 
> Perhaps higher-level locks prevent this.  If so, a comment explaining this
> would be reassuring.

 The serial API says this function is called with port_sem taken -- I can 
certainly paste the comment here too.

> > +static void zs_shutdown(struct uart_port *uport)
> > +{
> > +	struct zs_port *zport = to_zport(uport);
> > +	struct zs_scc *scc = zport->scc;
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&scc->zlock, flags);
> > +
> > +	zport->regs[5] &= ~TxENAB;
> > +	zport->regs[3] &= ~RxENABLE;
> > +	write_zsreg(zport, R5, zport->regs[5]);
> > +	write_zsreg(zport, R3, zport->regs[3]);
> > +
> > +	spin_unlock_irqrestore(&scc->zlock, flags);
> > +
> > +	scc->irq_guard--;
> 
> Ditto.

 Ditto. :-)

> > +static void zs_reset(struct zs_port *zport)
> > +{
> > +	struct zs_scc *scc = zport->scc;
> > +	int irq;
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&scc->zlock, flags);
> > +	irq = !irqs_disabled_flags(flags);
> 
> hacky?

 See the comment above -- any ideas?

> > +	switch (zport->clk_mode) {
> > +	case 64:
> > +		zport->regs[4] |= X64CLK;
> > +		break;
> > +	case 32:
> > +		zport->regs[4] |= X32CLK;
> > +		break;
> > +	case 16:
> > +		zport->regs[4] |= X16CLK;
> > +		break;
> > +	case 1:
> > +		zport->regs[4] |= X1CLK;
> > +		break;
> > +	default:
> > +		BUG();
> > +	}
> 
> afacit clk_mode = 16 is the only value possible in this driver.

 I doesn't hurt to handle all the cases.  Perhaps I'll add an ioctl() to 
handle changing of clk_mode for `setserial' or suchalike.  Note that X1CLK 
is isochronous mode. ;-)

> > +static struct uart_driver zs_reg;
> > +static struct console zs_sercons = {
> > +	.name	= "ttyS",
> > +	.write	= zs_console_write,
> > +	.device	= uart_console_device,
> > +	.setup	= zs_console_setup,
> > +	.flags	= CON_PRINTBUFFER,
> 
> You might want to set CON_BOOT here.  See the recently-merged
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc7/2.6.21-rc7-mm2/broken-out/fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch

 Done.  Thanks for the point (now I recall seeing the patch, but I have 
obviously already forgotten about it).

> I think there was some great controversy recently concerning the naming of
> the device which the z8530 driver drives.  Perhaps you're not affected
> here.  It was dwmw2 vs Stephen Rothwell ;)

 Hmm, it sounds intriguing, but Google doesn't seem to be able to find 
anything relevant for me -- any pointers?

 Now the real fun with this thing will happen if I ever get to supporting 
synchronous operation as well -- these chips are certainly capable of (in 
addition to that isochronous thingy mentioned above) and they indeed are 
wired correctly for this to work, which generally means TxC and RxC lines 
are on the respective connectors. ;-)

 I can see you have applied the patch regardless, so I'll send you just a 
diff with updates shortly -- once I have tested the changes with a piece 
of hardware.

  Maciej
