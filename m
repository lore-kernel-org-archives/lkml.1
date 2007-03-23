Return-Path: <linux-kernel-owner+w=401wt.eu-S1945911AbXCWPSa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945911AbXCWPSa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 11:18:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992456AbXCWPSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 11:18:30 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56784 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945911AbXCWPS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 11:18:29 -0400
Message-ID: <4603E806.3030205@redhat.com>
Date: Fri, 23 Mar 2007 15:45:26 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Marti Raudsepp <marti@juffo.org>
CC: Alasdair G Kergon <agk@redhat.com>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       device-mapper development <dm-devel@redhat.com>,
       Kernel hackers <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christophe Saout <christophe@saout.de>
Subject: [PATCH] disable barriers in dm-crypt [was Re: BUG: Files corrupt
 after moving LVM volume to USB disk]
References: <20070322000348.92631512.akpm@linux-foundation.org>	 <20070322153301.GN27600@agk.surrey.redhat.com> <2a12af650703221742p6691f4b5i21667a5c98217fb6@mail.gmail.com>
In-Reply-To: <2a12af650703221742p6691f4b5i21667a5c98217fb6@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Summary of what I've managed to rule out so far:
>1. this problem does not occur without dm-crypt

Please could you test attached patch ?
Sorry for another annoying reboot :-)

Milan
--
mbroz@redhat.com



From: Milan Broz <mbroz@redhat.com>

Disable barriers in dm-crypt because of current workqueue processing
can reorder requests.

This must be addresed later but for now disabling barriers is needed
to prevent data corruption.

Signed-off-by: Milan Broz <mbroz@redhat.com>

Index: linux-2.6.20.1/drivers/md/dm-crypt.c
===================================================================
--- linux-2.6.20.1.orig/drivers/md/dm-crypt.c	2007-03-23 15:07:11.000000000 +0100
+++ linux-2.6.20.1/drivers/md/dm-crypt.c	2007-03-23 15:09:59.000000000 +0100
@@ -925,6 +925,9 @@ static int crypt_map(struct dm_target *t
 	struct crypt_config *cc = ti->private;
 	struct crypt_io *io;
 
+	if (bio_barrier(bio))
+		return -EOPNOTSUPP;
+
 	io = mempool_alloc(cc->io_pool, GFP_NOIO);
 	io->target = ti;
 	io->base_bio = bio;


