Return-Path: <linux-kernel-owner+w=401wt.eu-S1751472AbXAXOKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751472AbXAXOKU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 09:10:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751487AbXAXOKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 09:10:19 -0500
Received: from cytosin.uni-konstanz.de ([134.34.240.61]:40780 "EHLO
	cytosin.uni-konstanz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbXAXOKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 09:10:19 -0500
X-Greylist: delayed 1437 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Jan 2007 09:10:19 EST
X-IronPort-AV: i="4.13,231,1167609600"; 
   d="scan'208"; a="6288286:sNHT20337751"
Message-ID: <1169646379.45b7632be1cb1@webmail.uni-konstanz.de>
Date: Wed, 24 Jan 2007 14:46:19 +0100
From: Jochen Oekonomopulos <jochen.oekonomopulos@uni-konstanz.de>
To: linux-kernel@vger.kernel.org
Subject: bio -> bi_bdev
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) 3.2.2
X-Originating-IP: 195.176.20.45
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

I am working on a module to redirect a bio request from one block device
to another. Therefore, I catch every bio from one device, clone it and
change the underlying block_device bi_bdev to the other block device.
Everything works fine, except that the first page read is always filled
with random data. Everything else works fine. So I am wondering, if
there is something I did not take into consideration.

I tested it under 2.6.8 and 2.6.19 with the same results.

Below is the essence of my redirection code.


"device" is the instance of my device structure. The original read was
made to it and I want to redirect it to the block_device linked in
bdev.

struct bio bio, cloned_bio;
int sect = 0;


rq_for_each_bio(bio, req) {
		
		cloned_bio = bio_clone(bio, GFP_NOIO);
		cloned_bio -> bi_private = bio;
		cloned_bio -> bi_bdev = device -> bdev;
		
		if(bio_data_dir(cloned_bio) == WRITE) {

			submit_bio(WRITE, cloned_bio);
		}
		else {

			submit_bio(READ, cloned_bio);
		}
		
		sect += cloned_bio->bi_size/KERNEL_SECTOR_SIZE;

	}

thanks in advance for any feedback,

Jochen Oekonomopulos
