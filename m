Return-Path: <linux-kernel-owner+w=401wt.eu-S1751458AbZCKUpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458AbZCKUpq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 16:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750941AbZCKUph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 16:45:37 -0400
Received: from n16a.bullet.mail.mud.yahoo.com ([68.142.207.126]:32106 "HELO
	n16a.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750916AbZCKUpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 16:45:36 -0400
X-Yahoo-Newman-Id: 174091.22841.bm@omp418.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=QYoQmCv4aYN8sOISMv0kzCcFZwF72kQ5ahOxiXipe+uTPZUIO1Rp+CO8PRuGhmksM2xsKCTZO+JJOjlqmaSOEwmsTSalAcDw8QZ2r/IoxOEK57EX7NEV+WmbSTFyyQDv+Kd1oOBU67G8Io8PiNGsLLc0iahKkxHJT8bvUuL9uH0=  ;
X-YMail-OSG: F.rez.UVM1mIvEuWgjh3CINrhWnWZ9X5Jw9qT8Kbs5NyN0zt0Onkvct6UG7M2JNdd2IELF22V2QCIdBcqYrs.9YibHYJFrV_8u9gAcjUtg1RDdIifF.G.k2peAQ1T6MocOly_ExXvM2wXAaO2tEg3SzT
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Wolfgang =?iso-8859-1?q?M=FCes?= <wolfgang.mues@auerswald.de>
Subject: Re: [PATCH 3/7] mmc_spi: adjust for delayed data token response
Date: Wed, 11 Mar 2009 12:45:32 -0800
User-Agent: KMail/1.9.10
Cc: Pierre Ossman <drzeus@drzeus.cx>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Matt Fleming" <matt@console-pimps.org>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
References: <200903111421.56295.wolfgang.mues@auerswald.de>
In-Reply-To: <200903111421.56295.wolfgang.mues@auerswald.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200903111345.33154.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 March 2009, Wolfgang Mües wrote:
> @@ -639,8 +640,23 @@ mmc_spi_writeblock(struct mmc_spi_host *
>  	 * doesn't necessarily tell whether the write operation succeeded;
>  	 * it just says if the transmission was ok and whether *earlier*
>  	 * writes succeeded; see the standard.
> -	 */
> -	switch (SPI_MMC_RESPONSE_CODE(scratch->status[0])) {
> +	 *
> +	 * In practice, there are (even modern SDHC-)Cards which need
> +	 * some bits to send the response, so we have to cope with this

All hardware needs some bits to send binary data!!

Do you mean "which don't send byte-aligned responses,
contrary to MMC/SD/SDIO specifications"?


> +	 * situation and check the response bit-by-bit. Arggh!!!
> +	 */
> +	pattern  = scratch->status[0] << 24;
> +	pattern |= scratch->status[1] << 16;
> +	pattern |= scratch->status[2] << 8;
> +	pattern |= scratch->status[3];
> +
> +	/* left-adjust to leading 0 bit */
> +	while (pattern & 0x80000000)
> +		pattern <<= 1;
> +	/* right-adjust for pattern matching. Code is in bit 4..0 now. */
> +	pattern >>= 27;
> +
> +	switch (pattern) {
>  	case SPI_RESPONSE_ACCEPTED:
>  		status = 0;
>  		break;
> @@ -671,8 +687,8 @@ mmc_spi_writeblock(struct mmc_spi_host *
>  	/* Return when not busy.  If we didn't collect that status yet,
>  	 * we'll need some more I/O.
>  	 */
> -	for (i = 1; i < sizeof(scratch->status); i++) {
> -		if (scratch->status[i] != 0)
> +	for (i = 4; i < sizeof(scratch->status); i++) {
> +		if (scratch->status[i] & 0x01)

I think I see why you skip four bytes, since you used
them above.  But why change the "!= 0" test?


>  			return 0;
>  	}
>  	return mmc_spi_wait_unbusy(host, timeout);
> 
> ---
> regards
> 

