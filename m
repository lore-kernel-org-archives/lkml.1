Return-Path: <linux-kernel-owner+w=401wt.eu-S1758593AbYEMIIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758593AbYEMIIA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 04:08:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754831AbYEMIHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 04:07:44 -0400
Received: from lazybastard.de ([212.112.238.170]:38454 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754782AbYEMIHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 04:07:43 -0400
Date: Tue, 13 May 2008 10:07:27 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Bryan Wu <cooloney@kernel.org>
Cc: dwmw2@infradead.org, will.newton@gmail.com, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH 1/1] [MTD/MAPS] Blackfin Async Flash Maps: Handle the case where flash memory and ethernet mac/phy are mapped onto the same async bank
Message-ID: <20080513080727.GA15795@logfs.org>
References: <1210653525-19437-1-git-send-email-cooloney@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1210653525-19437-1-git-send-email-cooloney@kernel.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2008 12:38:45 +0800, Bryan Wu wrote:
>
> +#define pr_devinit(fmt, args...) ({ static const __devinitdata char __fmt[] = fmt; printk(__fmt, ## args); })

Is this still needed?

> +static void bfin_copy_from(struct map_info *map, void *to, unsigned long from, ssize_t len)
> +{
> +	size_t i;
> +	map_word test;
> +
> +	if ((unsigned long)to & 0x1) {
> +		for (i = 0; i < len; i += 2) {
> +			u16 *dst = (u16 *)(to + i);
> +			test = bfin_read(map, from + i);
> +			put_unaligned(test.x[0], dst);
> +		}
> +	} else {
> +		for (i = 0; i < len; i += 2) {
> +			u16 *dst = (u16 *)(to + i);
> +			test = bfin_read(map, from + i);
> +			*dst = test.x[0];
> +		}
> +	}
> +
> +	if (len & 0x1) {
> +		u8 *last_to_byte = (u8 *)(to + i);
> +		test = bfin_read(map, from + i);
> +		*last_to_byte = (u8)test.x[0];
> +	}
> +}

The pointer casts are superfluous.  Linus prefers variable declarations
up front (sorry for my bad example).  The "+ i" in the last conditional
is a bit dangerous as any changes to the loop can break it.  Linux code
has lots of churn and not everyone is careful enough to spot such
subtleties.
And I believe you can improve performance by killing the put_unaligned
in the loop.  So if we put it all together the end result should be
something like this:

static void bfin_copy_from(struct map_info *map, void *to, unsigned long from, ssize_t len)
{
	size_t i;
	map_word test;
	u8 *byte;
	u16 *dst;

	if ((unsigned long)to & 0x1) {
		byte = to;
		test = bfin_read(map, from);
		*byte = test.x[0] >> 8;
		to++;
		from++;
		len--;
	}

	for (i = 0; i < len; i += 2) {
		dst = to + i;
		test = bfin_read(map, from + i);
		*dst = test.x[0];
	}

	if ((len & 0x1) {
		byte = to + len - 1;
		test = bfin_read(map, from + len - 1);
		*byte = test.x[0] & 0xff;
	}
}

What do you think?

> +static void bfin_write(struct map_info *map, map_word d1, unsigned long ofs)
> +{
> +	struct async_state *state = (struct async_state *)map->map_priv_1;
> +	u16 d;
> +
> +	d = (u16)d1.x[0];

You didn't need the cast above.  Why here?

Otherwise looks good to me.

Jörn

-- 
Debugging is twice as hard as writing the code in the first place.
Therefore, if you write the code as cleverly as possible, you are,
by definition, not smart enough to debug it.
-- Brian W. Kernighan
