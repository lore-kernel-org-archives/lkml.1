Return-Path: <linux-kernel-owner+w=401wt.eu-S1755490AbYJHNf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490AbYJHNf2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 09:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbYJHNfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 09:35:15 -0400
Received: from verein.lst.de ([213.95.11.210]:43971 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750753AbYJHNfO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 09:35:14 -0400
Date: Wed, 8 Oct 2008 15:34:53 +0200
From: Christoph Hellwig <hch@lst.de>
To: Tiger Yang <tiger.yang@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>, Christoph Hellwig <hch@lst.de>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH 13/39] ocfs2: Add extended attribute support
Message-ID: <20081008133453.GH25392@lst.de>
References: <1222293680-15451-1-git-send-email-mfasheh@suse.com> <1222293680-15451-14-git-send-email-mfasheh@suse.com> <20081002081644.GB24717@lst.de> <20081007220811.GG26373@wotan.suse.de> <48EC1359.6040109@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48EC1359.6040109@oracle.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2008 at 09:56:41AM +0800, Tiger Yang wrote:
> I have looked the patch for btrfs about this. We are different.
> Btrfs store the whole xattr name including the prefix "user." 
> "trusted.", we store index number instead of it.

I looked at the git tree and there are two users of
ocfs2_xattr_handler().

 (1) for using the ->list handler in listattr.  That's something I fixed
     in btrfs that I wanted to point you to.  The whole concept of a
     ->list handler is stupid, and it was only added as a hack for
     the tmpfs "generic" xattr support which is a mess.  Instead of
     looking up a handler that would only do the same thing anyway
     for all on-disk attributes just call the code directly and
     have a map from index to prefix (look at
     fs/xfs/linux-2.6/xfs_xattr.c for an example).  You
     also have a check for OCFS2_MOUNT_NOUSERXATTR for the user
     attributes, but that's much easier done by just checking the
     index in an if (and I'd personally just kill it completely, the
     options doesn't seem useful - but that's an unrelated bit)
 
 (2) For generating the hash.  I don't quite understand why you want to
     also hash the prefix if it's not store on disk anyway but sorted
     into the numeric buckets.
