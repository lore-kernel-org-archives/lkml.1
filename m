Return-Path: <linux-kernel-owner+w=401wt.eu-S1755318AbXGDQoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318AbXGDQoz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 12:44:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757110AbXGDQoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 12:44:38 -0400
Received: from 74-0-229-162.T1.lbdsl.net ([74.0.229.162]:43650 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757080AbXGDQoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 12:44:34 -0400
Date: Wed, 4 Jul 2007 10:44:32 -0600
From: Andreas Dilger <adilger@clusterfs.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: cmm@us.ibm.com, Kalpak Shah <kalpak@clusterfs.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org
Subject: Re: [EXT4 set 3][PATCH 1/1] ext4 nanosecond timestamp
Message-ID: <20070704164432.GN6578@schatzie.adilger.int>
Mail-Followup-To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	cmm@us.ibm.com, Kalpak Shah <kalpak@clusterfs.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
References: <1183275416.4010.125.camel@localhost.localdomain> <1183458506.4102.5.camel@garfield.linsyssoft.com> <1183519975.3922.7.camel@localhost.localdomain> <468B3FDA.7060809@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <468B3FDA.7060809@linux.vnet.ibm.com>
User-Agent: Mutt/1.4.1i
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 04, 2007  12:06 +0530, Aneesh Kumar K.V wrote:
> Mingming Cao wrote:
> >On Tue, 2007-07-03 at 15:58 +0530, Kalpak Shah wrote:
> >>On Sun, 2007-07-01 at 03:36 -0400, Mingming Cao wrote:
> >>>+
> >>>+#define EXT4_INODE_GET_XTIME(xtime, inode, raw_inode)		 \
> >>>+do {								 \
> >>>+	(inode)->xtime.tv_sec = le32_to_cpu((raw_inode)->xtime);	    
> >>>\
> >>>+	if (EXT4_FITS_IN_INODE(raw_inode, EXT4_I(inode), xtime ## _extra))  
> >>>\
> >>>+		ext4_decode_extra_time(&(inode)->xtime,			    
> >>>\
> >>>+				       raw_inode->xtime ## _extra);	    
> >>>\
> >>>+} while (0)
> >>>+
> >>>+#define EXT4_EINODE_GET_XTIME(xtime, einode, raw_inode)		 \
> >>>+do {								 \
> >>>+	if (EXT4_FITS_IN_INODE(raw_inode, einode, xtime))		    
> >>>\
> >>>+		(einode)->xtime.tv_sec = le32_to_cpu((raw_inode)->xtime);   
> >>>\
> >>>+	if (EXT4_FITS_IN_INODE(raw_inode, einode, xtime ## _extra))	    
> >>>\
> >>>+		ext4_decode_extra_time(&(einode)->xtime,		    
> >>>\
> >>>+				       raw_inode->xtime ## _extra);	    
> >>>\
> >>>+} while (0)
> >>>+
> >>This nanosecond patch seems to be missing the fix below which is 
> >>required for http://bugzilla.kernel.org/show_bug.cgi?id=5079
> >>
> >>If the timestamp is set to before epoch i.e. a negative timestamp then 
> >>the file may have its date set into the future on 64-bit systems. So 
> >>when the timestamp is read it must be cast as signed.
> >
> >Missed this one.
> >Thanks. Will update ext4 patch queue tonight with this fix.
> 
> IIRC in the conference call it was decided to not to apply this patch. 
> Andreas may be able to update better.

I wasn't on the most recent concall, and I've forgotten the details of
any discussion on a previous concall.

Care really needs to be taken here that negative timestamps are handled
properly.  We can take the sign bit from the inode i_*time, but then we
need to change the load/save of the extra time to use a shift of 31
instead of 32.  If we overflow the epoch we have to ensure that the high
bits of the seconds is handled correctly.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

