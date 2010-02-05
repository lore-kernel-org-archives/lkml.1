Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933687Ab0BECiQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 21:38:16 -0500
Received: from hera.kernel.org ([140.211.167.34]:34984 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933633Ab0BECiL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 21:38:11 -0500
Message-ID: <4B6B8622.9090109@kernel.org>
Date: Fri, 05 Feb 2010 11:44:50 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Grant Grundler <grundler@google.com>
CC: Chandra Shekhar Sah <edu4madh@gmail.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: port multiplier problem
References: <4B5885F7.2020007@gmail.com> <4B6833DD.1020001@gmail.com>	 <4B683581.7070708@kernel.org> <4B683DEF.3000302@gmail.com>	 <da824cf31002020844r12cada26x57f96b0aa24b59c6@mail.gmail.com>	 <4B686B2B.2080406@gmail.com>	 <da824cf31002021104v72efcd05ne639091042d5999d@mail.gmail.com>	 <4B687B7C.2070406@gmail.com>	 <da824cf31002031837t1cf2357bsbb53a3b4ea5e671f@mail.gmail.com>	 <4B6A3DED.6060708@kernel.org> <da824cf31002040959y63f3484cv6d551acd49b80fa7@mail.gmail.com>
In-Reply-To: <da824cf31002040959y63f3484cv6d551acd49b80fa7@mail.gmail.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 05 Feb 2010 02:38:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 02/05/2010 02:59 AM, Grant Grundler wrote:
>> That said, I'm not quite sure this is relevant to the reported
>> problem but it's worth a shot.
>
> I didn't have a better idea.

Heh... yeah, me neither.  If that doesn't work, I'll dig out 3726s I
have and see whether the new kernels are having problems with them but
I can't think of anything which could have effects like this.

> I'm seeing this in sata_pmp_quirks() since ATA_LFLAG_NO_SRST was introduced:
>  337 static void sata_pmp_quirks(struct ata_port *ap)
>  338 {
>  339         u32 *gscr = ap->link.device->gscr;
>  340         u16 vendor = sata_pmp_gscr_vendor(gscr);
>  341         u16 devid = sata_pmp_gscr_devid(gscr);
>  342         struct ata_link *link;
>  343
>  344         if (vendor == 0x1095 && devid == 0x3726) {
>  345                 /* sil3726 quirks */
>  346                 ata_for_each_link(link, ap, EDGE) {
>  347                         /* Class code report is unreliable and SRST
>  348                          * times out under certain configurations.
>  349                          */
>  350                         if (link->pmp < 5)
>  351                                 link->flags |= ATA_LFLAG_NO_SRST |
>  352                                                ATA_LFLAG_ASSUME_ATA;
>  353
>  354                         /* port 5 is for SEMB device and it doesn't like SRST */
>  355                         if (link->pmp == 5)
>  356                                 link->flags |= ATA_LFLAG_NO_SRST |
>  357                                                ATA_LFLAG_ASSUME_SEMB;
>  358                 }
> 
> 
> But the ATA_LFLAG_NO_SRST used in line 351 is not present in the
> 2.6.26 tree I know works with PMPs. The original commit comment isn't
> specific about exactly which HW had problems:
>     http://www.mail-archive.com/git-commits-head@vger.kernel.org/msg24335.html
> 
>    "Some links on some PMPs locks up on SRST and/or report incorrect
>     device signature.  Implement ATA_LFLAG_NO_SRST, ASSUME_ATA and
>     ASSUME_SEMB to handle these quirky links.  NO_SRST makes EH avoid
>     SRST.  ASSUME_ATA and SEMB forces class code to ATA and SEMB_UNSUP
>     respectively.  Note that SEMB isn't currently supported yet so the
>     _UNSUP variant is used."
> 
> Can you publish which PMP implementations sometimes lock up on SRST?

I don't remember the details but it was a 3726 or 4726 with slightly
different firmware revision.

> I doubt this is related to the problem Chandra is seeing but again,
> don't have better ideas.
> 
> BTW, this same kernel works fine without disabling port 5 (SEMB
> port).  I didn't know this until I just looked. I know previous
> source trees Google used ignored SEMB port on 3726 and I mistakenly
> assumed this one did too. :(

But the other report where the PMP device failed hardreset too was a
3/4726.  I don't know what the variables are (firmware revision
definitely is one but there seem to be others) but these pseudo
devices are extremely fragile.  Certain configurations just don't work
or work with strange quirks.  I think it would be best to just stay
away from those.

Thanks.

-- 
tejun
