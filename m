Return-Path: <linux-kernel-owner+w=401wt.eu-S932666AbXAWCoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932666AbXAWCoR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 21:44:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932667AbXAWCoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 21:44:17 -0500
Received: from mail.gmx.net ([213.165.64.20]:57263 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932666AbXAWCoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 21:44:16 -0500
X-Authenticated: #5039886
Date: Tue, 23 Jan 2007 03:44:13 +0100
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Robert Hancock <hancockr@shaw.ca>
Cc: Jeff Garzik <jeff@garzik.org>, Chr <chunkeey@web.de>,
       Alistair John Strachan <s0348365@sms.ed.ac.uk>,
       linux-kernel@vger.kernel.org, htejun@gmail.com, jens.axboe@oracle.com,
       lwalton@real.com, pomac@vapor.com
Subject: Re: SATA exceptions with 2.6.20-rc5
Message-ID: <20070123024412.GA16533@atjola.homenet>
Mail-Followup-To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
	Robert Hancock <hancockr@shaw.ca>, Jeff Garzik <jeff@garzik.org>,
	Chr <chunkeey@web.de>,
	Alistair John Strachan <s0348365@sms.ed.ac.uk>,
	linux-kernel@vger.kernel.org, htejun@gmail.com,
	jens.axboe@oracle.com, lwalton@real.com, pomac@vapor.com
References: <fa.ow4pXUncgdZmfLf3oyfrn1W+Bk0@ifi.uio.no> <fa.SoSeidhDuEr/K0kN+L4vW61Vpnc@ifi.uio.no> <fa.m8QbVQMhuOshKzTdlSjNjOhaNcc@ifi.uio.no> <fa.hDS02YCM8Tv1/STeTpJGEQD/49s@ifi.uio.no> <fa.eqBbU9XvtTizNMpuUjctnk8vuOI@ifi.uio.no> <fa.4QxeKMcmkoyhlL26AivZV6BFQJQ@ifi.uio.no> <45B563C6.5070505@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <45B563C6.5070505@shaw.ca>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.01.22 19:24:22 -0600, Robert Hancock wrote:
> Björn Steinbrink wrote:
> >>>Running a kernel with the return statement replace by a line that prints
> >>>the irq_stat instead.
> >>>
> >>>Currently I'm seeing lots of 0x10 on ata1 and 0x0 on ata2.
> >>40 minutes stress test now and no exception yet. What's interesting is
> >>that ata1 saw exactly one interrupt with irq_stat 0x0, all others that
> >>might have get dropped are as above.
> >>I'll keep it running for some time and will then re-enable the return
> >>statement to see if there's a relation between the irq_stat 0x0 and the
> >>exception.
> >
> >No, doesn't seem to be related, did get 2 exceptions, but no irq_stat
> >0x0 for ata1. Syslog/dmesg has nothing new either, still the same
> >pattern of dismissed irq_stats.
> 
> I've finally managed to reproduce this problem on my box, by doing:
> 
> watch --interval=0.1 /sbin/hdparm -I /dev/sda
> 
> on one drive and then running bonnie++ on /dev/sdb connected to the 
> other port on the same controller device. Usually within a few minutes 
> one of the IDENTIFY commands would time out in the same way you guys 
> have been seeing.
> 
> Through some various trials and tribulations, the only conclusion I can 
> come to is that this controller really doesn't like that 
> NV_INT_STATUS_CK804 register being looked at in ADMA mode. I tried 
> adding some debug code to the qc_issue function that would check to see 
> if the BUSY flag in altstatus went high or that register showed an 
> interrupt within a certain time afterwards, however that really seemed 
> to hose things, the system wouldn't even boot.

Hm, I don't think it is unhappy about looking at NV_INT_STATUS_CK804.
I'm running 2.6.20-rc5 with the INT_DEV check removed for 8 hours now
without a single problem and that should still look at
NV_INT_STATUS_CK804, right?
I just noticed that my last email might not have been clear enough. The
exceptions happened when I re-enabled the return statement in addition
to the debug message. Without the INT_DEV check, it is completely fine
AFAICT.

> Try out this patch, it just calls the ata_host_intr function where 
> appropriate without using nv_host_intr which looks at the 
> NV_INT_STATUS_CK804 register. This is what the original ADMA patch from 
> Mr. Mysterious NVIDIA Person did, I'm guessing there may be a reason for 
> that. With this patch I can get through a whole bonnie++ run with the 
> repeated IDENTIFY requests running without seeing the error.

I'll see if I can schedule a test run for tomorrow, I currently need
this box.

Thanks,
Björn
