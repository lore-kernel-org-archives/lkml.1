Return-Path: <linux-kernel-owner+w=401wt.eu-S1767243AbXCIM7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767243AbXCIM7X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 07:59:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767244AbXCIM7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 07:59:23 -0500
Received: from wx-out-0506.google.com ([66.249.82.238]:62196 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767243AbXCIM7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 07:59:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=WX/ZG4MRlgLd+Yi9xVwCODQI9zXFaZN66LwdFxOshoK1CSSZrtEi4t5I77oO4MF4GaNVbtxPKVzCayIr4DFDd5W8Zpb/ub0EICExvUoV87216rwDOz7IZDTg12/RSg52qcQU47Dm2K/AXyp+CyBCa/VUoL465d/Nra5iyBDyIVM=
Message-ID: <45F15A28.5010700@gmail.com>
Date: Fri, 09 Mar 2007 21:59:20 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Conke Hu <conke.hu@gmail.com>
CC: Jeff Garzik <jeff@garzik.org>, Alan <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] ATAPI command TEST_UNIT_READY never succeeds!
References: <5767b9100703070409o3e094420rf7ccffc436332184@mail.gmail.com>	 <5767b9100703070423y194bf492wad28ddc66ab98775@mail.gmail.com>	 <45EEAFB4.3060306@gmail.com> <5767b9100703090421h27711ceeqda5648eefd428456@mail.gmail.com>
In-Reply-To: <5767b9100703090421h27711ceeqda5648eefd428456@mail.gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Conke Hu wrote:
> On 3/7/07, Tejun Heo <htejun@gmail.com> wrote:
>> (snip)
>> I've read your last posting about this, but forgot to follow up.  TUR is
>> supposed to fail if ATAPI device doesn't have media loaded.  TUR fails
>> and sense data returns device not ready - media not present.  That's the
>> normal operation.  Does TUR fail even with media loaded or is sense data
>> not properly fetched?
>>
> 
> Thank you, Tejun! I did forget to load any media :(
> When I load media and retry, TUR succeeds but there is still a
> problem: when using ahci driver, TUR will not succeed unless it runs
> twice, and the following loop always runs till retries==2
> -------------------- code in sr.c, get_capabilities()
> -------------------------
>     retries = 0;
>     do {
>         memset((void *)cmd, 0, MAX_COMMAND_SIZE);
>         cmd[0] = TEST_UNIT_READY;
> 
>         the_result = scsi_execute_req (cd->device, cmd, DMA_NONE, NULL,
>                            0, &sshdr, SR_TIMEOUT,
>                            MAX_RETRIES);
> 
>         retries++;
>     } while (retries < 5 &&
>          (!scsi_status_is_good(the_result) ||
>           (scsi_sense_valid(&sshdr) &&
>            sshdr.sense_key == UNIT_ATTENTION)));
> ------------------------------------- end code
> -------------------------------------
> 
> this issue only occurs in ahci driver,  and libata + pata driver is OK.

After media is loaded, it takes some time for the device to get ready,
and it's supposed to raise UNIT_ATTENTION to tell the driver that media
has changed.  TUR fails with UA and sense data reports media exchanged
and the next TUR succeeds.  In SATA, you might also see unit reset UA
due to the probing sequence.  Those are why TUR is tried several times
in the first place.

So, there's nothing wrong with failing TURs, it's perfectly normal that
they fail first one or two tries.

-- 
tejun
