Return-Path: <linux-kernel-owner+w=401wt.eu-S1030403AbXC2Qvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030403AbXC2Qvg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 12:51:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030412AbXC2Qvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 12:51:35 -0400
Received: from hu-out-0506.google.com ([72.14.214.238]:28864 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030376AbXC2Qve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 12:51:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=WqfjrK4ZlNakwxm59CrNRXNT3EhgQUQxgaMyiVJH2Ft43hz1+esIHOqps9Wz82xh8KHWtOUfTLpl+dzBSv0dQG7Ad09uo9E5l3YOlc+HuCk1Owb1RfNfGDiQW1jUtmuk/Et4DEZdNrrrhl77+wShAQWzx2FwuRDO03qavJ652w4=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [ PATCH] Add suspend/resume for HPET was: Re: [3/6] 2.6.21-rc4: known regressions
Date: Thu, 29 Mar 2007 18:51:18 +0200
User-Agent: KMail/1.9.6
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Jeff Chua <jeff.chua.linux@gmail.com>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, pavel@suse.cz,
       linux-pm@lists.osdl.org, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz, Jens Axboe <jens.axboe@oracle.com>,
       Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       jgarzik@pobox.com, linux-ide@vger.kernel.org,
       "Michael S. Tsirkin" <mst@mellanox.co.il>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <200703290747.28929.maximlevitsky@gmail.com> <Pine.LNX.4.64.0703290930540.6730@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703290930540.6730@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703291851.19424.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 March 2007 18:35:21 Linus Torvalds wrote:
> 
> On Thu, 29 Mar 2007, Maxim wrote:
> 
> > On Thursday 29 March 2007 07:08:58 Linus Torvalds wrote:
> > > 
> > > (Or, better yet, shouldn't we set "boot_hpet_disable" when we decide not 
> > > to use the HPET, and set hpet_virt_address to NULL?)
> > 
> > This is done here
> > 
> > out_nohpet:
> > 	iounmap(hpet_virt_address);
> > 	hpet_virt_address = NULL;
> 
> No, that only clears hpet_virt_address, and thus makes all subsequent 
> "hpet_readl()" and "hpet_writel()" calls oops.
> 
> But it doesn't actually *tell* anybody that the HPET is disabled, so if 
> you later on do
> 
> 	if (is_hpet_capable()) {
> 		time = hpet_readl(..);
> 		..
> 
> you will just Oops!
> 
> So as far as I can see, even with your latest patch, if hpet_enable() 
> fails (and triggers the "goto out_nohpet" cases), you'll just oops 
> immediately when you try to suspend/resume the HPET.
> 
> THAT was what I meant - when we clear hpet_virt_address, we should also 
> tell all potential subsequent users that the HPET is not there!
> 
> 		Linus
> 

Hi,
	I agree, and as you said I did exactly that:

out_nohpet:
	iounmap(hpet_virt_address);
	hpet_virt_address = NULL;
	boot_hpet_disable = 1; <<<--- this ensures that is_hpet_capable() will never return positive value


	I also sent an updated version on my patch with subject line "[PATCH v2] Add suspend/resume for HPET"

	I forgot (a typo) to check error code in  hpet_register_sysfs
	Thanks to Sergei Shtylyov for pointing me on that.

	This patch should be ok.

	Best regards,
		Maxim Levitsky
