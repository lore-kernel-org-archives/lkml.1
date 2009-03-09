Return-Path: <linux-kernel-owner+w=401wt.eu-S1752891AbZCIQKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891AbZCIQKy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 12:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750980AbZCIQKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 12:10:45 -0400
Received: from rcsinet13.oracle.com ([148.87.113.125]:46304 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbZCIQKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 12:10:45 -0400
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
       martin.petersen@oracle.com
Subject: Re: [PATCH] block: fix memory leak in bio_clone()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <49B4DD9C.5030902@cn.fujitsu.com>
	<20090309092407.GI11787@kernel.dk>
Date: Mon, 09 Mar 2009 12:10:27 -0400
In-Reply-To: <20090309092407.GI11787@kernel.dk> (Jens Axboe's message of "Mon\, 9 Mar 2009 10\:24\:07 +0100")
Message-ID: <yq1prgqy8wc.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Source-IP: acsmt704.oracle.com [141.146.40.82]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.49B53F7D.01C3:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Jens" == Jens Axboe <jens.axboe@oracle.com> writes:

Jens> So the leak will not occur, but it does mean that it isn't
Jens> honoring the gfp_mask passed in to bio_clone(), which is the first
Jens> bug.

bio_integrity_clone() had no mask because all callers of it used
GFP_NOIO explicitly.

But as you now recall there is a patch queued that adds the mask :)


Jens> The second bug is that it should be using its own bioset, as it is
Jens> illegal to do multiple __GFP_WAIT allocations on a single mempool
Jens> and always expect progress.

So how do you propose I go about this?

The original intent was to contain all the integrity blah inside the
bio_set to make it completely transparent to the caller.  That's why the
bip mempool is hanging off of the bio_set.  But obviously two bvecs are
needed per bio, one to describe data and to describe the integrity
buffer.

Having two bvec mempools per bio_set seems icky.  I guess what you are
suggesting is that we could have a dedicated bio_integrity_set akin to
the bio_split_pool.  That removes the caller's option of passing a
dedicated bio_set to the clone command, though.  Will that have forward
progress implications for stacking drivers?

-- 
Martin K. Petersen	Oracle Linux Engineering
