Return-Path: <linux-kernel-owner+w=401wt.eu-S1756782AbXFZKpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782AbXFZKpr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 06:45:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752653AbXFZKpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 06:45:38 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:54697 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbXFZKph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 06:45:37 -0400
Date: Tue, 26 Jun 2007 16:15:46 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, David Chinner <dgc@sgi.com>,
       suparna@in.ibm.com, cmm@us.ibm.com, xfs@oss.sgi.com
Subject: Re: [PATCH 4/7][TAKE5] support new modes in fallocate
Message-ID: <20070626104546.GB19870@amitarora.in.ibm.com>
References: <20070511110301.GB28425@in.ibm.com> <20070512080157.GF85884050@sgi.com> <20070612061652.GA6320@amitarora.in.ibm.com> <20070613235217.GS86004887@sgi.com> <20070614091458.GH5181@schatzie.adilger.int> <20070614120413.GD86004887@sgi.com> <20070614193347.GN5181@schatzie.adilger.int> <20070625132810.GA1951@amitarora.in.ibm.com> <20070625134500.GE1951@amitarora.in.ibm.com> <20070625215239.GK5181@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070625215239.GK5181@schatzie.adilger.int>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2007 at 03:52:39PM -0600, Andreas Dilger wrote:
> On Jun 25, 2007  19:15 +0530, Amit K. Arora wrote:
> > +#define FA_FL_DEALLOC	0x01 /* default is allocate */
> > +#define FA_FL_KEEP_SIZE	0x02 /* default is extend/shrink size */
> > +#define FA_FL_DEL_DATA	0x04 /* default is keep written data on DEALLOC */
> 
> In XFS one of the (many) ALLOC modes is to zero existing data on allocate.
> For ext4 all this would mean is calling ext4_ext_mark_uninitialized() on
> each extent.  For some workloads this would be much faster than truncate
> and reallocate of all the blocks in a file.

In ext4, we already mark each extent having preallocated blocks as
uninitialized. This is done as part of following code (which is part of
patch 5/7) in ext4_ext_get_blocks() :  

@@ -2122,6 +2160,8 @@ int ext4_ext_get_blocks(handle_t *handle
        /* try to insert new extent into found leaf and return */
        ext4_ext_store_pblock(&newex, newblock);
        newex.ee_len = cpu_to_le16(allocated);
+       if (create == EXT4_CREATE_UNINITIALIZED_EXT)  /* Mark uninitialized */
+               ext4_ext_mark_uninitialized(&newex);
        err = ext4_ext_insert_extent(handle, inode, path, &newex);
        if (err) {
                /* free data blocks we just allocated */


> In that light, please change the comment to /* default is keep existing data */
> so that it doesn't imply this is only for DEALLOC.

Ok. Will update the comment.

Thanks!
--
Regards,
Amit Arora
