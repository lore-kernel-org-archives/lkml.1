Return-Path: <linux-kernel-owner+w=401wt.eu-S1753544AbYB0FW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbYB0FW1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 00:22:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751654AbYB0FWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 00:22:19 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:23644 "EHLO
	pd3mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbYB0FWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 00:22:18 -0500
Date: Tue, 26 Feb 2008 23:24:17 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH] sata_nv: fix nmi intr or system hanging in rhel4u6 adma.
In-reply-to: <15F501D1A78BD343BE8F4D8DB854566B1BFE2AE7@hkemmail01.nvidia.com>
To: Kuan Luo <kluo@nvidia.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel <linux-kernel@vger.kernel.org>,
       Tejun Heo <htejun@gmail.com>, Peer Chen <pchen@nvidia.com>,
       Allen Martin <AMartin@nvidia.com>
Message-id: <47C4F401.8000607@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <15F501D1A78BD343BE8F4D8DB854566B1BFE2AE5@hkemmail01.nvidia.com>
 <47C42534.1090107@shaw.ca> <47C43E27.5070700@garzik.org>
 <15F501D1A78BD343BE8F4D8DB854566B1BFE2AE7@hkemmail01.nvidia.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kuan Luo wrote:
> Jeff wrote:
>> robert worte:
>>> This is basically avoiding switching into register mode, 
>> right? I don't 
>>> think this is a very good solution as the point of the 
>> tf_read function 
>>> is that it's supposed to read the taskfile provided by the drive to 
>>> diagnose the error, so not doing this isn't a good thing.
>> Agree with this analysis -- if ->tf_read() is being called, then 
>> obviously the core wants a current copy of the device's ATA registers.
>>
>> It is not a good solution to simply avoiding returning 
>> meaningful data, 
>> because -- as Robert notes -- we need tf_read for analysis.
>>
>> 	Jeff
>>
> 
> The driver got one error : "nv_adma_check_cpb: CPB 0, flags=0x11". The
> code entered ata_port_abort -> ata_qc_complete
> -> fill_result_tf->nv_adma_tf_read.
> 
> Firstly, nv_adma_register_mode failed, showing the below messages:
> timeout waiting for ADMA IDLE, stat=0x440
> timeout waiting for ADMA LEGACY, stat=0x440
> 
> Then enter ata_tf_read function. 
> I found the system hung at tf->hob_nsect = ioread8(ioaddr->nsect_addr);
> Sometimes the screen showed "
> CPU0: Machin check Exception 0000000000000004
> Bank 4:b200000000070f0f
> kernel panic -not syncing: CPU Context corrupt.
> "
> If nv_adma_register_mode failed, the reg result should be not
> meaningful. 
> I don't know why the systm hung.

I suspect nv_adma_register_mode failing may be the key. I don't know why 
this happens. It could be the timeout needs to be longer but I've tried 
increasing it significantly without apparent effect. (Essentially it's 
waiting for the status to go to the IDLE state, and then clears the GO 
bit and waits for LEGACY to be set. In this case both waits timed out.)
