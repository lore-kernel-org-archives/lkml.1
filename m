Return-Path: <linux-kernel-owner+w=401wt.eu-S932281AbZGRGxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281AbZGRGxi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 02:53:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752358AbZGRGxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 02:53:33 -0400
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:57706 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbZGRGxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 02:53:32 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-disposition: inline
Content-type: text/plain; CHARSET=US-ASCII
Date: Sat, 18 Jul 2009 02:52:13 -0400
From: Andreas Dilger <adilger@sun.com>
Subject: Re: How to handle >16TB devices on 32 bit hosts ??
In-reply-to: <871voewm6y.fsf@basil.nowhere.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: device-mapper development <dm-devel@redhat.com>,
       Neil Brown <neilb@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Message-id: <20090718065213.GK4231@webber.adilger.int>
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
References: <19041.4714.686158.130252@notabene.brown>
 <20090718043155.GI4231@webber.adilger.int> <871voewm6y.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 18, 2009  08:16 +0200, Andi Kleen wrote:
> Andreas Dilger <adilger@sun.com> writes:
> > I think the point is that for those people who want to use > 16TB
> > devices on 32-bit platforms (e.g. embedded/appliance systems) the
> > choice is between "completely non-functional" and "uses a bit more
> > memory per page", and the answer is pretty obvious.
> 
> It's not just more memory per page, but also worse code all over the
> VM. long long 32bit code is generally rather bad, especially on
> register constrained x86.

If you aren't running a 32-bit system with this config, you shouldn't
really care.  For those systems that need to run in this mode they
would rather have it work a few percent slower instead of not at all.

> But I think the fsck problem is a show stopper here anyways.
> Enabling a setup that cannot handle IO errors wouldn't 
> be really a good idea.
> 
> In fact this problem already hits before 16TB on 32bit.

The e2fsck code is currently just starting to get > 16TB support,
and while the initial implementation is naive, we are definitely
planning on reducing the memory needed to check very large devices.

The last test numbers I saw were 5GB of RAM for a 20TB filesystem,
but since the bitmaps used are fully-allocated arrays that isn't
surprising.  We are planning to replace this with a tree, since the
majority of bitmaps used by e2fsck have large contiguous ranges of
set or unset bits and can be represented much more efficiently.

> Unless people rewrite fsck to use /dev/shm >4GB swapping
> (or perhaps use JFS which iirc had a way to use the file system
> itself as fsck scratch space)

I'm guessing that such systems won't have a 20TB boot device, but
rather a small flash boot/swap device (a few GB is cheap) and then
they could swap, if strictly necessary.

Also, for filesystems like btrfs or ZFS the checking can be done
online and incrementally without storing a full representation of
the state in memory.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

