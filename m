Return-Path: <linux-kernel-owner+w=401wt.eu-S1763239AbYESSWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763239AbYESSWi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 14:22:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759844AbYESSW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 14:22:28 -0400
Received: from gv-out-0910.google.com ([216.239.58.190]:30991 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760818AbYESSW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 14:22:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=W42AMO+TmmVY8dPudQt+cjLDril3G6uXV7eMnH399CAf6C87ETwyEWkFI1B2dk/A65MdeNx3ZFxQ5l9mRrj5cUefyNojmprMq/4FgbwQTX/KHuSrXIPISyQ6+9wpYfEpc89GqWO7G9gMiyRS1wNFGIvOSmVhgAmd7T8R32xbHGo=
Date: Mon, 19 May 2008 22:22:14 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andi Kleen <andi@firstfloor.org>, Paulo Marques <pmarques@grupopie.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: /proc/kallsyms broken in 2.6.26-rc1-git6
Message-ID: <20080519182214.GD7773@cvg>
References: <4824A7B6.70306@firstfloor.org> <4824AD3C.3070506@grupopie.com> <20080509233742.GA22265@martell.zuzino.mipt.ru> <48281540.9020207@grupopie.com> <20080512155052.GB6913@cvg> <20080512172323.GA9236@uranus.ravnborg.org> <20080513095437.GJ31954@one.firstfloor.org> <20080519181118.GA22931@uranus.ravnborg.org> <20080519181543.GC7773@cvg> <20080519182115.GA24285@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080519182115.GA24285@uranus.ravnborg.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Sam Ravnborg - Mon, May 19, 2008 at 08:21:15PM +0200]
| On Mon, May 19, 2008 at 10:15:43PM +0400, Cyrill Gorcunov wrote:
| > [Sam Ravnborg - Mon, May 19, 2008 at 08:11:18PM +0200]
| > | On Tue, May 13, 2008 at 11:54:37AM +0200, Andi Kleen wrote:
| > | > > I expect it to be a toolchain issue. Andi is often running with gcc versions
| > | > > that are very new (fresh from svn maybe). I dunno about binutils.
| > | > 
| > | > No actually that's a pretty old version from SUSE 10.2
| > | > 
| > | > gcc-4.1.3-29
| > | > binutils-2.17.50.0.5-21
| > | > 
| > | > This means i've been recently trying to get the x86-64 kernel to work
| > | > with the new gold linker from binutils mainline, but it's far from
| > | > booting yet and was not used here.
| > | > 
| > | > > To reproduce I would expect that a very recent gcc/binutils is needed.
| > | > > Andi?
| > | > 
| > | > Just a SUSE 10.2 toolchain. You can probably rpm2cpio it from any 
| > | > SUSE mirror.
| > | 
| > | I have just commit the following that should fix it.
| > | 
| > | 	Sam
| > | 
| > | commit aab34ac8582303ef57b792710fc5dd5991477475
| > | Author: Sam Ravnborg <sam@ravnborg.org>
| > | Date:   Mon May 19 20:07:58 2008 +0200
| > | 
| > |     kbuild: filter away debug symbols from kernel symbols
| > |     
| > |     Andi Kleen <andi@firstfloor.org>
| > |     reported that he saw a lot of symbols like this:
| > |     
| > |     0000000000000b24 N DW.aio.h.903a6d92.2
| > |     0000000000000bce N DW.task_io_accounting.h.8d8de327.0
| > |     0000000000000bec N DW.hrtimer.h.c23659c6.0
| > |     
| > |     in his System.map / kallsyms output.
| > |     
| > |     Simple solution is to skip all debugging
| > |     symbols (they are marked 'N').
| > |     
| > |     Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
| > |     Cc: Paulo Marques <pmarques@grupopie.com>
| > | 
| > | diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
| > | index 5d20a2e..ad2434b 100644
| > | --- a/scripts/kallsyms.c
| > | +++ b/scripts/kallsyms.c
| > | @@ -108,6 +108,9 @@ static int read_symbol(FILE *in, struct sym_entry *s)
| > |  	/* exclude also MIPS ELF local symbols ($L123 instead of .L123) */
| > |  	else if (str[0] == '$')
| > |  		return -1;
| > | +	/* exclude debugging symbols */
| > | +	else if (stype == 'N')
| > | +		return -1;
| > |  
| > |  	/* include the type field in the symbol name, so that it gets
| > |  	 * compressed together */
| > | diff --git a/scripts/mksysmap b/scripts/mksysmap
| > | index 4390fab..6e133a0 100644
| > | --- a/scripts/mksysmap
| > | +++ b/scripts/mksysmap
| > | @@ -32,6 +32,7 @@
| > |  # For System.map filter away:
| > |  #   a - local absolute symbols
| > |  #   U - undefined global symbols
| > | +#   N - debugging symbols
| > |  #   w - local weak symbols
| > |  
| > |  # readprofile starts reading symbols when _stext is found, and
| > | @@ -40,5 +41,5 @@
| > |  # so we just ignore them to let readprofile continue to work.
| > |  # (At least sparc64 has __crc_ in the middle).
| > |  
| > | -$NM -n $1 | grep -v '\( [aUw] \)\|\(__crc_\)\|\( \$[adt]\)' > $2
| > | +$NM -n $1 | grep -v '\( [aNUw] \)\|\(__crc_\)\|\( \$[adt]\)' > $2
| > |  
| > | 
| > 
| > Hi Sam,
| > 
| > should not there be
| > 
| > 	toupper(stype) == 'N'
| > 
| > (just a guess)
| 
| I conisered this. But decided that we could do so if we needed it later.
| In the nm output I got they were all 'N'.
| 
| 	Sam
| 

ok, thanks

		- Cyrill -
