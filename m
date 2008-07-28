Return-Path: <linux-kernel-owner+w=401wt.eu-S1758771AbYG1UUH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758771AbYG1UUH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 16:20:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752188AbYG1UTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 16:19:55 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:26541 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751635AbYG1UTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 16:19:54 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuEAAFnGjUhbsgeP/2dsb2JhbAAIixSlIg
Message-ID: <488E29DD.4050303@belbone.be>
Date: Mon, 28 Jul 2008 22:19:41 +0200
From: =?ISO-8859-1?Q?C=E9dric_Godin?= <cedric@belbone.be>
User-Agent: Thunderbird 2.0.0.14 (X11/20080626)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       SCSI Kernel <linux-scsi@vger.kernel.org>
Subject: Re: [SCSI] can't plug Nokia 5300 anymore (bisected)
References: <Pine.LNX.4.44L0.0807281054060.2296-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0807281054060.2296-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Mon, 28 Jul 2008, Cédric Godin wrote:
>
>   
>>>>>> Hello,
>>>>>>
>>>>>> since 2 or 3 -git kernels (Linus tree)  I have a problem with my laptop 
>>>>>> and its connection through USB to a nokia 5300 gsm.
>>>>>>
>>>>>> The logs show me a endless loop (until i unplug my USB cable) of 
>>>>>> following messages :
>>>>>>
>>>>>> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
>>>>>> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current]
>>>>>> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
>>>>>> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current]
>>>>>> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
>>>>>> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current]
>>>>>> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
>>>>>> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current]
>>>>>> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
>>>>>> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current]
>>>>>>
>>>>>> I bisected the kernel and found the following commit as result :
>>>>>>
>>>>>> 427e59f09fdba387547106de7bab980b7fff77be is first bad commit
>>>>>> commit 427e59f09fdba387547106de7bab980b7fff77be
>>>>>> Author: James Bottomley <James.Bottomley@HansenPartnership.com>
>>>>>> Date:   Sat Mar 8 18:24:17 2008 -0600
>>>>>>
>>>>>>    [SCSI] make use of the residue value
>>>>>>
>>>>>>    USB sometimes doesn't return an error but instead returns a residue
>>>>>>    value indicating part (or all) of the command wasn't completed.  So if
>>>>>>    the driver _done() error processing indicates the command was fully
>>>>>>    processed, subtract off the residue so that this USB error gets
>>>>>>    propagated.
>>>>>>             
>
>   
>> That's me sending the wrong dmesg, sorry :-$
>>
>> Attached is the "good" one.
>>
>>     
>>> see only one error, and the commit you found wouldn't have affected 
>>> that error.  More accurately, if the commit magnified the error into an 
>>> endless loop, then without the commit the error would still have been 
>>> present and would have caused data corruption.
>>>
>>> Anyway, it would be interesting to see what happens with the commit in 
>>> place and the following patch applied.  (The first part of the patch 
>>> has already been accepted by James.)
>>>   
>>>       
>> Same problem.
>>     
>
> Okay.  The problem is one we've seen many times in the past: The device
> reports that it contains one sector more than it really does contain.  
> When the system tries to access the non-existent "last" sector, all
> sorts of problems occur.  In your case the device returned no data,
> together with an indication that a problem existed (Check Condition
> status) and no indication of what the problem actually was (no Sense
> data).
>
> The patch below should fix the problem.
>
> Alan Stern
>
>
>
> Index: usb-2.6/drivers/usb/storage/unusual_devs.h
> ===================================================================
> --- usb-2.6.orig/drivers/usb/storage/unusual_devs.h
> +++ usb-2.6/drivers/usb/storage/unusual_devs.h
> @@ -225,6 +225,13 @@ UNUSUAL_DEV(  0x0421, 0x0495, 0x0370, 0x
>  		US_SC_DEVICE, US_PR_DEVICE, NULL,
>  		US_FL_MAX_SECTORS_64 ),
>  
> +/* Reported by Cedric Godin <cedric@belbone.be> */
> +UNUSUAL_DEV(  0x0421, 0x04b9, 0x0551, 0x0551,
> +		"Nokia",
> +		"5300",
> +		US_SC_DEVICE, US_PR_DEVICE, NULL,
> +		US_FL_FIX_CAPACITY ),
> +
>  /* Reported by Olaf Hering <olh@suse.de> from novell bug #105878 */
>  UNUSUAL_DEV(  0x0424, 0x0fdc, 0x0210, 0x0210,
>  		"SMSC",
>
>   
it works, thanks !

Tested-by: Cedric Godin <cedric@belbone.be>


