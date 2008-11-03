Return-Path: <linux-kernel-owner+w=401wt.eu-S1753794AbYKCRa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794AbYKCRa7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 12:30:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751049AbYKCRav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 12:30:51 -0500
Received: from gv-out-0910.google.com ([216.239.58.188]:54936 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbYKCRau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 12:30:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=DtPtwP1HuZAN1qbPUMdzCzJcbT2mY0uH13KdaA96hq2CPi/RYzizcohnwn276sg0Kr
         21lk6B8DZNpp3qvycvNhIIYweT6hBGleJKlO79ZZ38uJBgv2EoYxwcp7HhTAnPTxJyz7
         JvV8e4iSYstBJ8kTuX2k8V1pbaiESXheS3jDw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: upstream regression (IO-APIC?)
Date: Mon, 3 Nov 2008 18:28:07 +0100
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, Alok N Kataria <akataria@vmware.com>,
       Robert Hancock <hancockr@shaw.ca>,
       Arjan van de Ven <arjan@infradead.org>, Pavel Machek <pavel@suse.cz>
References: <fa.mewpISr5S4wcdUNw1DVfOnQfl8s@ifi.uio.no> <200811021537.24771.bzolnier@gmail.com> <200811022124.24992.bzolnier@gmail.com>
In-Reply-To: <200811022124.24992.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200811031828.07285.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 02 November 2008, Bartlomiej Zolnierkiewicz wrote:
> On Sunday 02 November 2008, Bartlomiej Zolnierkiewicz wrote:
> > On Thursday 30 October 2008, Robert Hancock wrote:
> > > Bartlomiej Zolnierkiewicz wrote:
> > > > The current Linus tree as of commit e946217e4fdaa67681bbabfa8e6b18641921f750
> > > > is broken for me.  I get either the following panic (see log from qemu below)
> > > > or lost IRQs on ATA init...  Is this a known issue?
> > > > 
> > > > PS The tree that I used before and was supposedly good (sorry, I'm too tired
> > > > to verify it now) had commit 57f8f7b60db6f1ed2c6918ab9230c4623a9dbe37 at head.
> > 
> > Unfortunately 57f8f7b60db6f1ed2c6918ab9230c4623a9dbe37 (v2.6.28-rc1)
> > is also bad.  Bisecting it further was a real pain (i.e. I hit broken
> > build with x86 irqbalance changes, broken build with netfilter nat
> > changes and jbd journal problem).  In the end it turned out that 2.6.27
> > is bad too!  However with 2.6.27 the panic occurs only once per several
> > attempts and if there is no panic kernel boots normally (no lost IRQs).
> > 
> > [...]
> > 
> > I finally managed to narrow it down to change making x86 use tsc_khz
> > for loops_per_jiffy -- commit 3da757daf86e498872855f0b5e101f763ba79499
> > ("x86: use cpu_khz for loops_per_jiffy calculation").  This approach
> > seems too simplistic (as I see now Arjan & Pavel expressed concerns
> > about it back when the patch was posted initially [1][2]).  Also it
> > would probably be preferred to re-use existing preset_lpj variable
> > (just like KVM does it for similar purpose [3]) instead of adding a
> > lpj_tsc one and increasing complexity.
> 
> It turned out that I can boot a kernel with different config with
> HZ == 250 just fine and switching to HZ == 1000 makes it fail.
> 
> 
> Looking into it some more:
> 
> HZ == 250 kernel (good):
> 
> Calibrating delay loop (skipped), value calculated using timer frequency.. 2986.79 BogoMIPS (lpj=5973580)
> 
> HZ == 1000 kernel (bad):
> 
> Calibrating delay loop (skipped), using tsc calculated value.. 2990.35 BogoMIPS (lpj=1495176)
> 
> HZ == 1000 kernel with hackyfix (good):
> 
> Calibrating delay using timer specific routine.. 3016.68 BogoMIPS (lpj=6033376)
> 
> 
> Argggh... lpj is used for udelay() & friends so this bug is quite
> dangerous (since udelay() & friends are used for hardware delays)...

It may be not as severe as I initially thought,
(obviously) the real hardware works fine:

calibrate_delay_direct(): lpj=1495884
Calibrating delay loop (skipped), value calculated using timer frequency.. 2990.36 BogoMIPS (lpj=1495183)

So the issue only affects qemu ATM.

Thanks,
Bart
