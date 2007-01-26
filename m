Return-Path: <linux-kernel-owner+w=401wt.eu-S932617AbXAZKqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932617AbXAZKqi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 05:46:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932769AbXAZKqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 05:46:38 -0500
Received: from nic2.axis.se ([193.13.178.10]:38573 "EHLO krynn.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932617AbXAZKqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 05:46:37 -0500
Date: Fri, 26 Jan 2007 11:46:18 +0100
Message-Id: <200701261046.l0QAkIdt032408@ignucius.se.axis.com>
From: Hans-Peter Nilsson <hans-peter.nilsson@axis.com>
To: david-b@pacbell.net
CC: linux-kernel@vger.kernel.org, mikael.starvik@axis.com,
       spi-devel-general@lists.sourceforge.net
In-reply-to: <200701250502.56467.david-b@pacbell.net> (message from David
	Brownell on Thu, 25 Jan 2007 05:02:56 -0800)
Subject: [PATCH 1/2] take 2: (was-kind-of: 3/5 SPI tx_default) 2.6.20-rc6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From: David Brownell <david-b@pacbell.net>
> Date: Thu, 25 Jan 2007 05:02:56 -0800

> On Wednesday 24 January 2007 8:52 pm, Hans-Peter Nilsson wrote:
> > (Please CC me on replies, I'm not subscribed to LKML or the SPI list.  Thanks.)
> > 
> > The SD/MMC SPI-based protocol isn't really duplex.  In the
> > normal case there's either information transmitted or received,
> > not both simultaneously.  The unused data is always 0xff; ones.
> > Unfortunately, the SPI framework leaves outgoing data for a
> > left-out tx_buf just as "undefined"
> 
> In current kernels that's actually changed.  The value to be shifted
> out is now specified ... as all-zeroes, which is what various chips
> need to receive, and various (half-duplex/Microwire) controllers seem
> to be doing in any case.
> 
> If that's an issue -- and MMC-over-SPI needs to specify some other
> value --

Well, it *is* specified as ones (0xff).  Curiously enough, I
can't point to a statement in the "Simplified Physical Layer
Specification 2.0".  It's likely specified in the "7.5 SPI Bus
Timing Diagrams", which is "blank for the Simplified
Specification".  If you look at SanDisk's OEM documents for
"MultiMediaCard"/ "Reduced-Size MultiMediaCard" v1.3, you can
see that *that* document nicely complements the "Simplified
Specification", and specifies it as 0xff (see "5.23 SPI Bus
Timing Diagrams").  FWIW, I found this referenced from somewhere
I-forgot when I STFW'd for SD/MMC SPI documentation or Linux
drivers, so I'm not "ratting them out" for providing
documentation withheld elsewhere. :-} Besides, I think they're
one of those making the rules for the SDcard organization.

...and anyway, I just *had* to try: well, it doesn't work with 0. :-)

> I think a better way to package this would be to define a new
> flag for spi->mode, since controller drivers are already supposed
> to be checking that to make sure they handle all the options which
> have been specified.

But it's unspecified what the controller drivers should do with
flags don't recognize (should they refuse? warn? ignore? - I see
they all ignore) so with that suggestion, we'll have a situation
where drivers wouldn't know about the new flag and would
silently not work.

Perhaps it can be "legislated" or at least strongly suggested
that SPI drivers must return -EINVAL for flags in spi->mode that
they don't recognise?  Typically, for 2.6.19 flags, in their
master-setup method:

  if (spi->mode & ~(SPI_CPHA | SPI_CPOL | SPI_CS_HIGH | SPI_LSB_FIRST))
	return -EINVAL;

(I think I'll do exactly that with the drivers I wrote.)

>  That flag could work in conjunction with
> a byte

Or why not a 32-bit word!  If controllers can only handle non-0
values for bits_per_word <= 8, they can check for that.  (Before
you suggest a 64-bit value, consider that the 64-bit-ness would
supposedly be rarely used and the value is likely to be looked
up in inner loops like for the bitbanged driver.  Ok, there are
ways around that, it's just that I don't think a 64-bit value
would be more useful than the implications.  We can always
change it when a use-case appears.  I guess that implies having
it a u8, but typically the 32 vs 8 bit difference is much less
than 64 vs 32.  Toolshed alert!)

> provided in the spi_device, that would be used instead of
> zero.  (Some folk have noted that when debugging, it's easier if
> the pattern there is neither all-ones nor all-zeroes ... something
> that a digital scope will show is easier to work with.)

FWIW, I defined it as a single bit in that patch, because that's
what my HW can do when the transmitter is disabled - and because
MOSI *is* a single-valued signal. ;-)  Also, I made it
per-transfer, which for mmc_spi wouldn't mean much, only perhaps
to possibly drop all-zero buffers, which of course implied that
someone would have to scan them first anyway (i.e. no fewer
memory accesses), so I guess I had no serious use-case.

