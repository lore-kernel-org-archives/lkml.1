Return-Path: <linux-kernel-owner+w=401wt.eu-S1752589AbZEYFFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589AbZEYFFa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 01:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750925AbZEYFFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 01:05:20 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:20175 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbZEYFFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 01:05:19 -0400
To: Alberto Bertogli <albertito@blitiri.com.ar>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [RFC PATCH] bio-integrity: Copy bip_buf and bip_size in bio_integrity_clone()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <20090524042035.GF1376@blitiri.com.ar>
Date: Mon, 25 May 2009 01:04:55 -0400
In-Reply-To: <20090524042035.GF1376@blitiri.com.ar> (Alberto Bertogli's
	message of "Sun, 24 May 2009 01:20:35 -0300")
Message-ID: <yq1iqjpg4co.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Source-IP: abhmt008.oracle.com [141.146.116.17]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010203.4A1A26FD.016B:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Alberto" == Alberto Bertogli <albertito@blitiri.com.ar> writes:

Alberto> While at it, I found that bio_integrity_clone() does not clone
Alberto> neither bip_buf nor bip_size, which already copies the bvec,
Alberto> which should have the same data because it's allocated in
Alberto> bio_integrity_prep().

Alberto> Is there any reason I'm missing why they shouldn't be copied in
Alberto> bio_integrity_clone(), as illustrated in the following patch?

Yes.  The bip_buf is strictly an internal housekeeping construct.  It
contains a pointer to the kernel buffer that contains the protection
information if the protection was added by the block layer itself (via
bio_integrity_prep()).  However, that's not always the case.  The
protection information may be passed down from a filesystem or
(eventually) a userland application.  So the bip_buf is for use by the
top-level of the block layer exclusively.  The bip_vec is what you want
to use for accessing the actual protection information.

Also, the cloned bio may be truncated or split.  In that case the
bip_buf isn't going to match the data bvec.  So in any case blindly
cloning bip_buf isn't going to work.

Right now the integrity vector itself is cloned together with the bio
because of the way the block layer works (advancing bvec offset for
partial completion).  However, I'm brewing on a patch that gets rid of
that so we can avoid cloning the vector and thus cut down on memory
allocations as the I/O goes through each remapping layer.  With my patch
in place the bip_vec becomes immutable and bip_buf will go away.

I took a quick look at your DM patch last week and I didn't see any
reason why it couldn't hook into the block integrity infrastructure.
Take a look at drivers/scsi/sd_dif.c for clues on how to do that.

Let me know if you have questions...

-- 
Martin K. Petersen	Oracle Linux Engineering
