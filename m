Return-Path: <linux-kernel-owner+w=401wt.eu-S1758862AbXE2Qoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758862AbXE2Qoa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 12:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751828AbXE2QoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 12:44:22 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:53563 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752229AbXE2QoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 12:44:21 -0400
Date: Tue, 29 May 2007 09:44:10 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Tejun Heo <htejun@gmail.com>
cc: Gregor Jasny <gjasny@googlemail.com>, Jeff Garzik <jgarzik@pobox.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Linux v2.6.22-rc3
In-Reply-To: <465BF244.5080200@gmail.com>
Message-ID: <alpine.LFD.0.98.0705290924350.26602@woody.linux-foundation.org>
References: <alpine.LFD.0.98.0705252008210.26602@woody.linux-foundation.org>
  <9d2cd630705270801m2826be60p3f802c502b26c531@mail.gmail.com> 
 <46599E6B.1000209@pobox.com>  <9d2cd630705270907y4722653cpf79f073fa8f12f08@mail.gmail.com>
  <alpine.LFD.0.98.0705270922030.26602@woody.linux-foundation.org> 
 <9d2cd630705271315x7030c91ew2f175c921c022880@mail.gmail.com> 
 <465AA536.6080608@gmail.com> <9d2cd630705280707h4921900fxc93a07a87f0bdf66@mail.gmail.com>
 <465BF244.5080200@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 29 May 2007, Tejun Heo wrote:
> 
> Aieee, so the drive doesn't like the new SRST sequence.

It would appear that the old code largely ignored the SRST error entirely, 
no?

If we *used* to do (in ata_bus_post_reset()):

	if (dev0)
		ata_busy_sleep(ap, ATA_TMOUT_BOOT_QUICK, ATA_TMOUT_BOOT);

and you changed that to actually care about the return value:

	if (dev0) {
		rc = ata_wait_ready(ap, deadline);
		if (rc && rc != -ENODEV)
			return rc;
	}

(in _two_ places). That change also changed the same "post_reset" handling 
in a totally _different_ way: it used to do ata_busy_sleep() twice, now it 
still does it twice, but it does it with the same "timeout" value, so if 
the first one times out, then the second one won't be given any timeout AT 
ALL!

And to make matters worse: the first timeout seems to be for ANOTHER PORT 
ENTIRELY! So you seem to break port 1 even if the timeout happened on port 
0, as far as I can read that sequence. 

So I think your ata_bus_post_reset() changes are rather suspect. The fact 
that you don't change the timeout, and use the same deadline for two 
different ports (and for multiple commands to the same port, afaik), seems 
rather suspect. The old code also didn't care about failures in certain 
phases of the reset sequence, and it appears that it did so for good 
reason.

		Linus
