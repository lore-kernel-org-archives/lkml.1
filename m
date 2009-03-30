Return-Path: <linux-kernel-owner+w=401wt.eu-S1760455AbZC3Tmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760455AbZC3Tmy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 15:42:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760242AbZC3Tmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 15:42:43 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:47031 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755269AbZC3Tml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 15:42:41 -0400
Message-ID: <49D1206E.7090809@garzik.org>
Date: Mon, 30 Mar 2009 15:41:34 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Ric Wheeler <rwheeler@redhat.com>,
       "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Mark Lord <lkml@rtr.ca>, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <alpine.LFD.2.00.0903271511230.3994@localhost.localdomain> <alpine.LFD.2.00.0903271522210.3994@localhost.localdomain> <49CD7B10.7010601@garzik.org> <49CD891A.7030103@rtr.ca> <49CD9047.4060500@garzik.org> <49CE2633.2000903@s5r6.in-berlin.de> <49CE3186.8090903@garzik.org> <49CE35AE.1080702@s5r6.in-berlin.de> <49CE3F74.6090103@rtr.ca> <20090329231451.GR26138@disturbed> <20090330003948.GA13356@mit.edu> <49D0710A.1030805@ursus.ath.cx> <20090330100546.51907bd2@the-village.bc.nu> <49D0A3D6.4000300@ursus.ath.cx> <49D0AA4A.6020308@redhat.com> <alpine.LFD.2.00.0903300817400.3948@localhost.localdomain> <49D0EF1E.9040806@redhat.com> <alpine.LFD.2.00.0903300922231.3948@localhost.localdomain> <49D0FD4C.1010007@redhat.com> <alpine.LFD.2.00.0903301038100.3948@localhost.localdomain> <49D11BDD.70702@redhat.com>
In-Reply-To: <49D11BDD.70702@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:
> Linus Torvalds wrote:
>> And my point is, IT MAKES SENSE to just do the elevator barrier, 
>> _without_ the drive command. 
> 
> No argument there.  I have seen NCQ starvation on SATA disks,
> with some requests sitting in the drive for seconds, while
> the drive was busy handling hundreds of requests/second
> elsewhere...

If certain requests are hanging out in the drive's wbcache longer than 
others, that increases the probability that OS filesystem-required, 
elevator-provided ordering becomes skewed once requests are passed to 
drive firmware.

The sad, sucky fact is that NCQ starvation implies FLUSH CACHE is more 
important than ever, if filesystems want to get ordering correct.




IDEALLY, according to the SATA protocol spec, we could issue up to 32 
NCQ commands to a SATA drive, each marked with the "FUA" bit to force 
the command to hit permanent media before returning.

In theory, this NCQ+FUA mode gives the drive maximum ability to optimize 
parallel in-progress commands, decoupling command completion and command 
issue -- while also giving the OS complete control of ordering by virtue 
of emptying the SATA tagged command queue.

In practice, NCQ+FUA flat out did not work on early drives, and 
performance was way under what you would expect for parallel write-thru 
command execution.  I haven't benchmarked NCQ+FUA in a few years; it 
might be worth revisiting.

	Jeff



