Return-Path: <linux-kernel-owner+w=401wt.eu-S1756216AbZBBLtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216AbZBBLtT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 06:49:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752758AbZBBLtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 06:49:06 -0500
Received: from h155.mvista.com ([63.81.120.155]:11243 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752754AbZBBLtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 06:49:05 -0500
Message-ID: <4986DDA9.6010903@ru.mvista.com>
Date: Mon, 02 Feb 2009 14:48:57 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jgarzik@redhat.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Mikael Pettersson <mikpe@it.uu.se>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.29-rc libata sff 32bit PIO regression
References: <Pine.LNX.4.64.0901211322010.15945@blonde.anvils> <20090126191151.18b094e6@lxorguk.ukuu.org.uk> <Pine.LNX.4.64.0902012050190.16351@blonde.anvils>
In-Reply-To: <Pine.LNX.4.64.0902012050190.16351@blonde.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Hugh Dickins wrote:
> On Mon, 26 Jan 2009, Alan Cox wrote:
>   
>>> [PATCH] libata sff: 32bit PIO use 16bit on slop
>>>
>>> 871af1210f13966ab911ed2166e4ab2ce775b99d libata: Add 32bit PIO support
>>> causes errors on a four-year-old ata_piix Dell Precision 670.  Using
>>> 16bit PIO instead of 32bit PIO on the odd 1, 2 or 3 chars fixes that.
>>>
>>> Signed-off-by: Hugh Dickins <hugh@veritas.com>
>>>       
>> For the 3 bytes of slop it should use a single iowrite32 but otherwise
>> that seems ok. We do need to handle the FIFO setup on the AMD differently
>> if we do this ...
>>     
>
> Sorry, I believe you were waiting on me for this, to accompany your
> AMD and VLB patches.  I'm afraid I don't have any such AMD devices
> to test this along with yours, and the only non-0 slop that I've seen
> in testing has been 2 (about 25% of ops, so I removed the "unlikely").
> But this patch works as well for me as the patch I posted before
> (though much more verbose: please simplify if you see a better way).
>
>
> [PATCH] libata sff: 32bit PIO use 16bit on slop
>
> 871af1210f13966ab911ed2166e4ab2ce775b99d libata: Add 32bit PIO support
> causes errors on a four-year-old ata_piix Dell Precision 670.  Using
> 16bit PIO instead of 32bit PIO on the odd 1 or 2 chars fixes that,
> but Alan Cox indicates that we should still use 32bit for 3 chars.
>
> Signed-off-by: Hugh Dickins <hugh@veritas.com>
> ---
>
>  drivers/ata/libata-sff.c |   33 ++++++++++++++++++++++++---------
>  1 file changed, 24 insertions(+), 9 deletions(-)
>
> --- 2.6.29-rc3/drivers/ata/libata-sff.c	2009-01-29 12:33:28.000000000 +0000
> +++ linux/drivers/ata/libata-sff.c	2009-02-01 20:21:13.000000000 +0000
> @@ -773,18 +773,33 @@ unsigned int ata_sff_data_xfer32(struct
>  	else
>  		iowrite32_rep(data_addr, buf, words);
>  
> -	if (unlikely(slop)) {
> -		__le32 pad;
> -		if (rw == READ) {
> -			pad = cpu_to_le32(ioread32(ap->ioaddr.data_addr));
> -			memcpy(buf + buflen - slop, &pad, slop);
> +	if (slop) {
> +		unsigned char *trailing_buf = buf + buflen - slop;
>   
> +   
>   
> +		if (slop <= 2) {
> +			__le16 slop_word;
> +			if (rw == READ) {
> +				slop_word = cpu_to_le16(ioread16(data_addr));
> +				memcpy(trailing_buf, &slop_word, slop);
> +			} else {
> +				slop_word = 0;
> +				memcpy(&slop_word, trailing_buf, slop);
> +				iowrite16(le16_to_cpu(slop_word), data_addr);
> +			}
>  		} else {
> -			memcpy(&pad, buf + buflen - slop, slop);
> -			iowrite32(le32_to_cpu(pad), ap->ioaddr.data_addr);
> +			__le32 slop_word;
> +			if (rw == READ) {
> +				slop_word = cpu_to_le32(ioread32(data_addr));
> +				memcpy(trailing_buf, &slop_word, slop);
> +			} else {
> +				slop_word = 0;
> +				memcpy(&slop_word, trailing_buf, slop);
> +				iowrite32(le32_to_cpu(slop_word), data_addr);
> +			}
>   

   How about the following?

		unsigned char *tail = buf + buflen - slop;
		unsigned char pad[4];

		if (rw == READ) {
			if (slop <= 2)
				ioread16_rep(data_addr, pad, 1);
			else
				ioread32_rep(data_addr, pad, 1);
			memcpy(tail, pad, slop);
 		} else {
			memcpy(pad, tail, slop);
			memset(pad + slop, 0, 4 - slop);
			if (slop <= 2)
				iowrite16_rep(data_addr, pad, 1);
			else
				iowrite32_rep(data_addr, pad, 1);
		}

>  	}
> -	return words << 2;
> +
> +	return buflen + (buflen & 1);
>   

    return (buflen + 1) & ~1;

   Well, I guess I could just have posted my own patch... :-)

MBR, Sergei


