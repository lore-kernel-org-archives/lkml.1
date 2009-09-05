Return-Path: <linux-kernel-owner+w=401wt.eu-S934507AbZIEAMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934507AbZIEAMt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:12:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934174AbZIEAMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:12:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:45407 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934059AbZIEAMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:12:46 -0400
Message-ID: <4AA1ACF8.7030101@kernel.org>
Date: Sat, 05 Sep 2009 09:12:40 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Tim Blechmann <tim@klingt.org>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: 2.6.31-rc5 regression: hd don't show up
References: <h63737$b2a$1@ger.gmane.org> <4A852BC0.1090404@kernel.org> <4A8559D7.6090405@klingt.org> <4A8774E5.4070609@kernel.org> <4A87D9FC.9070408@klingt.org> <4A96460F.3020600@kernel.org> <4A965E3B.3000808@klingt.org> <4A966F7D.60707@kernel.org> <4A97B9C0.9090003@klingt.org> <4A9B7E1E.8060909@kernel.org> <4A9DAF78.4070703@klingt.org> <4A9DD6D9.50407@kernel.org> <4A9E371A.5040208@klingt.org> <4A9FCD8C.6010107@kernel.org> <4AA18F57.8030107@klingt.org>
In-Reply-To: <4AA18F57.8030107@klingt.org>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/mixed;
 boundary="------------050804060307020409020102"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 05 Sep 2009 00:12:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050804060307020409020102
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Tim Blechmann wrote:
>>>>>>> booting the machine today, one hd is missing again ... bootlog attached
>>>>>> Hmmm... strange.  I don't really see how it could be escaping.  Can
>>>>>> you please apply the attached patch?  It still won't change the
>>>>>> behavior but should be able to catch where it's escaping.
>>>>> attached you find two bootlogs, for a correct boot, and with one hd
>>>>> missing ...
>>>> Heh heh, this is getting a bit embarrassing.  Seems like I wasn't
>>>> looking at the right path.  Can you please try this one too?  If it
>>>> says "XXX D7 pulldown quick exit path" and then succeed to probe,
>>>> that's the previous failure case so you don't need to keep trying to
>>>> reproduce the problem.
>>> i've attached the two boot logs again ...
>> Okay, it was another wrong guess.  Can you please try this one?
> 
> unfortunately, i haven't been able to get a bootlog of a failure the
> issue after rebooting like 20 times with yesterday's linus/master.
> once i couldn't boot, since the root hd wasn't found, so i don't think,
> the issue is solved, it just doesn't show very frequently ...
> 
> the bootlog of a working system is attached, if i experience another
> issue, i will send you another bootlog. since i am out of town for a few
> days, it may take some time, though ...

Alright, please keep me posted.  Another possibility is that it's
timing related and the PHY goes down briefly post-reset.  I think I've
found the code path but not sure yet and given how many times my hunch
has been wrong on this case, not too confident either.  Anyways, if
it's timing related, too many printks could have thrown it off.  If
you can't reproduce the failure with the previous patch, please try
this one and see whether it prints out "XXX: clearing to
ATA_DEV_NONE" on failure.

Thanks.

-- 
tejun

--------------050804060307020409020102
Content-Type: text/x-patch;
 name="nodev-debug-3.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="nodev-debug-3.patch"

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index a04488f..d0d0f88 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2673,8 +2673,10 @@ int ata_eh_reset(struct ata_link *link, int classify,
 				classes[dev->devno] = ATA_DEV_ATA;
 			else if (lflags & ATA_LFLAG_ASSUME_SEMB)
 				classes[dev->devno] = ATA_DEV_SEMB_UNSUP;
-		} else
+		} else {
+			ata_dev_printk(dev, KERN_INFO, "XXX clearing to ATA_DEV_NONE\n");
 			classes[dev->devno] = ATA_DEV_NONE;
+		}
 	}
 
 	/* record current link speed */

--------------050804060307020409020102--
