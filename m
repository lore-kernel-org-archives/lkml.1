Return-Path: <linux-kernel-owner+w=401wt.eu-S1756212AbZDCKJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212AbZDCKJb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 06:09:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753787AbZDCKJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 06:09:22 -0400
Received: from mail.windriver.com ([147.11.1.11]:38005 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752934AbZDCKJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 06:09:21 -0400
Message-ID: <49D5DF93.8020101@windriver.com>
Date: Fri, 03 Apr 2009 18:06:11 +0800
From: Harry Ciao <qingtao.cao@windriver.com>
Reply-To: qingtao.cao@windriver.com
Organization: Wind River, CDC
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: michael@ellerman.id.au
CC: norsk5@yahoo.com, bluesmoke-devel@lists.sourceforge.net,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [v1 PATCH 3/3] EDAC: CPC925 MC platform device setup
References: <1238739044-19926-1-git-send-email-qingtao.cao@windriver.com>	 <1238739044-19926-2-git-send-email-qingtao.cao@windriver.com> <1238741478.6802.44.camel@localhost>
In-Reply-To: <1238741478.6802.44.camel@localhost>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 03 Apr 2009 10:08:52.0744 (UTC) FILETIME=[30DE9880:01C9B444]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Ellerman Ð´µÀ:
> On Fri, 2009-04-03 at 14:10 +0800, Harry Ciao wrote:
>   
>> Setup a platform device for the CPC925 Memory Controller during system
>> booting up, against which CPC925 MC EDAC driver would be matched.
>>
>> Signed-off-by: Harry Ciao <qingtao.cao@windriver.com>
>> ---
>>  arch/powerpc/platforms/maple/setup.c |   47 ++++++++++++++++++++++++++++++++++
>>  1 files changed, 47 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/powerpc/platforms/maple/setup.c b/arch/powerpc/platforms/maple/setup.c
>> index bfd60e4..ca8a3ff 100644
>> --- a/arch/powerpc/platforms/maple/setup.c
>> +++ b/arch/powerpc/platforms/maple/setup.c
>> @@ -335,3 +335,50 @@ define_machine(maple) {
>>  	.progress		= maple_progress,
>>  	.power_save		= power4_idle,
>>  };
>> +
>> +#ifdef CONFIG_EDAC
>> +#define CPC925_MC_START		0xf8000000
>> +#define CPC925_MC_END		0xf8ffffff /* sizeof 16MB */
>> +/* Register a platform device for CPC925 memory controller */
>> +static int __init maple_cpc925_edac_setup(void)
>> +{
>> +	struct platform_device *pdev;
>> +	struct device_node *np = NULL;
>> +	struct resource r;
>> +
>> +	np = of_find_node_by_name(NULL, "hostbridge");
>>     
>
> This is way too generic IMHO. You're going to match on any node called
> "hostbridge" on any 64-bit powerpc machine, there's a good chance there
> are other firmwares out there with such a node, or will be in the
> future.
>
> Is there no compatible or model property you can look for, so you're at
> least somewhat confident you're actually looking at a CPC925?
>
> If not this should be a machine_initcall() for Maple only.
>
>   
>> +	if (of_address_to_resource(np, 0, &r)) {
>> +		/*
>> +		 * of_address_to_resource() would get the #address-cells
>> +		 * and #size-cells properties for a node from its parent.
>> +		 * On Maple 64bit target hostbridge parent node has specified
>> +		 * both of these two properties to be 2. However, the actual
>> +		 * "cell" value for host bridge node is 1. Since we can't
>> +		 * fix this firmware-generated DTB, we have to setup a
>> +		 * resource structure manually.
>> +		 */
>> +		memset(&r, 0, sizeof(r));
>> +		r.start = CPC925_MC_START;
>> +		r.end = CPC925_MC_END;
>> +		r.name = "hostbridge";
>> +		r.flags = IORESOURCE_MEM;
>>     
>
> We do have fixups for bogus firmware including maple, look in
> prom_init.c:fixup_device_tree_maple(). Although that's for actual
> firmware, not a DTB.
>
> cheers
>
>   
Hi Michael,

Thanks a lot for your comments! I can see it would be much better than
mine. Next whole week I will be on vacation, I will give some serious
thoughts about your ideas and improve my patch in v2 after I come back.

Best regards,

Harry
