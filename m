Return-Path: <linux-kernel-owner+w=401wt.eu-S1763017AbYBZRAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763017AbYBZRAm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 12:00:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762577AbYBZRAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 12:00:32 -0500
Received: from mail2.shareable.org ([80.68.89.115]:42610 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762558AbYBZRAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 12:00:32 -0500
Date: Tue, 26 Feb 2008 17:00:11 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Chris Wedgwood <cw@f00f.org>
Subject: Re: Proposal for "proper" durable fsync() and fdatasync()
Message-ID: <20080226170011.GB21203@shareable.org>
References: <20080226072649.GB30238@shareable.org> <20080225234319.f4589ae4.akpm@linux-foundation.org> <20080226075921.GG30238@shareable.org> <200802262016.11297.nickpiggin@yahoo.com.au> <47C441C1.5060305@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47C441C1.5060305@garzik.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Nick Piggin wrote:
> >Anyway, the idea of making fsync/fdatasync etc. safe by default is
> >a good idea IMO, and is a bad bug that we don't do that :(
> 
> Agreed...  it's also disappointing that [unless I'm mistaken] you have 
> to hack each filesystem to support barriers.
> 
> It seems far easier to make sync_blkdev() Do The Right Thing, and 
> magically make all filesystems data-safe.

Well, you need ordered metadata writes, barriers _and_ flushes with
some filesystems.

Merely writing all the data pages than issuing a drive cache flush
won't Do The Right Thing with those filesystems - someone already
mentioned Btrfs, where it won't.

But I agree that your suggestion would make a superb default, for
filesystems which don't provide their own function.

It's not optimal even then.

  Devices: On a software RAID, you ideally don't want to issue flushes
  to all drives if your database did a 1 block commit entry.  (But they
  probably use O_DIRECT anyway, changing the rules again).  But all that
  can be optimised in generic VFS code eventually.  It doesn't need
  filesystem assistance in most cases.

  Apps: don't always want a full flush; sometimes a barrier would do.

-- Jamie
