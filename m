Return-Path: <linux-kernel-owner+w=401wt.eu-S1754704AbYAMUxN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704AbYAMUxN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 15:53:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753583AbYAMUw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 15:52:58 -0500
Received: from mailbox2.myri.com ([64.172.73.26]:1984 "EHLO myri.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753460AbYAMUw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 15:52:57 -0500
Message-ID: <478A79E4.3060601@myri.com>
Date: Sun, 13 Jan 2008 15:51:48 -0500
From: Loic Prylli <loic@myri.com>
User-Agent: Thunderbird/2.0.0.4 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Greg KH <greg@kroah.com>,
       Matthew Wilcox <matthew@wil.cx>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, linux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Martin Mares <mj@ucw.cz>, Tony Camuso <tcamuso@redhat.com>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
 opt-in
References: <alpine.LFD.1.00.0801111156230.3148@woody.linux-foundation.org>	<20080111201716.GO18741@parisc-linux.org>	<alpine.LFD.1.00.0801111224090.3148@woody.linux-foundation.org>	<20080111204228.GP18741@parisc-linux.org>	<alpine.LFD.1.00.0801111311170.3148@woody.linux-foundation.org>	<20080111211753.GR18741@parisc-linux.org>	<alpine.LFD.1.00.0801111326120.3148@woody.linux-foundation.org>	<20080111213803.GS18741@parisc-linux.org>	<20080111235856.GA16079@jurassic.park.msu.ru>	<20080112002638.GA18710@kroah.com>	<20080112144030.GA19279@jurassic.park.msu.ru>	<20080112094557.71f5382a@laptopd505.fenrus.org>	<478A5727.3000102@myri.com> <20080113104124.022cd0a5@laptopd505.fenrus.org>
In-Reply-To: <20080113104124.022cd0a5@laptopd505.fenrus.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 1/13/2008 1:41 PM, Arjan van de Ven wrote:
> On Sun, 13 Jan 2008 13:23:35 -0500
> Loic Prylli <loic@myri.com> wrote:
>
> Matthew pointed a patch that basically does what you suggested; only one comment on your mail left after that:
>
>   
>> 2) the pci_enable_ext_config() function and dev->ext_cfg_space field, 
>> sysfs interface should be removed from the patch.  There has never
>> been a problem reporting crashes or any undefined behaviour while
>> trying to access ext-conf-space, all the problems where *using
>> mmconfig to access legacy-conf-space*.
>>     
>
>
> This entirely misses the point of why I made the patch. The point is NOT
> that devices are buggy. The point is that right now, 99.99% of the machines
> out there do NOT need extended config space (no matter how it gets accessed),
>   

> The point of my patch was to make people who don't need extended config space,
> not have to deal with it anymore.
>   




I think I got your point the first time, and I agree it is sound. But in 
my subjective and biased opinion,  I just think ext-conf-space is 
already useful and widespread enough (being used is not the same as 
being strictly required for basic operation) for your proposed tradeoff 
to not be optimal (protecting against "future/non-proven" hardware bugs, 
i.e. bringing non-proven benefits, at the expense of making life harder 
for ext-conf-space users while bringing additional extra API/code).


To take an example from the linux tree: the driver/pci/pcie/aer code 
uses ext-conf-space for every pcie-root (currently several distributions 
enable it by default), does it mean opt-in would be automatically 
activated for most pcie hierarchies (defeating most of the benefits of 
being opt-in), or we just disable that code by default?


Does lspci -v will automatically opt-in all pcie (right now by default 
it tries to list the extended-capabilities for pcie and pcix), or do we 
now require manual explicit sysfs operations to get the whole thing? Is 
is an additional flag to lspci (if so will that flag also apply to pcix, 
possibly causing a crash for lspci -v 
-<opt-in-all-potential-ext-devices> on some machines).



> Note: There is not a 100% overlap between "need" and "will not be used in 
> the patches that use legacy for < 256". In the other patches posted, 
> extended config space will be used in cases where it won't be with my 
> patch. (Most obvious one is an "lspci -vx" from automated scripts).



To go one step your direction, I have already argued in a couple of 
emails that I would prefer to not implement ext-conf-space access for 
any PCI-X devices (removing PCI-X2 from pci_ext_cfg_size), because there 
we are trying to support devices that we don't really know exists or 
will ever exists. And protecting against "unproven bugs" makes more 
sense when it only removes "unproven benefits".



>  
> Is  that a problem? We've had 2 years of mess, with one not-enough patch after another.
>   
> There still are problems TODAY (eg im 2.6.24-rc7). The patch that falls back
> to an alternative method for below 256 is no doubt a step in the right direction. 
> (although I'm not all that happy about mixing access types, it's not provably incorrect)
> Is it enough? I'm not sure. 


FWIW, I have in my tree a patch almost identical to Ivan's dated 
"December 2005". Because of the constant activity on the mmconfig front 
(that I thought would make it obsolete), I never took the effort of 
suggesting it before one month ago (I am not a regular user of 
linux-kernel). I admit nobody else should view it that way, but for me  
rather than the last attempt at fixing mmconfig, it's a patch first used 
two years ago that would have arguably prevented all problems that have 
been reported since then.

Besides, recent mails show that hypothetically, we could even not change 
anything to the existing conf-space code, since the only known bug 
remaining is the one associated with bar probing and could be adressed by:

http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc6/2.6.24-rc6-mm1/broken-out/pci-disable-decoding-during-sizing-of-bars.patch


[ Thanks to Robert hancok and Grant Grundler for explaining to me the 
history of bar-probing last month  ]


Even if  that bar-probing patch was applied (maybe it needs to be more 
combat-proven), by default, it still seems  better to not use mmconfig 
for legacy-conf-space access, but going two extra precaution steps 
beyond what seems necessary might be excessive.




> Only time can tell I suppose, but the risk side is that
> if it is not enough, users who don't need the extended config space for functionality
> will suffer the bugs AGAIN.
>   



You can indeed never exclude 100% that possibility, but if they see a 
problem again, it is likely to be a new category of hardware/BIOS bugs 
never seen before.



Loic

