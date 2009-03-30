Return-Path: <linux-kernel-owner+w=401wt.eu-S1756823AbZC3RjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823AbZC3RjZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 13:39:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751937AbZC3RjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 13:39:16 -0400
Received: from rtr.ca ([76.10.145.34]:37733 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751929AbZC3RjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 13:39:16 -0400
Message-ID: <49D103C1.3010405@rtr.ca>
Date: Mon, 30 Mar 2009 13:39:13 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jeff Garzik <jeff@garzik.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <alpine.LFD.2.00.0903271511230.3994@localhost.localdomain> <alpine.LFD.2.00.0903271522210.3994@localhost.localdomain> <49CD7B10.7010601@garzik.org> <49CD891A.7030103@rtr.ca> <49CD9047.4060500@garzik.org> <49CE2633.2000903@s5r6.in-berlin.de> <49CE3186.8090903@garzik.org> <49CE35AE.1080702@s5r6.in-berlin.de> <49CE3F74.6090103@rtr.ca> <20090329231451.GR26138@disturbed> <20090330003948.GA13356@mit.edu> <49D0710A.1030805@ursus.ath.cx> <20090330100546.51907bd2@the-village.bc.nu> <49D0A3D6.4000300@ursus.ath.cx> <49D0AA4A.6020308@redhat.com> <alpine.LFD.2.00.0903300817400.3948@localhost.localdomain> <49D0EF1E.9040806@redhat.com> <alpine.LFD.2.00.0903300922231.3948@localhost.localdomain> <49D0FD4C.1010007@redhat.com>
In-Reply-To: <49D0FD4C.1010007@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ric Wheeler wrote:
> Linus Torvalds wrote:
..
>> That's one of the issues. The cost of those flushes can be really 
>> quite high, and as mentioned, in the absense of redundancy you don't 
>> actually get the guarantees that you seem to think that you get.
> 
> I have measured the costs of the write flushes on a variety of devices, 
> routinely, a cache flush is on the order of 10-20 ms with a healthy 
> s-ata drive.
..

Err, no.  Yes, the flush itself will be very quick,
since the drive is nearly always keeping up with the I/O
already (as we are discussing in a separate subthread here!).

But.. the cost of that FLUSH_CACHE command can be quite significant.
To issue it, we first have to stop accepting R/W requests,
and then wait for up to 32 of them currently in-flight to complete.
Then issue the cache-flush, and wait for that to complete.

Then resume R/W again.

And FLUSH_CACHE is a PIO command for most libata hosts,
so it has a multi-microsecond CPU hit as well as the I/O hit,
whereas regular R/W commands will usually use less CPU because
they are usually done via an automated host command queue.

Tiny, but significant.  And more so on smaller/slower end-user systems
like netbooks than on datacenter servers, perhaps.

Cheers
