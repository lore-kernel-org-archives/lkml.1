Return-Path: <linux-kernel-owner+w=401wt.eu-S1756716AbZLUMXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716AbZLUMXA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 07:23:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751546AbZLUMW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 07:22:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44995 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753404AbZLUMW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 07:22:59 -0500
Message-ID: <4B2F68AA.2020102@suse.cz>
Date: Mon, 21 Dec 2009 13:23:06 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: Michael Tokarev <mjt@tls.msk.ru>, Sam Ravnborg <sam@ravnborg.org>,
       Michael Guntsche <mike@it-loops.com>,
       Oliver Hartkopp <oliver@hartkopp.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kbuild: correct size calculation of bzImgae / fix x86
 boot
References: <20091219233457.GA4288@trillian.comsick.at>	<20091220084656.GA485@merkur.ravnborg.org>	<20091220091138.GA1793@trillian.comsick.at>	<20091220100344.GA6614@merkur.ravnborg.org>	<4B2E084D.6080105@msgid.tls.msk.ru> <m2y6kxetu8.fsf@igel.home>
In-Reply-To: <m2y6kxetu8.fsf@igel.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Schwab napsal(a):
> Does dash's printf support %b?  Then this should work.

Good idea. %b is specified by posix, so there is hope :). Does Andreas'
patch work for others as well? I'd like to fix this upstream ASAP, OTOH
right now it's broken "only" for dash users, so let's not rush and make
it even worse.

Thanks,
Michal
> 
> Andreas.
> 
> diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
> index cd815ac..340813d 100644
> --- a/scripts/Makefile.lib
> +++ b/scripts/Makefile.lib
> @@ -213,14 +213,16 @@ cmd_gzip = (cat $(filter-out FORCE,$^) | gzip -f -9 > $@) || \
>  
>  # Bzip2 and LZMA do not include size in file... so we have to fake that;
>  # append the size as a 32-bit littleendian number as gzip does.
> -size_append = printf $(shell						\
> +size_append = printf %b $$(						\
>  dec_size=0;								\
>  for F in $1; do								\
>  	fsize=$$(stat -c "%s" $$F);					\
>  	dec_size=$$(expr $$dec_size + $$fsize);				\
>  done;									\
> -printf "%08x" $$dec_size |						\
> -	sed 's/\(..\)\(..\)\(..\)\(..\)/\\\\x\4\\\\x\3\\\\x\2\\\\x\1/g'	\
> +for i in 1 2 3 4; do							\
> +	printf '\\%04o' $$(expr $$dec_size % 256);			\
> +  	dec_size=$$(expr $$dec_size / 256);				\
> +done									\
>  )
