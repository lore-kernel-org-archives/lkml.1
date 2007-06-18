Return-Path: <linux-kernel-owner+w=401wt.eu-S1761642AbXFRL1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761642AbXFRL1d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 07:27:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752686AbXFRL1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 07:27:25 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:56667 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbXFRL1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 07:27:24 -0400
X-Originating-Ip: 72.143.66.27
Date: Mon, 18 Jun 2007 07:25:05 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: implementation of boot-time kernel parameters
Message-ID: <Pine.LNX.4.64.0706180709390.14098@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  (i asked about this on the KJ list but didn't get much in the way of
response, so i'll try here.)

  the short form:  as a lead-in to trying to clean up some obsolete
content in Documentation/kernel-parameters.txt (and there appears to
be a lot of it), i can see how boot-time kernel parms are defined
these days -- with "__setup()" or "early_param()".

  i'm also aware of an older and (apparently) LILO-specific way to do
it -- using something like "pas16=" where the appropriate driver code
has to parse the value string (eg., in drivers/scsi/pas16.c):

/*
 * Function : pas16_setup(char *str, int *ints)
 *
 * Purpose : LILO command line initialization of the overrides array,
 *
 * Inputs : str - unused, ints - array of integer parameters with ints[0]
 *      equal to the number of ints.
 *
 */

void __init pas16_setup(char *str, int *ints)
{
    static int commandline_current = 0;
    int i;
    if (ints[0] != 2)
        printk("pas16_setup : usage pas16=io_port,irq\n");
    else
        if (commandline_current < NO_OVERRIDES) {
            overrides[commandline_current].io_port = (unsigned short) ints[1];
            overrides[commandline_current].irq = ints[2];
            for (i = 0; i < NO_BASES; ++i)
                if (bases[i].io_port == (unsigned short) ints[1]) {
                    bases[i].noauto = 1;
                    break;
                }
            ++commandline_current;
        }
}

  now, the pas16 driver also handles setting those values as module
parameters:

#ifdef MODULE
module_param(pas16_addr, ushort, 0);
module_param(pas16_irq, int, 0);
#endif

  but there are definitely drivers that support *only* the LILO form
for boot-time parms, which would seem to suggest that, unless you're
using LILO, you don't get some of those kernel parameters, no?

  in situations like that, is it even accurate to say that those are
supported kernel parameters if they're not supported on non-LILO
systems?  and how should stuff like this be brought up to date, if at
all?

rday

p.s.  note that the comment at the top of the doc file reads:

                          Kernel Parameters
                          ~~~~~~~~~~~~~~~~~

The following is a consolidated list of the kernel parameters as
implemented (mostly) by the __setup() macro ...

  which, as i'm sure you can appreciate, is somewhat misleading since
some of the parms are relevant only for LILO-based systems.  anyway,
is there a standard for all of this?
--
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
