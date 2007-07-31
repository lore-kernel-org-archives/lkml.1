Return-Path: <linux-kernel-owner+w=401wt.eu-S1763589AbXGaOpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763589AbXGaOpw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 10:45:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759684AbXGaOpj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 10:45:39 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:25937 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762966AbXGaOpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 10:45:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=dR3RNn5youkrs2aAhJWqMz19GeCrkce4j2XO8W3hCu0FC+f9waYhQZaRDQNgQIWTQUoPGZfixDMU2QpXj564T7TnCIiEXtx5qJBzNuLNrP/aNzyhGmBhQiaD23o/aSillwGtwznHYEEEDPZBUifB4pw2WnDWKEZb/S529rSnK/8=
Message-ID: <46AF4B05.4010700@gmail.com>
Date: Tue, 31 Jul 2007 23:45:25 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Jeff Garzik <jeff@garzik.org>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, edwintorok@gmail.com, axboe@kernel.dk
Subject: Re: [patch 2/4] Expose Power Management Policy option to users
References: <20070705194909.337398431@intel.com>	 <20070705130518.135e4e3c.kristen.c.accardi@intel.com>	 <46AE12B6.6090408@garzik.org>  <46AED656.8070407@gmail.com> <1185891382.2750.8.camel@laptopd505.fenrus.org>
In-Reply-To: <1185891382.2750.8.camel@laptopd505.fenrus.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Tue, 2007-07-31 at 15:27 +0900, Tejun Heo wrote:
>> Jeff Garzik wrote:
>>> Any chance the SCSI peeps could ACK this, and then let me include it in
>>> the ALPM patchset in the libata tree?
>> ATA link PS is pretty complex with HIPM, DIPM and AHCI ALPM.  I'm not
>> sure whether this three level knob would be sufficient. 
> 
> adding more levels later is easy.

Dunno whether they would be linear levels and putting HIPM, DIPM, ALPM
selection into SCSI sysfs knob doesn't look so appealing.

>>  It might be
>> good enough if we're gonna develop extensive in-kernel black/white list
>> specifying which method works on which combination but my gut tells me
>> that it's best left to userland (probably in the form of per-notebook PS
>> profile).
> 
> either sucks. AHCI ALPM ought to work if it's supported; it's what other
> operating systems also use... 
>> Adding to the fun, there are quite a few broken devices out there which
>> act weirdly when link PS actions are taken.
> 
> do you have any specific examples that act funny with the patch in
> question here? (the patch tries to be careful, previous patches weren't
> always so please test this patch before claiming the concept as a whole
> is broken)

They were hardware problems.  I don't think any amount of proper
implementation can fix them.  I have one DVD RAM somewhere in my pile of
hardware which locks up solidly if any link PS mode is used and had a
report of a HDD which had problem with link PS.  Can't remember the
details tho.  Also, IIRC one of my wendies spins down on SLUMBER.

>> Also, I generally don't think AHCI ALPM is a good idea.  It doesn't have
>> 'cool down' period before entering PS state
> 
> that's a chipset implementation decision.... not part of the
> spec/technology per se.

That's actually something AHCI spec specifically states.  From section
8.3.1.3.

When PxCMD.ALPE is set to ‘1’, if the HBA recognizes that there are no
commands to process, the HBA shall initiate a transition to Partial or
Slumber interface power management state based upon the setting of
PxCMD.ASP. The HBA recognizes no commands to transmit as either:

    • PxSACT is set to 0h, and the HBA updates PxCI from a non-zero
value to 0h.
    • PxCI is set to 0h, and a Set Device Bits FIS is received that
updates PxSACT from a non-zero value to 0h.

Have no idea why it's specified this way.  Adding 100ms or 1s cool down
time wouldn't burn noticeably more power.  Maybe AHCI expects the host
driver to queue commands even for non-NCQ drives but libata currently
doesn't do that.

Anyways, I don't really think this attribute belongs to SCSI sysfs
hierarchy.  There currently isn't any alternative but sysfs is part of
userland visible interface and putting something into SCSI sysfs
hierarchy just because libata doesn't have one doesn't look like a good
idea.

sysfs isn't far from being detached from kobject and driver model.  I
think it would be best to wait a bit and build proper libata sysfs
hierarchy which won't have to be changed later when libata departs from
SCSI.  Well, it isn't really a good way but IMHO it's better than
sticking ATA power saving node into SCSI sysfs hierarchy.

Thanks.

-- 
tejun
