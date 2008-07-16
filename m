Return-Path: <linux-kernel-owner+w=401wt.eu-S1759011AbYGPITE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759011AbYGPITE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 04:19:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753834AbYGPISs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 04:18:48 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:50712 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbYGPISq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 04:18:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:x-accept-language:mime-version:to
         :subject:content-type:content-transfer-encoding;
        b=IrJA3s38ql6FIevmCXbagERSQ/ens/lZyHRFbKFDYeH46Ziy5o0s21ffzHKr9ImbcX
         /bRHai3T7SNz27EYyLM82GJRAQaLJW3bwXDEq5CYH0QZ+nR9/Nb19+Is/PcK4AM6h3xi
         vq9iLIrtEOthTqcopEdED+maWqwBKIbs1G9fM=
Message-ID: <487DAEDB.3020007@gmail.com>
Date: Tue, 15 Jul 2008 22:18:35 -1000
From: Adam Greenblatt <adam.greenblatt@gmail.com>
User-Agent: Mozilla Thunderbird 0.9 (X11/20041103)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: penberg@cs.helsinki.fi, akpm@linux-foundation.org, jack@ucw.cz,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.26] isofs: fix minor filesystem corruption, take 2
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some iso9660 images contain files with rockridge data that is either 
incorrect or
incompletely parsed.  Prior to commit 
f2966632a134e865db3c819346a1dc7d96e05309,
(included with kernel 2.6.13) the kernel ignored the rockridge data for 
these files,
while still allowing the files to be accessed under their non-rockridge 
names.  That
commit inadvertently changed things so that files with invalid rockridge 
data could
not be accessed  at all.  (I ran across the problem when comparing some 
old CDs with
hard disk copies I had made long ago under kernel 2.4: a few of the 
files on the hard
disk copies were no longer visible on the CDs.)

This change reverts to the pre-2.6.13 behavior.

Signed-off-by: Adam Greenblatt <adam.greenblatt@gmail.com>
---
Pekka Enberg correctly pointed out that there was a similar change made to
parse_rock_ridge_inode_internal() that should also be reverted.  Please 
ignore
my previous patch, and use this patch instead.  Thanks Pekka!
--- linux-2.6.26/fs/isofs/rock.c.orig   2008-07-13 11:51:29.000000000 -1000
+++ linux-2.6.26/fs/isofs/rock.c        2008-07-15 21:52:43.000000000 -1000
@@ -209,6 +209,9 @@ repeat:
 
        while (rs.len > 2) { /* There may be one byte for padding 
somewhere */
                rr = (struct rock_ridge *)rs.chr;
+               /* Ignore rock ridge info if rr->len is out of range, but
+                  don't return -EIO because that would make the file
+                  invisible. */
                if (rr->len < 3)
                        goto out;       /* Something got screwed up here */
                sig = isonum_721(rs.chr);
@@ -216,8 +219,9 @@ repeat:
                        goto eio;
                rs.chr += rr->len;
                rs.len -= rr->len;
+               /* As above, ignore rock ridge info if rr->len is bogus. */
                if (rs.len < 0)
-                       goto eio;       /* corrupted isofs */
+                       goto out;       /* Something got screwed up here */
 
                switch (sig) {
                case SIG('R', 'R'):
@@ -307,6 +311,9 @@ parse_rock_ridge_inode_internal(struct i
 repeat:
        while (rs.len > 2) { /* There may be one byte for padding 
somewhere */
                rr = (struct rock_ridge *)rs.chr;
+               /* Ignore rock ridge info if rr->len is out of range, but
+                  don't return -EIO because that would make the file
+                  invisible. */
                if (rr->len < 3)
                        goto out;       /* Something got screwed up here */
                sig = isonum_721(rs.chr);
@@ -314,8 +321,9 @@ repeat:
                        goto eio;
                rs.chr += rr->len;
                rs.len -= rr->len;
+               /* As above, ignore rock ridge info if rr->len is bogus. */
                if (rs.len < 0)
-                       goto eio;       /* corrupted isofs */
+                       goto out;       /* Something got screwed up here */
 
                switch (sig) {
 #ifndef CONFIG_ZISOFS          /* No flag for SF or ZF */

