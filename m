Return-Path: <linux-kernel-owner+w=401wt.eu-S1756690AbXFZFCB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690AbXFZFCB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 01:02:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752945AbXFZFBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 01:01:39 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51903 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752379AbXFZFBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 01:01:38 -0400
Date: Mon, 25 Jun 2007 22:01:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Duane Griffin <duaneg@dghda.com>, linux-kernel@vger.kernel.org,
       didier <did447@gmail.com>, Solra Bizna <sbizna@tejat.net>,
       Daniel Drake <dsd@gentoo.org>
Subject: Re: [patch 2/2] HFS+: Add custom dentry hash and comparison
 operations
Message-Id: <20070625220118.199f86a8.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0706251412030.1817@scrub.home>
References: <20070620000644.891099313@dastardly.home.dghda.com>
	<20070620000647.280620153@dastardly.home.dghda.com>
	<Pine.LNX.4.64.0706251412030.1817@scrub.home>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jun 2007 14:17:19 +0200 (CEST) Roman Zippel <zippel@linux-m68k.org> wrote:

> +/*
> + * Hash a string to an integer as appropriate for the HFS+ filesystem.
> + * Composed unicode characters are decomposed and case-folding is performed
> + * if the appropriate bits are (un)set on the superblock.
> + */
> +int hfsplus_hash_dentry(struct dentry *dentry, struct qstr *str)
> +{
> +	struct super_block *sb = dentry->d_sb;
> +	const char *astr;
> +	const u16 *dstr;
> +	int casefold, decompose, size, dsize, len;
> +	unsigned long hash;
> +	wchar_t c;
> +	u16 c2;
> +
> +	casefold = (HFSPLUS_SB(sb).flags & HFSPLUS_SB_CASEFOLD);
> +	decompose = !(HFSPLUS_SB(sb).flags & HFSPLUS_SB_NODECOMPOSE);
> +	hash = init_name_hash();
> +	astr = str->name;
> +	len = str->len;
> +	while (len > 0) {
> +		size = asc2unichar(sb, astr, len, &c);
> +		astr += size;
> +		len -= size;
> +
> +		if (decompose && (dstr = decompose_unichar(c, &dsize))) {
> +			do {
> +				c2 = *dstr++;
> +				if (!casefold || (c2 = case_fold(c2)))
> +					hash = partial_name_hash(c2, hash);
> +			} while (--dsize > 0);

Are you really sure that we cannot start this loop with dsize==0?  This isn't
obviously true to these bleary eyes.

> +		} else {
> +			c2 = c;
> +			if (!casefold || (c2 = case_fold(c2)))
> +				hash = partial_name_hash(c2, hash);
> +		}
> +	}
> +	str->hash = end_name_hash(hash);
