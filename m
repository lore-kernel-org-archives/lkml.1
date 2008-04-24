Return-Path: <linux-kernel-owner+w=401wt.eu-S1758136AbYDXOAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758136AbYDXOAT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 10:00:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753101AbYDXOAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 10:00:09 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40049 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414AbYDXOAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 10:00:07 -0400
Date: Thu, 24 Apr 2008 15:00:00 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       dave@linux.vnet.ibm.com, ezk@cs.sunysb.edu, mhalcrow@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 00/13] vfs: add helpers to check r/o bind mounts
Message-ID: <20080424140000.GE15214@ZenIV.linux.org.uk>
References: <20080424113950.818688067@szeredi.hu> <20080424124245.GC15214@ZenIV.linux.org.uk> <E1Jp18b-0003iB-FK@pomaz-ex.szeredi.hu> <20080424134826.GD15214@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080424134826.GD15214@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2008 at 02:48:26PM +0100, Al Viro wrote:
> On Thu, Apr 24, 2008 at 03:05:21PM +0200, Miklos Szeredi wrote:
> > Several calls to nfsd_setattr() for starters.  But I didn't do a full
> > audit of all vfs_* callers, there might well be others.

BTW, nfsd_setattr() on r/o ->ex_mnt *will* fail.  Again, check fh_verify()
and see what it does with MAY_SATTR.

And I certainly agree that it ought to be replaced by will/wont pair to
close the remount race.  One that had been there all along.  All fh_verify()
callers of that kind need it - we want to pull mnt_{will,wont}_write()
pair into callers *and* stretch to protect the entire relevant area.

Which contains vfs_...() in case of nfsd_create, etc.  See what I mean?
That's exactly the thing I'd been talking about - the area we want to
cover is _bigger_ than vfs_...() and contains nfsd-specific logic.  IOW,
doesn't get folded into any VFS-provided helper.
