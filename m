Return-Path: <linux-kernel-owner+w=401wt.eu-S1756858AbYGPElm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858AbYGPElm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 00:41:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751558AbYGPEle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 00:41:34 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:40379 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235AbYGPEld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 00:41:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:x-accept-language:mime-version:to
         :subject:content-type:content-transfer-encoding;
        b=S11JbKJCSWwXVjMrVjEhQ4V0+4sIfCBa0rNaHLv8qqPbgRKcc7LBIs5fTd35xa0iJj
         aIl7xV8T6+bVAj/Rr0SjJ99sqi5TJpYcuh9PkLxISsunV8+QcM2TyMPVuRW3eF+lSYLk
         Ywoy03m16gpdtg6HE9lQieXuqP4fECOZl9/q4=
Message-ID: <487D7BF9.60509@gmail.com>
Date: Tue, 15 Jul 2008 18:41:29 -1000
From: Adam Greenblatt <adam.greenblatt@gmail.com>
User-Agent: Mozilla Thunderbird 0.9 (X11/20041103)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: akpm@linux-foundation.org, jack@ucw.cz, linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.26] isofs: fix minor filesystem corruption
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
names.  That commit
inadvertently changed things so that files with invalid rockridge data 
could not be accessed
at all.  (I ran across the problem when comparing some old CDs with hard 
disk copies I had
made long ago under kernel 2.4: a few of the files on the hard disk 
copies were no longer
visible on the CDs.)

This change reverts to the pre-2.6.13 behavior.

Signed-off-by: Adam Greenblatt <adam.greenblatt@gmail.com>
---
--- linux-2.6.26/fs/isofs/rock.c.orig   2008-07-15 18:19:36.000000000 -1000
+++ linux-2.6.26/fs/isofs/rock.c        2008-07-15 18:16:56.000000000 -1000
@@ -217,7 +217,7 @@ repeat:
                rs.chr += rr->len;
                rs.len -= rr->len;
                if (rs.len < 0)
-                       goto eio;       /* corrupted isofs */
+                       goto out;       /* corrupted isofs */
 
                switch (sig) {
                case SIG('R', 'R'):

