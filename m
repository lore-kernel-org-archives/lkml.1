Return-Path: <linux-kernel-owner+w=401wt.eu-S1753464AbZFXBsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464AbZFXBsx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 21:48:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752696AbZFXBsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 21:48:40 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:39900 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbZFXBsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 21:48:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=JnQW65K40cF/qxzzvO9dONH1EpnTQwbuUhgq1KQuwAVAfy1ffvwkSLOy4g8WpHQa2P
         RQJkQb8vj8a0CrTKkioX8O/1jL0gbz7HCOkx3pXDO0K8fRH/H6GOuTWISV9K2poQwuvU
         Ly5a61rxus3WBvbntfH9hQWilCTteP3VHN4CA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: David Miller <davem@davemloft.net>
Subject: Re: [patch 4/6] ide: allow ide_dev_read_id() to be called from the IRQ context
Date: Wed, 24 Jun 2009 03:36:24 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-next-20090623-11043-g1684859-dirty; KDE/4.2.3; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200906232329.11648.bzolnier@gmail.com> <20090623.162256.190152758.davem@davemloft.net>
In-Reply-To: <20090623.162256.190152758.davem@davemloft.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200906240336.25263.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 June 2009 01:22:56 David Miller wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Date: Tue, 23 Jun 2009 23:29:11 +0200
> 
> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > Subject: [PATCH] ide: allow ide_dev_read_id() to be called from the IRQ context
> > 
> > * Un-static __ide_wait_stat().
> > 
> > * Allow ide_dev_read_id() helper to be called from the IRQ context by
> >   adding irq_ctx flag and using mdelay()/__ide_wait_stat() when needed.
> > 
> > * Switch ide_driveid_update() to set irq_ctx flag.
> > 
> > This change is needed for the consecutive patch which fixes races in
> > handling of user-space SET XFER commands but for improved bisectability
> > and clarity it is better to do it in a separate patch.
> > 
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > ---
> > I'm not completely happy with this version of patch since I originally
> > intended to unify ide_busy_sleep() with __ide_wait_stat() first..
> 
> This and patch #5 seems way overkill for the problem being solved.

They fix a real bug, they do it in a clean way and their total impact on
the code source is 40 lines _changed_ (not a single line of "new" code)..

They remove disable_irq_nosync()/enable_irq() use as an added bonus..

> All requests programmed into the device get synchronized through the
> block request queue, even these raw taskfile commands.
> 
> It seems to me that it should be possible to use the block request
> layer facilities to plug the queue, wait all executing commands to
> complete and for the device to quiesce, then push this single RAW
> command from the user to the device, and finally unplug the queue.

Probably.  These patches are in the accordance with the new policy
of "the minimal impact and the maximum outcome".

> Alternatively, if the block request layer can't help, we can put a
> mutex around submissions, and have this user RAW command submission
> take that mutex.

Feel free to try other approaches..

These patches were just some bugfixes that I was working recently
and thought that it would be a good idea to finish them and send them
to you (possibly saving you some work in the future) instead of simply
deleting them (like I did with cleanup patches that I was working on).

I will not cry if they got rejected for whatever reason (valid or not)
or try to push them to Linus independently..

IOW if there are really some technical issues left to be addressed with
these patches I'll be happy to address them but I'm not doing any more
new IDE stuff.  I can still help with reviewing or explaining things from
time to time but you are the one responsible for the end effect now..

> Anything other than moving code that does significant delays into
> interrupt context.

The code in question is only for a special commands doing user requested
xfer mode changes (they shall not be used at all in the first place because
the kernel does all the needed job nowadays).

IOW these patches only affect users of 'hdparm -X' (which is hardly an IRQ
latency problem ;).
