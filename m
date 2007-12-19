Return-Path: <linux-kernel-owner+w=401wt.eu-S1759523AbXLSApd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759523AbXLSApd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 19:45:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754958AbXLSApZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 19:45:25 -0500
Received: from py-out-1112.google.com ([64.233.166.183]:33118 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360AbXLSApY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 19:45:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:reply-to:to:cc:subject:message-id:mime-version:content-type;
        b=xeanJX07iquWVlMn+YdP8uocau0liew7RKXIudzt31ZRvNMoCV5MK3Ji7U4gXGL7fYKStSMjza6LqC8R9ik3KBSp/ks5T/8HcbVt3+tRwIp61l3CLZawoAIFIaTW1SbhDW9V+Nfd/CDTEI/0JlrpbSEEkHQX53BfEH3FnrDJ5rM=
Date: Tue, 18 Dec 2007 19:45:18 -0500 (EST)
From: Parag Warudkar <parag.warudkar@gmail.com>
X-X-Sender: parag@mini.warudkars.net
Reply-To: parag.warudkar@gmail.com
To: linux-kernel@vger.kernel.org
cc: mingo@elte.hu, akpm@linux-foundation.org, torvalds@linux-foundation.org,
       ak@suse.de
Subject: [PATCH] x86: Fix dmi_alloc() to not advance alloc index in case of
 failure
Message-ID: <Pine.LNX.4.64.0712181937560.3616@mini.warudkars.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


dmi_alloc() for CONFIG_X86_64 is defined to allocate from a static array 
and it maintains a allocation index which is advanced each time allocation 
is attempted - it gets incremented even if an allocation fails thereby 
depriving any future request that may be small enough to be satisfied from 
the array.

Fix this by first testing if allocation is going to be possible and 
incrementing alloc index only then.

Signed-off-by: Parag Warudkar <parag.warudkar@gmail.com>

--- linux-2.6/include/asm-x86/dmi.h	2007-12-07 10:04:42.000000000 -0500
+++ linux-2.6-work/include/asm-x86/dmi.h	2007-12-18 18:08:42.000000000 -0500
@@ -22,8 +22,9 @@
  static inline void *dmi_alloc(unsigned len)
  {
  	int idx = dmi_alloc_index;
-	if ((dmi_alloc_index += len) > DMI_MAX_DATA)
+	if ((dmi_alloc_index + len) > DMI_MAX_DATA)
  		return NULL;
+	dmi_alloc_index += len;
  	return dmi_alloc_data + idx;
  }

