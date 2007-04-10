Return-Path: <linux-kernel-owner+w=401wt.eu-S1161123AbXDJXuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161123AbXDJXuS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 19:50:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161104AbXDJXuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 19:50:18 -0400
Received: from cantor.suse.de ([195.135.220.2]:51839 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161123AbXDJXuP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 19:50:15 -0400
From: Neil Brown <neilb@suse.de>
To: syrius.ml@no-log.org
Date: Wed, 11 Apr 2007 09:49:59 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17948.8871.997123.363344@notabene.brown>
Cc: linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [dm-devel] bio too big device md1 (16 > 8)
In-Reply-To: message from syrius.ml@no-log.org on Saturday April 7
References: <87irc84bcq.87hcrs4bcq@87fy7c4bcq.message.id>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This is difficult.

Summary of problem is:
  Filesystem on LVM on md/raid1
  Add an md/linear to the md/raid1 and fs dies with 'bio too big'.

Where to begin....

The fs level builds bios to send down to the device, and it queries
the device to find out how big the bio can be.
There are two ways it can query the device
  1/ it can look at the max_sectors field in the queue structure.
  2/ it can call the merge_bvec_fn function in the queue structure.

It actually does both.  max_sectors sets an over-all maximum, and
merge_bvec_fn - if defined - can ACK or NAK each page being added.

It is currently very awkward for a stacked device to respond to a
merge_bvec_fn by calling the merge_bvec_fn of the underlying devices.
So they don't.
I'm not sure what dm does, but md simply sets max_sectors to 1 page if
there is a merge_bvec_fn in an underlying device.

So in this particular case, as md/linear defines a merge_bvec_fn, as
soon as the md/linear array is added to the md/raid1 array, the
max_sectors of the md/raid1 is set to 1 page.

This works ok when a filesystem is on an md/raid1 as the filesystem
check max_sectors every time before building the bio.

However in your case, dm (aka LVM) is in there too.

dm doesn't know that md/raid1 has just changed max_sectors and there
is no convenient way for it to find out.  So when the filesystem tries
to get the max_sectors for the dm device, it gets the value that dm set
up when it was created, which was somewhat larger than one page.
When the request gets down to the raid1 layer, it caused a problem.

You can probably make your array work by adding the md/linear array to
the md/raid1 *before* enabling the LVM device on top of it.  However
that isn't really a good long-term solution.

We really need better ways for stacked devices to communicate.

Alasdair Kergon (dm developer) has some patches to make it practical
to recursively call merge_bvec_fn so they might be part of the
solution, but more discussion is needed before that becomes a reality.

Sorry I cannot be more helpful at this stage.

NeilBrown

