Return-Path: <linux-kernel-owner+w=401wt.eu-S1765128AbXGSKbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765128AbXGSKbf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 06:31:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932403AbXGSKCR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 06:02:17 -0400
Received: from wr-out-0506.google.com ([64.233.184.227]:2343 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765641AbXGSKCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 06:02:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=EYVMNExtB/fvGgqmXSBLHuE/0mIQm7hOcIkMRBHDGT1gCV3SgRJmJjKycPYOlALb+DIXlhE4SYA/237S/H8YnG7UlB95gkPNowmnpUoxf6fvDGRD9WPd39Qep71Z3RKIfCsX3s7QUDdUWrsoDo5Ze7eDTDkpGVDv4WPpucEQF+c=
Message-ID: <af3ea28a0707190301l5d8a801aj260a259a08360de1@mail.gmail.com>
Date: Thu, 19 Jul 2007 18:01:52 +0800
From: "ye janboe" <janboe.ye@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: jffs2 statfs issue
Cc: dwmw2@infradead.org, jffs-dev@axis.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

jffs2 can not return correct free space amount.
I checked jffs2_statfs, there is problem.

	avail = c->dirty_size + c->free_size;
	if (avail > c->sector_size * c->resv_blocks_write)
		avail -= c->sector_size * c->resv_blocks_write;
	else
		avail = 0;

But in jffs2_reserve_space, c->dirty_size will compare to
c->nospc_dirty_size. If dirty < c->nospc_dirty_size, it will return
nospace error.

So I change above code to
	dirty = c->dirty_size + c->erasing_size - c->nr_erasing_blocks *
c->sector_size + c->unchecked_size;
	if (dirty > c->nospc_dirty_size)
		avail = c->dirty_size + c->free_size - c->nospc_dirty_size;
	else
		avail = c->free_size;

Do this make sense?

Thanks a lot!

Janboe
