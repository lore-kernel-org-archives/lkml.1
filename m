Return-Path: <linux-kernel-owner+w=401wt.eu-S1752028AbYANFUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028AbYANFUc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 00:20:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750914AbYANFUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 00:20:22 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:53628 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861AbYANFUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 00:20:21 -0500
Date: Sun, 13 Jan 2008 23:20:13 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: fixed a bug of adma in rhel4u5 with HDS7250SASUN500G.
In-reply-to: <15F501D1A78BD343BE8F4D8DB854566B1BFE2AC0@hkemmail01.nvidia.com>
To: Kuan Luo <kluo@nvidia.com>
Cc: Tejun Heo <htejun@gmail.com>, Mark Lord <liml@rtr.ca>,
       Jeff Garzik <jeff@garzik.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Allen Martin <AMartin@nvidia.com>, Peer Chen <pchen@nvidia.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       David Milburn <dmilburn@redhat.com>
Message-id: <478AF10D.5080805@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <4781F008.9070404@gmail.com> <4782422C.8020202@rtr.ca>
 <4782B73B.8080309@shaw.ca> <4782BC48.4000309@gmail.com>
 <4782C008.3030902@shaw.ca> <4782CB62.7040901@gmail.com>
 <4782CEF9.3040708@gmail.com> <4782DFFE.50301@shaw.ca>
 <4782E5A8.9010305@gmail.com> <4782E63E.1000606@gmail.com>
 <4782E78F.9050205@shaw.ca> <4782E912.1050204@gmail.com>
 <4783493A.7070800@gmail.com> <47838B57.8020407@shaw.ca>
 <47842A54.2060107@gmail.com> <47842ABA.2060605@gmail.com>
 <47844471.4070705@shaw.ca> <47845708.6060900@gmail.com>
 <478567D8.10601@shaw.ca>
 <15F501D1A78BD343BE8F4D8DB854566B1BFE2ABF@hkemmail01.nvidia.com>
 <478812C9.1000901@shaw.ca>
 <15F501D1A78BD343BE8F4D8DB854566B1BFE2AC0@hkemmail01.nvidia.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kuan Luo wrote:
> Robert hancock wrote:
>> What problem does this resolve? I tested it against the cache 
>> flush/NCQ 
>> write switching problem we've been trying to solve, and it 
>> doesn't look 
>> like it fixes that one - if I apply this patch and then remove the 
>> udelay(20) in sata_nv.c that I added which prevented me from 
>> seeing this 
>> problem before, it shows up.
>>
> 
> First thank  davide to help to send the attachment.
> 
> Robert,
> The patch is to solve the error message "ata1: CPB flags CMD err,
> flags=0x11" when testing HDS7250SASUN500G in rhel4u5.
> I tested this hd in 2.6.24-rc7 which needed to remove the mask in
> blacklist to run the ncq and the same error also showed up. 
> 
> I traced the  bug and found that the interrupt finished a command (for
> example, tag=0) when the driver got that adma status is
> NV_ADMA_STAT_DONE  and  cpb->resp_flags is NV_CPB_RESP_DONE.
> However, For this hd, the drive maybe didn't clear bit 0 at this moment.
> It meaned the hardware  had not completely finished the command.
> If at the same time  the driver freed the command(tag 0) and sended
> another command (tag 0), the error happened.
> 
> The notifier register is 32-bit register containing notifier value.
> Value is bit vector containing one bit per tag number (0-31) in
> corresponding bit positions (bit 0 is for tag 0, etc). When bit is set
> then ADMA indicates that command with corresponding tag number completed
> execution.
> 
> So i added the check notifier code. Sometimes i saw that the notifier
> reg set some bits  , but the adma status set NV_ADMA_STAT_CMD_COMPLETE
> ,not NV_ADMA_STAT_DONE. So i added the NV_ADMA_STAT_CMD_COMPLETE check
> code.

That looks like a good fix then. (Though a possible optimization would 
be to and the check_commands value with the notifier clear value rather 
than testing against the notifier on each loop. That's fairly minor though.)

As I mentioned, this doesn't seem to resolve the problem we're seeing 
with rapidly intermixed NCQ commands and cache flushes (at least, if I 
take out the arbitrary 20usec delay from the driver and add this patch, 
the problem still shows up). It could be a similar problem, though, of 
commands being issued before the controller is really ready for them. If 
you or others at NVIDIA could assist in tracking down that problem it 
would be appreciated..
