Return-Path: <linux-kernel-owner+w=401wt.eu-S1756163AbYD2CnB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163AbYD2CnB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 22:43:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752892AbYD2Cmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 22:42:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58182 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752810AbYD2Cmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 22:42:49 -0400
Date: Mon, 28 Apr 2008 19:42:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: yhlu.kernel@gmail.com
Cc: Yinghai Lu <yhlu.kernel.send@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Gabriel C <nix.or.die@googlemail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Mika Fischer <mika.fischer@zoopnet.de>
Subject: Re: [PATCH] x86: mtrr cleanup for converting continuous to discrete
 layout v5
Message-Id: <20080428194200.c778029a.akpm@linux-foundation.org>
In-Reply-To: <200804281505.05764.yhlu.kernel@gmail.com>
References: <200804272337.40130.yhlu.kernel@gmail.com>
	<200804281244.56938.yhlu.kernel@gmail.com>
	<200804281316.14168.yhlu.kernel@gmail.com>
	<200804281505.05764.yhlu.kernel@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2008 15:05:05 -0700 Yinghai Lu <yhlu.kernel.send@gmail.com> wrote:

> 
> some BIOS like to use continus MTRR layout, and may X driver can not add
> WB entries for graphical cards when 4g or more RAM installed.
> 
> the patch will change MTRR to discrete.
> 
> mtrr_chunk_size= could be used to have smaller continuous block to hold holes.
> default is 256m, could be set according to size of graphics card memory.
> 
> v2: fix -1 for UC checking
> v3: default to disable, and need use enable_mtrr_cleanup to enable this feature
>     skip the var state change warning.
>     remove next_basek in range_to_mtrr()
> v4: correct warning mask.
> v5: CONFIG_MTRR_SANITIZER
> 
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

> +#ifdef CONFIG_MTRR_SANITIZER
> +
> +#ifdef CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT

I don't think these newly-added config items should exist, sorry.  But
then, the changelog does't describe _why_ they exist (it should!) and I
probably missed it in the discusson.

Anyone who distributes a kernel will need to enable both
CONFIG_MTRR_SANITIZER and CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT, so the
config items are only useful for saving a bit of kernel text in custom
kernel builds.

> +static int enable_mtrr_cleanup __initdata = 1;
> +#else
> +static int enable_mtrr_cleanup __initdata;

The disable_mtrr_cleanup and enable_mtrr_cleanup boot options are also
problematic.  We really really want this stuff to all happen automatically.

What happens with this sort of thing is that people's machines misbehave
and I expect most of them never find out about the magic option.  They
give up on Linux or use a different computer or use a different distro
which happened to set the option the other way, etc, etc.  Some people will
think to do a bit of googling and might stumble across the option after a
while.

It's all rather user-unfriendly and we should try really hard to just make
things work.  Is this at all possible?


Anyway.  I think the problem which you have identified is solveable in
userspace, isn't it?  Read the existing mtrr settings and rewrite them in a
better form?  If so, we could prepare a little program which does that and
make the X people and distributors aware of it.  This has the significant
advantage that it will fix pre-2.6.26 kernels too.

> +#endif
> +
> +#else
> +
> +static int enable_mtrr_cleanup __initdata = -1;
> +
> +#endif
> +
> +static int __init disable_mtrr_cleanup_setup(char *str)
> +{
> +	if (enable_mtrr_cleanup != -1)
> +		enable_mtrr_cleanup = 0;
> +	return 0;
> +}
> +early_param("disable_mtrr_cleanup", disable_mtrr_cleanup_setup);
> +
> +static int __init enable_mtrr_cleanup_setup(char *str)
> +{
> +	if (enable_mtrr_cleanup != -1)
> +		enable_mtrr_cleanup = 1;
> +	return 0;
> +}
> +early_param("enble_mtrr_cleanup", enable_mtrr_cleanup_setup);
> +
> +#define RANGE_NUM 256
> +
> +struct res_range {
> +	size_t start;
> +	size_t end;
> +};

size_t is a surprising choice of type.

> +static void __init subtract_range(struct res_range *range, size_t start,
> +				size_t end)
> +{
> +	int i;
> +	int j;
> +
> +	for (j = 0; j < RANGE_NUM; j++) {
> +		if (!range[j].end)
> +			continue;
> +
> +		if (start <= range[j].start && end >= range[j].end) {
> +			range[j].start = 0;
> +			range[j].end = 0;
> +			continue;
> +		}
> +
> +		if (start <= range[j].start && end < range[j].end && range[j].start < end + 1) {

We prefer that code remain within 0 columns, please.

> +			range[j].start = end + 1;
> +			continue;
> +		}
> +
> +
> +		if (start > range[j].start && end >= range[j].end && range[j].end > start - 1) {
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
> +
> +static int __cpuinit cmp_range(const void *x1, const void *x2)

You wanted __init here.


