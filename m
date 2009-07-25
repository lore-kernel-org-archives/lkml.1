Return-Path: <linux-kernel-owner+w=401wt.eu-S1755329AbZGYDYC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329AbZGYDYC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 23:24:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752420AbZGYDYB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 23:24:01 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56736 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996AbZGYDYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 23:24:00 -0400
Date: Fri, 24 Jul 2009 23:23:44 -0400
From: Dave Jones <davej@redhat.com>
To: Ian Lance Taylor <iant@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kbuild@vger.kernel.org,
       barryn@pobox.com, bugme-daemon@bugzilla.kernel.org
Subject: Re: [Bug 13012] 2.6.28.9 causes init to segfault on Debian etch;
	2.6.28.8 OK
Message-ID: <20090725032343.GA20841@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Ian Lance Taylor <iant@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Frans Pop <elendil@planet.nl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kbuild@vger.kernel.org, barryn@pobox.com,
	bugme-daemon@bugzilla.kernel.org
References: <200907100928.07369.elendil@planet.nl> <200907101659.31813.elendil@planet.nl> <alpine.LFD.2.01.0907121058040.3552@localhost.localdomain> <m3k52d1775.fsf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3k52d1775.fsf@google.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 12, 2009 at 10:29:50PM -0700, Ian Lance Taylor wrote:

 > (The gcc 4.2 and later option -Wstrict-overflow=N can help find the
 > cases where a program relies on defined signed overflow, but only if
 > somebody is patient enough to wade through all the false positives.)
 
I got curious and wondered just how many warnings this would trigger,
so I did a build with -Wstrict-overflow=5.  I was pleasantly surprised
to see that it isn't that many from an allmodconfig build..

crypto/algboss.c:173: warning: assuming signed overflow does not occur when simplifying conditional to constant
net/ipv4/igmp.c:773: warning: assuming signed overflow does not occur when simplifying conditional to constant
drivers/ata/libata-eh.c:3076: warning: assuming signed overflow does not occur when simplifying conditional to constant
sound/core/seq/seq_queue.c:195: warning: assuming signed overflow does not occur when simplifying conditional to constant
drivers/block/ub.c:2293: warning: assuming signed overflow does not occur when simplifying conditional to constant
sound/pci/es1968.c:1545: warning: assuming signed overflow does not occur when simplifying conditional to constant
sound/pci/es1968.c:1582: warning: assuming signed overflow does not occur when simplifying conditional to constant
fs/ext3/inode.c:658: warning: assuming signed overflow does not occur when simplifying conditional to constant
fs/ext4/inode.c:797: warning: assuming signed overflow does not occur when simplifying conditional to constant
drivers/edac/amd64_edac.c:726: warning: assuming signed overflow does not occur when simplifying conditional to constant
sound/soc/codecs/wm8988.c:665: warning: assuming signed overflow does not occur when simplifying conditional to constant
net/bluetooth/cmtp/core.c:234: warning: assuming signed overflow does not occur when simplifying conditional to constant
net/mac80211/rc80211_minstrel.c:193: warning: assuming signed overflow does not occur when simplifying conditional to constant
drivers/isdn/hardware/eicon/debug.c:419: warning: assuming signed overflow does not occur when simplifying conditional to constant
drivers/uio/uio.c:707: warning: assuming signed overflow does not occur when simplifying conditional to constant
drivers/uio/uio.c:671: warning: assuming signed overflow does not occur when simplifying conditional to constant
drivers/uio/uio.c:642: warning: assuming signed overflow does not occur when simplifying conditional to constant
drivers/net/usb/hso.c:2308: warning: assuming signed overflow does not occur when simplifying conditional to constant
drivers/video/matrox/matroxfb_g450.c:214: warning: assuming signed overflow does not occur when simplifying conditional to constant
drivers/video/matrox/matroxfb_g450.c:160: warning: assuming signed overflow does not occur when simplifying conditional to constant
drivers/video/matrox/matroxfb_maven.c:1125: warning: assuming signed overflow does not occur when simplifying conditional to constant
drivers/video/matrox/matroxfb_maven.c:1044: warning: assuming signed overflow does not occur when simplifying conditional to constant
drivers/net/wireless/zd1211rw/zd_rf_uw2453.c:417: warning: assuming signed overflow does not occur when simplifying conditional to constant

Some of these appear to be obvious cases where we don't care about
the sign (loop counters for eg)

Is it worth fixing these up, with diffs like the below ?

	Dave

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 5f51fed..3bb95de 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -595,7 +595,7 @@ static int ext3_alloc_branch(handle_t *handle, struct inode *inode,
 			int *offsets, Indirect *branch)
 {
 	int blocksize = inode->i_sb->s_blocksize;
-	int i, n = 0;
+	unsigned int i, n = 0;
 	int err = 0;
 	struct buffer_head *bh;
 	int num;

