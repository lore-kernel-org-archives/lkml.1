Return-Path: <linux-kernel-owner+w=401wt.eu-S1755467AbXEEXsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467AbXEEXsX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 19:48:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755465AbXEEXsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 19:48:23 -0400
Received: from aun.it.uu.se ([130.238.12.36]:50792 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755442AbXEEXsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 19:48:22 -0400
Date: Sun, 6 May 2007 01:46:54 +0200 (MEST)
Message-Id: <200705052346.l45NksOb022632@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: htejun@gmail.com, mikpe@it.uu.se
Subject: Re: 2.6.21-mm1: many processes end up in D state
Cc: akpm@osdl.org, jgarzik@pobox.com, jirislaby@gmail.com,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       stable@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 05 May 2007 17:30:51 +0200, Tejun Heo wrote:
> Mikael Pettersson wrote:
> >> I.e. no freezing of ports...
> > 
> > Your patch to delete the 'return 1;' on error is correct,
> > and makes the code match exactly the behaviour of previous
> > versions of sata_promise, except for the additional error
> > decoding.
> > 
> > ahci and sata_sil24 do the return in this situation. I don't
> > yet understand why they can get away with it while sata_promise
> > cannot, but for now the return should be removed.
> 
> That's because sata_sil24 and ahci call either ata_port_abort() or
> ata_port_freeze() prior to finishing error_intr routine.  Both functions
> abort all in-flight command and schedule EH.

Ah. Thanks, that clarifies things.

Jiri: please test the patch below instead. That is, revert to
the original code _with_ the 'return 1;', and then add this
patch to it. It should have pretty much the same effect as
removing the 'return 1;', however calling ata_port_abort()
is more in line with libata's new-style error handling.

/Mikael

--- linux-2.6.21-mm1/drivers/ata/sata_promise.c.~1~	2007-05-05 22:24:41.000000000 +0200
+++ linux-2.6.21-mm1/drivers/ata/sata_promise.c	2007-05-05 22:25:21.000000000 +0200
@@ -653,6 +653,8 @@ static void pdc_error_intr(struct ata_po
 	qc->err_mask |= ac_err_mask;
 
 	pdc_reset_port(ap);
+
+	ata_port_abort(ap);
 }
 
 static inline unsigned int pdc_host_intr( struct ata_port *ap,
