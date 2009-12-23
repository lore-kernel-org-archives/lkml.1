Return-Path: <linux-kernel-owner+w=401wt.eu-S1754330AbZLWI3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330AbZLWI3p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 03:29:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752249AbZLWI3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 03:29:10 -0500
Received: from a.mx.secunet.com ([213.68.205.161]:47780 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752348AbZLWI3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 03:29:09 -0500
Date: Wed, 23 Dec 2009 09:01:52 +0100
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Jens Axboe <jens.axboe@oracle.com>, Andi Kleen <andi@firstfloor.org>,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       mingo@elte.hu, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, avi@redhat.com,
       johannes@sipsolutions.net, "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 0/2] Parallel crypto/IPsec v7
Message-ID: <20091223080152.GB32467@secunet.com>
References: <4B2F7DD2.2080902@linux.intel.com> <4B2F83F6.2040705@kernel.org> <4B2F9212.3000407@linux.intel.com> <4B300C01.8080904@kernel.org> <1261480220.4937.24.camel@laptop> <alpine.LFD.2.00.0912220917270.31313@localhost.localdomain> <1261504042.4937.59.camel@laptop> <4B31907C.7070408@kernel.org> <20091223065240.GA27225@gondor.apana.org.au> <20091223080000.GA32467@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091223080000.GA32467@secunet.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-OriginalArrivalTime: 23 Dec 2009 08:04:04.0821 (UTC) FILETIME=[7EC63850:01CA83A6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds the 'pcrypt' parallel crypto template. With this template it
is possible to process the crypto requests of a transform in parallel without
getting request reorder. This is in particular interesting for IPsec.

The parallel crypto template is based on the 'padata' generic
parallelization/serialization method. With this method data objects can
be processed in parallel, starting at some given point.
The parallelized data objects return after serialization in the order as
they were before the parallelization. In the case of IPsec, this makes it
possible to run the expensive parts in parallel without getting packet
reordering.

IPsec forwarding tests with two quad core machines (Intel Core 2 Quad Q6600)
and an EXFO FTB-400 packet blazer showed the following results:

On all tests I used smp_affinity to pin the interrupts of the network cards
to different cpus.

linux-2.6.33-rc1 (64 bit)
Packetsize: 1420 byte
Test time: 60 sec
Encryption: aes192-sha1
bidirectional throughput without packet loss: 2 x 325 Mbit/s
unidirectional throughput without packet loss: 325 Mbit/s

linux-2.6.33-rc1 (64 bit)
Packetsize: 128 byte
Test time: 60 sec
Encryption: aes192-sha1
bidirectional throughput without packet loss: 2 x 100 Mbit/s
unidirectional throughput without packet loss: 125 Mbit/s


linux-2.6.33-rc1 with padata/pcrypt (64 bit)
Packetsize: 1420 byte
Test time: 60 sec
Encryption: aes192-sha1
bidirectional throughput without packet loss: 2 x 650 Mbit/s
unidirectional throughput without packet loss: 850  Mbit/s

linux-2.6.33-rc1 with padata/pcrypt (64 bit)
Packetsize: 128 byte
Test time: 60 sec
Encryption: aes192-sha1
bidirectional throughput without packet loss: 2 x 100 Mbit/s
unidirectional throughput without packet loss: 125 Mbit/s


So the performance win on big packets is quite good. But on small packets
the troughput results with and without the workqueue based parallelization
are amost the same on my testing environment.

Changes from v6:

- Rework padata to use workqueues instead of softirqs for
  parallelization/serialization

- Add a cyclic sequence number pattern, makes the reset of the padata
  serialization logic on sequence number overrun superfluous.

- Adapt pcrypt to the changed padata interface.

- Rebased to linux-2.6.33-rc1

Steffen
