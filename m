Return-Path: <linux-kernel-owner+w=401wt.eu-S1755451AbZEQXOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451AbZEQXOj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 19:14:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754378AbZEQXOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 19:14:07 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:36803 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbZEQXOA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 19:14:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=Edv2fp9lHM61aJtxj8MbUKjWc8qAVoKaJa7XBfrAN4p+ntZrNal+2eOFxKS6x7rRIM
         0Qadf1CvGkmJ6mRNWNg9h44Nu1nLNj3JJ76pOMW9x3tULm/Xde7x40SBDWBVmR51VKiL
         rdLeC48kTB6bjwupbBd7UKgPzNPDu5RqwDN8U=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Richard Atterer <richard@2009.atterer.net>
Subject: Re: s2disk hangs with kernel >=2.6.29, SATA, Gigabyte EG45M-DS2H (bisected)
Date: Mon, 18 May 2009 01:17:27 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc3-00442-ga3668b0; KDE/4.2.2; i686; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Elias Oltmanns <eo@nebensachen.de>, linux-ide@vger.kernel.org
References: <20090516225153.GA7883@arbonne.lan>
In-Reply-To: <20090516225153.GA7883@arbonne.lan>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200905180117.28413.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sunday 17 May 2009 00:51:53 Richard Atterer wrote:
> Hello,
> 
> I have had problems using s2disk starting sometime before 2.6.29 (and 
> continuing up until now, 2.6.30-rc6), but only got around to bisecting the 
> issue now.
> 
> The symptom is as follows: When I start s2disk (by running the hibernate 
> command), the system switches to the console and prints "s2disk: 
> Snapshotting system". The cursor freezes for a moment, I hear the noise 
> that my DVD writer makes when it is reset, the lights of my USB hub go off 
> and on again. Then the cursor continues to blink and nothing more happens, 
> the system just hangs.
> 
> I have a Gigabyte EG45M-DS2H motherboard with two disks attached: One SATA 
> disk containing Linux, and one older PATA disk with data. AHCI is enabled 
> in the BIOS.
> 
> The patch that causes the hang is 295f00042aaf6b553b5f37348f89bab463d4a469:
> ide: don't execute the next queued command from the hard-IRQ context (v2)

Hmm, this should have been fixed by:

commit 2ea5521022ac8f4f528dcbae02668e02a3501a5a
Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date:   Wed Jan 14 19:19:04 2009 +0100

    ide: fix suspend regression

    On Monday 12 January 2009, Simon Holm Thøgersen wrote:
    > commit 295f000 ("ide: don't execute the next queued command from the
    > hard-IRQ context (v2)") breaks suspend to disk for me. On
    > 'echo disk > /sys/power/state' the systems hangs, letting me switch
    > virtual consoles, but not responding to Alt+SysRq

    Restart the request queue early for REQ_TYPE_PM_RESUME requests
    (though there is only one resume request for the whole resume
    sequence it stays in the queue until is fully completed and now
    depends on kblockd for processing consequential resume states).

    Reported-and-bisected-by: Simon Holm Thøgersen <odie@cs.aau.dk>
    Tested-by: Simon Holm Thøgersen <odie@cs.aau.dk>
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

What was the last 'good' kernel that you've started bisection with?

Thanks,
Bart
