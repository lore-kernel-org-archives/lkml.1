Return-Path: <linux-kernel-owner+w=401wt.eu-S1755155AbYANDLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155AbYANDLt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 22:11:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752129AbYANDLj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 22:11:39 -0500
Received: from hqemgate02.nvidia.com ([216.228.112.143]:2466 "EHLO
	HQEMGATE02.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbYANDLi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 22:11:38 -0500
X-PGP-Universal: processed;
	by hqnvupgp02.nvidia.com on Sun, 13 Jan 2008 19:11:26 -0800
X-MimeOLE: Produced By Microsoft Exchange V6.5
MIME-Version: 1.0
Subject: RE: fixed a bug of adma in rhel4u5 with HDS7250SASUN500G.
Date: Mon, 14 Jan 2008 11:08:27 +0800
Message-ID: <15F501D1A78BD343BE8F4D8DB854566B1BFE2AC0@hkemmail01.nvidia.com>
In-Reply-To: <478812C9.1000901@shaw.ca>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: fixed a bug of adma in rhel4u5 with HDS7250SASUN500G.
Thread-Index: AchUt6haosjcVtzPTh6qLDaACeheNgBnLRFQ
References: <4781F008.9070404@gmail.com> <4782422C.8020202@rtr.ca> <4782B73B.8080309@shaw.ca> <4782BC48.4000309@gmail.com> <4782C008.3030902@shaw.ca> <4782CB62.7040901@gmail.com> <4782CEF9.3040708@gmail.com> <4782DFFE.50301@shaw.ca> <4782E5A8.9010305@gmail.com> <4782E63E.1000606@gmail.com> <4782E78F.9050205@shaw.ca> <4782E912.1050204@gmail.com> <4783493A.7070800@gmail.com> <47838B57.8020407@shaw.ca> <47842A54.2060107@gmail.com> <47842ABA.2060605@gmail.com> <47844471.4070705@shaw.ca> <47845708.6060900@gmail.com> <478567D8.10601@shaw.ca> <15F501D1A78BD343BE8F4D8DB854566B1BFE2ABF@hkemmail01.nvidia.com> <478812C9.1000901@shaw.ca>
From: "Kuan Luo" <kluo@nvidia.com>
To: "Robert Hancock" <hancockr@shaw.ca>
Cc: "Tejun Heo" <htejun@gmail.com>, "Mark Lord" <liml@rtr.ca>,
       "Jeff Garzik" <jeff@garzik.org>,
       "IDE/ATA development list" <linux-ide@vger.kernel.org>,
       "Allen Martin" <AMartin@nvidia.com>, "Peer Chen" <pchen@nvidia.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "David Milburn" <dmilburn@redhat.com>
X-OriginalArrivalTime: 14 Jan 2008 03:09:11.0957 (UTC) FILETIME=[D620AC50:01C8565A]
Content-class: urn:content-classes:message
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert hancock wrote:
> What problem does this resolve? I tested it against the cache 
> flush/NCQ 
> write switching problem we've been trying to solve, and it 
> doesn't look 
> like it fixes that one - if I apply this patch and then remove the 
> udelay(20) in sata_nv.c that I added which prevented me from 
> seeing this 
> problem before, it shows up.
>

First thank  davide to help to send the attachment.

Robert,
The patch is to solve the error message "ata1: CPB flags CMD err,
flags=0x11" when testing HDS7250SASUN500G in rhel4u5.
I tested this hd in 2.6.24-rc7 which needed to remove the mask in
blacklist to run the ncq and the same error also showed up. 

I traced the  bug and found that the interrupt finished a command (for
example, tag=0) when the driver got that adma status is
NV_ADMA_STAT_DONE  and  cpb->resp_flags is NV_CPB_RESP_DONE.
However, For this hd, the drive maybe didn't clear bit 0 at this moment.
It meaned the hardware  had not completely finished the command.
If at the same time  the driver freed the command(tag 0) and sended
another command (tag 0), the error happened.

The notifier register is 32-bit register containing notifier value.
Value is bit vector containing one bit per tag number (0-31) in
corresponding bit positions (bit 0 is for tag 0, etc). When bit is set
then ADMA indicates that command with corresponding tag number completed
execution.

So i added the check notifier code. Sometimes i saw that the notifier
reg set some bits  , but the adma status set NV_ADMA_STAT_CMD_COMPLETE
,not NV_ADMA_STAT_DONE. So i added the NV_ADMA_STAT_CMD_COMPLETE check
code.



-----------------------------------------------------------------------------------
This email message is for the sole use of the intended recipient(s) and may contain
confidential information.  Any unauthorized review, use, disclosure or distribution
is prohibited.  If you are not the intended recipient, please contact the sender by
reply email and destroy all copies of the original message.
-----------------------------------------------------------------------------------
