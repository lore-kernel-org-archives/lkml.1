Return-Path: <linux-kernel-owner+w=401wt.eu-S1759556AbXH0W40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759556AbXH0W40 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 18:56:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752388AbXH0W4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 18:56:19 -0400
Received: from madara.hpl.hp.com ([192.6.19.124]:54296 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751184AbXH0W4S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 18:56:18 -0400
Date: Mon, 27 Aug 2007 15:55:55 -0700
From: Stephane Eranian <eranian@hpl.hp.com>
To: Daniel Walker <dwalker@mvista.com>
Cc: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>, ak@suse.de,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: nmi_watchdog=2 regression in 2.6.21
Message-ID: <20070827225555.GI784@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <1186531609.22044.50.camel@imap.mvista.com> <20070808142059.GF30805@atjola.homenet> <20070827175431.GD784@frankl.hpl.hp.com> <1188237331.2435.255.camel@dhcp193.mvista.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="9amGYk9869ThD9tj"
Content-Disposition: inline
In-Reply-To: <1188237331.2435.255.camel@dhcp193.mvista.com>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Daniel,

On Mon, Aug 27, 2007 at 10:55:31AM -0700, Daniel Walker wrote:

> Here is the cpuinfo for processor 0 .. It's got four cores so this isn't
> the full /proc/cpuinfo output ..
> 

> processor       : 0
> vendor_id       : GenuineIntel 
> cpu family      : 6
> model           : 14

The looks like a Core Duo. If that is really the case,
then commit e82f64e5bb0648a13630d752c35be1e7bd8bab96 from Bjorn
should fix your problem. I have it is my 2.6.23-rc3 tree.


> model name      : Intel(R) Dual Pentium(R) M CPU        @ 2.00GHz

Yet the model name looks strange. So we need to run one more test,
as the fam/model is not enough. What we need to check is whether or
not this processor implements architectural perfmon or not.

Could you please compile and run the attached program and send me 
the output?

Thanks.

> 

-- 

-Stephane

--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="cpuid-pmu2.c"

#include <sys/types.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>

typedef struct {
	unsigned int version:8;
	unsigned int num_cnt:8;
	unsigned int cnt_width:8;
	unsigned int ebx_length:8;
} pmu_eax_t;

static inline void cpuid(unsigned int op, unsigned int *eax, unsigned int *ebx, unsigned int *ecx, unsigned int *edx)
{
	__asm__("cpuid"
			: "=a" (*eax),
			"=b" (*ebx),
			"=c" (*ecx),
			"=d" (*edx)
			: "0" (op), "c"(0));
}

int main(void)
{
	unsigned int ecx, ebx, edx;
	union {
		unsigned int val;
		pmu_eax_t eax;
	} eax;

	cpuid(0, &eax.val, &ebx, &ecx, &edx);
	if (eax.val < 0xa) {
		printf("does not support architected PMU\n");
		return 0;
	}
	cpuid(0xa, &eax.val, &ebx, &ecx, &edx);
	
	printf("eax=0x%lx: version=%d  num_cnt=%d\n",
	       eax.val,
	       eax.eax.version,
	       eax.eax.num_cnt);
	return 0;
}

--9amGYk9869ThD9tj--
