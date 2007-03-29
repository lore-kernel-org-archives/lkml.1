Return-Path: <linux-kernel-owner+w=401wt.eu-S1030410AbXC2Ql0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030410AbXC2Ql0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 12:41:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030383AbXC2QlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 12:41:23 -0400
Received: from smtp.osdl.org ([65.172.181.24]:60274 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030400AbXC2QlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 12:41:18 -0400
Date: Thu, 29 Mar 2007 09:35:21 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Maxim <maximlevitsky@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
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
Subject: Re: [ PATCH] Add suspend/resume for HPET was: Re: [3/6] 2.6.21-rc4:
 known regressions
In-Reply-To: <200703290747.28929.maximlevitsky@gmail.com>
Message-ID: <Pine.LNX.4.64.0703290930540.6730@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
 <200703290641.20236.maximlevitsky@gmail.com>
 <Pine.LNX.4.64.0703282203550.6730@woody.linux-foundation.org>
 <200703290747.28929.maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 29 Mar 2007, Maxim wrote:

> On Thursday 29 March 2007 07:08:58 Linus Torvalds wrote:
> > 
> > (Or, better yet, shouldn't we set "boot_hpet_disable" when we decide not 
> > to use the HPET, and set hpet_virt_address to NULL?)
> 
> This is done here
> 
> out_nohpet:
> 	iounmap(hpet_virt_address);
> 	hpet_virt_address = NULL;

No, that only clears hpet_virt_address, and thus makes all subsequent 
"hpet_readl()" and "hpet_writel()" calls oops.

But it doesn't actually *tell* anybody that the HPET is disabled, so if 
you later on do

	if (is_hpet_capable()) {
		time = hpet_readl(..);
		..

you will just Oops!

So as far as I can see, even with your latest patch, if hpet_enable() 
fails (and triggers the "goto out_nohpet" cases), you'll just oops 
immediately when you try to suspend/resume the HPET.

THAT was what I meant - when we clear hpet_virt_address, we should also 
tell all potential subsequent users that the HPET is not there!

		Linus
