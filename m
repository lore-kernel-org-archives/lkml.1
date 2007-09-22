Return-Path: <linux-kernel-owner+w=401wt.eu-S1763022AbXIVKez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763022AbXIVKez (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 06:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753637AbXIVKes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 06:34:48 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:25519 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206AbXIVKer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 06:34:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bOkq0QkO4yr3tfDz7lekyMXxam9L/j2GUb1QlwyzW7iikx9tIgBPInrqkXOIQIb6F0Uubh+qRTQER2CqHYNFu/m4LXSLJUMOcG3MMgzvEZkO0QHH2iYgS8D6uGC/FSfsvoRzDqpTHlPMARMjZZOS6WgwSr90jXxn5OIS0GNyLkE=
Message-ID: <6101e8c40709220334v7eefbb8g73128bc315ca07d4@mail.gmail.com>
Date: Sat, 22 Sep 2007 12:34:45 +0200
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org, reiserfs-dev@namesys.com
Subject: Re: [stable] [PATCH] 2.6.22.6 fix kernel panic on corrupted reiserfs directory
Cc: lepton <ytht.net@gmail.com>, "Greg KH" <greg@kroah.com>
In-Reply-To: <20070921224527.GA14632@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070914101019.GA12437@router.lepton.home>
	 <6101e8c40709141004v57d74eb5hc683901fa267da2b@mail.gmail.com>
	 <20070921224527.GA14632@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[snap]

Hi,
  When reading corrupted reiserfs directory data, d_reclen
  could be a negative number or a big positive number, this
  can lead to kernel panic or oop.
  The following patch adds a sanity check. (against 2.6.20.4)

Signed-off-by: Lepton Wu <ytht.net@gmail.com>

diff -X linux-2.6.22.6-lepton/Documentation/dontdiff -pru
linux-2.6.22.6/fs/reiserfs/dir.c
linux-2.6.22.6-lepton/fs/reiserfs/dir.c
--- linux-2.6.22.6/fs/reiserfs/dir.c    2007-09-14 17:41:15.000000000 +0800
+++ linux-2.6.22.6-lepton/fs/reiserfs/dir.c     2007-09-14
18:02:10.000000000 +0800
@@ -121,6 +121,16 @@ static int reiserfs_readdir(struct file
                                        continue;
                                d_reclen = entry_length(bh, ih, entry_num);
                                d_name = B_I_DEH_ENTRY_FILE_NAME(bh, ih, deh);
+
+                               if (d_reclen <= 0 ||
+                                   d_name + d_reclen > bh->b_data +
bh->b_size) {
+                                       /* There is corrupted data in entry,
+                                        * We'd better stop here */
+                                       pathrelse(&path_to_entry);
+                                       ret = -EIO;
+                                       goto out;
+                               }
+
                                if (!d_name[d_reclen - 1])
                                        d_reclen = strlen(d_name);

[/snap]

it is Lepton's patch.
Namesys boys, this patch is OK?
Greg, I neither do find this patch in Linus's tree.

-- 
Thanks,
Oliver
