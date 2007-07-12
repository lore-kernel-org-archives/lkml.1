Return-Path: <linux-kernel-owner+w=401wt.eu-S1759253AbXGLRy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759253AbXGLRy0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 13:54:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754655AbXGLRyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 13:54:17 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:4870 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752878AbXGLRyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 13:54:16 -0400
Message-ID: <469669F5.6070906@shadowen.org>
Date: Thu, 12 Jul 2007 18:50:45 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: "Maciej W. Rozycki" <macro@linux-mips.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Ralf Baechle <ralf@linux-mips.org>, Mark Mason <mason@broadcom.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-mips@linux-mips.org,
       linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sb1250-duart.c: SB1250 DUART serial support
References: <Pine.LNX.4.64N.0707121745010.3029@blysk.ds.pg.gda.pl>
In-Reply-To: <Pine.LNX.4.64N.0707121745010.3029@blysk.ds.pg.gda.pl>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Maciej W. Rozycki wrote:
>  This is a driver for the SB1250 DUART, a dual serial port implementation 
> included in the Broadcom family of SOCs descending from the SiByte SB1250 
> MIPS64 chip multiprocessor.  It is a new implementation replacing the 
> old-fashioned driver currently present in the linux-mips.org tree.  It 
> supports all the usual features one would expect from a(n asynchronous) 
> serial driver, including modem line control (as far as hardware supports 
> it -- there is edge detection logic missing from the DCD and RI lines and 
> the driver does not implement polling of these lines at the moment), the 
> serial console, BREAK transmission and reception, including the magic 
> SysRq.  The receive FIFO threshold is not maintained though.
> 
> Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
> ---
> Hi,
> 
>  The driver was tested with a SWARM board which uses a BCM1250 SOC (which 
> is dual MIPS64 CMP) and has both ports of the single DUART implemented 
> wired externally.  Both were tested.  Testing included using the ports as 
> terminal lines at 1200bps (which is the ports minimum), 115200bps and a 
> couple of random speeds inbetween.  The modem lines were verified to 
> operate correctly.  No testing was performed with a use as a network 
> interface, like with SLIP or PPP.
> 
>  The driver builds succesfully and without warnings both as integrated and 
> as modular.  There are a couple of -W warnings, but they are results of 
> some inconsistencies (signedness mismatches) in the serial core.  It 
> produces no sparse warnings.  There are a few benign warnings from 
> patchcheck.pl, one of which is, I believe, a bug in the script itself 
> (maintainers cc-ed):
> 
> printk() should include KERN_ facility level
> #750: FILE: drivers/serial/sb1250-duart.c:675:
> +		printk(err);

Heh, yeah Ingo pointed this style out.  This is a wrapper where the
facility will be supplied by the caller (I assume).  The thought there
was that only complain on printks which had a string literal as their
first arguement.  That gets us very high accuracy and eliminates these
falsies.

> 
> The <asm/io.h> warning is, I gather, not a problem and warnings about the 
> _SB_MAKEMASK() macro should be addressed as a separate change.

I think I tend to agree that the MAKEMASK ones are separate.  Good to
see someone using their common sense in the face of whinging by the tool.

You will be pleased to know that the latest version of the tool is
throwing a new batch of errors on your patch :)  Included at the end of
the email.

>  The driver runs correctly with a 64-bit SMP kernel in a big- and 
> little-endian configuration (with spinlock debugging enabled).  Modular 
> configuration was not tested at the run time.  UP configuration was not 
> tested at all, but is not expected to give any troubles.
> 
>  I have asked for testing at the linux-mips list, but rather than results 
> I have received some pressure to push the patch regardless.  So here it 
> goes. ;-)

-apw

WARNING: declaring multiple variables together should be avoided
#372: FILE: drivers/serial/sb1250-duart.c:246:
+	unsigned int mctrl, status;

WARNING: declaring multiple variables together should be avoided
#386: FILE: drivers/serial/sb1250-duart.c:260:
+	unsigned int clr = 0, set = 0, mode2;

WARNING: declaring multiple variables together should be avoided
#464: FILE: drivers/serial/sb1250-duart.c:338:
+	unsigned int status, ch, flag;

WARNING: declaring multiple variables together should be avoided
#667: FILE: drivers/serial/sb1250-duart.c:541:
+	unsigned int mode1 = 0, mode2 = 0, aux = 0;

WARNING: declaring multiple variables together should be avoided
#668: FILE: drivers/serial/sb1250-duart.c:542:
+	unsigned int mode1mask = 0, mode2mask = 0, auxmask = 0;

WARNING: declaring multiple variables together should be avoided
#669: FILE: drivers/serial/sb1250-duart.c:543:
+	unsigned int oldmode1, oldmode2, oldaux;

WARNING: declaring multiple variables together should be avoided
#670: FILE: drivers/serial/sb1250-duart.c:544:
+	unsigned int baud, brg;

WARNING: declaring multiple variables together should be avoided
#907: FILE: drivers/serial/sb1250-duart.c:781:
+	int chip, side;

WARNING: declaring multiple variables together should be avoided
#908: FILE: drivers/serial/sb1250-duart.c:782:
+	int max_lines, line;

WARNING: declaring multiple variables together should be avoided
#1060: FILE: drivers/serial/sb1250-duart.c:934:
+	int i, ret;

