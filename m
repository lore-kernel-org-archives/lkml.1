Return-Path: <linux-kernel-owner+w=401wt.eu-S1751895AbYKFTNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895AbYKFTNX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 14:13:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751096AbYKFTNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 14:13:14 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34377 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861AbYKFTNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 14:13:13 -0500
Date: Thu, 6 Nov 2008 19:12:50 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Peter Alfredsen <loki_val@gentoo.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Lee Howard <lee.howard@mainpine.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Is the PCI serial driver code GPL v2 or v3
Message-ID: <20081106191250.GA28514@flint.arm.linux.org.uk>
References: <20081106174341.GA8155@xolotl.n0ano.com> <200811061952.37490.loki_val@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811061952.37490.loki_val@gentoo.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2008 at 08:52:31PM +0200, Peter Alfredsen wrote:
> It seems like a typo to me to.. That wording has been constant since the 
> file drivers/serial/serial_8250_pci.c was created based on work in 
> drivers/char/serial.c:
> http://git.kernel.org/?p=linux/kernel/git/tglx/history.git;a=commitdiff;h=33c0d1b0c3ebb61243d9b19ce70d9063acff2aac
> serial_8250.c has the "or later" clause there.
> 
> But I suppose the best way is to ask the originator of that file. 
> Russell, what say you?
> Did you mean to license that file under GPL-2 or GPL-2+?

It was based upon the original serial.c by Ted T'so, but with some
reworking to add a separate quirks table, and quite a number of cleanups.

My personal position is that code I author is GPLv2, and not GPLv2 or
later.  So it's a question whether you consider that I'm the author
of the code in that file, or whether you think it's Ted's with my
contributions were under Ted's original terms.


BTW, now that you bring this to my attention, I see this hack in there:

struct serial_private *
pciserial_init_ports(struct pci_dev *dev, struct pciserial_board *board)
{
        if (dev->vendor == PCI_VENDOR_ID_OXSEMI ||
            dev->vendor == PCI_VENDOR_ID_MAINPINE)
                pci_oxsemi_tornado_init(dev, board);

        nr_ports = board->num_ports;

It's completely unnecessary with the quirk system, which follows
these lines:

        /*
         * Run the new-style initialization function.
         * The initialization function returns:
         *  <0  - error
         *   0  - use board->num_ports
         *  >0  - number of ports
         */
        if (quirk->init) {
                rc = quirk->init(dev);
                if (rc < 0) {
                        priv = ERR_PTR(rc);
                        goto err_out;
                }
                if (rc)
                        nr_ports = rc;
        }

So, why they couldn't add a quirk where the init function returns the
number of ports, instead of modifying some random board structure and
possibly upsetting future allocations is beyond me.

We now have the situation, again, where some random entry in the
pci_boards array is being modified which could trip up a future
board registration.

This is plainly idiotic and utterly buggy.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
