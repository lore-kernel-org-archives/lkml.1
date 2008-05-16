Return-Path: <linux-kernel-owner+w=401wt.eu-S1760607AbYEPWP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760607AbYEPWP2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 18:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755870AbYEPWPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 18:15:10 -0400
Received: from mail2.shareable.org ([80.68.89.115]:36595 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945AbYEPWPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 18:15:08 -0400
Date: Fri, 16 May 2008 23:15:06 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: ext4 development <linux-ext4@vger.kernel.org>,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/4] ext3: call blkdev_issue_flush on fsync
Message-ID: <20080516221506.GD15334@shareable.org>
Mail-Followup-To: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
References: <482DDA56.6000301@redhat.com> <482DDB5E.4030404@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <482DDB5E.4030404@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Sandeen wrote:
> To ensure that bits are truly on-disk after an fsync,
> ext3 should call blkdev_issue_flush if barriers are supported.
> 
> Inspired by an old thread on barriers, by reiserfs & xfs
> which do the same, and by a patch SuSE ships with their kernel

blkdev_issue_flush uses BIO_RW_BARRIER, which becomes REQ_HARDBARRIER.
REQ_HARDBARRIER does _not_ mean force the data to disk.

It is a barrier request, which when optimised for the highest
performance can return a long time before the data is physically on
the disk.  (It can even do nothing, correctly).

In many cases, block drivers implement a barrier using a hardware
flush command, so it turns out the same.  Then your patch is effective.

(It is however sending unnecessary hardware commands sometimes,
because fsync's journal write (when there is one) will also issue a
flush command, and another is not required; it may reduce performance.)

But that is not what REQ_HARDBARRIER means: block drivers are allowed
to implement barriers in other ways which are more efficient.

I'm not sure if this problem is theoretical only, or if any block
drivers actually do take advantage of this.

A good fix would be to add REQ_HARDFLUSH, with a precise meaning:
don't return until the hardware reports the data safely committed.  It
would be very little change to most (if not all) current drivers.

-- Jamie
