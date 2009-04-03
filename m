Return-Path: <linux-kernel-owner+w=401wt.eu-S935517AbZDCRme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935517AbZDCRme (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 13:42:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934164AbZDCRla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 13:41:30 -0400
Received: from iona.labri.fr ([147.210.8.143]:51533 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935316AbZDCRl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 13:41:26 -0400
Message-ID: <49D64A42.9080304@inria.fr>
Date: Fri, 03 Apr 2009 19:41:22 +0200
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
CC: "Andrew J. Gallatin" <gallatin@myri.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] ioat-dca: force I/OAT DCA when disabled in BIOS
References: <49D13FB1.9090701@inria.fr> <129600E5E5FB004392DDC3FB599660D7910371D7@irsmsx504.ger.corp.intel.com>
In-Reply-To: <129600E5E5FB004392DDC3FB599660D7910371D7@irsmsx504.ger.corp.intel.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Maciej,

Thanks for at this.



Sosnowski, Maciej wrote:
> Brice Goglin wrote:
>   
>> Some machines (for instance Dell Poweredge servers) disable I/OAT DCA
>> support in the BIOS without any way to reenable it.
>> DCA may actually be enabled manually it in the processors' MSR and in
>> upstream bridge registers. We have been doing this with a hacky userspace
>> program, but we feel that the ioatdma driver may actually take care of it.
>>
>> Here's a patch doing so, if the ioat_dca_force module parameter is set
>> to 1 on load.
>>
>> There are some things to improve:
>> * Which pcidev should actually get DCA enabled? The patch below looks for
>>   Intel upstream bridges. Do we need a check for pdev->is_pcie ? Or maybe
>>   even look at pdev->pcie_type? It looks like the pcidev that need to be
>>   configured on my machines are PCI_EXP_TYPE_ROOT_PORT, but I am not sure
>>   it actually matters. Some Intel people will probably know how to fix this.
>> * Any better name for #defin'ing bit #6 at offset 0x64 in the config-space
>>   of these bridges?
>>
>> Signed-off-by: Brice Goglin <Brice.Goglin@inria.fr>
>> Signed-off-by: Andrew Gallatin <gallatin@myri.com>
>>
>>     
>
> Hi Brice,
>
> While this patch should work for some platforms (with I/OAT devices of IDs: 0x1a38, 0x360b, 0x65ff) it is not a platform generic solution.
> Generally enabling DCA, like this dca_force() routine does, requires other settings including the tag_map which should be set by BIOS.
> Thus it should be BIOS responsibility to prepare the whole required configuration for DCA.

Well, that's exactly the reason why the patch only enforces DCA when
ioat_dca_force=1 is given. We obviously don't want to tweak registers
like this by default, unless the admin knows what he is doing.

Having to run a custom script is really annoying for many Dell machine
users where the tag_map is already correctly set by the BIOS. And you
have to make sure that the script runs before ioatdma is loaded (which
means you cannot built ioatdma inside the kernel, by the way).

By the way, do you have some ideas about how to filter bridges better?
Maybe somebody at Intel has a whitelist of intel bridges that could be
involved here?

thanks,
Brice

