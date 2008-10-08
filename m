Return-Path: <linux-kernel-owner+w=401wt.eu-S1755333AbYJHOFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333AbYJHOFY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 10:05:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754352AbYJHOFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 10:05:09 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:63717 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754355AbYJHOFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 10:05:08 -0400
Message-ID: <48ECBDF8.9060008@oracle.com>
Date: Wed, 08 Oct 2008 22:04:40 +0800
From: Tao Ma <tao.ma@oracle.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: Tiger Yang <tiger.yang@oracle.com>, Mark Fasheh <mfasheh@suse.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH 13/39] ocfs2: Add extended attribute support
References: <1222293680-15451-1-git-send-email-mfasheh@suse.com> <1222293680-15451-14-git-send-email-mfasheh@suse.com> <20081002081644.GB24717@lst.de> <20081007220811.GG26373@wotan.suse.de> <48EC1359.6040109@oracle.com> <20081008133453.GH25392@lst.de>
In-Reply-To: <20081008133453.GH25392@lst.de>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Christoph Hellwig wrote:
> On Wed, Oct 08, 2008 at 09:56:41AM +0800, Tiger Yang wrote:
>> I have looked the patch for btrfs about this. We are different.
>> Btrfs store the whole xattr name including the prefix "user." 
>> "trusted.", we store index number instead of it.
> 
> I looked at the git tree and there are two users of
> ocfs2_xattr_handler().
> 
>  (1) for using the ->list handler in listattr.  That's something I fixed
>      in btrfs that I wanted to point you to.  The whole concept of a
>      ->list handler is stupid, and it was only added as a hack for
>      the tmpfs "generic" xattr support which is a mess.  Instead of
>      looking up a handler that would only do the same thing anyway
>      for all on-disk attributes just call the code directly and
>      have a map from index to prefix (look at
>      fs/xfs/linux-2.6/xfs_xattr.c for an example).  You
>      also have a check for OCFS2_MOUNT_NOUSERXATTR for the user
>      attributes, but that's much easier done by just checking the
>      index in an if (and I'd personally just kill it completely, the
>      options doesn't seem useful - but that's an unrelated bit)
yes, you are right. The handler for list is borrowed from ext3 and 
somewhat ugly. We just need the prefix name but use such a complicated 
method. Just a map from index to prefix should work fine.
>  
>  (2) For generating the hash.  I don't quite understand why you want to
>      also hash the prefix if it's not store on disk anyway but sorted
>      into the numeric buckets.
This is done intentionally. See the design doc 
http://oss.oracle.com/osswiki/OCFS2/DesignDocs/ExtendedAttributes.
"Each entry has a 32-bit hash value associated with it. The hash value 
is calculated using the full (prefix.suffix) name of the xattr to avoid 
hash collisions when the same suffix is used in multiple attribute 
namespaces. "
So Mark, do you think we need this prefix hash?
Anyway, if we make consensus that the hash calculation doesn't need 
prefix any more, we can remove the ocfs2_xattr_handler safely.

Regards,
Tao
