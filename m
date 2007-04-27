Return-Path: <linux-kernel-owner+w=401wt.eu-S1755301AbXD0AB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301AbXD0AB1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 20:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755302AbXD0AB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 20:01:27 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:11923 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755301AbXD0ABZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 20:01:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=OwEQ6tI2fSWbdy2Zdwuba19n5I/JY/Y0VwV5QM2VT9wi1PkuVXD0+swzw80Dk/XFIO/+aWASb0NfoY169HWisUos47akMUt3ie4POcUsyK0k3RyAYAjZhvWBNTy8dr5BhVG9oXmsxc3I2UsVCXXK/NNHhC1TeVRoJsoHn5VUvvc=
Message-ID: <f4e013870704261701j3833369dv828fd9aaccb10c23@mail.gmail.com>
Date: Thu, 26 Apr 2007 17:01:19 -0700
From: "Mark Hull-Richter" <mhullrich@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Request for clarification on disk i/o limitations
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm studying the behavior of the page cache vs. direct i/o in the
kernel (so far up to 2.6.9-42.0.10 for CentOS 4.4, moving to 2.6.18
for CentOS 5 soon).

I have found that large I/O requests get broken up differently between
direct i/o and cached i/o (not surprising, but it's the way they're
broken up that puzzles me).

While both direct and cached i/o break the i/o requests down to page
sized chunks, these are subsequently merged back together until a
limit is reached.  For direct i/o on my SCSI disks, that limit is 88
segments, or 704 sectors (352k of a 512k block), so when direct i/os
of 512k chunks are performed via dd, each 512k i/o usually gets broken
into one 704 sector chunk and one 320 sector chunk.

However, when this same kind of i/o is done through the page cache,
the pages also get chunked together, and each 704 sector chunk limits
the size of an i/o sent to the scheduler, but this time, the 704
sector chunks typically get merged into a 1408 sector chunk because
the limiting factor here is a maximum sectors per i/o size of 2048.

My question is: what is the relationship between the hardware segment
limit (enforced in ll_new_segment and __bio_add_page) of 88 pages per
segment and the hardware maximum sectors per i/o of 2048 (enforced by
ll_back_merge, and also ll_front_merge, though I haven't seen that one
happen yet)?  Where do these limits come from and why don't they
match?

(The other subject of my study is why EMC NAS devices take at least 2x
as long as SCSI "DAS" disks, and why paged i/o appears to be no more
than 1/2 the speed of direct i/o on both types of disk, specifically
for large i/os (>256k chunks.)

Please reply with CC to me directly as I am still not on the list (but
I will be soon.)

Thanks.

-- 
Mark Hull-Richter, Linux Kernel Engineer
DATAllegro (www.datallegro.com)
85 Enterprise, Second Floor, Aliso Viejo, CA  92656
949-680-3082 - Office     949-330-7691 - fax
