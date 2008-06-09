Return-Path: <linux-kernel-owner+w=401wt.eu-S1754233AbYFIQDA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233AbYFIQDA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 12:03:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751502AbYFIQCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 12:02:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34460 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751392AbYFIQCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 12:02:50 -0400
Date: Mon, 9 Jun 2008 08:58:18 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Kay Sievers <kay.sievers@vrfy.org>
cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Vegard Nossum <vegard.nossum@gmail.com>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Neil Brown <neilb@suse.de>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Dave Young <hidave.darkstar@gmail.com>
Subject: Re: [bug, 2.6.26-rc4/rc5] sporadic bootup crashes in
 blk_lookup_devt()/prepare_namespace()
In-Reply-To: <1213026413.14898.5.camel@linux.site>
Message-ID: <alpine.LFD.1.10.0806090850090.3473@woody.linux-foundation.org>
References: <20080609080312.GA32458@elte.hu>  <20080609020623.b6727f2b.akpm@linux-foundation.org>  <19f34abd0806090209l541d93c6jaba2704314b34418@mail.gmail.com>  <20080609133426.GB20194@cs181133002.pp.htv.fi>  <19f34abd0806090658v54f3a912n2ed30ad6cc20d00@mail.gmail.com>
  <19f34abd0806090728s3b3fdbeq7dd3d31d02c8f28e@mail.gmail.com>  <20080609165757.184724ff@gondolin.boeblingen.de.ibm.com>  <alpine.LFD.1.10.0806090819410.3473@woody.linux-foundation.org> <1213026413.14898.5.camel@linux.site>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 9 Jun 2008, Kay Sievers wrote:
> 
> I think we should keep the patch, as it fixed a different issue, and it
> seems the bug was there even before the patch - the function was just
> not called 3 times, so even more unlikely to trigger it.

No, before the patch we never did a "dev_to_disk()" on the device. We just 
did

	if (strcmp(dev->bus_id, name) == 0) {
		devt = dev->devt;
		break;
	}

and we simply didn't care if it was a disk or a partition - it would work 
correctly for both.

Your patch made it simply not work for partitions at all (by dereferencing 
an illegal address off them). My fix makes it ignore partitions entirely, 
but I'm a bit nervous that there might be some setup that sets up *only* 
partitions, not any base device at all. I guess that is unlikely, but it 
worries me a bit.

		Linus
