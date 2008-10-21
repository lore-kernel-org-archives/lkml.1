Return-Path: <linux-kernel-owner+w=401wt.eu-S1754990AbYJUSRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990AbYJUSRg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 14:17:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752019AbYJUSRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 14:17:25 -0400
Received: from anchor-post-35.mail.demon.net ([194.217.242.85]:2273 "EHLO
	anchor-post-35.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751423AbYJUSRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 14:17:24 -0400
Message-ID: <48FE1CBA.8080805@lougher.demon.co.uk>
Date: Tue, 21 Oct 2008 19:17:30 +0100
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: "David P. Quigley" <dpquigl@tycho.nsa.gov>
CC: akpm@linux-foundation.org, linux-embedded@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       tim.bird@am.sony.com
Subject: Re: Subject: [PATCH 12/16] Squashfs: header files
References: <E1KqrTX-0001y4-JE@dylan> <1224606318.31157.80.camel@moss-terrapins.epoch.ncsc.mil>
In-Reply-To: <1224606318.31157.80.camel@moss-terrapins.epoch.ncsc.mil>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David P. Quigley wrote:

> 
> Something that seems weird is the inconsistency in the ordering of these
> structs. The base part is the same across all inodes but for your
> reg/lreg dir/ldir pairs you seem to shuffle the order of the added
> parts. Is there a reason for this? Is their layout the same on disk
> (baring the extra data in the l versions)? If so they probably should be
> the same in the struct.
> 
> 

They're deliberately shuffled about to eliminate holes (due to alignment 
contraints), and to maximise compression.  Shifting to cluster similar 
fields can get better compression, and the current layout is the result 
of a lot of work to to get the best ordering.

For example:

 >> +struct squashfs_reg_inode {
 >> +	__le16			inode_type;
 >> +	__le16			mode;
 >> +	__le16			uid;
 >> +	__le16			guid;
 >> +	__le32			mtime;
 >> +	__le32	 		inode_number;
 >> +	__le32			start_block;
 >> +	__le32			fragment;
 >> +	__le32			offset;
 >> +	__le32			file_size;
 >> +	__le16			block_list[0];
 >> +};

Inode_number, start_block, fragment clustered together because in most 
filesystems they'll contain a lot of zero bits (filesystems mainly being 
small).  Better compression.

 >> +
 >> +struct squashfs_lreg_inode {
 >> +	__le16			inode_type;
 >> +	__le16			mode;
 >> +	__le16			uid;
 >> +	__le16			guid;
 >> +	__le32			mtime;
 >> +	__le32	 		inode_number;
 >> +	__le64			start_block;
 >> +	__le64			file_size;
 >> +	__le64			sparse;
 >> +	__le32			nlink;
 >> +	__le32			fragment;
 >> +	__le32			offset;
 >> +	__le32			xattr;
 >> +	__le16			block_list[0];
 >> +};

Start_block, file_size have been doubled, and the fragment field 
consequently moved to preserve 64-bit alignment constraints on 64-bit 
quantities (no holes).  Plus moving fragment means it can be grouped 
with the new nlink field giving a nice run of zero bits (non-extended 
regular files have an implicit nlink of 1).

