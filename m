Return-Path: <linux-kernel-owner+w=401wt.eu-S1753798AbYIAOcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798AbYIAOcW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 10:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751121AbYIAOcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 10:32:14 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:13692 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbYIAOcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 10:32:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=qMh4fmjTPhxer0O8bHAsRu8u1FjkgOytvQp7tZlO0iWbspRzzMlcU+ynUulDX75KHd
         oI11GT2Qjqs8OwlcQEHq3oIKsV+xJC34UZCZnr1RYoNx0oItpjNWwAd9Me91MdHrh+9t
         K8vv1+XaC7JoTklVlVv7D+dzTF5UHN0ctIrJQ=
Date: Mon, 1 Sep 2008 18:29:50 +0400
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org
Cc: axboe@kernel.dk, dwmw2@infradead.org
Subject: warning during mtd registration in 2.6.27-rc5
Message-ID: <20080901142949.GA18081@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Since commit abf5439370491dd6fbb4fe1a7939680d2a9bc9d4
I'm seeing this problem:

kobject (c3abad68): tried to init an initialized object, something is seriously wrong.
[<c0027ff0>] (dump_stack+0x0/0x14) from [<c013c484>] (kobject_init+0x40/0x78)
[<c013c444>] (kobject_init+0x0/0x78) from [<c013ca24>] (kobject_init_and_add+0x20/0x44)
 r5:c3abad68 r4:c3ac2520
[<c013ca08>] (kobject_init_and_add+0x4/0x44) from [<c0137c6c>] (blk_register_filter+0x48/0x60)
 r5:c3ab4060 r4:c3aba880
[<c0137c24>] (blk_register_filter+0x0/0x60) from [<c01366c4>] (add_disk+0x60/0xb8)
 r4:c3ac2400
[<c0136664>] (add_disk+0x0/0xb8) from [<c01a6994>] (add_mtd_blktrans_dev+0x210/0x244)
 r5:c3ab4060 r4:00000001
[<c01a6784>] (add_mtd_blktrans_dev+0x0/0x244) from [<c01a6bbc>] (mtdblock_add_mtd+0x58/0x64)
 r8:c03c7910 r7:c3ab6100 r6:c03c6bd4 r5:c03c6c04 r4:c3ab6100
[<c01a6b64>] (mtdblock_add_mtd+0x0/0x64) from [<c01a6144>] (blktrans_notify_add+0x3c/0x68)
 r5:c3ab6100 r4:c03c6c04
[<c01a6108>] (blktrans_notify_add+0x0/0x68) from [<c01a3a20>] (add_mtd_device+0xc0/0x120)
 r6:c03c6b80 r5:c3ab6100 r4:c03c6bc4
[<c01a3960>] (add_mtd_device+0x0/0x120) from [<c01a4e50>] (add_one_partition+0x468/0x500)
 r6:c3ac2000 r5:00700000 r4:c3ab6100
[<c01a49e8>] (add_one_partition+0x0/0x500) from [<c01a4f20>] (add_mtd_partitions+0x38/0x7c)
[<c01a4ee8>] (add_mtd_partitions+0x0/0x7c) from [<c0016a48>] (sharpsl_nand_init+0x1dc/0x238)
....

This happens when adding mtd partitions. I've traced it to the fact that
mtd partition devices share the genhd queue with the whole chip block device.
Thus blk_register_filter receives the same pointer for the chip and for each
registered partition.

-- 
With best wishes
Dmitry

