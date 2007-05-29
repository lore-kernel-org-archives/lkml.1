Return-Path: <linux-kernel-owner+w=401wt.eu-S1764138AbXE2JMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764138AbXE2JMl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 05:12:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753090AbXE2JMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 05:12:31 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:32563 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbXE2JM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 05:12:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nRE+5mG0Hr0GvW5vraobhupub5R+1uQ4E+TEYR4eehJSPVDU6VEMIrURMx/EdfV+UjUzK9WKDy5ro9x2LWSU2pFk1rCwTbvIGdUQCrDIX/oyGJl9rIvUHSlU14MTN1l3cXJ7T0BP74LbmJonnPCuT/Nj4ky08esCPNKy+PhFKuM=
Message-ID: <5201e28f0705290212q60dc1bcfkfc234b321f3c3b64@mail.gmail.com>
Date: Tue, 29 May 2007 11:12:27 +0200
From: "Stefan Bader" <sbader3@googlemail.com>
To: "Neil Brown" <neilb@suse.de>
Subject: Re: [RFD] BIO_RW_BARRIER - what it means for devices, filesystems, and dm/md.
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       dm-devel@redhat.com, linux-raid@vger.kernel.org,
       "Jens Axboe" <jens.axboe@oracle.com>, "David Chinner" <dgc@sgi.com>,
       "Alasdair Kergon" <agk@redhat.com>
In-Reply-To: <18010.12880.258773.95448@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <18006.38689.818186.221707@notabene.brown>
	 <5201e28f0705250652mff2735dwd2c14f5ad130ae97@mail.gmail.com>
	 <18010.12880.258773.95448@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > 2007/5/25, Neil Brown <neilb@suse.de>:
> > BIO_RW_FAILFAST: means low-level driver shouldn't do much (or no)
> > error recovery. Mainly used by mutlipath targets to avoid long SCSI
> > recovery. This should just be propagated when passing requests on.
>
> Is it "much" or "no"?
> Would it be reasonable to use this for reads from a non-degraded
> raid1?  What about writes?
>
This depends on the device driver's implementation. AFAIK there is no
fix rule how to handle that flag exactly. The SCSI driver seems to
omit internal recovery procedures but requests still can take as long
as the SCSI request time-out. I am not sure of all internals. Maybe
some error recovery is done as long as it shouldn't take very long.
For the DASD driver on zSeries this flags will only affect situations
when the driver decides there is no other way of succeeding. Recovery
is still done.
Using this flag was intended to move error handling to an upper layer
in the device stack. For multipathing it is good to be able to map a
request to another path instead of waiting until the SCSI layer
finally would give up with one path. For a RAID1 this might cause
requests to fail which would have been recovered. This might require
more error handling in md.
The error code as it is at this time doesn't say much in detail. I
once saw patches (and there are comments about a path missing from
Jens Axboe) to pass sense data (from SCSI) in the bio. I am not sure
whether this was dropped for some reason or just is in the pipe. Jens?

Stefan
