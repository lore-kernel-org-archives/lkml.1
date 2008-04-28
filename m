Return-Path: <linux-kernel-owner+w=401wt.eu-S933441AbYD1KAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933441AbYD1KAT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 06:00:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761819AbYD1KAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 06:00:06 -0400
Received: from guard.arkoon.net ([62.161.237.193]:40420 "EHLO
	akguard.arkoon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755248AbYD1KAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 06:00:04 -0400
X-Greylist: delayed 1194 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Apr 2008 06:00:04 EDT
To: linux-kernel@vger.kernel.org
Subject: Unsuccessful access to the last blocks of a device [2.4/2.6 PATCH]
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 7.0.2 September 26, 2006
Message-ID: <OF86A13DB6.D3710FA2-ONC1257439.0034CA09-C1257439.00351771@arkoon.net>
Date: Mon, 28 Apr 2008 11:39:59 +0200
X-MIMETrack: S/MIME Sign by Notes Client on mathieu lafon/Arkoon(Release 7.0.2|September
 26, 2006) at 28/04/2008 11:39:54,
	Serialize by Notes Client on mathieu lafon/Arkoon(Release 7.0.2|September
 26, 2006) at 28/04/2008 11:39:54,
	Serialize complete at 28/04/2008 11:39:54,
	S/MIME Sign failed at 28/04/2008 11:39:54: Cl? chiffr?e introuvable,
	Serialize by Router on arkoon-mail.arkoon.net/Arkoon(Release 7.0.2|September
 26, 2006) at 28/04/2008 11:40:01,
	Serialize complete at 28/04/2008 11:40:01
From: "Mathieu Lafon" <mlafon@arkoon.net>
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have encountered a problem where I wasn't able to access to the last 
blocks
of a partition.

By example, using dd:

# dd if=/dev/hda1 of=/dev/null
dd: /dev/hda1: Input/output error

In the kernel logs:

03:01: rw=0, want=28864, limit=28863 
attempt to access beyond end of device 

After having investigated this issue, I have found the following 
explanation:

- A getblk() call is done to read one of the last block of my partition.
  The block is located in the last PAGE_SIZE (4kB) of the partition.
  In my case, the getblk() call is done by the e2compr patch
  (e2compr.sourceforge.net) but I don't think it is the problem (correct
  me if I'm wrong).

- The block is not in the page cache so a new page is created by 
grow_buffers()
  with 4 buffers of 1kB.

- When the page is created, hash_page_buffers() is called to initialize 
the
  buffers. The buffers are initialized by simply incrementing the block
  number without any check.

  In my case, the last buffer is initialized with a block number outside 
of
  the partition.

- When dd try to access to one of the last block, the (invalid) cached 
page
  is found and trigger the previous error (attempt to access beyond end of
  device) because one buffer of the page is really beyond end of device.

- If I manage to get the cache flushed, I can read the whole partition
  because the (invalid) cached page is not found and 
block_read_full_page()
  correctly initialize the new page by checking the last block.

I have made a patch for 2.4.32 to test for the last block in 
grow_buffers()
and hash_page_buffers() in the same way it is done in 
block_read_full_page().

Regarding the 2.6 branch, I have looked at the source code and the problem
seems to be the same in init_page_buffers() which is called by __getblk().

-- 
Mathieu Lafon - Arkoon Network Security
