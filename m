Return-Path: <linux-kernel-owner+w=401wt.eu-S1762667AbXLNToL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762667AbXLNToL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 14:44:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753177AbXLNTn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 14:43:57 -0500
Received: from ruby.spiritone.com ([216.99.193.130]:39153 "EHLO
	ruby.spiritone.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbXLNTn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 14:43:57 -0500
X-Greylist: delayed 582 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Dec 2007 14:43:57 EST
Message-ID: <4762DAB1.1020807@BitWagon.com>
Date: Fri, 14 Dec 2007 11:34:09 -0800
From: John Reiser <jreiser@BitWagon.com>
Organization: -
User-Agent: Mozilla Thunderbird 1.0.8-1.1.fc4 (X11/20060501)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: linux-kernel@vger.kernel.org, security@kernel.org
Subject: /dev/urandom uses uninit bytes, leaks user data
X-Enigmail-Version: 0.92.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xfer_secondary_pool() in drivers/char/random.c tells add_entropy_words()
to use uninitialized tmp[] whenever bytes is not a multiple of 4.
Besides being unfriendly to automated dynamic checkers, this is a
potential leak of user data into the output stream.  When called from
extract_entropy_user, then uninit tmp[] can capture leftover data
from a previous copy_from_user().

Signed off by: jreiser@BitWagon.com

--- ./drivers/char/random.c.orig	2007-12-14 11:06:03.000000000 -0800
+++ ./drivers/char/random.c	2007-12-14 11:06:57.000000000 -0800
@@ -708,7 +708,19 @@

 		bytes=extract_entropy(r->pull, tmp, bytes,
 				      random_read_wakeup_thresh / 8, rsvd);
- 		add_entropy_words(r, tmp, (bytes + 3) / 4);
+		/*
+		 * 2007-12-13 (valgrind/memcheck) Do not use undefined bytes.
+		 * Avoid info leak when called from extract_entropy_user:
+		 * uninit tmp[] can have data from previous copy_from_user().
+		 * Instead: fill last word using first bytes.
+		 */
+		{
+			__u8 *src = (__u8 *)&tmp[0];
+			__u8 *dst = bytes + src;
+			for (; 0!=(3 & bytes); ++bytes)
+				*dst++ = *src++;
+		}
+		add_entropy_words(r, tmp, bytes>>2);
 		credit_entropy_store(r, bytes*8);
 	}

-- 
John Reiser, jreiser@BitWagon.com

