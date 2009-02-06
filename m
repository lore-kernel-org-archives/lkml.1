Return-Path: <linux-kernel-owner+w=401wt.eu-S1753567AbZBFQuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567AbZBFQuX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 11:50:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752621AbZBFQuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 11:50:05 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:4900 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051AbZBFQuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 11:50:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=LL9kWsx/+5jmxpGDAOQ3GVZ2fhlMQFzmqMOJoQoEWzGlsFQQLiKYpcC68y/rCSnFKF
         ngtvsi7qpznHqpDh4w6dt9gPLh5Qs8OFzlIkPSuJoYGMftF4+xHQuVggRrYJnVtUm8RU
         qrYTy+3wdnml7Hx0hcoZRU3S8aS2CyjqE2Euw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 01/15] ide: include <asm/ide.h> only when needed
Date: Fri, 6 Feb 2009 17:21:46 +0100
User-Agent: KMail/1.10.4 (Linux/2.6.29-rc3-next-20090206; KDE/4.1.4; i686; ; )
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>, geert@linux-m68k.org,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       apw@canonical.com
References: <20090201174916.19144.11318.sendpatchset@localhost.localdomain> <200902052214.31483.bzolnier@gmail.com> <498B7D09.6040100@ru.mvista.com>
In-Reply-To: <498B7D09.6040100@ru.mvista.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200902061721.46813.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Friday 06 February 2009, Sergei Shtylyov wrote:
> Hello.
> 
> Bartlomiej Zolnierkiewicz wrote:
> 
> >>>>> +#include <asm/ide.h>
> >>>>>           
> >>>> Did you try checkpatch.pl?
> >>>>         
> >>> Sure.
> >>>
> >>> This driver uses stuff from <asm-mips/ide.h>.
> >>>
> >>> [ I guess I could put '-mips' there to silence warnings on tx493{8,9}.c,
> >>>   however I don't know of the way to get rid of ide-io-std.c's one... ]
> >>>       
> >> BTW, tx4939ide_{in,out}put_data_swap and
> >> tx4939ide_{in,out}put_data_swap do exactly same thing.
> >>
> >> If byte-swapped version of ide_{in,out}put_data() were available by
> >> ide core, they can be used instead.  The byte-swapped version of
> >> default_tp_ops would much helps such queer big-endian platforms.  Is
> >> it worth to bloat ide core? ;-)
> >>     
> >
> > Seems to be a good idea and it may also help some other host drivers
> > (ide-h8300.c?).
> >   
> 
>    I'm not sure we need to carry the extra little used code just to help 
> some exotic driver.

It doesn't seem like we would need to carry any extra extra code for host
drivers that don't need it because we have flexible Kconfig language to take
care of such cases, i.e.

...
config CONFIG_IDE_BE_IO
	bool
...
config BLK_DEV_IDE_TX4938
	tristate "TX4938 internal IDE support"
	depends on SOC_TX4938
	select IDE_TIMINGS
	select IDE_BE_IO
...

Thus having be_tp_ops would decrease code duplication [ I now also see that
m68k host drivers would benefit from it.  I haven't noticed it before because
readw()/writew() are redefined in <asm-m68k/ide.h> ] and decrease total IDE
subsystem maintainance costs.

Thanks,
Bart
