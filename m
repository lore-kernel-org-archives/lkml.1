Return-Path: <linux-kernel-owner+w=401wt.eu-S966860AbXIKG05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966860AbXIKG05 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 02:26:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966271AbXIKGPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 02:15:19 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:51001 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966265AbXIKGPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 02:15:16 -0400
Date: Tue, 11 Sep 2007 11:45:22 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Bernhard Walle <bwalle@suse.de>
Cc: kexec@lists.infradead.org, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/5] Extended crashkernel command line
Message-ID: <20070911061522.GD5053@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <20070909083914.065380136@strauss.suse.de> <20070909083914.488571169@strauss.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070909083914.488571169@strauss.suse.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 09, 2007 at 10:39:15AM +0200, Bernhard Walle wrote:

[..]
> +
> +/*
> + * parsing the "crashkernel" commandline
> + *
> + * this code is intended to be called from architecture specific code
> + */
> +
> +
> +/*
> + * This function parses command lines in the format
> + *
> + *   crashkernel=<ramsize-range>:<size>[,...][@<base>]
> + *
> + * The function returns 0 on success and -EINVAL on failure.
> + */
> +static int parse_crashkernel_mem(char 			*cmdline,
> +				 unsigned long long 	*crash_size,
> +				 unsigned long long 	*crash_base,
> +				 unsigned long 		system_ram)
> +{
> +	char *cur = cmdline;
> +
> +	*crash_size = 0;
> +	*crash_base = 0;
> +
> +	/* for each entry of the comma-separated list */
> +	do {
> +		unsigned long long start = 0, end = ULLONG_MAX;
> +		unsigned long long size = -1;
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

"offset" seems to be optional in the new syntax. What happens if user does
not specify offset. I think crash_base will be set to zero and system will
try to reserve x amount of memory start at zero? That would fail?

I think we should add some intelligence for automatic selection of "offset"
if user has not specified one. Automatically choose a chunk of free memory.
This takes away the headache from user for selecting a right place. In fact
one "offset" might not be valid for all the systems. I remember, somebody
had reported that ACPI tables were mapped lower in the address space and
reserving memory for kdump had failed.

Choosing the "offset" automatically should help distributions where one
command line is supposed to work on all the systems.

Thanks
Vivek
