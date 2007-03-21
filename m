Return-Path: <linux-kernel-owner+w=401wt.eu-S932375AbXCUG5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932375AbXCUG5j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 02:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932356AbXCUG5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 02:57:39 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:33985 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932375AbXCUG5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 02:57:38 -0400
Message-ID: <4600D756.7070500@cosmosbay.com>
Date: Wed, 21 Mar 2007 07:57:26 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Christoph Lameter <christoph@lameter.com>,
       Andi Kleen <andi@firstfloor.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] SLAB : Use num_possible_cpus() in enable_cpucache()
References: <20070320181235.77d28864.dada1@cosmosbay.com> <Pine.LNX.4.64.0703201248530.12664@graphe.net> <20070320213218.GA13952@one.firstfloor.org> <46005B7D.3090701@cosmosbay.com> <Pine.LNX.4.64.0703201715110.17799@graphe.net> <4600D04B.6030305@cosmosbay.com>
In-Reply-To: <4600D04B.6030305@cosmosbay.com>
Content-Type: multipart/mixed;
 boundary="------------040700020805090101030502"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Wed, 21 Mar 2007 07:57:28 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040700020805090101030502
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

The existing comment in mm/slab.c is *perfect*, so I reproduce it :

         /*
          * CPU bound tasks (e.g. network routing) can exhibit cpu bound
          * allocation behaviour: Most allocs on one cpu, most free operations
          * on another cpu. For these cases, an efficient object passing between
          * cpus is necessary. This is provided by a shared array. The array
          * replaces Bonwick's magazine layer.
          * On uniprocessor, it's functionally equivalent (but less efficient)
          * to a larger limit. Thus disabled by default.
          */

As most shiped linux kernels are now compiled with CONFIG_SMP, there is no way 
a preprocessor #if can detect if the machine is UP or SMP. Better to use 
num_possible_cpus().

This means on UP we allocate a 'size=0 shared array', to be more efficient.

Another patch can later avoid the allocations of 'empty shared arrays', to 
save some memory.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>

--------------040700020805090101030502
Content-Type: text/plain;
 name="slab_use_num_possible_cpus.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="slab_use_num_possible_cpus.patch"

diff --git a/mm/slab.c b/mm/slab.c
index 57f7aa4..a69d0a5 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3975,10 +3975,8 @@ static int enable_cpucache(struct kmem_c
 	 * to a larger limit. Thus disabled by default.
 	 */
 	shared = 0;
-#ifdef CONFIG_SMP
-	if (cachep->buffer_size <= PAGE_SIZE)
+	if (cachep->buffer_size <= PAGE_SIZE && num_possible_cpus() > 1)
 		shared = 8;
-#endif
 
 #if DEBUG
 	/*

--------------040700020805090101030502--
