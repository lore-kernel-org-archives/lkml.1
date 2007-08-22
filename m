Return-Path: <linux-kernel-owner+w=401wt.eu-S1761972AbXHVNur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761972AbXHVNur (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 09:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756918AbXHVNuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 09:50:40 -0400
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:36580 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756631AbXHVNuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 09:50:39 -0400
Date: Wed, 22 Aug 2007 09:45:33 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [PATCH] SLUB use cmpxchg_local
Message-ID: <20070822134532.GA3769@Krystal>
References: <20070821231216.GA29691@Krystal> <Pine.LNX.4.64.0708211614370.6062@schroedinger.engr.sgi.com> <20070821233938.GD29691@Krystal> <Pine.LNX.4.64.0708211640430.6225@schroedinger.engr.sgi.com> <20070821234702.GE29691@Krystal> <Pine.LNX.4.64.0708211649260.6886@schroedinger.engr.sgi.com> <20070822000323.GG29691@Krystal> <p73fy2cz7bs.fsf@bingen.suse.de> <20070822003834.GB1400@Krystal> <Pine.LNX.4.64.0708211757360.3118@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708211757360.3118@schroedinger.engr.sgi.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:36:22 up 23 days, 13:55,  4 users,  load average: 2.71, 1.61, 1.25
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Measurements on a AMD64 2.0 GHz dual-core

In this test, we seem to remove 10 cycles from the kmalloc fast path.
On small allocations, it gives a 14% performance increase. kfree fast
path also seems to have a 10 cycles improvement.

1. Kmalloc: Repeatedly allocate then free test

* cmpxchg_local slub
kmalloc(8) = 63 cycles      kfree = 126 cycles
kmalloc(16) = 66 cycles     kfree = 129 cycles
kmalloc(32) = 76 cycles     kfree = 138 cycles
kmalloc(64) = 100 cycles    kfree = 288 cycles
kmalloc(128) = 128 cycles   kfree = 309 cycles
kmalloc(256) = 170 cycles   kfree = 315 cycles
kmalloc(512) = 221 cycles   kfree = 357 cycles
kmalloc(1024) = 324 cycles  kfree = 393 cycles
kmalloc(2048) = 354 cycles  kfree = 440 cycles
kmalloc(4096) = 394 cycles  kfree = 330 cycles
kmalloc(8192) = 523 cycles  kfree = 481 cycles
kmalloc(16384) = 643 cycles kfree = 649 cycles

* Base
kmalloc(8) = 74 cycles      kfree = 113 cycles
kmalloc(16) = 76 cycles     kfree = 116 cycles
kmalloc(32) = 85 cycles     kfree = 133 cycles
kmalloc(64) = 111 cycles    kfree = 279 cycles
kmalloc(128) = 138 cycles   kfree = 294 cycles
kmalloc(256) = 181 cycles   kfree = 304 cycles
kmalloc(512) = 237 cycles   kfree = 327 cycles
kmalloc(1024) = 340 cycles  kfree = 379 cycles
kmalloc(2048) = 378 cycles  kfree = 433 cycles
kmalloc(4096) = 399 cycles  kfree = 329 cycles
kmalloc(8192) = 528 cycles  kfree = 624 cycles
kmalloc(16384) = 651 cycles kfree = 737 cycles

2. Kmalloc: alloc/free test

* cmpxchg_local slub
kmalloc(8)/kfree = 96 cycles
kmalloc(16)/kfree = 97 cycles
kmalloc(32)/kfree = 97 cycles
kmalloc(64)/kfree = 97 cycles
kmalloc(128)/kfree = 97 cycles
kmalloc(256)/kfree = 105 cycles
kmalloc(512)/kfree = 108 cycles
kmalloc(1024)/kfree = 105 cycles
kmalloc(2048)/kfree = 107 cycles
kmalloc(4096)/kfree = 390 cycles
kmalloc(8192)/kfree = 626 cycles
kmalloc(16384)/kfree = 662 cycles

* Base
kmalloc(8)/kfree = 116 cycles
kmalloc(16)/kfree = 116 cycles
kmalloc(32)/kfree = 116 cycles
kmalloc(64)/kfree = 116 cycles
kmalloc(128)/kfree = 116 cycles
kmalloc(256)/kfree = 126 cycles
kmalloc(512)/kfree = 126 cycles
kmalloc(1024)/kfree = 126 cycles
kmalloc(2048)/kfree = 126 cycles
kmalloc(4096)/kfree = 384 cycles
kmalloc(8192)/kfree = 749 cycles
kmalloc(16384)/kfree = 786 cycles

Mathieu


-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
