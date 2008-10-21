Return-Path: <linux-kernel-owner+w=401wt.eu-S1753587AbYJUI5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587AbYJUI5o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 04:57:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751932AbYJUI5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 04:57:35 -0400
Received: from ti-out-0910.google.com ([209.85.142.187]:45475 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbYJUI5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 04:57:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=GgyKRiv/tzEU4exflzDCe2PetIUj90whE955dUxd3roTOEhPYH9wW3rXXHL2h6OUFy
         QfVs+oSRidVKAUgoEDWqJ0eGnEF8HWSvocwK1yVjEW4udSr7vq25bT4LsmjHEjiJUmBl
         lfkLH8GTfh6FPuEiNdl0T6MohAAdbvAy6ffsA=
Message-ID: <48FD9903.2090400@gmail.com>
Date: Tue, 21 Oct 2008 17:55:31 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>
CC: Christian Mueller <Christian.Mueller@wdc.com>,
       Bruce Allen <ballen@gravity.phys.uwm.edu>,
       Smartmontools Mailing List 
	<smartmontools-support@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: [smartmontools-support] inactive SATA drives won't stay in standby
 or sleep, PATA models did. (fwd)
References: <D73D40172004714D95D7A84AC3E68EC802282133@wdscexbe03.sc.wdc.com>	<48EBFE9B.9070503@gmail.com>	<18674.4081.839329.116533@harpo.it.uu.se>	<48F2D9A8.1030502@gmail.com>	<18683.50533.786782.474536@harpo.it.uu.se> <18685.35827.914278.413151@harpo.it.uu.se>
In-Reply-To: <18685.35827.914278.413151@harpo.it.uu.se>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Mikael.
> I did a round of regression tests which identified another
> related but different problem.
> 
> In kernels 2.6.24 and 2.6.25 sata_promise would actually recover
> from the timeouts, while in kernels 2.6.26 and 2.6.27 it would not.
> Before 2.6.26 sata_promise explicitly used sata_std_hardreset, but
> in the "make reset related methods proper port operations" commit
> (a1efdaba2dbd6fb89e23a87b66d3f4dd92c9f5af), Tejun changed sata_promise
> to use the hardreset it now inherits from ata_sff_port_ops, namely
> sata_sff_hardreset. This change looks accidental. The main difference
> between these two procedures is that the sff version will poll the
> legacy status register until the port becomes ready.

Hmm... it's quite likely that I've introduced the regression but that
commit ain't it (I actually wrote a script to verify the inheritance
change doesn't actually change the function table).  What used to be
sata_std_hardreset() is now sata_sff_hardreset().  The change was made
while separating out SFF as [S]ATA as per the standard doesn't have
any way to wait for device readiness.  The TF-polling is SFF specific
and thus moved out to sata_sff_hardreset().

So, in both 2.6.24 and 2.6.25, sata_promise did wait for device
readiness after hardreset as does 2.6.26 or any later version.

> Changing sata_promise to use sata_std_hardreset in 2.6.26/.27
> makes the EH after the timeouts much more reliable. Not as
> tidy as with the previous ->prereset fix, but still working.

The only behavior change between 2.6.25 and 2.6.26 as far as
sata_promise is concerned is that hardrset is preferred over
softreset.  Here's what I think is going on.

Previously, after a timeout, libata-eh will invoke softreset and if
that works all should have been fine whether hardreset actually worked
or not.  Now, after something goes wrong, libata EH calls hardreset
and as hardreset doesn't work properly without the controller reset so
it fails.  So, the libata core layer change exposed a bug in
hardreset, which was one of the reasons why the change was made -
hardreset being the last line of defense, using it occasionally
doesn't make sense test-coverage-wise.

I agree the core layer changes can be quite confusing but they were
necessary to keep the core layer scalable.  libata now has oodles of
different types of low level drivers and things were and still are
getting quite treacherous for drivers living on the edge.

Anyways, so, please fix hardreset.  If it can't wait for device
readiness reliably, the right thing to do is to use
sata_std_hardreset() which will trigger follow-up softreset to wait
for device readiness and classify devices but if adding the controller
reset makes the hardreset more reliable, please do so.

Thanks.

-- 
tejun
