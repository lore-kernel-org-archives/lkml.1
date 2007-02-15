Return-Path: <linux-kernel-owner+w=401wt.eu-S966005AbXBOQDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966005AbXBOQDY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 11:03:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966006AbXBOQDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 11:03:24 -0500
Received: from nz-out-0506.google.com ([64.233.162.233]:61489 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966005AbXBOQDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 11:03:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=gon++FPd451hgj6APHRKpem4H50t+vXHhZl5yTrOR2sYUdmiol37NwKWt/rWf5P9M7jGj14Samc9w0+Tl5OLAlkH2cqgtk6GzZo9fWegQJaMcBhbT55u0QEI7jOPdr/B7iZFqUz0mVSMhgFHVYBR+hqYAMQVItPThrLxKwedqW0=
Message-ID: <45D3F445.1030708@gmail.com>
Date: Thu, 15 Feb 2007 14:48:53 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: "Martin A. Fink" <fink@mpe.mpg.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: SATA-performance: Linux vs. FreeBSD
References: <200702121502.17130.fink@mpe.mpg.de>
In-Reply-To: <200702121502.17130.fink@mpe.mpg.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Martin.

Martin A. Fink wrote:
> Test					OpenSuSE(AHCI)			FreeBSD(AHCI)
> ---------------------------------------------------------------------------------------------------------------------------------------
> SSD(vfat 25GB)			41+/-2 MB/s at 4-10%		15+/-0 MB/s at 2% CPU
> SSD(raw  25GB) 		26+/-1 MB/s at 4-10% CPU	48+/-0 MB/s at 1% CPU
> SSD(ext3 25GB)		39+/-5 MB/s at 10-15% CPU	34+/-0 MB/s at 14% CPU
> SSD(ext2 25GB)		42+/-1 MB/s at 10-15% CPU	32+/-0 MB/s at 10% CPU
> ---------------------------------------------------------------------------------------------------------------------------------------
> 
> Test					OpenSuSE (AHCI off)		FreeBSD (AHCI off)
> ---------------------------------------------------------------------------------------------------------------------------------------
> SSD(vfat 25GB)			22+/-4 MB/s at 6-19% CPU	--
> SSD(raw  25GB)		33+/-4 MB/s at 7-14% CPU	41+/-0 MB/s at 1% CPU
> SSD(ext2 25GB)		27+/-6 MB/s at 6-14% CPU	--
> ---------------------------------------------------------------------------------------------------------------------------------------
> 
> Question 1:
> Can anybody explain to me, why writing to a SATA-I device with AHCI consumes 
> so much CPU time using Linux, while it takes almost no CPU time on FreeBSD 
> 6.2 ? Especially comparing values of writing to the raw device?

Can't tell.  AHCI needs very few MMIOs to perform each request.  As Andi 
suggested, please do oprofile.  It's easy.

> Question 2:
> Can anybody explain to me, why writing to a solid state disk (a kind of memory 
> that always has the same constant bandwidth) has such big standard errors in 
> writing rate using Linux (between 1 to 6 MB/s error) while FreeBSD gives an 
> almost constant writing rate (as one would expect it for a SSD) ?

The default iosched is heavily optimized for regular disks with moving 
head and for more usual workload.  Requests are sometimes paused to wait 
for requests in adjacent area.  Use deadline or noop for ssd.

Also, try turn off NCQ.  Some of early drives from major disk vendors 
had all kinds of issues with NCQ implementation.  SSD firmwares don't 
tend to be of high quality.

> Question 3:
> Why is writing to a raw device in Linux slower than using e.g. ext2 ? And why 
> is Linux writing rate much lower (-12.5 % for the best case) compared to 
> writing rate of FreeBSD?

As written above, the first thing I can think of is interaction with 
iosched.  SSD and your workload are pretty unusual.

> Question 4:
> When writing to the SATA-II HDD Linux is around 10% slower than FreeBSD when 
> using ext3, but around as fast as FreeBSD when writing raw. Why?

Dunno much about that.  Where's the test result?

> How can I improve the speed of Linux,

Other ppl have pointed out but use /dev/sdX not the raw devices.  If you 
use raw, you end up writing each chunk synchronously.

-- 
tejun

