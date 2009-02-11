Return-Path: <linux-kernel-owner+w=401wt.eu-S1756163AbZBKMz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163AbZBKMz2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 07:55:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754663AbZBKMzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 07:55:18 -0500
Received: from mx2.redhat.com ([66.187.237.31]:51385 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753467AbZBKMzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 07:55:17 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090211212208.C3C6.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20090211212208.C3C6.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20090210142443.629E.KOSAKI.MOTOHIRO@jp.fujitsu.com> <19f34abd0902092310g513fb776s2e4d37285c8fa7be@mail.gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: dhowells@redhat.com, Vegard Nossum <vegard.nossum@gmail.com>,
       Serge Hallyn <serue@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Eric Sesterhenn <snakebyte@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>, containers@lists.osdl.org
Subject: Re: [CRED bug?] 2.6.29-rc3 don't survive on stress workload
Date: Wed, 11 Feb 2009 12:54:06 +0000
Message-ID: <27972.1234356846@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> f6  : 1003e6b6b6b6b6b6b6b6b f7  : 0ffe6af8e85a500000000

I'd guess you now have CONFIG_DEBUG_SLAB turned on.  That looks like slab
poisoning in register f6.

> r17 : 00000000dead4ead r18 : a000000100cd2274 r19 : a000000100d6b6c0

And that looks like SPINLOCK_MAGIC in r17, so I'd guess something just
successfully validated a spinlock, possibly atomic_dec_and_lock() in
free_uid().

This may mean that the user_struct being released is valid, but the
user_namespace it refers to is already released.

David
