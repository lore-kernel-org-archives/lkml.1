Return-Path: <linux-kernel-owner+w=401wt.eu-S1755366AbZALQcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366AbZALQcS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 11:32:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752698AbZALQcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 11:32:05 -0500
Received: from ext-cn0ut-4.online-age.net ([63.210.253.233]:16340 "EHLO
	ext-cn0ut-4.online-age.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752677AbZALQcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 11:32:04 -0500
X-Greylist: delayed 2992 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Jan 2009 11:32:04 EST
Date: Mon, 12 Jan 2009 16:41:50 +0100
From: Enrik Berkhan <Enrik.Berkhan@ge.com>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       David Vrabel <david.vrabel@csr.com>, linux-kernel@vger.kernel.org
Subject: Re: Reference counting of MMC host driver modules
Message-ID: <20090112154150.GA27289@ngeserver2.localdomain>
References: <49678443.8040909@ge.com> <49679570.3070403@csr.com> <20090109200024.GA14754@ngeserver2.localdomain> <49686F0C.7030807@s5r6.in-berlin.de> <20090111104111.5a0f00e1@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090111104111.5a0f00e1@mjolnir.drzeus.cx>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 12 Jan 2009 15:41:53.0712 (UTC) FILETIME=[4AFE9B00:01C974CC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Pierre Ossman wrote:
> Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> > So, if somebody asked me to copy my ieee1394/sbp2 safeguard into
> > firewire/fw-sbp2, I would reject that on the grounds that killing the
> > connection to the FireWire disk is the *expected result* of
> > # modprobe -r firewire-ohci
> I have to agree with Stefan's reasoning here. The reference counting is
> about protecting kernel integrity, not about saving the user's foot.

Yes, meanwhile, I have to admit you all are right and I have been
looking in the wrong direction.

My original problem was the following:

- MD raid0 made of some MMC/SD devices
- raid0 activated
- rmmod mmc_host_driver (user error, not noticing the raid is active)
- insmod mmc_host_driver (user error, still not noticing the raid is active)
- write to raid0 device
- kernel crash

I have debugged this a little and found the following reason for the
crash:

When removing the mmc_host_driver, everything seems to be fine; the
MMC/SD block device has been deactivated by mmc_blk_remove(), that in
turn has stopped the queue via mmc_cleanup_queue(). mmc_cleanup_queue()
calls blk_cleanup_queue() on the underlying struct request_queue. By
this, the reference count of the struct request_queues kboj drops to
zero. The MD driver still has the block device open and, actually,
things work fine unless the memory of the struct request_queue isn't
touched, because it is marked dead. Of course, accessing the MD device
returns EIO, but that's fine.

When the mmc_host_driver is reloaded, new struct request_queues will be
allocated and with some probability, the old memory will be re-used for
them or the old memory locations will be re-used for something else. The
key point is that the queues still in use by the MD layer will
effectively no longer be marked dead or completely corrupted.

I don't know if this is a problem of the MD layer, the MMC/SD block
driver, a more general problem or even no problem at all :)

How can this be fixed?

Enrik
