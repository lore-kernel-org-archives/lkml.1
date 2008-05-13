Return-Path: <linux-kernel-owner+w=401wt.eu-S1759485AbYEMK0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759485AbYEMK0R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 06:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754080AbYEMK0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 06:26:06 -0400
Received: from smtp25.orange.fr ([193.252.22.23]:61590 "EHLO smtp25.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754032AbYEMK0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 06:26:05 -0400
X-ME-UUID: 20080513102603520.7F15F1C000A9@mwinf2556.orange.fr
Message-ID: <48296C96.8060000@cosmosbay.com>
Date: Tue, 13 May 2008 12:25:26 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Gianni Tedesco <gxt@cs.nott.ac.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, arges@linux.vnet.ibm.com,
       Maynard Johnson <maynardj@us.ibm.com>,
       Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org,
       oprofile-list@lists.sourceforge.net, Mike Travis <travis@sgi.com>
Subject: Re: oprofile BUG() in current kernel.
References: <1210593756.3708.7.camel@dao.KWGR614>	 <19f34abd0805120519t12fceef9u7870006a904c85b2@mail.gmail.com>	 <1210599105.3479.1.camel@dao.KWGR614> <48285002.9080702@us.ibm.com>	 <1210610283.7218.4.camel@snuffleupagus>	 <20080513014010.e0723e01.akpm@linux-foundation.org> <1210671688.3472.10.camel@dao.KWGR614>
In-Reply-To: <1210671688.3472.10.camel@dao.KWGR614>
Content-Type: multipart/mixed;
 boundary="------------020009000304080605000107"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020009000304080605000107
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Gianni Tedesco a =E9crit :
>
>
> Nope, exact same bad paging request in kernel mode... probably the bug
> is something deep in oprofile then?
>  =20
Hum... Are you using oprofile as a module or statically included in kerne=
l ?

Current module loader only allocates percpu room by examining=20
".data.percpu" section and should be augmented to also look at=20
".data.percpu.shared_aligned"
Or, change DEFINE_PER_CPU_SHARED_ALIGNED() for modules (to use=20
".data.percpu" only)

Anyway, with the per_cpu conversion of cpu_buffer, we dont need to=20
request cache_line alignment anymore

[PATCH] oprofile: Dont request cache line alignment for cpu_buffer

Alignment was previously requested because cpu_buffer was an [NR_CPUS]=20
array, to avoid cache line sharing between CPUS.

After commit 608dfddd845da5ab6accef70154c8910529699f7 (=20
oprofile: change cpu_buffer from array to per_cpu variable ),
we dont need to force an alignement anymore since cpu_buffer sits in=20
per_cpu zone.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>



--------------020009000304080605000107
Content-Type: text/plain;
 name="oprofile.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="oprofile.patch"

diff --git a/drivers/oprofile/cpu_buffer.c b/drivers/oprofile/cpu_buffer.c
index efcbf4b..2450b3a 100644
--- a/drivers/oprofile/cpu_buffer.c
+++ b/drivers/oprofile/cpu_buffer.c
@@ -27,7 +27,7 @@
 #include "buffer_sync.h"
 #include "oprof.h"
 
-DEFINE_PER_CPU_SHARED_ALIGNED(struct oprofile_cpu_buffer, cpu_buffer);
+DEFINE_PER_CPU(struct oprofile_cpu_buffer, cpu_buffer);
 
 static void wq_sync_buffer(struct work_struct *work);
 
diff --git a/drivers/oprofile/cpu_buffer.h b/drivers/oprofile/cpu_buffer.h
index 1358817..c3e366b 100644
--- a/drivers/oprofile/cpu_buffer.h
+++ b/drivers/oprofile/cpu_buffer.h
@@ -46,7 +46,7 @@ struct oprofile_cpu_buffer {
 	unsigned long sample_invalid_eip;
 	int cpu;
 	struct delayed_work work;
-} ____cacheline_aligned;
+};
 
 DECLARE_PER_CPU(struct oprofile_cpu_buffer, cpu_buffer);
 

--------------020009000304080605000107--


