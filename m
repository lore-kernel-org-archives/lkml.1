Return-Path: <linux-kernel-owner+w=401wt.eu-S1762179AbYBFXBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762179AbYBFXBr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 18:01:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761682AbYBFXBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:01:33 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:13757 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761616AbYBFXBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:01:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=chv4wInP8VgGdZyNssI5zyg52NCY6BZ2bofamn52XbRXkBEhPJkOIlMCbj4n82DACpCqOyKKBlBwG2Y03xefRVVLPqTS095zmjv+y+HaZjnya+QzGp9ykkyJ0pgA0+pJDezrGn2SPG752DnQ07kwndPd9UK/fKIUC5ML59ci2Fk=
Message-ID: <6101e8c40802061501i31a6af25g54704109f06a8cba@mail.gmail.com>
Date: Thu, 7 Feb 2008 00:01:30 +0100
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>, stable@kernel.org,
       stable-commits@vger.kernel.org
Subject: Re: [2.6.22.y] {01**/17} - do_anonymous_page-race - series for stable kernel
In-Reply-To: <6101e8c40802011733y69521724t9e02690419f55201@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6101e8c40802011733y69521724t9e02690419f55201@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---8<---

-- 
Thanks,From: Andrea Arcangeli <andrea@suse.de>
Subject: Race condition in userspace testcase
References: 46948, LTC11574


Additional Comment #103 From Andrea Arcangeli 2004-10-15 19:41
the last patch I attached is the safest I believe.

I'm not sure if a lock_unlock or lock_unlock is always guaranteed to happen
after the I/O, and this makes sure no race can happen anymore.

---
 fs/bio.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/fs/bio.c	2007-07-08 19:32:17.000000000 -0400
+++ b/fs/bio.c	2007-08-27 14:01:21.000000000 -0400
@@ -1028,6 +1028,15 @@ void bio_endio(struct bio *bio, unsigned
 	bio->bi_size -= bytes_done;
 	bio->bi_sector += (bytes_done >> 9);

+	if (bio_data_dir(bio) == READ)
+		/*
+		 * If the current cpu has written to the page by hand
+		 * without dma, we must enforce ordering to be sure
+		 * this written data will be visible before we expose
+		 * the page contents to other cpus (for example with
+		 * a set_pte).
+		 */
+		smp_wmb();
 	if (bio->bi_end_io)
 		bio->bi_end_io(bio, bytes_done, error);
 }
---8<---

--
Oliver
