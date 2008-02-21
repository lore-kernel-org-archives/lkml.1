Return-Path: <linux-kernel-owner+w=401wt.eu-S1763100AbYBUDjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763100AbYBUDjl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 22:39:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753919AbYBUDjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 22:39:33 -0500
Received: from mail.suse.de ([195.135.220.2]:49501 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753886AbYBUDjc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 22:39:32 -0500
From: Neil Brown <neilb@suse.de>
To: David Chinner <dgc@sgi.com>
Date: Thu, 21 Feb 2008 14:39:36 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18364.62072.219900.681747@notabene.brown>
Cc: Michael Tokarev <mjt@tls.msk.ru>, Ric Wheeler <ric@emc.com>,
       device-mapper development <dm-devel@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] Re: [PATCH] Implement barrier support for single device DM devices
In-Reply-To: message from David Chinner on Tuesday February 19
References: <20080215120821.GA8267@basil.nowhere.org>
	<20080215122002.GM29914@agk.fab.redhat.com>
	<47B58EAA.8040405@msgid.tls.msk.ru>
	<20080215142010.GA29552@one.firstfloor.org>
	<20080215141229.GB1788@agk.fab.redhat.com>
	<47B97E87.6040209@emc.com>
	<47B9870B.8060005@msgid.tls.msk.ru>
	<20080218221644.GN155407@sgi.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday February 19, dgc@sgi.com wrote:
> On Mon, Feb 18, 2008 at 04:24:27PM +0300, Michael Tokarev wrote:
> > First, I still don't understand why in God's sake barriers are "working"
> > while regular cache flushes are not.  Almost no consumer-grade hard drive
> > supports write barriers, but they all support regular cache flushes, and
> > the latter should be enough (while not the most speed-optimal) to ensure
> > data safety.  Why to require write cache disable (like in XFS FAQ) instead
> > of going the flush-cache-when-appropriate (as opposed to write-barrier-
> > when-appropriate) way?
> 
> Devil's advocate:
> 
> Why should we need to support multiple different block layer APIs
> to do the same thing? Surely any hardware that doesn't support barrier
> operations can emulate them with cache flushes when they receive a
> barrier I/O from the filesystem....

The simple answer to "why multiple APIs" is "different performance
trade-offs". 
If barriers are implemented in at the end of the pipeline, they can
presumably be reasonably cheap.
If they have to be implemented at the top of the pipeline, thus
stalling the whole pipeline, they are likely to be more expensive.

A filesystem may be able to mitigate the expense if it knows something
about the purpose of the data.
e.g. ext3 in data=writeback mode could wait only for journal writes to
complete before submitting the (would-be) barrier write of the commit
block, and would not bother to wait for data writes.

However, consistent APIs are also a good thing.
I would easily accept an argument that a BIO_RW_BARRER request must
*always* be correctly ordered around all other requests to the same
device.  If a layered device cannot get the service it requires from
lower level devices, it must do that flush/write/wait itself.

That should be paired with a way for the upper levels to find out how
efficient barriers are.  I guess the three levels of barrier
efficiency are:
  1/ handled above the elevator - least efficient
  2/ handled between elevator and device (by 'flush request'), medium
  3/ handled inside device (e.g. ordered SCSI request) most efficient.

NeilBrown
