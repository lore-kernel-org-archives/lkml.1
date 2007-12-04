Return-Path: <linux-kernel-owner+w=401wt.eu-S1751889AbXLDETb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889AbXLDETb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 23:19:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751425AbXLDETW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 23:19:22 -0500
Received: from smtp01.mtu.ru ([62.5.255.48]:57649 "EHLO smtp01.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409AbXLDETW (ORCPT <rfc822; linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 23:19:22 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: Is BIO_RW_FAILFAST really usable?
To: Jeff Garzik <jeff@garzik.org>, Neil Brown <neilb@suse.de>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Date: Tue, 04 Dec 2007 07:19:16 +0300
References: <18260.49019.684445.303719@notabene.brown> <4754CEB9.4030703@garzik.org>
User-Agent: KNode/0.10.5
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <20071204041915.8B63AABF9BD@smtp01.mtu.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:

> Neil Brown wrote:
>> I've been looking at use BIO_RW_FAILFAST in md/raid to improve
>> handling of some error cases.
>> 
>> This is particularly significant for the DASD driver (s390 specific).
>> I believe it uses optic fibre to connect to the drives.  When one of
>> these paths is unplugged, IO requests will block until an operator
>> runs a command to reset the card (or until it is plugged back in).

Are there any options? This reminds me of Emulex lpfc driver that by default
would retry forever but could be configured to fail request after timeout.

>> The only way to avoid this blockage is to use BIO_RW_FAILFAST.  So
>> we really need BIO_RW_FAILFAST for a reliable RAID1 configuration on
>> DASD drives.
>> 
>> However, I just tested BIO_RW_FAILFAST on my SATA drives: controller
>> 
>> 02:06.0 RAID bus controller: Silicon Image, Inc. SiI 3114
>> [SATALink/SATARaid] Serial ATA Controller (rev 02)
>> 
>> (not using the cards minimal RAID functionality) and requests fail
>> immediately and always with e.g.
>> 
>> sd 2:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT
>> driverbyte=DRIVER_OK,SUGGEST_OK end_request: I/O error, dev sdc, sector
>> 2048
>> 
>> So fail fast obviously isn't generally usable.
>> 
>> What is the answer here?  Is the Silicon Image driver doing the wrong
>> thing, or is DASD doing the wrong thing, or is BIO_RW_FAILFAST
>> under-specified and we really need multiple flags or what?
> 
> It's a hard thing to implement, in general, for scalability reasons.
> 
> To make it work, you need to examine each driver's error handling to
> figure out what "fail fast" really means.
> 
> Most storage drivers are written to try as hard as possible to complete
> a request, where "try as hard as possible" can often mean internal
> retries while trying various multi-path configurations and hardware mode
> changes.  You might be catching SATA in the middle of error handling,
> for example.
> 
> So each driver really has a /slight different/ version of "try to
> complete this request", which has the obvious effects on BIO_RW_FAILFAST.
> 
> No clue about DASD, but in SATA's case I bet that a media or transfer
> error could be returned to the system more rapidly, while we continue to
> try to recover in the background. 

Well, FAILFAST is really needed only for redundant configuration (either
multipath or RAID). But in this case what is the point of retrying request
at all? It just complicates implementation.

Just fail request as soon as possible and let upper layer to recover.

-andrey

> libata doesn't have any direct 
> knowledge of fail-fast at this point, IIRC.
> 
> But overall it's a job where you must examine each driver, or set of
> drivers :/
> 
> Jeff
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ide" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


