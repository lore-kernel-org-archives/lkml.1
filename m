Return-Path: <linux-kernel-owner+w=401wt.eu-S1753807AbZIBWtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807AbZIBWtu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 18:49:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753588AbZIBWtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 18:49:49 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:38479
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbZIBWts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 18:49:48 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Pavel Machek <pavel@ucw.cz>
Subject: [PATCH] Update Documentation/md.txt to mention journaling won't help dirty+degraded case.
Date: Wed, 2 Sep 2009 17:49:46 -0500
User-Agent: KMail/1.11.2 (Linux/2.6.28-14-generic; KDE/4.2.2; x86_64; ; )
Cc: Ric Wheeler <rwheeler@redhat.com>, david@lang.hm,
       Theodore Tso <tytso@mit.edu>, Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
References: <20090826001645.GN4300@elf.ucw.cz> <4A9910D5.4060208@redhat.com> <20090902201210.GC1840@ucw.cz>
In-Reply-To: <20090902201210.GC1840@ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909021749.47695.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Landley <rob@landley.net>

Add more warnings to the "Boot time assembly of degraded/dirty arrays" section,
explaining that using a journaling filesystem can't overcome this problem.

Signed-off-by: Rob Landley <rob@landley.net>
---

 Documentation/md.txt |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/Documentation/md.txt b/Documentation/md.txt
index 4edd39e..52b8450 100644
--- a/Documentation/md.txt
+++ b/Documentation/md.txt
@@ -75,6 +75,23 @@ So, to boot with a root filesystem of a dirty degraded raid[56], use
 
    md-mod.start_dirty_degraded=1
 
+Note that Journaling filesystems do not effectively protect data in this
+case, because the update granularity of the RAID is larger than the journal
+was designed to expect.  Reconstructing data via partity information involes
+matching together corresponding stripes, and updating only some of these
+stripes renders the corresponding data in all the unmatched stripes
+meaningless.  Thus seemingly unrelated data in other parts of the filesystem
+(stored in the unmatched stripes) can become unreadable after a partial
+update, but the journal is only aware of the parts it modified, not the
+"collateral damage" elsewhere in the filesystem which was affected by those
+changes.
+
+Thus successful journal replay proves nothing in this context, and even a
+full fsck only shows whether or not the filesystem's metadata was affected.
+(A proper solution to this problem would involve adding journaling to the RAID
+itself, at least during degraded writes.  In the meantime, try not to allow
+a system to shut down uncleanly with its RAID both dirty and degraded, it
+can handle one but not both.)
 
 Superblock formats
 ------------------


-- 
Latency is more important than throughput. It's that simple. - Linus Torvalds
