Return-Path: <linux-kernel-owner+w=401wt.eu-S1753001AbZGAOzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001AbZGAOzw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 10:55:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753858AbZGAOzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 10:55:32 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:42561 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839AbZGAOz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 10:55:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=DpxXpZ89DLsZHfV7cayd2wCmbH3OQBEliRM3sNbOLP5yiP9oFaj5h8uwN9Y/VqF8ye
         w11aEfU75RD5JhpW4W41z6nXHHy4ghSdWMCyHUF4lKT4wJh4l229Aeu2KHT4+pMg5kfC
         SYyhbvapSOaW7QH3JPp13UpNp3WNU0koIJEfs=
Subject: Re: [BUG] MIPS: Hibernation in the latest linux-mips:master branch
 not work
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-mips@linux-mips.org, Pavel Machek <pavel@ucw.cz>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <1246432570.9660.22.camel@falcon>
References: <1246372868.19049.17.camel@falcon>
	 <20090630144540.GA18212@linux-mips.org>  <1246432570.9660.22.camel@falcon>
Content-Type: text/plain
Organization: DSLab, Lanzhou University, China
Date: Wed, 01 Jul 2009 22:55:12 +0800
Message-Id: <1246460112.9660.45.camel@falcon>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-01 at 15:16 +0800, Wu Zhangjin wrote:
> On Tue, 2009-06-30 at 15:45 +0100, Ralf Baechle wrote:
> > On Tue, Jun 30, 2009 at 10:41:08PM +0800, Wu Zhangjin wrote:
> > 
> > > I just updated my git repository to the master branch of the latest
> > > linux-mips git repository, and tested the STD/Hibernation support on
> > > fuloong2e and yeeloong2f, it failed:
> > > 
> > > when using the no_console_suspend kernel command line to debug, it
> > > stopped on:
> > > 
> > > PM: Shringking memory... done (1000 pages freed)
> > > PM: Freed 160000 kbytes in 1.68 seconds (95.23 MB/s)
> > > PM: Creating hibernation image:
> > > PM: Need to copy 5053 pages
> > > PM: Hibernation image created (4195 pages copied)
> > > 
> > > and then, the number indicator light of keyboard works well, but can not
> > > type anything. 
> > > 
> > > anybody have tested it on another platform? does it work?
> > 
> > At the time of the merge I tested it on Malta and found it to be working.
> > 
> 
> Just traced it, the executing path is something like this:
> 
> 	hibernate(kernel/power/hibernate.c)
> 	--> hibernation_snapshot
> 	--> dpm_resume_end
> 	--> dpm_resume
>         --> device_resume
> 	--> dev->bus->resume(generic_ide_resume), dev_name(dev) = 0.0
> 	--> blk_execute_rq
>         {
> 		DECLARE_COMPLETION_ONSTACK(wait);
> 		...
> 		wait_for_completion(&wait);	// stop here
> 		...
> 	}
> 
> I guess there is a possible bug in the latest ide patches, I'm trying to
> find which one is 'bad'.
> 

There is really a bug in one of ide patches, here it is:

commit a1317f714af7aed60ddc182d0122477cbe36ee9b
Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date:   Tue Jun 23 23:52:17 2009 -0700

    ide: improve handling of Power Management requests
    
    Make hwif->rq point to PM request during PM sequence and do not
allow
    any other types of requests to slip in (the old comment was never
correct
    as there should be no such requests generated during PM sequence).
    
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

I have reverted this part of the above patch, seems works, need more
tests:

-
-               WARN_ON_ONCE(hwif->rq);
 repeat:
                prev_port = hwif->host->cur_port;
+
+               if (drive->dev_flags & IDE_DFLAG_BLOCKED)
+                       rq = hwif->rq;
+               else
+                       WARN_ON_ONCE(hwif->rq);
+

please get more information from this bug report:

[Bug #13663] suspend to ram regression (IDE related)
http://lkml.org/lkml/2009/6/29/341

Regards!
Wu Zhangjin

