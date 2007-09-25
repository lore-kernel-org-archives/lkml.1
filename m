Return-Path: <linux-kernel-owner+w=401wt.eu-S1755765AbXIYUiG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755765AbXIYUiG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 16:38:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752111AbXIYUhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 16:37:54 -0400
Received: from barikada.upol.cz ([158.194.242.200]:41086 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbXIYUhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 16:37:53 -0400
To: Bernhard Walle <bwalle@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       kexec@lists.infradead.org, akpm@linux-foundation.org
Subject: Re: [patch 1/7] Extended crashkernel command line
In-Reply-To: <20070925182258.175348676@strauss.suse.de>
References: <20070925182257.900701776@strauss.suse.de> <20070925182258.175348676@strauss.suse.de>
User-Agent: slrn + jed (x86_64-pc-linux-glibc-debian)
Date: Tue, 25 Sep 2007 22:53:36 +0200
Message-Id: <E1IaHPU-00089b-Bc@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Tue, 25 Sep 2007 20:22:58 +0200
>
> This is the generic part of the patch. It adds a parse_crashkernel() function
> in kernel/kexec.c that is called by the architecture specific code that
> actually reserves the memory. That function takes the whole command line and
> looks itself for "crashkernel=" in it.
[]
> +++ b/include/linux/kexec.h
> @@ -187,6 +187,8 @@ extern u32 vmcoreinfo_note[VMCOREINFO_NO
>  extern size_t vmcoreinfo_size;
>  extern size_t vmcoreinfo_max_size;
>  
> +int __init parse_crashkernel(char *cmdline, unsigned long long system_ram,
> +		unsigned long long *crash_size, unsigned long long *crash_base);

I still want to point out my consernes about `unsigned long long long'
bloat.

>  #else /* !CONFIG_KEXEC */
>  struct pt_regs;
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
[]
> +/*
> + * This function parses command lines in the format
> + *
> + *   crashkernel=<ramsize-range>:<size>[,...][@<base>]

#v+
olecom@flower:/tmp$ grep '@offset' <extended-crashkernel-cmdline.mbox
    crashkernel=<range1>:<size1>[,<range2>:<size2>,...][@offset]
-       /* crashkernel=size@offset specifies the size to reserve for a crash
+While the "crashkernel=size[@offset]" syntax is sufficient for most
+    crashkernel=<range1>:<size1>[,<range2>:<size2>,...][@offset]
+       crashkernel=range1:size1[,range2:size2,...][@offset]
olecom@flower:/tmp$ grep '@base' <extended-crashkernel-cmdline.mbox
+ *     crashkernel=size[@base]
olecom@flower:/tmp$ grep '@<base' <extended-crashkernel-cmdline.mbox
+ *   crashkernel=<ramsize-range>:<size>[,...][@<base>]
olecom@flower:/tmp$ grep '@<offset' <extended-crashkernel-cmdline.mbox
olecom@flower:/tmp$
#v-

> + *
> + * The function returns 0 on success and -EINVAL on failure.
> + */
> +static int __init parse_crashkernel_mem(char 			*cmdline,
> +					unsigned long long	system_ram,
> +					unsigned long long	*crash_size,
> +					unsigned long long	*crash_base)
> +{
> +	char *cur = cmdline;
> +
> +	/* for each entry of the comma-separated list */
> +	do {
> +		unsigned long long start = 0, end = ULLONG_MAX;
> +		unsigned long long size = -1;

memparse(), as a wrapper for somple_strtoll(), always have a return value
(zero by default).
<http://article.gmane.org/gmane.linux.kernel/583426>

Consider coded error path now, please.

And why not to make overall result reliable? This is kernel after all.

I.e. if there's valid `crashkernel=' option, but some parsing errors, why
not to apply some heuristics with warning in syslog, if user have some
conf, bootloader (random) errors, but feature still works?

> +
> +		/* get the start of the range */
> +		start = memparse(cur, &cur);
> +		if (*cur != '-') {
> +			printk(KERN_WARNING "crashkernel: '-' expected\n");
> +			return -EINVAL;
> +		}
> +		cur++;
> +
> +		/* if no ':' is here, than we read the end */
> +		if (*cur != ':') {
> +			end = memparse(cur, &cur);
> +			if (end <= start) {
> +				printk(KERN_WARNING "crashkernel: end <= start\n");
> +				return -EINVAL;
> +			}
> +		}
> +
> +		if (*cur != ':') {
> +			printk(KERN_WARNING "crashkernel: ':' expected\n");
> +			return -EINVAL;
> +		}
> +		cur++;
> +
> +		size = memparse(cur, &cur);
> +		if (size < 0) {
> +			printk(KERN_WARNING "crashkernel: invalid size\n");
> +			return -EINVAL;
> +		}
> +
> +		/* match ? */
> +		if (system_ram >= start  && system_ram <= end) {
> +			*crash_size = size;
> +			break;
> +		}
> +	} while (*cur++ == ',');
> +
> +	if (*crash_size > 0) {
> +		while (*cur != ' ' && *cur != '@')
> +			cur++;
> +		if (*cur == '@')
> +			*crash_base = memparse(cur+1, &cur);
> +	}
> +
> +	return 0;
> +}
--
-o--=O`C
 #oo'L O
<___=E M
