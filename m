Return-Path: <linux-kernel-owner+w=401wt.eu-S1761599AbYD2NHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761599AbYD2NHo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 09:07:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761397AbYD2NHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 09:07:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44181 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761362AbYD2NHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 09:07:20 -0400
Date: Tue, 29 Apr 2008 15:07:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: yhlu.kernel@gmail.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Gabriel C <nix.or.die@googlemail.com>,
       Mika Fischer <mika.fischer@zoopnet.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86: mtrr cleanup for converting continuous to
	discrete layout v8
Message-ID: <20080429130704.GC24766@elte.hu>
References: <200804272337.40130.yhlu.kernel@gmail.com> <200804281505.05764.yhlu.kernel@gmail.com> <200804290200.33459.yhlu.kernel@gmail.com> <200804290352.33543.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804290352.33543.yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


a few minor cleanliness observations:

> +#ifdef CONFIG_MTRR_SANITIZER
> +
> +#ifdef CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT
> +static int enable_mtrr_cleanup __initdata = 1;
> +#else
> +static int enable_mtrr_cleanup __initdata;
> +#endif
> +
> +#else
> +
> +static int enable_mtrr_cleanup __initdata = -1;
> +
> +#endif

this should be a single:

 #ifdef CONFIG_MTRR_SANITIZER
 static int mtrr_cleanup_enabled = CONFIG_MTRR_SANITIZER_DEFAULT;
 #endif

block.

> +#define RANGE_NUM 256

small explaination (comment) about what the limit means.

> +static int __init add_range(struct res_range *range, int nr_range, unsigned long start,
> +			      unsigned long end, int merge)

looks cleaner this way:

  static int __init
  add_range(struct res_range *range, int nr_range, unsigned long start,
            unsigned long end, int merge)

> +{
> +	int i;
> +
> +	if (!merge)
> +		goto addit;
> +
> +	/* try to merge it with old one */
> +	for (i = 0; i < nr_range; i++) {
> +		unsigned long final_start, final_end;
> +		unsigned long common_start, common_end;
> +
> +		if (!range[i].end)
> +			continue;
> +
> +		common_start = max(range[i].start, start);
> +		common_end = min(range[i].end, end);
> +		if (common_start > common_end + 1)
> +			continue;
> +
> +		final_start = min(range[i].start, start);
> +		final_end = max(range[i].end, end);
> +
> +		range[i].start = final_start;
> +		range[i].end =  final_end;
> +		return nr_range;
> +	}
> +
> +addit:

perhaps factor out the loop into a separate function and avoid the goto.

> +static void __init subtract_range(struct res_range *range, unsigned long start,
> +				unsigned long end)

should be:

 static void __init
 subtract_range(struct res_range *range, unsigned long start,
                unsigned long end)

> +	int i;
> +	int j;

can be:

	int i, j;

> +		}
> +
> +

stale newline.

> +		if (start > range[j].start && end >= range[j].end && range[j].end > start - 1) {

should be some sort of more readable in_range() check?

> +			range[j].end = start - 1;
> +			continue;
> +		}
> +
> +		if (start > range[j].start && end < range[j].end) {
> +			/* find the new spare */
> +			for (i = 0; i < RANGE_NUM; i++) {
> +				if (range[i].end == 0)
> +					break;
> +			}
> +			if (i < RANGE_NUM) {
> +				range[i].end = range[j].end;
> +				range[i].start = end + 1;
> +			} else {
> +				printk(KERN_ERR "run of slot in ranges\n");
> +			}
> +			range[j].end = start - 1;
> +			continue;
> +		}
> +	}
> +}

> +struct var_mtrr_state {
> +	unsigned long range_startk, range_sizek;
> +	unsigned long chunk_sizek;
> +	unsigned long gran_sizek;
> +	unsigned int reg;
> +	unsigned address_bits;
> +};

s/unsigned address_bits/unsigned int address_bits/

also move range_sizek on a separate line.

plus we tend to align structures this way:

> +struct var_mtrr_state {
> +	unsigned long		range_startk;
> +	unsigned long		range_sizek;
> +	unsigned long		chunk_sizek;
> +	unsigned long		gran_sizek;
> +	unsigned int		reg;
> +	unsigned int		address_bits;
> +};

(to put the types and field names into a visually more consistent form)

> +static void __init set_var_mtrr(
> +	unsigned int reg, unsigned long basek, unsigned long sizek,
> +	unsigned char type, unsigned address_bits)

should be:

 static void __init
 set_var_mtrr(unsigned int reg, unsigned long basek, unsigned long sizek,
              unsigned char type, unsigned address_bits)

> +	u32 base_lo, base_hi, mask_lo, mask_hi;
> +	unsigned address_mask_high;

s/unsigned/unsigned int

hm, will this work on 64-bit? Above-4G is controlled via separate 
mechanisms though so i guess it does.

> +	address_mask_high = ((1u << (address_bits - 32u)) - 1u);

use alignment macros instead.

> +		unsigned long sizek;
> +		/* Compute the maximum size I can make a range */
> +		if (range_startk)

put extra newline between variable definition and code.

> +	var_state.range_startk = 0;
> +	var_state.range_sizek = 0;
> +	var_state.reg = 0;
> +	var_state.address_bits = address_bits;
> +	var_state.chunk_sizek = mtrr_chunk_size >> 10;
> +	var_state.gran_sizek = mtrr_gran_size >> 10;

initialization looks nicer with vertical alignment, i.e.:

> +	var_state.range_startk	= 0;
> +	var_state.range_sizek	= 0;
> +	var_state.reg		= 0;
> +	var_state.address_bits	= address_bits;
> +	var_state.chunk_sizek	= mtrr_chunk_size >> 10;
> +	var_state.gran_sizek	= mtrr_gran_size >> 10;

> +	/* Clear out the extra MTRR's */
> +	while (var_state.reg < num_var_ranges)
> +		set_var_mtrr(var_state.reg++, 0, 0, 0, var_state.address_bits);

the ++ is a hard to notice side-effect of the loop. It's cleaner to 
separate it out or to have a for() loop for it.

> +static int __init mtrr_cleanup(unsigned address_bits)
> +{
> +	unsigned long i, base, size, def, dummy;
> +	mtrr_type type;
> +	struct res_range range[RANGE_NUM];
> +	int nr_range;
> +	unsigned long extra_remove_base, extra_remove_size;

try to use a 'christmas tree' ordering of variables, i.e.:

> +	unsigned long extra_remove_base, extra_remove_size;
> +	unsigned long i, base, size, def, dummy;
> +	struct res_range range[RANGE_NUM];
> +	mtrr_type type;
> +	int nr_range;

> +	return 1;
> +
> +}

superfluous newline.

all in one, this is a very useful and nice feature.

	Ingo
