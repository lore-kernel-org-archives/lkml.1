Return-Path: <linux-kernel-owner+w=401wt.eu-S1752819AbYJUJEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819AbYJUJEX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 05:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751965AbYJUJEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 05:04:13 -0400
Received: from ti-out-0910.google.com ([209.85.142.191]:44492 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953AbYJUJEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 05:04:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=TR5JrxTrywI4VqqzQYCs0HF0x28rRMAG+8F4/NGIyZ0gUelh4/ck4/GINwfRc1Q1qA
         5DnS8mvpOyC7AMr+YCfdHjYZb77t/h0/+eZTh89ufly+NfoeSFTjv3O9lJc329tsJ+HR
         tdK+IsY5qFH8ie23bgCN3Bg+DyAphz7AGUUlM=
Message-ID: <48FD9A90.8000205@gmail.com>
Date: Tue, 21 Oct 2008 18:02:08 +0900
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
References: <D73D40172004714D95D7A84AC3E68EC802282133@wdscexbe03.sc.wdc.com>	<48EBFE9B.9070503@gmail.com>	<18674.4081.839329.116533@harpo.it.uu.se>	<48F2D9A8.1030502@gmail.com>	<18683.50533.786782.474536@harpo.it.uu.se>	<48FD580E.4080101@gmail.com> <18685.35653.125899.390135@harpo.it.uu.se>
In-Reply-To: <18685.35653.125899.390135@harpo.it.uu.se>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Mikael Pettersson wrote:
> Tejun Heo writes:
>  > Hello, Mikael.
>  > I would put this into ->hardreset itself as the controller can also
>  > get out of sync with reality during reset.
> 
> The only thing I see going on between prereset and (hard/soft)reset
> is an optional freeze, so I don't see why moving the pdc_reset_port()
> into the beginning of hardreset() would make any difference.
> 
> sata_promise currently uses the ->hardreset and ->softreset inherited
> from ata_sff_port_ops, so it would need to override both to ensure that
> we always do pdc_reset_port() before libata does its thing. That's why
> I felt doing that in ->prereset would be the right solution.

Hmm.. reset sequence goes on like the following.

 1. prereset
 2. hardreset, if fail, retry
 3. follow-up softreset if requested, if fail, goto #2
 4. postreset, if successful

So, if some PHY event happens while the reset is waiting for device
readiness and makes the controller state go out of sync with the
drive.  ->prereset() will NOT be called for the following retry.

As a rule, ->hardreset should be able to reset the controller from all
possible situations.  ->prereset can be used to smooth out initial
reset tries (ie. during initial probing, waiting for device readiness
before SRST for SFF controllers w/o hardreset) but at best its
function is advisory.  When things go wrong, ->hardreset should be
able to provide solution whatever state the controller is in.

If both hard and soft resets work better with the controller reset
added, I think it would be best to override both.

Thanks.

-- 
tejun
