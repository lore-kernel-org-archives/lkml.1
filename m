Return-Path: <linux-kernel-owner+w=401wt.eu-S1755078AbZEXBv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078AbZEXBv4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 21:51:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753876AbZEXBvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 21:51:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33546 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753041AbZEXBvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 21:51:48 -0400
From: "NeilBrown" <neilb@suse.de>
To: "Ken Milmore" <ken.milmore@googlemail.com>
Date: Sun, 24 May 2009 11:51:37 +1000 (EST)
Message-ID: <0fa4b1e19d3edb12931e0d641ce2c7d7.squirrel@neil.brown.name>
In-Reply-To: <4A188CAD.1080009@googlemail.com>
References: <4A188CAD.1080009@googlemail.com>
Subject: Re: Write barriers on MD RAID1
Cc: linux-kernel@vger.kernel.org, "Jens Axboe" <jens.axboe@oracle.com>
User-Agent: SquirrelMail/1.4.15
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 24, 2009 9:54 am, Ken Milmore wrote:
>
> Support for write barriers on MD RAID1 devices appears to be broken on
> 2.6.29 and later kernels.  Mounting an ext3 or ext4 filesystem over an
> md raid1 block device gives the kernel message:
>
>    JBD: barrier-based sync failed on md0 - disabling barriers
>
> Is this intentional?  It looks like a regression to me, since write
> barriers (ostensibly) worked for MD RAID1 on earlier kernels (well, all
> of the 2.6.27 series at least...)
>
> Doing a git bisect suggested that this is the culprit:
>
> commit cec0707e40ae25794b5a2de7b7f03c51961f80d9
> Author: Jens Axboe <jens.axboe@oracle.com>
> Date:   Tue Jan 13 15:28:32 2009 +0100
>
>      block: silently error an unsupported barrier bio

Yes, that patch is broken.
the new code it introduces should probably go in the top of
__make_request rather than just before the call to ->make_request_fn.
make_request_fn functions other than __make_request generally
don't use ->next_ordered at all.

Jens?  Would you agree?

NeilBrown


>
> Rolling this back from 2.6.29.4 made the JBD error message go away for
> me.  I tried to do some disk benchmarking to determine if write barriers
> were really still working, but the results were not very conclusive.
>
> Details of test setup:
> - 2.6.29.4 kernel (config from slackware-current)
> - ext3 filesystem (mounted with barrier=1), also tried ext4
> - MD RAID1 block device over two SATA disks
> - Intel motherboard AHCI controller (82801)
>
> I got similar behaviour on a virtualised setup using qemu, with the RAID
> over two emulated IDE disks.
>
> Please contact me if I can provide any further information.
>
> -Ken Milmore.
>

