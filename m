Return-Path: <linux-kernel-owner+w=401wt.eu-S1760751AbXEJL3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760751AbXEJL3S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 07:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756942AbXEJL3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 07:29:09 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:3818 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754100AbXEJL3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 07:29:07 -0400
Message-ID: <4643020C.1010307@shadowen.org>
Date: Thu, 10 May 2007 12:29:16 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-mm2 -- compat_core_sys_select() kmalloc(0)
References: <20070509012322.199f292b.akpm@linux-foundation.org>
In-Reply-To: <20070509012322.199f292b.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Seems that compat_core_sys_select() is using kmalloc(0) and SLUB is
picking up on it.  Occuring on an older x86_64 numa system.

BUG: at include/linux/slub_def.h:88 kmalloc_index()

Call Trace:
 [<ffffffff80270392>] get_slab+0x50/0x1f7
 [<ffffffff802706d0>] __kmalloc+0xf/0x6d
 [<ffffffff802a0421>] compat_core_sys_select+0x7e/0x1d8
 [<ffffffff802a061d>] compat_sys_select+0xa2/0x131
 [<ffffffff8021acb2>] ia32_sysret+0x0/0xa


This appears to occur when a 32 bit app uses select(0, ...) as a
timeout.  I think its safe as it is, in that we'll never touch the
pointers if n==0 but more eyes would help.  It might be clearer to
special case the n==0 case to avoid all this.

-apw
