Return-Path: <linux-kernel-owner+w=401wt.eu-S1755902AbXIXI1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902AbXIXI1W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 04:27:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754584AbXIXI1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 04:27:15 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:34499 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754367AbXIXI1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 04:27:14 -0400
Date: Mon, 24 Sep 2007 10:28:48 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: LAK <linux-arm-kernel@lists.arm.linux.org.uk>,
       LKML <linux-kernel@vger.kernel.org>
Subject: What's in mmc.git for 2.6.24
Message-ID: <20070924102848.503a8d22@poseidon.drzeus.cx>
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The merge window for 2.6.24 should open up any day now, so it's
probably time for me to detail what I intend to cram in there.

This release will probably be one of the biggest ones for the MMC layer
so far. The major pieces are SDIO and SPI support, but there are
several small nuggets as well.

SDIO
----

Gone are the days of having to rely on proprietary stacks for SDIO
support in Linux. So no more spotty support for hosts and possible GPL
problems. SDIO will now be a standard feature of Linux.

The model is largely based on PCI. All the memory operations they have
(readX/writeX and friends) exist in an equivalent manner for SDIO. We
also have the readsb() and writesb() functions which exist only on some
platforms for "normal" I/O. (For those not familiar with these
functions, they write every byte of a block of data into a single
byte in the address space.)

The big difference from other buses is that you have to hold the host
lock (which has gotten SDIO wrappers for ease of use), and that all I/O
operations may sleep.

There has been some talk about asynchronous requests, but that doesn't
really make much sense for a bus like SDIO where you don't interleave
transfers.

Interrupt support is also there and uses an interface similar to other
buses. It is called from process context though (currently a dedicated
kernel thread handles interrupts). Your ISR will also be called with
the host lock held, so keep the ISR short and try delegate what you
can. The only MUST is that you must remove the interrupt source before
you exit.

There are currently three working drivers for this new stack:

 - sdio_uart: A driver for the standardised GPS and UART interfaces.
Currently we only know how the GPS system works, so UART is only a
future possibility.

 - libertas_sdio: Support for Marvell's 8686 Libertas wifi chip. Will
be merged late in the merge window as there are some interdependencies
between my tree and the libertas tree.

 - hci_sdio: A driver for the standardised bluetooth interface. Marcel
is in charge of this and I assume he intends to merge it as it is in a
working condition.

Porting drivers to this stack can be a bit of work. Other stacks seem
to take the approach of handing over half the system to the sdio
function drivers. This stack does not. Instead, it enforces a rather
strict layering and hides almost all of the protocol stuff. Basically
you should see it as a register interface, not a SDIO protocol
interface.

This might annoy some who want to be able to easily port drivers
between stacks. But I believe that this will result in a much more
robust system instead of a collection of hacks and workarounds. As an
example, SPI support for SDIO is completely transparent for the
function drivers. Few of the other stacks could have facilitated this.

Finally, the SDIO stuff will work with any controller that correctly
follows the MMC and SD specifications. Unfortunately, many don't. A
common hardware bug is alignment requirements on addresses or sizes. So
driver maintainers, please have a look at your controllers and make
sure they can handle any kind of data block.

SPI
---

The second large feature is the fact that you can now use your SPI
controllers for MMC, SD and SDIO. Yes, even SDIO works nicely over SPI.
This means that a lot more systems can get storage and expansion I/O at
basically the cost of a connector.

In theory, everything that works with a true MMC/SD/SDIO controller
will work over SPI. In practice, some things won't. There is a lot of
shoddy hardware out there, so there's bound to be cards that aren't
properly following specs when it comes to SPI. In my collection, I've
found one card so far that doesn't work in SPI mode.

David Brownell is currently marked as providing "odd fixes" for the
mmc_spi driver, but we could really use a proper maintainer. So if you
have sufficient experience with Linux' SPI interface and the time,
please raise your hand.

Error codes
-----------

I've finally gotten around to removing the MMC layer specific error
codes. It now uses standard errno codes for all reporting.

As a part of this, I've defined some codes to have specific meaning
when found in the MMC layer:

 * ETIMEDOUT    Card took too long to respond.

 * EILSEQ       Basic format problem with the received or sent data
                (e.g. CRC check failed, incorrect opcode in response
                or bad end bit).

 * EINVAL       Request cannot be performed because of restrictions
                in hardware and/or the driver.

 * ENOMEDIUM    Host can determine that the slot is empty and is
                actively failing requests.

These are also documented in include/linux/mmc/core.h.

MMC_BYTEBLOCK
-------------

The BYTEBLOCK capability meant that the controller could satisfy
requests of any size (up to maximum block size). It was added so that
callers could determine if the hardware/driver could satisfy the
request or not.

As the result of the check was simply aborting, and the fact that the
MMC and SD specs require blocks of any size, making the flag basically
mean "not broken", it has now been replaced with a check inside the
relevant drivers. When a request, that is correct as far as the
protocol is concerned, is received that cannot be satisfied, the driver
shall fail it with the error code -EINVAL.

LEDs
----

For those systems where there is no LED directly hooked up to the MMC
controller, I've now added a LED trigger for each MMC host on the
system. This is particularly useful for those of you that will use the
new SPI feature as there is no MMC controller in that case.


Adrian Bunk (1):
      make struct sdio_dev_attrs[] static

David Brownell (4):
      MMC headers learn about SPI
      MMC/SD card driver learns SPI
      MMC core learns about SPI
      mmc_spi host driver

