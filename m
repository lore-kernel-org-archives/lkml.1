Return-Path: <linux-kernel-owner+w=401wt.eu-S1763638AbZDHUkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763638AbZDHUkd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 16:40:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763313AbZDHUkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 16:40:12 -0400
Received: from ti-out-0910.google.com ([209.85.142.187]:49498 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761140AbZDHUkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 16:40:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=nJ6ZB6vvGSuPVrFj8pXS+URRCfnCLp3MNtbZKNOxSCEalhRqlxYgTxe6k2cwo1RlMy
         lsn1ozEDcFMEoen2dhfB5Z48TXokMxyeqyO7+b53zxWd+fwbkf+7S5rR/MaCWTJi6ESG
         dSSnpTfPXjiMAEF0cvbrVBcoy17nFqdg58mxc=
Message-ID: <49DD0BC7.5090801@gmail.com>
Date: Wed, 08 Apr 2009 13:40:39 -0700
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Dustin Harrison <d.harrison@sutus.com>,
       Sagar Borikar <sagar.borikar@gmail.com>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 2/2] sata_sil: disable DMA engine in ->freeze
References: <20090407232247.GA16086@havoc.gtf.org>	 <20090407232331.GA16190@havoc.gtf.org> <3fb94e50904072213n637525b1w4b032544dcef3618@mail.gmail.com> <49DC3357.3030703@garzik.org> <49DCFCEE.7040000@sutus.com> <49DCFFE5.7080807@garzik.org>
In-Reply-To: <49DCFFE5.7080807@garzik.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Jeff Garzik wrote:
>> Thanks for updating the patch Jeff.  I see you spotted the reason why
>> I didn't put the code into sil_freeze.  I tested your patch and it
>> prevented the kernel panic.  I now get the following output, which
>> seems to be correct to me.
>>
>> WARNING: at drivers/ata/libata-core.c:5209 ata_qc_complete()
> 
> hum, my patch would indeed trigger this WARN_ON_ONCE() in
> ata_qc_complete():
> 
>         if (ap->ops->error_handler) {
>                 struct ata_device *dev = qc->dev;
>                 struct ata_eh_info *ehi = &dev->link->eh_info;
> 
>                 WARN_ON_ONCE(ap->pflags & ATA_PFLAG_FROZEN);
> 
> Tejun, was that WARN_ON() originally added to detect spurious callers?
> Or, completions after the EH started?
> 
> AFAICS, libata still owns the qc's at this point, so it should not be a
> problem to complete them when the port is frozen.

Ah... that one.  The WARN_ON_ONCE() was added because I was worried
that LLD interrupt handler might get activated after the port is
frozen and try to complete the commands which now belong to EH.  Given
that ata_qc_from_tag() returns NULL for any commands which get already
marked failed, it's a bit paranoid.  Well, I was a bit paranoid when
adding new EH the first time, so...

Removing it should be fine at this point, I think, but I'm away from
my toys so testing is a bit difficult, so please test the path which
triggered the WARN_ON_ONCE() works fine (it should) before removing
it.

Thanks.

-- 
tejun
