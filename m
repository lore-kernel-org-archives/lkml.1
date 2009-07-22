Return-Path: <linux-kernel-owner+w=401wt.eu-S1756574AbZGVD0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574AbZGVD0e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 23:26:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756268AbZGVD0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 23:26:34 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57321 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751406AbZGVD0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 23:26:33 -0400
Message-ID: <4A66868F.4010001@cn.fujitsu.com>
Date: Wed, 22 Jul 2009 11:25:03 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       bblum@google.com, linux-kernel@vger.kernel.org, menage@google.com,
       vda.linux@googlemail.com, mikew@google.com
Subject: Re: [RFCv2][PATCH] flexible array implementation
References: <20090721220017.60A219D3@kernel>
In-Reply-To: <20090721220017.60A219D3@kernel>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +/**
> + * flex_array_put - copy data into the array at @element_nr
> + * @src:	address of data to copy into the array
> + * @element_nr:	index of the position in which to insert
> + * 		the new element.

@fa and @flags are not documented.

> + *
> + * Note that this *copies* the contents of @src into
> + * the array.  If you are trying to store an array of
> + * pointers, make sure to pass in &ptr instead of ptr.
> + *
> + * Locking must be provided by the caller.
> + */
> +int flex_array_put(struct flex_array *fa, int element_nr, void *src, gfp_t flags)
> +{
> +	int part_nr = fa_element_to_part_nr(fa, element_nr);
> +	struct flex_array_part *part;
> +	void *dst;
> +
> +	part = __fa_get_part(fa, part_nr, flags);
> +	if (!part)
> +		return -ENOMEM;

So this may allocate memory, and has disavantages:

- If flex_array_put() is called in atomic context, flags has to be GFP_ATOMIC.
- and thus it may fail.

Since we pass the total_elem to flex_array_alloc(), how about add a flag,
and if the flag is set, the alloc() will also allocate all fa_parts?

And add __flex_array_put(), which assumes fa_parts has been allocated.

> +	dst = &part->elements[offset_inside_part(fa, element_nr)];
> +	memcpy(dst, src, fa->element_size);
> +	return 0;
> +}
> +
