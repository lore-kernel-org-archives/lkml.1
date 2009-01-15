Return-Path: <linux-kernel-owner+w=401wt.eu-S1763451AbZAOS4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763451AbZAOS4F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 13:56:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755569AbZAOSzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 13:55:54 -0500
Received: from smtp-out.google.com ([216.239.33.17]:63278 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755524AbZAOSzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 13:55:52 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:
	x-gmailtapped-by:x-gmailtapped;
	b=ZiK0RHh8oggC0SnOrKMcJtvVXgfFubfJGqWNN/ZTDQdsOxKDl+corft0TCzCXsmJZ
	7u/V7HbVwSCz1XONKzwSw==
MIME-Version: 1.0
In-Reply-To: <1232035561.5966.48.camel@localhost.localdomain>
References: <200901051952.58029.bzolnier@gmail.com>
	 <20090105185428.GS32491@kernel.dk>
	 <ac3eb2510901051347r6593d0fmd64702b1689716c1@mail.gmail.com>
	 <20090106073515.GY32491@kernel.dk> <4964866D.8010503@msgid.tls.msk.ru>
	 <1231342473.3282.19.camel@localhost.localdomain>
	 <496ECBA0.60209@gmail.com>
	 <87f94c370901150707h10506e99reaa40c23e32ab18c@mail.gmail.com>
	 <1232035561.5966.48.camel@localhost.localdomain>
Date: Thu, 15 Jan 2009 10:55:45 -0800
Message-ID: <da824cf30901151055o2385ef74x918e8390e576d807@mail.gmail.com>
Subject: Re: [PATCH] block: export SSD/non-rotational queue flag through sysfs
From: Grant Grundler <grundler@google.com>
To: James Bottomley <James.Bottomley@hansenpartnership.com>,
       Jens Axboe <jens.axboe@oracle.com>
Cc: Greg Freemyer <greg.freemyer@gmail.com>, Tejun Heo <htejun@gmail.com>,
       Michael Tokarev <mjt@tls.msk.ru>, Kay Sievers <kay.sievers@vrfy.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.28.16.142
X-GMailtapped: grundler
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2009 at 8:06 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
...
> Right, this is the flash cache idea that's been floating around for a
> while.  It's even been suggested as a way of avoiding the IDE barrier
> flush penalties.  I think Seagate went as far as making hybrid drives
> that were a large flash cache backed by rotational storage.

"inline" RAM caches  were implemented 10+ years ago for SCSI devices
to avoid seek *and* rotational delay penalties. These were transperent
SCSI devices that would cache and prefetch content from disks.
For the given dataset size, the seek cost was effectively zero. This is
mostly true today for high-end disk arrays which have large RAM
front-end's (TB) and very smart data placement strategies (reduced seek).

Back to the bikeshed painting: I prefer two flags: "AVGREADCOST" and
"AVGWRITECOST as the flag. This isn't just about seek. Rotational delay
@7200 RPM is 8.3ms. Making both non-zero implies rotational media.
Different devices have different read and write characteristics.
Flash typically has a much higher write cost than read cost.
Disks (because of WCE) can be the opposite.

Code can test for zero/nonzero or (preferably) more fine grained.
e.g. "avgreadcost > 1ms" or "avgwritecost". I'm hoping this test
can be abstracted into a macro.

I'm hoping longterm, the values could be "self tuning" but don't know
how that might work - e.g. 1 minute avg? 10 minute avg? Cost
of collecting/maintaining the stats? Feels like a CONFIG option.

hth,
grant
