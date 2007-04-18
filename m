Return-Path: <linux-kernel-owner+w=401wt.eu-S932451AbXDRFkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932451AbXDRFkA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 01:40:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932473AbXDRFkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 01:40:00 -0400
Received: from wr-out-0506.google.com ([64.233.184.229]:35274 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932451AbXDRFj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 01:39:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=RSiXyyiRl0Ad51biJaoi2D1yHusfK+GwJLJAzuFsxw1sUOnXi5JjNcTF7ikdjzsglR5SBcqQMt+2OQ+xEPM/Zt+2ekXgFeV/QRrDK6IjcTCkTLbXUBt6Law+ZswMsRSvc5g85gkIeXRh+na37oRHoVlqXJoc1CrE+aaJ01ydjOE=
Message-ID: <4625AF20.7050904@gmail.com>
Date: Wed, 18 Apr 2007 14:39:44 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Mark Lord <liml@rtr.ca>
CC: Chuck Ebbert <cebbert@redhat.com>, emisca <emisca.ml@gmail.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@osdl.org>
Subject: Re: Loud "pop" coming from hard drive on reboot
References: <461D4E2C.6000704@redhat.com>	 <Pine.LNX.4.61.0704112315480.20436@yvahk01.tjqt.qr>	 <461D54AF.3060706@redhat.com> <414cba4e0704150907r215bf196n637070dd40bccc3b@mail.gmail.com> <46253F14.4020304@rtr.ca> <462540CD.9080406@redhat.com> <46254416.6090202@rtr.ca>
In-Reply-To: <46254416.6090202@rtr.ca>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Chuck Ebbert wrote:
>> Mark Lord wrote:
>>> I'll patch it locally on my own machines, but what about the tens
>>> of thousands of other Seagate notebook drive owners out there?
>>>
>>
>> This is a problem with Seagate specifically, spinning back up
>> on receipt of some command after spindown?
> 
> No, they just seem to be affected worse by it than some other brands.
> The bug is that libata/SCSI now spin-down the drive before the distro's
> scripts are done with it, so it spins down, and then gets spun up again
> by the distro, and then spun down again by the distro.
> 
> And along the way, one/both of the two causes a full mechanism "park",
> which is hard on things if abused (like this).
> 
> Or at least that's what I recall for it.  Tejun?

This really isn't a regression.  It's been always like that with libata.
 libata doesn't make devices go into standby mode and shutdown(8) does
it for libata.  The problem here is that libata does issue
SYNCHRONIZE_CACHE on shutdown.  So, the sequence of event is...

1. shutdown(8) issues SYNCHRONIZE_CACHE followed by STANDBY_NOW
2. kernel shutdown starts
3. libata shutdown issues SYNCHRONIZE_CACHE
4. power goes off

Some drives seem to spin up at step #3 even when its cache is clean and
power goes off right after the disk finishes the command.  So, it's
really bad when it happens - spin down, spin up followed by immediate
power off.

SCSI part of the fix is queued in scsi-misc-2.6 tree and libata-dev part
is acked and waiting to be merged, so the fix will be available in
2.6.22.  However, it's disabled by default to remain compatible with the
current behavior and requires userland change to fully fix the problem.

-- 
tejun
