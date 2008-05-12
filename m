Return-Path: <linux-kernel-owner+w=401wt.eu-S1757654AbYELM1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757654AbYELM1T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 08:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753917AbYELM1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 08:27:09 -0400
Received: from lazybastard.de ([212.112.238.170]:54903 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958AbYELM1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 08:27:08 -0400
Date: Mon, 12 May 2008 14:26:51 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Bryan Wu <bryan.wu@analog.com>
Cc: dwmw2@infradead.org, will.newton@gmail.com, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH try#2] [MTD/MAPS] Blackfin BF5xx Maps: Handle the case where flash memory and ethernet mac/phy are mapped onto the same async bank
Message-ID: <20080512122650.GA10014@logfs.org>
References: <1202020355.6671.23.camel@roc-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1202020355.6671.23.camel@roc-laptop>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 February 2008 14:32:35 +0800, Bryan Wu wrote:
> +
> +static void bf5xx_copy_from(struct map_info *map, void *to, unsigned long from, ssize_t len)
> +{
> +	unsigned long i;
> +	map_word test;
> +
> +	if ((unsigned long)to & 0x1) {
> +		for (i = 0; i < len / 2 * 2; i += 2) {
> +			test = bf5xx_read(map, from + i);
> +			put_unaligned(test.x[0], (__le16 *)(to + i));
> +		}
> +	} else {
> +		for (i = 0; i < len / 2 * 2; i += 2) {
> +			test = bf5xx_read(map, from + i);
> +			*((u16*)(to + i)) = test.x[0];
                        ^^^^^^^^^^^^^^^^^

I'm not particularly fond of such constructs, maybe because I have such
a hard time understanding what the code actually does.

How about:
	u16 *foo = to;

	for (i = 0; i < (len & ~1); i++) {
		test = bf5xx_read(map, from + 2 * i);
		foo[i] = test.x[0];
	}

With perhaps a better name than "foo" and the same conversion in the
rest of the function as well?

> +		}
> +	}
> +
> +	if (len & 0x1) {
> +		test = bf5xx_read(map, from + i);
> +		*((u8*)(to + i)) = (u8)test.x[0];
> +	}
> +}

Jörn

-- 
There's nothing better for promoting creativity in a medium than
making an audience feel "Hmm ­ I could do better than that!"
-- Douglas Adams in a slashdot interview
