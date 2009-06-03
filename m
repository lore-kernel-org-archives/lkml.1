Return-Path: <linux-kernel-owner+w=401wt.eu-S1756600AbZFCGeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600AbZFCGeh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 02:34:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756499AbZFCGeW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 02:34:22 -0400
Received: from claw.goop.org ([74.207.240.146]:50680 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756455AbZFCGeV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 02:34:21 -0400
Message-ID: <4A26196B.10402@goop.org>
Date: Wed, 03 Jun 2009 16:34:19 +1000
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Stephen Tweedie <sct@redhat.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 05/16] xen mtrr: Add mtrr_ops support for Xen mtrr
References: <1242163718-2934-1-git-send-email-jeremy@goop.org> <1242163718-2934-6-git-send-email-jeremy@goop.org> <alpine.LFD.2.00.0906021729260.3419@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0906021729260.3419@localhost.localdomain>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Tue, 12 May 2009, Jeremy Fitzhardinge wrote:
>   
>>  	if (cpu_has_mtrr) {
>>  		mtrr_if = &generic_mtrr_ops;
>> +#ifdef CONFIG_XEN_DOM0
>> +		xen_init_mtrr();
>> +#endif
>> +
>>     
>
>   No #ifdefs please. Also isn't there some common place where Xen can
>   do all of it's magic extra init ?
>   

This init function overrides mtrr_if if its running under Xen, so it 
needs to happen here.  But we can certainly lose the #ifdef.

>   Aside of that this patch needs to be split into two. One adding the
>   num_var_ranges op and one adding the Xen bits.
>   

OK.

>> +#include <xen/interface/platform.h>
>> +#include <asm/xen/hypervisor.h>
>> +#include <asm/xen/hypercall.h>
>> +
>> +static int __init xen_num_var_ranges(void);
>>     
>
>   Can we move the function here please ?
>   
OK.

>> +/* DOM0 TODO: Need to fill in the remaining mtrr methods to have full
>> + * working userland mtrr support. */
>> +static struct mtrr_ops xen_mtrr_ops = {
>> +	.vendor            = X86_VENDOR_UNKNOWN,
>> +	.get_free_region   = generic_get_free_region,
>> +	.have_wrcomb       = positive_have_wrcomb,
>> +	.use_intel_if	   = 0,
>> +	.num_var_ranges	   = xen_num_var_ranges,
>> +};
>> +
>> +static int __init xen_num_var_ranges(void)
>> +{
>> +	int ranges;
>> +	struct xen_platform_op op;
>> +
>> +	for (ranges = 0; ; ranges++) {
>> +		op.cmd = XENPF_read_memtype;
>>     
>
>   Is op.cmd changed in the hypervisor call ?
>   

No, it can be hoisted.

>   cpu_has_mtrr ..... please 
>   

OK.

Thanks,
    J
