Return-Path: <linux-kernel-owner+w=401wt.eu-S1757986AbZHQU2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757986AbZHQU2V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 16:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757801AbZHQU2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 16:28:20 -0400
Received: from rtr.ca ([76.10.145.34]:54070 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753349AbZHQU2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 16:28:19 -0400
Message-ID: <4A89BD63.8070103@rtr.ca>
Date: Mon, 17 Aug 2009 16:28:19 -0400
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: Bill Davidsen <davidsen@tmr.com>,
       James Bottomley <James.Bottomley@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Chris Worley <worleys@gmail.com>,
       Matthew Wilcox <matthew@wil.cx>, Bryan Donlan <bdonlan@gmail.com>,
       david@lang.hm, Markus Trippelsdorf <markus@trippelsdorf.de>,
       Matthew Wilcox <willy@linux.intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Nitin Gupta <ngupta@vflare.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: Discard support (was Re: [PATCH] swap: send callback when swap
 	slot is freed)
References: <200908122007.43522.ngupta@vflare.org>	 <1250344518.4159.4.camel@mulgrave.site>	 <20090816150530.2bae6d1f@lxorguk.ukuu.org.uk>	 <20090816083434.2ce69859@infradead.org>	 <1250437927.3856.119.camel@mulgrave.site> <4A8834B6.2070104@rtr.ca>	 <1250446047.3856.273.camel@mulgrave.site> <4A884D9C.3060603@rtr.ca>	 <1250447052.3856.294.camel@mulgrave.site> <4A898752.9000205@tmr.com> <87f94c370908171008t44ff64ack2153e740128278e@mail.gmail.com>
In-Reply-To: <87f94c370908171008t44ff64ack2153e740128278e@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Freemyer wrote:
..
> Mark, I don't believe your tool really addresses the mdraid situation,
> do you agree.  ie. Since your bypassing most of the block stack,
> mdraid has no way of snooping on / adjusting the discards you are
> sending out.
..

Taking care of mounted RAID / LVM filesystems requires in-kernel TRIM
support, possibly exported via an ioctl().

Taking care of unmounted RAID / LVM filesystems is possible in userland,
but would also benefit from in-kernel support, where layouts are defined
and known better than in userland.

The XFS_TRIM was an idea that Cristoph floated, as a concept for examination.

I think something along those lines would be best, but perhaps with an
interface at the VFS layer.  Something that permits a userland tool
to work like this (below) might be nearly ideal:

main() {
	int fd = open(filesystem_device);
	while (1) {
		int g, ngroups = ioctl(fd, GET_NUMBER_OF_BLOCK_GROUPS);
		for (g = 0; g < ngroups; ++g) {
			ioctl(fd, TRIM_ALL_FREE_EXTENTS_OF_GROUP, g);
		}
		sleep(3600);
	}
}

Not all filesystems have a "block group", or "allocation group" structure,
but I suspect that it's an easy mapping in most cases.

With this scheme, the kernel is absolved of the need to track/coallesce
TRIM requests entirely.

Something like that, perhaps.

