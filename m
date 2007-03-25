Return-Path: <linux-kernel-owner+w=401wt.eu-S933149AbXCYAR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933149AbXCYAR1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 20:17:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933159AbXCYAR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 20:17:27 -0400
Received: from smtp-out.google.com ([216.239.45.13]:3355 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933149AbXCYAR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 20:17:26 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=MNjS+sx3tXj5oYOna3xYjsVTx9SsWieLz0YW/I5pSg0jXRNjaVJfoAgAkHoPKvgO+
	AKJsFeT2wYBF/l5zFYpUA==
Message-ID: <b040c32a0703241717t5fc33fc5ke645708d12b6e5cb@mail.gmail.com>
Date: Sat, 24 Mar 2007 17:17:18 -0700
From: "Ken Chen" <kenchen@google.com>
To: "Jan Engelhardt" <jengelh@linux01.gwdg.de>
Subject: Re: [PATCH] max_loop limit
Cc: "Eric Dumazet" <dada1@cosmosbay.com>, "Tomas M" <tomas@slax.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0703240023220.10028@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <460236CE.1030303@slax.org>
	 <20070322110058.GB23664@tatooine.rebelbase.local>
	 <46026A92.4020106@slax.org>
	 <20070322144210.73dfaf83.dada1@cosmosbay.com>
	 <Pine.LNX.4.61.0703230232320.9555@yvahk01.tjqt.qr>
	 <Pine.LNX.4.61.0703240023220.10028@yvahk01.tjqt.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/23/07, Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:
> Sadly, it locks up the foreground process (losetup that would be), and I
> have not yet figured out why. And the mpt regression elsewhere is
> hindering me in finding out faster.

You need to tell the block layer that each loop device is a whole
block device, not a partition within another device. Otherwise, I
think it will cause a recursive mutex lock in block_dev.c:do_open().

This patch should fix the problem.

Signed-off-by: Ken Chen <kenchen@google.com>

--- ./drivers/block/loop.c.orig	2007-03-24 17:05:51.000000000 -0700
+++ ./drivers/block/loop.c	2007-03-24 17:06:06.000000000 -0700
@@ -1464,6 +1464,7 @@

 	if ((lo = loop_find_dev(number)) == NULL) {
 		lo = loop_init_one(number);
+		*part = 0;
 		if (IS_ERR(lo))
 			return (void *)lo;
 	}
