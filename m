Return-Path: <linux-kernel-owner+w=401wt.eu-S1754658AbYA3Cyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658AbYA3Cyu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 21:54:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751692AbYA3Cyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 21:54:40 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:18321 "EHLO
	pd3mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbYA3Cyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 21:54:39 -0500
Date: Tue, 29 Jan 2008 20:54:18 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH] sata_nv: fix for completion handling
In-reply-to: <479FE0D1.1030607@gmail.com>
To: Tejun Heo <htejun@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
       Kuan Luo <kluo@nvidia.com>, Allen Martin <AMartin@nvidia.com>
Message-id: <479FE6DA.1080404@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <479FD88F.8090605@shaw.ca> <479FE0D1.1030607@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Robert Hancock wrote:
>> This patch is based on an original patch from Kuan Luo of NVIDIA,
>> posted under subject "fixed a bug of adma in rhel4u5 with HDS7250SASUN500G".
>> His description follows. I've reworked it a bit to avoid some unnecessary
>> repeated checks but it should be functionally identical.
>>
>> "The patch is to solve the error message "ata1: CPB flags CMD err,
>> flags=0x11" when testing HDS7250SASUN500G in rhel4u5.
>> I tested this hd in 2.6.24-rc7 which needed to remove the mask in
>> blacklist to run the ncq and the same error also showed up. 
>>
>> I traced the  bug and found that the interrupt finished a command (for
>> example, tag=0) when the driver got that adma status is
>> NV_ADMA_STAT_DONE  and  cpb->resp_flags is NV_CPB_RESP_DONE.
>> However, For this hd, the drive maybe didn't clear bit 0 at this moment.
>> It meaned the hardware  had not completely finished the command.
>> If at the same time  the driver freed the command(tag 0) and sended
>> another command (tag 0), the error happened.
>>
>> The notifier register is 32-bit register containing notifier value.
>> Value is bit vector containing one bit per tag number (0-31) in
>> corresponding bit positions (bit 0 is for tag 0, etc). When bit is set
>> then ADMA indicates that command with corresponding tag number completed
>> execution.
>>
>> So i added the check notifier code. Sometimes i saw that the notifier
>> reg set some bits  , but the adma status set NV_ADMA_STAT_CMD_COMPLETE
>> ,not NV_ADMA_STAT_DONE. So i added the NV_ADMA_STAT_CMD_COMPLETE check
>> code."
>>
>> Signed-off-by: Robert Hancock <hancockr@shaw.ca>
> 
> Any chance this fixes the FLUSH problem?

I could still reproduce that issue when I took the udelay(20) out of the 
driver. Others have seen that without taking it out, so I suspect some 
systems/drives are more sensitive to that for some reason. However, who 
knows, it may help some people with that problem.

The symptoms of the problem dealt with here are different, not a command 
timeout it appears, but the controller reporting an error.
