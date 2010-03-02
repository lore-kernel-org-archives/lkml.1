Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060Ab0CBXTT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:19:19 -0500
Received: from mail-ew0-f220.google.com ([209.85.219.220]:64341 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746Ab0CBXTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:19:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ix6y2imNAE8Wq4CmlpTVEEIp6AwCEtNmdAIM1wZ5LAO2tK4sgJOnMQ8ELioAMcoKn4
         hePA94LI9OE5gDX2CKKh3KaWNzP//jH4FEZqZVUCVkrKWTATx8i5aoxyTi3Y+ptGyaGI
         i1up2l2BRLYZJZzDdRHfosfvj4A4INx8HUHls=
Message-ID: <4B8D9CED.7040603@garzik.org>
Date: Tue, 02 Mar 2010 18:19:09 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@mvista.com>
CC: Anton Vorontsov <avorontsov@ru.mvista.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/12] ahci: Introduce ahci_set_em_messages()
References: <20100302182850.GA32057@oksana.dev.rtsoft.ru> <20100302182939.GI3445@oksana.dev.rtsoft.ru> <4B8D80C3.1050006@ru.mvista.com>
In-Reply-To: <4B8D80C3.1050006@ru.mvista.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/2010 04:18 PM, Sergei Shtylyov wrote:
> Hello.
>
> Anton Vorontsov wrote:
>
>> Factor out some ahci_em_messages handling code from ahci_init_one().
>> We would like to reuse it for non-PCI devices.
>>
>> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
>> ---
>> drivers/ata/ahci.c | 41 ++++++++++++++++++++++++-----------------
>> 1 files changed, 24 insertions(+), 17 deletions(-)
>>
>> diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
>> index 18443e9..6694b17 100644
>> --- a/drivers/ata/ahci.c
>> +++ b/drivers/ata/ahci.c
>> @@ -3040,6 +3040,29 @@ static inline void
>> ahci_gtf_filter_workaround(struct ata_host *host)
>> {}
>> #endif
>>
>> +static void ahci_set_em_messages(struct ahci_host_priv *hpriv,
>> + struct ata_port_info *pi)
>> +{
>> + u8 messages;
>> + void __iomem *mmio = hpriv->mmio;
>> + u32 em_loc = readl(mmio + HOST_EM_LOC);
>> + u32 em_ctl = readl(mmio + HOST_EM_CTL);
>> +
>> + if (!ahci_em_messages || !(hpriv->cap & HOST_CAP_EMS))
>> + return;
>> +
>> + messages = (em_ctl & EM_CTRL_MSG_TYPE) >> 16;
>> +
>> + /* we only support LED message type right now */
>> + if ((messages & 0x01) && (ahci_em_messages == 1)) {
>> + /* store em_loc */
>> + hpriv->em_loc = ((em_loc >> 16) * 4);
>
> Could drop unneeded parens, while at it...

While not strictly necessary, parens often help with readability.  I 
think the above code looks fine as-is.  If the reader has to waste a few 
seconds recalling C's operator precedence, that detracts from the easy 
reading of the code.  Not everyone is like me and has worked on a C 
compiler, you know ;-)

	Jeff



