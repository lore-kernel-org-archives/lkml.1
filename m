Return-Path: <linux-kernel-owner+w=401wt.eu-S1751554Ab0AZAKJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554Ab0AZAKJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 19:10:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751229Ab0AZAKB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 19:10:01 -0500
Received: from relay3.sgi.com ([192.48.152.1]:50451 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751214Ab0AZAJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 19:09:59 -0500
Message-ID: <4B5E32D0.8040401@sgi.com>
Date: Mon, 25 Jan 2010 16:09:52 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Russ Anderson <rja@sgi.com>, Dave Airlie <airlied@redhat.com>,
       Alex Chiang <achiang@hp.com>, Thomas Gleixner <tglx@linutronix.de>,
       Cyrill Gorcunov <gorcunov@openvz.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Robin Holt <holt@sgi.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Adam Jackson <ajax@nwnk.net>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Gaetan Nadon <memsize@videotron.ca>, "H. Peter Anvin" <hpa@zytor.com>,
       Aaron Plattner <aplattner@nvidia.com>, Jack Steiner <steiner@sgi.com>,
       Tiago Vignatti <tiago.vignatti@nokia.com>, Cliff Wickman <cpw@sgi.com>,
       Matthew Wilcox <willy@linux.intel.com>,
       Christian Zander <chzander@nvidia.com>, Yu Zhao <yu.zhao@intel.com>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 1/4] pci: Update pci_set_vga_state to call arch functions
References: <20100118183412.560438000@alcatraz.americas.sgi.com>	<20100118183418.045021000@alcatraz.americas.sgi.com> <20100125155234.a2e397a1.akpm@linux-foundation.org>
In-Reply-To: <20100125155234.a2e397a1.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 18 Jan 2010 12:34:13 -0600
> Mike Travis <travis@sgi.com> wrote:
> 
>> Update pci_set_vga_state to call arch dependent functions to enable
>> Legacy VGA I/O transactions to be redirected to correct target.
>>
> 
> Changelog doesn't explain the reason for doing this, but it looks like
> that becomes clearer in later patches.

You're right, I should have carried more from the intro page into the
actual patch.
> 
>>  
>> +/* Some architectures require additional programming to enable VGA */
>> +static arch_set_vga_state_t arch_set_vga_state;
>> +
>> +void pci_register_set_vga_state(arch_set_vga_state_t func)
>> +{
>> +	arch_set_vga_state = func;	/* NULL disables */
>> +}
>> +
>> +static int pci_set_vga_state_arch(struct pci_dev *dev, bool decode,
>> +		      unsigned int command_bits, bool change_bridge)
>> +{
>> +	if (arch_set_vga_state)
>> +		return arch_set_vga_state(dev, decode, command_bits,
>> +						change_bridge);
>> +	return 0;
>> +}
> 
> hm, that's not terribly elegant.  It's racy too, although it seems
> unlikely that an arch will call pci_set_vga_state_arch() more than
> once.

Yes, it's only set (once) if it is a UV system.

> 
> Still, a neater solution might be
> 
> int arch_pci_set_vga_state(...) __weak
> {
> 	return 0;
> }
> 
> and then resolve it at linkage time?
> 
> 

Wouldn't the linked in stronger function then need to surround
the UV register updating with "if (uv_system)"?

Thanks for the comments Andrew.
