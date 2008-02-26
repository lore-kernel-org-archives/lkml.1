Return-Path: <linux-kernel-owner+w=401wt.eu-S1763154AbYBZRIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763154AbYBZRIT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 12:08:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752885AbYBZRIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 12:08:09 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49797 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752833AbYBZRII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 12:08:08 -0500
Subject: Re: 2.6.25-rc1 xen pvops regression
From: Mark McLoughlin <markmc@redhat.com>
Reply-To: Mark McLoughlin <markmc@redhat.com>
To: Ian Campbell <ijc@hellion.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Joel Becker <Joel.Becker@oracle.com>, Jody Belka <lists-lkml@pimb.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andi Kleen <andi@firstfloor.org>,
       Mika Penttila <mika.penttila@kolumbus.fi>
In-Reply-To: <1203665106.28436.19.camel@cthulhu.hellion.org.uk>
References: <20080212235404.GY7980@pimb.org> <47B2DBA5.6030001@goop.org>
	 <20080214022744.GA4160@mail.oracle.com> <47B3F2DC.8080707@goop.org>
	 <20080215202336.GE26034@mail.oracle.com>
	 <1203274161.27987.6.camel@localhost.localdomain>
	 <20080218104025.GA15899@ca-server1.us.oracle.com>
	 <1203458366.26910.15.camel@cthulhu.hellion.org.uk>
	 <47BBDA20.8030105@zytor.com>
	 <1203497511.26910.39.camel@cthulhu.hellion.org.uk>
	 <47BCA275.7000504@goop.org>
	 <1203546597.26910.74.camel@cthulhu.hellion.org.uk>
	 <47BDEA11.6010302@goop.org> <47BDEB57.5040203@zytor.com>
	 <47BDEF36.8000903@goop.org>
	 <1203631956.28436.4.camel@cthulhu.hellion.org.uk>
	 <47BDF9C7.6040400@zytor.com> <47BE0017.1020205@goop.org>
	 <47BE0228.7020204@zytor.com>
	 <1203665106.28436.19.camel@cthulhu.hellion.org.uk>
Content-Type: text/plain
Date: Tue, 26 Feb 2008 17:06:32 +0000
Message-Id: <1204045592.12238.6.camel@muff>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-02-22 at 07:25 +0000, Ian Campbell wrote:
> On Thu, 2008-02-21 at 14:58 -0800, H. Peter Anvin wrote:
> > 
> > Which it is on real hardware, because although it's not *reserved*
> > (type 2), it is certainly not made available as *normal memory* (type
> > 1).  If Xen maps this as type 1 then I definitely see the problem.
> > 
> > We can exclude type 1 memory from DMI scan, certainly.
> 
> I'd been meaning to ask this. So the machines you have which don't
> describe 0xf0000 as reserved also don't describe it as RAM? (I guess
> it's either a hole in the table or one of the other e820 types).
> Ian.

...

> >From 13bdb4ee9d80b83a81c3dbefa52464e511d1b4df Mon Sep 17 00:00:00 2001
> From: Ian Campbell <ijc@hellion.org.uk>
> Date: Fri, 22 Feb 2008 07:17:14 +0000
> Subject: [PATCH] x86: Do not scan for DMI if the DMI region is marked as RAM by e820.
> 
> Under Xen the memory at 0xf0000 is regular RAM and so can potentially contain a
> page table and hence cannot be mapped. The e820 map given to guest reflects
> this.
> 
> Signed-off-by: Ian Campbell <ijc@hellion.org.uk>

...

> @@ -371,6 +372,9 @@ void __init dmi_scan_machine(void)
>  		}
>  	}
>  	else {
> +		if (e820_all_mapped(0xF0000, 0xF0000+0x10000, E820_RAM))
> +			goto out;

	One issue with using the e820 map for this is that a Xen Dom0 will also
have this region marked as RAM in the e820 map, but will set up a fixmap
for it, allowing dmi_scan_machine() to map the region.

Cheers,
Mark.

