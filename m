Return-Path: <linux-kernel-owner+w=401wt.eu-S1756668AbZBSLIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668AbZBSLIB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 06:08:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756168AbZBSLHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 06:07:45 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:42761 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756062AbZBSLHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 06:07:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=dGICbchRZGAF/At0XcbN5A+KLGVcDBINMobKRfk2DELV9ZOs1UftTJKYyjQwNRpy7N
         zg28ELHozAuDGjmMjxb+WFTPYdo8VdQmwrYyaYaio5AdejEaUM7WFYvPuS+20WaZSgka
         uZE+xPHwdBzDuUnaixCP2uLEBkFp9vybtRFmQ=
MIME-Version: 1.0
In-Reply-To: <m2hc2yulrw.fsf@gmail.com>
References: <m2hc2yulrw.fsf@gmail.com>
Date: Thu, 19 Feb 2009 12:07:42 +0100
Message-ID: <38b2ab8a0902190307p214a6928v2f66b8ad5e9564e6@mail.gmail.com>
Subject: Question regarding concurrent accesses through block device and fs
From: Francis Moreau <francis.moro@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Resend to LKLM, hopping to get a wider audience ;) and to Andrew Morton since
  he wrote that part of the code, I think ]

Hello,

I have a question regarding the page cache/buffer heads behaviour when
some blocks are accessed through a regular file and through the block
dev hosting this file.

First it looks like when accessing some blocks through a block device,
the same mechanisms are used as when reading a file through a file
system: the page cache is used.

That means that a block could be mapped by several buffers at the same
time.

I don't see any issues to this (if we agree that the behaviour is undefined
in that case) but looking at __block_prepare_write(), it seems that we don't
want this to happen since it does:

       [...]
       if (buffer_new(bh)) {
               unmap_underlying_metadata(bh->b_bdev, bh->b_blocknr);
               [...]
       }

where unmap_underlying_metadata() unmaps the blockdev buffer
which maps b_blocknr block.

This code seems to catch only the case where the buffer is new (I don't
see why only this case is treated).

Also this call seems unneeded if __block_prepare_write() is called
when writing through the block dev since we already know that the buffer
doesn't exist (we are here to create it).

I already read the comment of the function unmap_underlying_metadata()
but I failed to understand it...

Could anybody tell me what is the actual policy ?


thanks
--
Francis
