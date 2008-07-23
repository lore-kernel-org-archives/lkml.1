Return-Path: <linux-kernel-owner+w=401wt.eu-S1754102AbYGWPuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102AbYGWPuV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 11:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752782AbYGWPuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 11:50:09 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:9593 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbYGWPuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 11:50:08 -0400
Date: Wed, 23 Jul 2008 10:50:05 -0500
From: scameron@beardog.cca.cpqcorp.net
To: linux-kernel@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, mike.miller@hp.com,
       fujita.tomonori@lab.ntt.co.jp
Subject: Re: HP (Compaq) Smart Array 5xxx controller SCSI driver
Message-ID: <20080723155005.GF8833@beardog.cca.cpqcorp.net>
References: <20080722175537.GB8833@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080722175537.GB8833@beardog.cca.cpqcorp.net>
User-Agent: Mutt/1.5.9i
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fujita Tomonori wrote:
> I created symbolic links (neat udev rules can do automatically).
> 
> clover:/home/fujita# ls -l /dev/cciss/
> total 0
> lrwxrwxrwx 1 root root 8 2008-07-23 21:38 c0d0 -> /dev/sde
> lrwxrwxrwx 1 root root 9 2008-07-23 21:39 c0d0p1 -> /dev/sde1
> lrwxrwxrwx 1 root root 9 2008-07-23 21:39 c0d0p2 -> /dev/sde2
> lrwxrwxrwx 1 root root 8 2008-07-23 21:38 c0d1 -> /dev/sdf
> lrwxrwxrwx 1 root root 8 2008-07-23 21:38 c0d2 -> /dev/sdg
> lrwxrwxrwx 1 root root 8 2008-07-23 21:38 c0d3 -> /dev/sdh
> 
> The symbolic links enable users to mount the device as before.
> 
> hpacucli seems to work (I didn't try all the commands but the point is
> that we can provide the ioctl compatibility): 

That's pretty neat, I'm surprised that works.  Obviously
you've got the needed ioctls already done. 

I bet if you deleted all the logical drives it wouldn't work
anymore (because /dev/cciss/c0d0 -> /dev/sde would disappear.)

A way around that would be to present a device to the linux
kernel with 8-byte LUN address of all zeroes mapped to some
bus/target/lun.  When the SCSI scan happens and the inquiry
is sent down to this address, the RAID controller will respond.
Then let sg bind to that, and get ACU to use the sg device.
(I hope it's clear what I'm saying.)

I don't know if the udev rules can be made smart enough to
point /dev/cciss/c0d0 at the sg device if there are no 
logical drives, and at the first logical drive if there 
is at least one.   In the longer term, ACU would have to 
be changed to use that sg device always rather than using
/dev/cciss/c0d0.

In the cciss driver, we always present /dev/cciss/c0d0
whether there are any logical drives or not for this reason,
a rather clunky solution.

-- steve
