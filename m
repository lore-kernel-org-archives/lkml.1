Return-Path: <linux-kernel-owner+w=401wt.eu-S1752952AbXHAUpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952AbXHAUpx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 16:45:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751316AbXHAUpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 16:45:43 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:32820 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbXHAUpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 16:45:42 -0400
To: linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org
Subject: kupdate weirdness
Message-Id: <E1IGL4G-00088R-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 01 Aug 2007 22:45:16 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following strange behavior can be observed:

1. large file is written
2. after 30 seconds, nr_dirty goes down by 1024
3. then for some time (< 30 sec) nothing happens (disk idle)
4. then nr_dirty again goes down by 1024
5. repeat from 3. until whole file is written

So basically a 4Mbyte chunk of the file is written every 30 seconds.
I'm quite sure this is not the intended behavior.

The reason seems to be that __sync_single_inode() will move the
partially written inode from s_io onto s_dirty, and sync_sb_inode()
will not splice it back onto s_io until the rest of the inodes on s_io
has been processed.

Since there will probably be a recently dirtied inode on s_io, this
will take some of time, but always less than 30 sec.

I don't know what's the easiest solution.

Any ideas?

Miklos
