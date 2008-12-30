Return-Path: <linux-kernel-owner+w=401wt.eu-S1751979AbYL3QzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979AbYL3QzV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 11:55:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751738AbYL3QzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 11:55:05 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:33072 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbYL3QzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 11:55:04 -0500
Message-ID: <495A5259.2080208@oracle.com>
Date: Tue, 30 Dec 2008 08:54:49 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@hansenpartnership.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, scsi <linux-scsi@vger.kernel.org>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Robert Love <robert.w.love@intel.com>
Subject: Re: linux-next: Tree for December 29 (fcoe/libfc)
References: <20081230031621.60acd90b.sfr@canb.auug.org.au>	 <20081229195358.6a239657.randy.dunlap@oracle.com> <1230651870.3296.2.camel@localhost.localdomain>
In-Reply-To: <1230651870.3296.2.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt702.oracle.com [141.146.40.80]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.495A525C.01BE:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> On Mon, 2008-12-29 at 19:53 -0800, Randy Dunlap wrote:
>> On Tue, 30 Dec 2008 03:16:21 +1100 Stephen Rothwell wrote:
>>
>>> Hi all,
>>>
>>> Changes since 20081219:
>>>
>>> Undropped tree:
>>> 	scci
>>> 	mtd
>>>
>>> Dropped trees (temporarily):
>>> 	nfs (akpm request due to 2.6.30 features)
>>> 	kvm (build problem)
>>> 	rr (build poblem)
>>> 	semaphore-removal (due to unfixed conflicts against Linus' tree)
>>> 	cpu_alloc (build problem)
>>> 	audit (difficult conflicts)
>>>
>>> Linus' tree had three build failures requiring patches and one requiring
>>> a revert.
>>
>> >From drivers/scsi/Kconfig:
>>
>> config LIBFC
>> 	tristate "LibFC module"
>> 	depends on SCSI && SCSI_FC_ATTRS
>> 	---help---
>> 	  Fibre Channel library module
>>
>> config FCOE
>> 	tristate "FCoE module"
>> 	depends on SCSI
>> 	select LIBFC
>> 	---help---
>> 	  Fibre Channel over Ethernet module
>>
>>
>> Aside from being very skimpy help messages, nothing there requires
>> SCSI_FC_ATTRS to be enabled for FCOE, so when FCOE is enabled,
>> LIBFC is selected, and then bang:
>>
>> ERROR: "scsi_is_fc_rport" [drivers/scsi/libfc/libfc.ko] undefined!
>> ERROR: "fc_remote_port_delete" [drivers/scsi/libfc/libfc.ko] undefined!
>> ERROR: "fc_remote_port_add" [drivers/scsi/libfc/libfc.ko] undefined!
>> ERROR: "fc_release_transport" [drivers/scsi/fcoe/fcoe.ko] undefined!
>> ERROR: "fc_remove_host" [drivers/scsi/fcoe/fcoe.ko] undefined!
>> ERROR: "fc_attach_transport" [drivers/scsi/fcoe/fcoe.ko] undefined!
> 
> I checked the select of an option that selects, it seems to work nicely,
> so I think this is the fix.  The custom has been to select the
> attributes rather than depend on them anyway.  There's also no need to
> depend on SCSI since the whole thing is enclosed in an if SCSI_LOWLEVEL
> && SCSI.
> 
> James
> 
> ---
> 
> 
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index 0e5e084..9f4cc8e 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -607,13 +607,12 @@ config SCSI_FLASHPOINT
>  
>  config LIBFC
>  	tristate "LibFC module"
> -	depends on SCSI && SCSI_FC_ATTRS
> +	select SCSI_FC_ATTRS
>  	---help---
>  	  Fibre Channel library module
>  
>  config FCOE
>  	tristate "FCoE module"
> -	depends on SCSI
>  	select LIBFC
>  	---help---
>  	  Fibre Channel over Ethernet module
> 
> 

This still has a build error when CONFIG_PCI=n:


linux-next-20081229/drivers/scsi/fcoe/fc_transport_fcoe.c: In function 'fcoe_load_transport_driver':
linux-next-20081229/drivers/scsi/fcoe/fc_transport_fcoe.c:324: error: 'pci_bus_type' undeclared (first use in this function)
make[4]: *** [drivers/scsi/fcoe/fc_transport_fcoe.o] Error 1



-- 
~Randy
