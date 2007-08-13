Return-Path: <linux-kernel-owner+w=401wt.eu-S945602AbXHMVQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S945602AbXHMVQY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 17:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759743AbXHMVPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 17:15:18 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:43292 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764361AbXHMVPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 17:15:14 -0400
Date: Mon, 13 Aug 2007 14:15:12 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 00/23] Atomic operations updates: add cmpxchg_local
In-Reply-To: <20070812145434.520271946@polymtl.ca>
Message-ID: <Pine.LNX.4.64.0708131409590.28026@schroedinger.engr.sgi.com>
References: <20070812145434.520271946@polymtl.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Aug 2007, Mathieu Desnoyers wrote:

> I have been asked for a cmpxchg_local implementation by Christoph Lameter so he
> can use it to accelerate the slub allocator.

Hmmm... I have run my own and tested a variety of approaches on cmpxchg a 
couple of weeks ago on an Athlong64. There was no significant performance 
gain (even on a test to just allocate from the same slab cache) and there 
were actual losses in the free path since the logic got a bit complex.

The main performance issue are still the cacheline that are 
touched and cmpxchg will not change that.

The exact code that was used to run these tests can be found in the 
Performance Counter Patchset that I posted 2 weeks ago.

cmpxchg_local

SLUB Performance testing
========================
1. Kmalloc: Repeatedly allocate then free test
10000 times kmalloc(8) = 2.3ms kfree() = 1.1ms
10000 times kmalloc(16) = 2.4ms kfree() = 1.2ms
10000 times kmalloc(32) = 2.4ms kfree() = 1.2ms
10000 times kmalloc(64) = 2.6ms kfree() = 1.4ms
10000 times kmalloc(128) = 2.8ms kfree() = 1.9ms
10000 times kmalloc(256) = 3ms kfree() = 2ms
10000 times kmalloc(512) = 3.4ms kfree() = 2.1ms
10000 times kmalloc(1024) = 3.9ms kfree() = 2.4ms
10000 times kmalloc(2048) = 4.1ms kfree() = 2.6ms
10000 times kmalloc(4096) = 4.8ms kfree() = 3.5ms
2. Kmalloc: alloc/free test
10000 times kmalloc(8)/kfree = 3ms
10000 times kmalloc(16)/kfree = 3.1ms
10000 times kmalloc(32)/kfree = 3.1ms
10000 times kmalloc(64)/kfree = 3.1ms
10000 times kmalloc(128)/kfree = 3.2ms
10000 times kmalloc(256)/kfree = 3.3ms
10000 times kmalloc(512)/kfree = 3.3ms
10000 times kmalloc(1024)/kfree = 3.4ms
10000 times kmalloc(2048)/kfree = 3.4ms
10000 times kmalloc(4096)/kfree = 3.5ms

base line

1. Repeatedly allocate then free test
10000 times kmalloc(8) = 2.4ms kfree() = 1.1ms
10000 times kmalloc(16) = 2.5ms kfree() = 1.1ms
10000 times kmalloc(32) = 2.5ms kfree() = 1.1ms
10000 times kmalloc(64) = 2.7ms kfree() = 1.4ms
10000 times kmalloc(128) = 2.9ms kfree() = 1.9ms
10000 times kmalloc(256) = 3.1ms kfree() = 2ms
10000 times kmalloc(512) = 3.4ms kfree() = 2.1ms
10000 times kmalloc(1024) = 3.9ms kfree() = 2.4ms
10000 times kmalloc(2048) = 4.2ms kfree() = 2.5ms
10000 times kmalloc(4096) = 4.9ms kfree() = 3.2ms
2. Alloc/Free test
10000 times kmalloc(8)/kfree = 3ms
10000 times kmalloc(16)/kfree = 3.1ms
10000 times kmalloc(32)/kfree = 3.1ms
10000 times kmalloc(64)/kfree = 3.1ms
10000 times kmalloc(128)/kfree = 3.2ms
10000 times kmalloc(256)/kfree = 3.2ms
10000 times kmalloc(512)/kfree = 3.2ms
10000 times kmalloc(1024)/kfree = 3.3ms
10000 times kmalloc(2048)/kfree = 3.3ms
10000 times kmalloc(4096)/kfree = 3.3ms

