Return-Path: <linux-kernel-owner+w=401wt.eu-S1753734AbYJRTOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734AbYJRTOP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 15:14:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753526AbYJRTEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 15:04:51 -0400
Received: from ns2.suse.de ([195.135.220.15]:47606 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753518AbYJRTEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 15:04:50 -0400
Date: Sat, 18 Oct 2008 11:47:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Tejun Heo <tj@kernel.org>,
       Taisuke Yamada <tai@rakugaki.org>, Jeff Garzik <jgarzik@redhat.com>
Subject: [patch 12/26] libata: LBA28/LBA48 off-by-one bug in ata.h
Message-ID: <20081018184750.GM301@suse.de>
References: <20081018183853.004667035@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="libata-lba28-lba48-off-by-one-bug-in-ata.h.patch"
In-Reply-To: <20081018184708.GA301@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us 
know.

------------------
From: Taisuke Yamada <tai@rakugaki.org>

commit 97b697a11b07e2ebfa69c488132596cc5eb24119 upstream

I recently bought 3 HGST P7K500-series 500GB SATA drives and
had trouble accessing the block right on the LBA28-LBA48 border.
Here's how it fails (same for all 3 drives):

  # dd if=/dev/sdc bs=512 count=1 skip=268435455 > /dev/null
  dd: reading `/dev/sdc': Input/output error
  0+0 records in
  0+0 records out
  0 bytes (0 B) copied, 0.288033 seconds, 0.0 kB/s
  # dmesg
  ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
  ata1.00: BMDMA stat 0x25
  ata1.00: cmd c8/00:08:f8:ff:ff/00:00:00:00:00/ef tag 0 dma 4096 in
  res 51/04:08:f8:ff:ff/00:00:00:00:00/ef Emask 0x1 (device error)
  ata1.00: status: { DRDY ERR }
  ata1.00: error: { ABRT }
  ata1.00: configured for UDMA/33
  ata1: EH complete
  ...

After some investigations, it turned out this seems to be caused
by misinterpretation of the ATA specification on LBA28 access.
Following part is the code in question:

  === include/linux/ata.h ===
  static inline int lba_28_ok(u64 block, u32 n_block)
  {
    /* check the ending block number */
    return ((block + n_block - 1) < ((u64)1 << 28)) && (n_block <= 256);
  }

HGST drive (sometimes) fails with LBA28 access of {block = 0xfffffff,
n_block = 1}, and this behavior seems to be comformant. Other drives,
including other HGST drives are not that strict, through.

>From the ATA specification:
(http://www.t13.org/Documents/UploadedDocuments/project/d1410r3b-ATA-ATAPI-6.pdf)

  8.15.29  Word (61:60): Total number of user addressable sectors
  This field contains a value that is one greater than the total number
  of user addressable sectors (see 6.2). The maximum value that shall
  be placed in this field is 0FFFFFFFh.

So the driver shouldn't use the value of 0xfffffff for LBA28 request
as this exceeds maximum user addressable sector. The logical maximum
value for LBA28 is 0xffffffe.

The obvious fix is to cut "- 1" part, and the patch attached just do
that. I've been using the patched kernel for about a month now, and
the same fix is also floating on the net for some time. So I believe
this fix works reliably.

Just FYI, many Windows/Intel platform users also seems to be struck
by this, and HGST has issued a note pointing to Intel ICH8/9 driver.

  "28-bit LBA command is being used to access LBAs 29-bits in length"
http://www.hitachigst.com/hddt/knowtree.nsf/cffe836ed7c12018862565b000530c74/b531b8bce8745fb78825740f00580e23

Also, *BSDs seems to have similar fix included sometime around ~2004,
through I have not checked out exact portion of the code.

Signed-off-by: Taisuke Yamada <tai@rakugaki.org>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/ata.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -682,7 +682,7 @@ static inline int ata_ok(u8 status)
 static inline int lba_28_ok(u64 block, u32 n_block)
 {
 	/* check the ending block number */
-	return ((block + n_block - 1) < ((u64)1 << 28)) && (n_block <= 256);
+	return ((block + n_block) < ((u64)1 << 28)) && (n_block <= 256);
 }
 
 static inline int lba_48_ok(u64 block, u32 n_block)

-- 
