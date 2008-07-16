Return-Path: <linux-kernel-owner+w=401wt.eu-S1758794AbYGPJFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758794AbYGPJFa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 05:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755436AbYGPJFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 05:05:23 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:9641 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755342AbYGPJFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 05:05:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:x-accept-language:mime-version:to
         :subject:content-type:content-transfer-encoding;
        b=DvrJDVXdJPivsLpA7K6GrseFH/XR5/T/qvk1tGWyu3xp2vSNbJSR1mBKteJnscuomV
         +EriLDxX6nfbvB+smH62dCM9qs5nVSHQD0gJytpNVysWPKxFNjqimVHhBkIh36LkiAKL
         LaO014QN82OvyV+jX9W9zExTY851Pt5JYUOmU=
Message-ID: <487DB9CE.3070906@gmail.com>
Date: Tue, 15 Jul 2008 23:05:18 -1000
From: Adam Greenblatt <adam.greenblatt@gmail.com>
User-Agent: Mozilla Thunderbird 0.9 (X11/20041103)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: penberg@cs.helsinki.fi, akpm@linux-foundation.org, jack@ucw.cz,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.26] isofs: fix minor filesystem corruption, take 3
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some iso9660 images contain files with rockridge data that is either 
incorrect or
incompletely parsed.  Prior to commit 
f2966632a134e865db3c819346a1dc7d96e05309
("[PATCH] rock: handle directory overflows") (included with kernel 
2.6.13) the
kernel ignored the rockridge data for these files, while still allowing 
the files
to be accessed under their non-rockridge names.  That commit 
inadvertently changed
things so that files with invalid rockridge data could not be accessed 
at all.
(I ran across the problem when comparing some old CDs with hard disk 
copies I had
made long ago under kernel 2.4: a few of the files on the hard disk 
copies were no
longer visible on the CDs.)

This change reverts to the pre-2.6.13 behavior.

Signed-off-by: Adam Greenblatt <adam.greenblatt@gmail.com>
---
This patch is functionally identical to the previous one, but correctly 
formats
the comments and commit description.  Please ignore my previous patches, 
and use
this patch instead.  Thanks!
--- linux-2.6.26/fs/isofs/rock.c.orig   2008-07-15 22:49:00.000000000 -1000
+++ linux-2.6.26/fs/isofs/rock.c        2008-07-15 22:50:06.000000000 -1000
@@ -209,6 +209,11 @@ repeat:
 
        while (rs.len > 2) { /* There may be one byte for padding 
somewhere */
                rr = (struct rock_ridge *)rs.chr;
+               /*
+                * Ignore rock ridge info if rr->len is out of range, but
+                * don't return -EIO because that would make the file
+                * invisible.
+                */
                if (rr->len < 3)
                        goto out;       /* Something got screwed up here */
                sig = isonum_721(rs.chr);
@@ -216,8 +221,12 @@ repeat:
                        goto eio;
                rs.chr += rr->len;
                rs.len -= rr->len;
+               /*
+                * As above, just ignore the rock ridge info if rr->len
+                * is bogus.
+                */
                if (rs.len < 0)
-                       goto eio;       /* corrupted isofs */
+                       goto out;       /* Something got screwed up here */
 
                switch (sig) {
                case SIG('R', 'R'):
@@ -307,6 +316,11 @@ parse_rock_ridge_inode_internal(struct i
 repeat:
        while (rs.len > 2) { /* There may be one byte for padding 
somewhere */
                rr = (struct rock_ridge *)rs.chr;
+               /*
+                * Ignore rock ridge info if rr->len is out of range, but
+                * don't return -EIO because that would make the file
+                * invisible.
+                */
                if (rr->len < 3)
                        goto out;       /* Something got screwed up here */
                sig = isonum_721(rs.chr);
@@ -314,8 +328,12 @@ repeat:
                        goto eio;
                rs.chr += rr->len;
                rs.len -= rr->len;
+               /*
+                * As above, just ignore the rock ridge info if rr->len
+                * is bogus.
+                */
                if (rs.len < 0)
-                       goto eio;       /* corrupted isofs */
+                       goto out;       /* Something got screwed up here */
 
                switch (sig) {
 #ifndef CONFIG_ZISOFS          /* No flag for SF or ZF */

