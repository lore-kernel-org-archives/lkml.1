Return-Path: <linux-kernel-owner+w=401wt.eu-S1752497AbYJUIB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497AbYJUIB3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 04:01:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751508AbYJUIBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 04:01:19 -0400
Received: from aun.it.uu.se ([130.238.12.36]:37223 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483AbYJUIBS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 04:01:18 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18685.35827.914278.413151@harpo.it.uu.se>
Date: Tue, 21 Oct 2008 09:59:47 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: Tejun Heo <htejun@gmail.com>,
       Christian Mueller <Christian.Mueller@wdc.com>,
       Bruce Allen <ballen@gravity.phys.uwm.edu>,
       Smartmontools Mailing List 
	<smartmontools-support@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: [smartmontools-support] inactive SATA drives won't stay in standby
 or sleep, PATA models did. (fwd)
In-Reply-To: <18683.50533.786782.474536@harpo.it.uu.se>
References: <D73D40172004714D95D7A84AC3E68EC802282133@wdscexbe03.sc.wdc.com>
	<48EBFE9B.9070503@gmail.com>
	<18674.4081.839329.116533@harpo.it.uu.se>
	<48F2D9A8.1030502@gmail.com>
	<18683.50533.786782.474536@harpo.it.uu.se>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Oct 2008 01:40:21 +0200, Mikael Pettersson wrote:
>On Mon, 13 Oct 2008 14:16:24 +0900, Tejun Heo wrote:
>>Mikael Pettersson wrote:
>>> - hardreset in sata_promise seems broken. I'll take a closer look
>>>   at that in about a week's time (I'll be busy with other work the
>>>   next couple of days).
>>
>>This looks like a rather serious problem, so please take a look at
>>this.
>
>I've done more tests now, and the problem is that errors detected
>outside of sata_promise itself, typically timeouts, don't trigger
>the pdc_reset_port() call needed to bring the ATA engine behind the
>port back to sanity.

I did a round of regression tests which identified another
related but different problem.

In kernels 2.6.24 and 2.6.25 sata_promise would actually recover
from the timeouts, while in kernels 2.6.26 and 2.6.27 it would not.
Before 2.6.26 sata_promise explicitly used sata_std_hardreset, but
in the "make reset related methods proper port operations" commit
(a1efdaba2dbd6fb89e23a87b66d3f4dd92c9f5af), Tejun changed sata_promise
to use the hardreset it now inherits from ata_sff_port_ops, namely
sata_sff_hardreset. This change looks accidental. The main difference
between these two procedures is that the sff version will poll the
legacy status register until the port becomes ready.

Changing sata_promise to use sata_std_hardreset in 2.6.26/.27
makes the EH after the timeouts much more reliable. Not as
tidy as with the previous ->prereset fix, but still working.

/Mikael
