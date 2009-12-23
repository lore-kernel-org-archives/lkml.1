Return-Path: <linux-kernel-owner+w=401wt.eu-S1756681AbZLWUMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681AbZLWUMP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 15:12:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753892AbZLWUMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 15:12:14 -0500
Received: from crmm.lgl.lu ([158.64.72.228]:56216 "EHLO lll.lu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753891AbZLWUMN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 15:12:13 -0500
Message-ID: <4B32796B.90001@lll.lu>
Date: Wed, 23 Dec 2009 21:11:23 +0100
From: alain <alain@knaff.lu>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andi Kleen <andi@firstfloor.org>, Mark Hounschell <markh@compro.net>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "dmarkh@cfl.rr.com" <dmarkh@cfl.rr.com>, Alain Knaff <alain@knaff.lu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "fdutils@fdutils.linux.lu" <fdutils@fdutils.linux.lu>,
       "Li, Shaohua" <shaohua.li@intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Fdutils] DMA cache consistency bug introduced in 2.6.28
References: <4AFB3962.2020106@ntlworld.com> <4B2B4485.6000305@cfl.rr.com> <4B2B5F86.1090403@cfl.rr.com> <alpine.LFD.2.00.0912180716400.3712@localhost.localdomain> <4B2B9F9F.7040802@compro.net> <alpine.LFD.2.00.0912180734220.3712@localhost.localdomain> <4B2BE05B.9050006@compro.net> <alpine.LFD.2.00.0912181213540.3712@localhost.localdomain> <4B30E1B4.7000702@compro.net> <alpine.LFD.2.00.0912220922250.31313@localhost.localdomain> <4B310879.9050701@compro.net> <1261525076.16916.4.camel@localhost.localdo main> <4B3162BC.9000508@cfl.rr.com> <4B3214EC.6020308@compro.net> <6598A4E21F1DB24D80BF72956484F59802EFD1C6@orsmsx001.amr.corp.intel.com> <4B32386B.2060509@compro.net> <alpine.LFD.2.00.0912230828230.6879@localhost.localdomain> <87bphpd4rt.fsf@basil.nowhere.org> <alpine.LFD.2.00.0912230845550.6879@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0912230845550.6879@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:

> diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
> index 3266b4f..9c9148c 100644
> --- a/drivers/block/floppy.c
> +++ b/drivers/block/floppy.c
> @@ -2237,13 +2237,10 @@ static void setup_format_params(int track)
>  	for (count = 1; count <= F_SECT_PER_TRACK; ++count) {
>  		here[n].sect = count;
>  		n = (n + il) % F_SECT_PER_TRACK;
> -		if (here[n].sect) {	/* sector busy, find next free sector */
> +		while (here[n].sect) {	/* sector busy, find next free sector */
>  			++n;
> -			if (n >= F_SECT_PER_TRACK) {
> +			if (n >= F_SECT_PER_TRACK)
>  				n -= F_SECT_PER_TRACK;
> -				while (here[n].sect)
> -					++n;
> -			}
>  		}
>  	}
>  	if (_floppy->stretch & FD_SECTBASEMASK) {

The original code does indeed look a little bit strange... and might
break if there is a long run of "busy" sectors near the end of the
physical track. Or maybe there is a mathematical reason why this
situation cannot occur. I'll have to think about it a little bit more to
come up with a test case that will break either the new or old code.

But in any case, if a bug would occur due to this code, it would only
depend on the format's parameters, and not on the hardwarde.

Regards,

Alain
