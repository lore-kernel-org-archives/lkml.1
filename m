Return-Path: <linux-kernel-owner+w=401wt.eu-S1751042AbYKFTtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751042AbYKFTtX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 14:49:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751083AbYKFTtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 14:49:15 -0500
Received: from mail.mainpine.com ([216.235.106.114]:44735 "EHLO
	mail.mainpine.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbYKFTtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 14:49:14 -0500
X-Greylist: delayed 562 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Nov 2008 14:49:14 EST
Reply-To: <lee.howard@mainpine.com>
From: "Lee Howard" <lee.howard@mainpine.com>
To: "'Russell King'" <rmk+lkml@arm.linux.org.uk>,
       "'Peter Alfredsen'" <loki_val@gentoo.org>,
       "'Alan Cox'" <alan@lxorguk.ukuu.org.uk>
Cc: <linux-kernel@vger.kernel.org>
References: <20081106174341.GA8155@xolotl.n0ano.com> <200811061952.37490.loki_val@gentoo.org> <20081106191250.GA28514@flint.arm.linux.org.uk>
Subject: RE: Is the PCI serial driver code GPL v2 or v3
Date: Thu, 6 Nov 2008 11:39:44 -0800
Organization: Mainpine
Message-ID: <AA46BE34D4E74CB69F948F36984126A9@callisto>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: AclAQ7T57ALcT3h+T+++5GA3YcgakQAAvfHg
In-Reply-To: <20081106191250.GA28514@flint.arm.linux.org.uk>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Sorry for the top-post, but Outlook is a pain...)

The "hack" originates from code done by Oxford Semiconductor.  I would be
happy to have it done with the quirk system, and I am willing to write a
patch to that effect.  My guess, however, would be that I'll still not do it
in your favorite way, and so I'm asking if you would like me to write the
code change or will you (or someone else here familiar with the favorite
ways) do it?

For what it's worth, I have tested 2.6.28-rc3 and it works vanilla with this
hardware.  :-)

Thanks,

Lee.


Lee Howard
Mainpine, Inc. Software Development Lead
Tel: +1 866 363 6680 ext 805 | Fax: +1 360 462 8160
lee.howard@mainpine.com | www.mainpine.com

-----Original Message-----
From: Russell King [mailto:rmk@arm.linux.org.uk] On Behalf Of Russell King
Sent: Thursday, November 06, 2008 11:13 AM
To: Peter Alfredsen; Alan Cox; Lee Howard
Cc: linux-kernel@vger.kernel.org
Subject: Re: Is the PCI serial driver code GPL v2 or v3

BTW, now that you bring this to my attention, I see this hack in there:

struct serial_private *
pciserial_init_ports(struct pci_dev *dev, struct pciserial_board *board) {
        if (dev->vendor == PCI_VENDOR_ID_OXSEMI ||
            dev->vendor == PCI_VENDOR_ID_MAINPINE)
                pci_oxsemi_tornado_init(dev, board);

        nr_ports = board->num_ports;

It's completely unnecessary with the quirk system, which follows these
lines:

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

So, why they couldn't add a quirk where the init function returns the number
of ports, instead of modifying some random board structure and possibly
upsetting future allocations is beyond me.

We now have the situation, again, where some random entry in the pci_boards
array is being modified which could trip up a future board registration.

This is plainly idiotic and utterly buggy.