Still, making it a u32 (or u8), with spi->bits_per_word
specifying the actual length, makes sense for example to
implementations around a shift-register but with no DMA.  A
controller can return -EINVAL (shouldn't that be -ENOSYS?) if it
finds a default_tx_word it can't support simply enough.  If we
define returning -EINVAL as always ok and that the driver/client
part is responsible for a fallback, I think we have agreement.

While I was looking, I noticed that the memory-layout of
non-8-bit words for SPI is a bit unclear.  The endianness of
data shifted out doesn't really define endianness in memory or
whether 24-bit words bytes are in order {hi, med, low, pad} or
indeed {pad, low, med, hi or whatever combination.  For a LE
architecture, storing data as LE in memory makes sense, and both
with and without padding makes sense too.  Perhaps best to just
document that it's undefined?

> then please re-issue this patch against 2.6.20, including
> the update to the bitbang driver ("reference implementation").

I used patch-2.6.20-rc6; I see not too many SPI things changed
besides defining the previously undefined as 0.  I didn't find a
reason to introduce a mode-flag; it should always be enough to
look at the word.  A flag is redundant with default_tx_word != 0
(in 2.6.20 semantics).  So, I just added that word and adjusted
the bitbang-driver.  As a courtesy, I also added simple bail-out
code for the other drivers (not compiled and submitted
separately).

Here's an updated patch for 2.6.20-rc6.  Tested against 2.6.19
and adjusted to 2.6.20-rx6; it applies to 2.6.19, except for the
last hunk of spi.h which is in a comment and due to that
s/undefined data/zeroes/.  It's just the first line changed, the
rest is the result of M-x fill-paragraph.

BTW, I hope I'm unnecessarily pointing out that if you'd prefer
just initializing "word = spi->default_tx_word;" that may
(depending on your gcc version) introduce a memory access which
we can avoid.  Sure, it's just bitbanging SPI, but why not win.

Signed-off-by: Hans-Peter Nilsson <hp@axis.com>

diff -upr a/include/linux/spi/spi.h b/include/linux/spi/spi.h
--- a/include/linux/spi/spi.h	2007-01-26 10:38:50.000000000 +0100
+++ b/include/linux/spi/spi.h	2007-01-26 10:53:30.000000000 +0100
@@ -43,6 +43,10 @@ extern struct bus_type spi_bus_type;
  *	This may be changed by the device's driver, or left at the
  *	default (0) indicating protocol words are eight bit bytes.
  *	The spi_transfer.bits_per_word can override this for each transfer.
+ * @default_tx_word: This word, of size bits_per_word, will be the value
+ *	shifted out if the transmit buffer is null.  This may be changed
+ *	by the device's driver, but the controller doesn't have to accept
+ *	all values.  The default for a controller is 0, and is always valid.
  * @irq: Negative, or the number passed to request_irq() to receive
  *	interrupts from this device.
  * @controller_state: Controller's runtime state
@@ -72,6 +76,7 @@ struct spi_device {
 #define	SPI_CS_HIGH	0x04			/* chipselect active high? */
 #define	SPI_LSB_FIRST	0x08			/* per-word bits-on-wire */
 	u8			bits_per_word;
+	u32			default_tx_word;
 	int			irq;
 	void			*controller_state;
 	void			*controller_data;
@@ -289,12 +294,13 @@ extern struct spi_master *spi_busnum_to_
  * the data being transferred; that may reduce overhead, when the
  * underlying driver uses dma.
  *
- * If the transmit buffer is null, zeroes will be shifted out
- * while filling rx_buf.  If the receive buffer is null, the data
- * shifted in will be discarded.  Only "len" bytes shift out (or in).
- * It's an error to try to shift out a partial word.  (For example, by
- * shifting out three bytes with word size of sixteen or twenty bits;
- * the former uses two bytes per word, the latter uses four bytes.)
+ * If the transmit buffer is null, the word in spi_device.default_tx_word
+ * will be shifted out while filling rx_buf.  If the receive buffer is
+ * null, the data shifted in will be discarded.  Only "len" bytes shift
+ * out (or in).  It's an error to try to shift out a partial word.  (For
+ * example, by shifting out three bytes with word size of sixteen or
+ * twenty bits; the former uses two bytes per word, the latter uses four
+ * bytes.)
  *
  * All SPI transfers start with the relevant chipselect active.  Normally
  * it stays selected until after the last transfer in a message.  Drivers
diff -upr a/drivers/spi/spi_bitbang.c b/drivers/spi/spi_bitbang.c
--- a/drivers/spi/spi_bitbang.c	2007-01-26 10:38:49.000000000 +0100
+++ b/drivers/spi/spi_bitbang.c	2007-01-26 10:57:38.292130863 +0100
@@ -73,10 +73,9 @@ static unsigned bitbang_txrx_8(
 	u8			*rx = t->rx_buf;
 
 	while (likely(count > 0)) {
-		u8		word = 0;
+		u8		word;
 
-		if (tx)
-			word = *tx++;
+		word = (tx != NULL) ? *tx++ : spi->default_tx_word;
 		word = txrx_word(spi, ns, word, bits);
 		if (rx)
 			*rx++ = word;
@@ -101,8 +100,7 @@ static unsigned bitbang_txrx_16(
 	while (likely(count > 1)) {
 		u16		word = 0;
 
-		if (tx)
-			word = *tx++;
+		word = (tx != NULL) ? *tx++ : spi->default_tx_word;
 		word = txrx_word(spi, ns, word, bits);
 		if (rx)
 			*rx++ = word;
@@ -127,8 +125,7 @@ static unsigned bitbang_txrx_32(
 	while (likely(count > 3)) {
 		u32		word = 0;
 
-		if (tx)
-			word = *tx++;
+		word = (tx != NULL) ? *tx++ : spi->default_tx_word;
 		word = txrx_word(spi, ns, word, bits);
 		if (rx)
 			*rx++ = word;

brgds, H-P
