Return-Path: <linux-kernel-owner+w=401wt.eu-S1753234AbYAWJdJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbYAWJdJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 04:33:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751814AbYAWJcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 04:32:55 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:42500 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751784AbYAWJcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 04:32:53 -0500
Message-ID: <479709BE.2090707@garzik.org>
Date: Wed, 23 Jan 2008 04:32:46 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>, Kuan Luo <kluo@nvidia.com>
CC: Tejun Heo <htejun@gmail.com>, Mark Lord <liml@rtr.ca>,
       Jeff Garzik <jeff@garzik.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Allen Martin <AMartin@nvidia.com>, Peer Chen <pchen@nvidia.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       David Milburn <dmilburn@redhat.com>
Subject: sata_nv and 2.6.24 (was Re: fixed a bug of adma in rhel4u5 with HDS7250SASUN500G.)
References: <4781F008.9070404@gmail.com> <4782422C.8020202@rtr.ca> <4782B73B.8080309@shaw.ca> <4782BC48.4000309@gmail.com> <4782C008.3030902@shaw.ca> <4782CB62.7040901@gmail.com> <4782CEF9.3040708@gmail.com> <4782DFFE.50301@shaw.ca> <4782E5A8.9010305@gmail.com> <4782E63E.1000606@gmail.com> <4782E78F.9050205@shaw.ca> <4782E912.1050204@gmail.com> <4783493A.7070800@gmail.com> <47838B57.8020407@shaw.ca> <47842A54.2060107@gmail.com> <47842ABA.2060605@gmail.com> <47844471.4070705@shaw.ca> <47845708.6060900@gmail.com> <478567D8.10601@shaw.ca> <15F501D1A78BD343BE8F4D8DB854566B1BFE2ABF@hkemmail01.nvidia.com> <478812C9.1000901@shaw.ca> <15F501D1A78BD343BE8F4D8DB854566B1BFE2AC0@hkemmail01.nvidia.com> <478AF10D.5080805@shaw.ca>
In-Reply-To: <478AF10D.5080805@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Kuan Luo wrote:
>> Robert hancock wrote:
>>> What problem does this resolve? I tested it against the cache 
>>> flush/NCQ write switching problem we've been trying to solve, and it 
>>> doesn't look like it fixes that one - if I apply this patch and then 
>>> remove the udelay(20) in sata_nv.c that I added which prevented me 
>>> from seeing this problem before, it shows up.
>>>
>>
>> First thank  davide to help to send the attachment.
>>
>> Robert,
>> The patch is to solve the error message "ata1: CPB flags CMD err,
>> flags=0x11" when testing HDS7250SASUN500G in rhel4u5.
>> I tested this hd in 2.6.24-rc7 which needed to remove the mask in
>> blacklist to run the ncq and the same error also showed up.
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
>> code.
> 
> That looks like a good fix then. (Though a possible optimization would 
> be to and the check_commands value with the notifier clear value rather 
> than testing against the notifier on each loop. That's fairly minor 
> though.)
> 
> As I mentioned, this doesn't seem to resolve the problem we're seeing 
> with rapidly intermixed NCQ commands and cache flushes (at least, if I 
> take out the arbitrary 20usec delay from the driver and add this patch, 
> the problem still shows up). It could be a similar problem, though, of 
> commands being issued before the controller is really ready for them. If 
> you or others at NVIDIA could assist in tracking down that problem it 
> would be appreciated..

Ping...  sata_nv status is still a bit open for 2.6.24, and I would like 
to move us forward a bit.

* Kuan's patch...  it has been confirmed (and is needed), correct?  can 
someone work up a good patch for 2.6.24?  The only one I ever received 
was badly word-wrapped, and at the time, Robert seemed uncertain of it, 
so I waited.

* ADMA ATAPI 4GB issues...  playing tricks with the ordering of 
allocations and DMA masks is just way too fragile.  We just cannot 
guarantee that all allocators work that way.  The obvious solution to me 
seems to be hardcoding the consistent DMA mask to 32-bit, but using 
64-bit for regular dma mask if-and-only-if ADMA is enabled.

* it sure seems like there are other open sata_nv ADMA issues -- can we 
hard-confirm or deny this?  bugzilla wasn't very helpful for me.  It 
doesn't seem like we can disable ADMA (to solve those issues) and get 
enough test time in (which is what I said a week (or more?) ago too...)

It seems like we should be able to tackle the first two issues promptly, 
at least.

	Jeff



