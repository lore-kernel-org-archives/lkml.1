Return-Path: <linux-kernel-owner+w=401wt.eu-S933051AbXGQRSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933051AbXGQRSu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 13:18:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753673AbXGQRSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 13:18:43 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:34911 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758312AbXGQRSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 13:18:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dG2WrgfbV/vVzuCEDc5cvBs63WvlEoPE4XIneD6e2T2egqCvrKKjapDanbZACA3WBBjworys1khgMQ+2prAGHRiSQLjmathufvXTXPhhGR4wdTDqkz6u9GkrDpMfpcE0rqmnUA0mnjvge/lLCE8i8UbG8DJlQMx0MThppWVHB2I=
Message-ID: <961aa3350707171018i58a47b7asb4a92e1bcd146adf@mail.gmail.com>
Date: Wed, 18 Jul 2007 02:18:41 +0900
From: "Akinobu Mita" <akinobu.mita@gmail.com>
To: ego@in.ibm.com
Subject: Re: [PATCH 4/10] cpu: deliver CPU_UP_CANCELED only to NOTIFY_OKed callbacks with CPU_UP_PREPARE
Cc: linux-kernel@vger.kernel.org, "Rusty Russell" <rusty@rustcorp.com.au>,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       "Dmitriy Zavin" <dmitriyz@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Andi Kleen" <andi@firstfloor.org>, "Ashok Raj" <ashok.raj@intel.com>,
       "Srivatsa Vaddagiri" <vatsa@in.ibm.com>, heiko.carstens@de.ibm.com,
       kiran@scalex86.org, clameter@sgi.com,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20070717082331.GA12231@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070716134855.GA1858@APFDCB5C> <20070716135347.GD2040@APFDCB5C>
	 <20070717082331.GA12231@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > So it is natural to deliver CPU_UP_CANCELED event only to the functions
> > that have returned NOTIFY_OK with CPU_UP_PREPARE event and not to call
> > the function that have returned NOTIFY_BAD. This is what this patch is doing.
>
> Yes, this makes sense.

Thank you for making sure of it.

>[...] However, it might break slab.
> If I am not mistaken, slab code initializes multiple objects in
> CPU_UP_PREPARE and relies on the CPU_UP_CANCELLED to destroy the
> objects which successfully got initialized before the some object's
> initialization went bad.

My testing machine is ordinary dual core non numa box. So it might not
trigger the problem that you are warried about under heavy slab alloc
failure injection.

At first glance I couln't find the problem in cpu hottplug code in slab.c yet,
but found some memory leak path. (it doesn't break slab though)

Index: 2.6-git/mm/slab.c
===================================================================
--- 2.6-git.orig/mm/slab.c
+++ 2.6-git/mm/slab.c
@@ -1221,13 +1221,18 @@ static int __cpuinit cpuup_callback(stru
 				shared = alloc_arraycache(node,
 					cachep->shared * cachep->batchcount,
 					0xbaadf00d);
-				if (!shared)
+				if (!shared) {
+					kfree(nc);
 					goto bad;
+				}
 			}
 			if (use_alien_caches) {
                                 alien = alloc_alien_cache(node, cachep->limit);
-                                if (!alien)
-                                        goto bad;
+                                if (!alien) {
+					kfree(shared);
+					kfree(nc);
+					goto bad;
+				}
                         }
 			cachep->array[cpu] = nc;
 			l3 = cachep->nodelists[node];
