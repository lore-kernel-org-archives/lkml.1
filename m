Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932448Ab0BPAup (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 19:50:45 -0500
Received: from cantor.suse.de ([195.135.220.2]:53350 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932434Ab0BPAun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 19:50:43 -0500
Date: Tue, 16 Feb 2010 11:50:36 +1100
From: Neil Brown <neilb@suse.de>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Linux mdadm superblock question.
Message-ID: <20100216115036.0f6b7bb6@notabene.brown>
In-Reply-To: <alpine.DEB.2.00.1002111758350.12031@p34.internal.lan>
References: <alpine.DEB.2.00.1002111758350.12031@p34.internal.lan>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Feb 2010 18:00:23 -0500 (EST)
Justin Piszcz <jpiszcz@lucidpixels.com> wrote:

> Hi,
> 
> I may be converting a host to ext4 and was curious, is 0.90 still the only 
> superblock version for mdadm/raid-1 that you can boot from without having 
> to create an initrd/etc?
> 
> Are there any benefits to using a superblock > 0.90 for a raid-1 boot 
> volume < 2TB?

The only noticeable differences that I can think of are:
 1/ If you reboot during recovery of a spare, then 0.90 will restart the
    recovery at the start, while 1.x will restart from where it was up to.
 2/ The /sys/class/block/mdXX/md/dev-YYY/errors counter is reset on each
    re-assembly with 0.90, but is preserved across stop/start with 1.x
 3/ If your partition starts on a multiple of 64K from the start of the
    device and is the last partition and contains 0.90 metadata, then
    mdadm can get confused by it.
 4/ If you move the devices to a host with a different arch and different
    byte-ordering, then extra effort will be needed to see the array for
    0.90, but not for 1.x

I suspect none of these is a big issue.

It is likely that future extensions will only be supported on 1.x metadata.
For example I hope to add support for storing a bad-block list, so that a
read error during recovery will only be fatal for that block, not the whole
recovery process.  This is unlikely ever to be supported on 0.90.  However
it may not be possible to hot-enable it on 1.x either, depending on how much
space has been reserved for extra metadata, so there is no guarantee that
using 1.x now makes you future-proof.

And yes, 0.90 is still the only superblock version that supports in-kernel
autodetect, and I have no intention of adding in-kernel autodetect for any
other version.

NeilBrown