David Vrabel (4):
      sdio: add SDIO_FBR_BASE(f) macro
      sdio: set the functions' block size
      sdio: extend sdio_readsb() and friends to handle any length of buffer
      sdio: add sdio_f0_readb() and sdio_f0_writeb()

Marc Pignat (1):
      mmc: at91_mci: disable handling of blocks with size not multiple
of 4 bytes

Mariusz Kozlowski (1):
      sdio: kmalloc + memset conversion to kzalloc

Nicolas Pitre (11):
      sdio: initial CIS parsing code
      sdio: link unknown CIS tuples to the sdio_func structure
      mmc: initialize mmc subsystem with subsys_initcall()
      sdio: defines for some standard interface types
      sdio: allow for mmc_claim_host to be aborted
      sdio: core support for SDIO function interrupt
      sdio: UART/GPS driver
      sdio: add /proc interface to sdio_uart driver
      sdio: add interface for host side SDIO interrupt reporting
      sdio: add default c_ispeed/c_ospeed values to sdio_uart driver
      sdio: fix recursion issues between sdio-uart driver and tty layer

Pierre Ossman (30):
      mmc: remove custom error codes
      mmc: improve error code feedback
      mmc: read ext_csd version number
      mmc: mmc_set_data_timeout() parameter write is redundant
      mmc: remove BYTEBLOCK capability
      mmc: remove confusing flag
      mmc: add missing printk levels
      mmc: detect SDIO cards
      mmc: implement SDIO IO_RW_DIRECT operation
      mmc: basic SDIO device model
      mmc: add SDIO driver handling
      mmc: add basic SDIO I/O operations
      mmc: enable/disable functions for SDIO
      sdio: read and decode interesting parts of the CCCR
      sdio: basic parsing of FBR
      sdio: split up common and function CIS parsing
      sdio: add device id table and matching
      mmc: whip bus uevent handler into shape
      sdio: add modalias support
      sdio: add basic sysfs attributes
      sdio: support IO_RW_EXTENDED
      sdio: change clock speed
      sdio: enable wide bus mode
      mmc: fix incorrect divisor in debug output
      mmc: fix sdio timeout calculation
      mmc: replace BUG_ON with WARN_ON
      sdhci: sdio interrupt support
      mmc: increase power up delay
      sdio: store vendor strings
      mmc: add led trigger

 MAINTAINERS                     |    8 +-
 drivers/mmc/card/Kconfig        |    7 +
 drivers/mmc/card/Makefile       |    2 +
 drivers/mmc/card/block.c        |   30 +-
 drivers/mmc/card/sdio_uart.c    | 1158 ++++++++++++++++++++++++++++++++
 drivers/mmc/core/Makefile       |    4 +-
 drivers/mmc/core/bus.c          |   67 ++-
 drivers/mmc/core/core.c         |  167 ++++--
 drivers/mmc/core/core.h         |    2 +
 drivers/mmc/core/host.c         |    8 +
 drivers/mmc/core/mmc.c          |  134 +++--
 drivers/mmc/core/mmc_ops.c      |  200 +++++--
 drivers/mmc/core/mmc_ops.h      |    3 +
 drivers/mmc/core/sd.c           |  126 +++--
 drivers/mmc/core/sd_ops.c       |  107 ++-
 drivers/mmc/core/sdio.c         |  395 +++++++++++
 drivers/mmc/core/sdio_bus.c     |  270 ++++++++
 drivers/mmc/core/sdio_bus.h     |   22 +
 drivers/mmc/core/sdio_cis.c     |  346 ++++++++++
 drivers/mmc/core/sdio_cis.h     |   23 +
 drivers/mmc/core/sdio_io.c      |  548 +++++++++++++++
 drivers/mmc/core/sdio_irq.c     |  243 +++++++
 drivers/mmc/core/sdio_ops.c     |  176 +++++
 drivers/mmc/core/sdio_ops.h     |   22 +
 drivers/mmc/host/Kconfig        |   13 +
 drivers/mmc/host/Makefile       |    1 +
 drivers/mmc/host/at91_mci.c     |   25 +-
 drivers/mmc/host/au1xmmc.c      |   58 +-
 drivers/mmc/host/imxmmc.c       |   16 +-
 drivers/mmc/host/mmc_spi.c      | 1408 +++++++++++++++++++++++++++++++++++++++
 drivers/mmc/host/mmci.c         |   20 +-
 drivers/mmc/host/omap.c         |   12 +-
 drivers/mmc/host/pxamci.c       |   12 +-
 drivers/mmc/host/sdhci.c        |   90 ++-
 drivers/mmc/host/tifm_sd.c      |   31 +-
 drivers/mmc/host/wbsd.c         |   43 +-
 include/linux/mmc/card.h        |   32 +
 include/linux/mmc/core.h        |   63 ++-
 include/linux/mmc/host.h        |   39 +-
 include/linux/mmc/mmc.h         |   39 +-
 include/linux/mmc/sdio.h        |  159 +++++
 include/linux/mmc/sdio_func.h   |  153 +++++
 include/linux/mmc/sdio_ids.h    |   23 +
 include/linux/mod_devicetable.h |   11 +
 include/linux/spi/mmc_spi.h     |   33 +
 scripts/mod/file2alias.c        |   20 +
 46 files changed, 5971 insertions(+), 398 deletions(-)


-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
