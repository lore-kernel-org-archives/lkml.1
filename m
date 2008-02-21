Return-Path: <linux-kernel-owner+w=401wt.eu-S934739AbYBUVS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934739AbYBUVS1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 16:18:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752666AbYBUVSS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 16:18:18 -0500
Received: from gw.goop.org ([64.81.55.164]:37244 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532AbYBUVSR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 16:18:17 -0500
Message-ID: <47BDEA11.6010302@goop.org>
Date: Thu, 21 Feb 2008 13:16:01 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ian Campbell <ijc@hellion.org.uk>
CC: "H. Peter Anvin" <hpa@zytor.com>, Joel Becker <Joel.Becker@oracle.com>,
       Jody Belka <lists-lkml@pimb.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andi Kleen <andi@firstfloor.org>,
       Mika Penttila <mika.penttila@kolumbus.fi>
Subject: Re: 2.6.25-rc1 xen pvops regression
References: <20080212235404.GY7980@pimb.org> <47B2DBA5.6030001@goop.org>	 <20080214022744.GA4160@mail.oracle.com> <47B3F2DC.8080707@goop.org>	 <20080215202336.GE26034@mail.oracle.com>	 <1203274161.27987.6.camel@localhost.localdomain>	 <20080218104025.GA15899@ca-server1.us.oracle.com>	 <1203458366.26910.15.camel@cthulhu.hellion.org.uk>	 <47BBDA20.8030105@zytor.com>	 <1203497511.26910.39.camel@cthulhu.hellion.org.uk>	 <47BCA275.7000504@goop.org> <1203546597.26910.74.camel@cthulhu.hellion.org.uk>
In-Reply-To: <1203546597.26910.74.camel@cthulhu.hellion.org.uk>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Campbell wrote:
> I'll see if I can track down where the page is getting used and have a
> go at getting in there first. It must be pretty early to be allocated
> already when dmi_scan_machine gets called.
>
> It's possible that the domain builder might have already allocated a PT
> at this address. I haven't checked but I think currently the domain
> builder always puts PT pages after the kernel so hopefully it's only a
> theoretical problem.
>   

Yes, it does.  And presumably the early pagetable builder is guaranteed 
to avoid special memory like the DMI space.  But the bug definitely 
seems to be a result of the DMI code trying to make a RW mapping of a 
pagetable page, so something is amiss there.

Ooh, sleazy hack idea: make DMI always map RO, so even if it does get a 
pagetable it causes no complaint...  A bit awkward, since there doesn't 
seem to be an RO form of early_ioremap.

> Another option I was thinking of was a command line option to disable
> DMI, which (maybe) isn't terribly useful in itself but it introduces an
> associated variable to frob with. That's similar to how the TSC was
> handled in the past (well, the opposite since TSC was forced on).
>   

Yep, that would work too.

Still curious about why a pagetable page is ending up in that range 
though.  Seems like it shouldn't be possible, since we shouldn't be 
allowed to allocate from those pages, at least until the DMI probe has 
happened...  Unless the early allocator is only excluded from e820 
reserved pages, which would cause a problem on systems which don't 
reserve the DMI space...  HPA?

    J
