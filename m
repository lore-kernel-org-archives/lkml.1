Return-Path: <linux-kernel-owner+w=401wt.eu-S1752624AbYIHOEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624AbYIHOEr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 10:04:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753463AbYIHOEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 10:04:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48609 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751963AbYIHOEh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 10:04:37 -0400
Date: Mon, 8 Sep 2008 16:04:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yan Li <elliot.li.tech@gmail.com>
Cc: linux-kernel@vger.kernel.org, joerg.roedel@amd.com, rjmaomao@gmail.com,
       Yinghai Lu <yhlu.kernel@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/2] VMware detection support for x86 and x86-64
Message-ID: <20080908140423.GG11993@elte.hu>
References: <20080221115452.GB13948@elte.hu> <20080907234510.GA24133@yantp.cn.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080907234510.GA24133@yantp.cn.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Yan Li <elliot.li.tech@gmail.com> wrote:

> +/* Backdoor def from open-vm-tools/lib/include/backdoor_def.h */
> +#define BDOOR_MAGIC          0x564D5868
> +/* Low-bandwidth backdoor port. --hpreg */
> +#define BDOOR_PORT           0x5658
> +#define BDOOR_CMD_GETVERSION 10
> +#define VERSION_MAGIC        0x6
> +
> +/*
> + *  getVersion  -  Read VM version & product code through backdoor
> + */
> +void getVersion(u32 *version)
> +{
> +	u32 eax, ebx, ecx, edx;
> +
> +	asm volatile("inl (%%dx)" :
> +		     "=a"(eax), "=c"(ecx), "=d"(edx), "=b"(ebx) :
> +		     "0"(BDOOR_MAGIC), "1"(BDOOR_CMD_GETVERSION),
> +		     "2"(BDOOR_PORT) : "memory");

hm, i know it's not your fault as you just took this vmware code, but 
this is really not an acceptable method of detection. The above is 
totally unsafe to do on native hardware - we dont know whether there's 
anything on that port.

vmware could have used one of the following methods to communicate to 
the guest kernel:

 - a CPUID and an MSR range - like a good virtual CPU should. That way 
   even bootloaders could detect the presence of vmware.
 - or a PCI ID and a PCI driver like KVM does
 - or a system call hypercall gateway like Xen and KVM does
 - or it could even have used a DMI signature of some sort

but no, vmware had to use 30 year old unsafe ISA port magic...

To add insult to injury that port is named 'backdoor' - very smart and 
confidence raising naming. Plus it does not even use some well-known PC 
port that is harmless to read - it has to be from the middle of the 
generic IO port resource range where a real PCI card could sit: 0x5658. 
Brilliant.

is there really no vmware PCI ID to query? Could you post the lspci -v 
output of your vmware guest? We could add an early-quirk for one of the 
core vmware PCI devices (in case there are any - i bet there are).

	Ingo
