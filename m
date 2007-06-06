Return-Path: <linux-kernel-owner+w=401wt.eu-S1758682AbXFFIdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758682AbXFFIdy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 04:33:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752887AbXFFIdo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 04:33:44 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:15742 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbXFFIdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 04:33:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=a8xBGjNK6sK87QwGtmvxLakumSFoHlsKNq3drDNRQoY7BeegFPuKs0mqpAhWx9wSc3Aa+qo27i2+ZoUzJTc8TrAryLwaa9dT/ftBUQ2xL5m2mppVi/KpKB8gGQYNr9q0nt7PreiSPPDrf/heRrKW7kRcRMMbAly28AWjHMH/Ia0=
Message-ID: <46667160.80905@gmail.com>
Date: Wed, 06 Jun 2007 17:33:36 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: David Greaves <david@dgreaves.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, xfs@oss.sgi.com,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       netdev@oss.sgi.com, linux-pm <linux-pm@lists.osdl.org>,
       Neil Brown <neilb@suse.de>
Subject: Re: 2.6.22-rc3 hibernate(?) fails totally - regression
References: <46608E3F.4060201@dgreaves.com> <200706012342.45657.rjw@sisk.pl> <46609FAD.7010203@dgreaves.com> <200706020122.49989.rjw@sisk.pl> <4661EFBB.5010406@dgreaves.com> <alpine.LFD.0.98.0706021538360.23741@woody.linux-foundation.org> <4662D852.4000005@dgreaves.com>
In-Reply-To: <4662D852.4000005@dgreaves.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

David Greaves wrote:
> Linus Torvalds wrote:
>> It would be interesting to see what triggered it, since it apparently 
>> worked before. So yes, a bisection would be great.
> 
> Tejun, all the problematic patches are yours - so adding you.

Ouch....

> given the first patch identified is
> 9666f4009c22f6520ac3fb8a19c9e32ab973e828: "libata: reimplement suspend/resume
> support using sdev->manage_start_stop"
> That seems a good candidate...

9ce3075c20d458040138690edfdf6446664ec3ee works, right?  Can you test
9666f4009c22f6520ac3fb8a19c9e32ab973e828 by removing
ata_scsi_device_suspend/resume callbacks from sata_via.c?  Just delete
all lines referencing those two functions.  There were one or two
fallouts from the conversion.

How many drives do you have?  Behavior difference introduced by the
reimplementation is serialization of resume sequence, so it takes more
time.  My test machine had problems resuming if resume took too long
even with the previous implementation.  It didn't matter whether the
long resuming sequence is caused by too many controllers or explicit
ssleep().  If time needed for resume sequence is over certain threshold,
machine hangs while resuming.  I thought it was a BIOS glitch and didn't
dig into it but you might be seeing the same issue.

Please post dmesg too.  Thanks.

-- 
tejun
