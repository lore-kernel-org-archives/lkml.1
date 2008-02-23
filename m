Return-Path: <linux-kernel-owner+w=401wt.eu-S1764693AbYBWUqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764693AbYBWUqj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 15:46:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755334AbYBWUqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 15:46:31 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:34160 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757190AbYBWUq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 15:46:29 -0500
Date: Sat, 23 Feb 2008 12:45:38 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: =?ISO-8859-15?Q?=C9ric_Piel?= <Eric.Piel@tremplin-utc.net>
cc: len.brown@intel.com, Christoph Hellwig <hch@lst.de>, dsdt@gaugusch.at,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, trenn@suse.de
Subject: Re: [PATCH] Use userland-like functions for reading the ACPI table
In-Reply-To: <47C07536.6040404@tremplin-utc.net>
Message-ID: <alpine.LFD.1.00.0802231232280.21332@woody.linux-foundation.org>
References: <20080210071226.GA23360@lst.de> <20080210071454.GA23428@lst.de> <47AEE6D1.4070402@tremplin-utc.net> <20080212053730.GA15347@lst.de> <47BDC705.6090902@tremplin-utc.net> <47C07536.6040404@tremplin-utc.net>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 23 Feb 2008, Éric Piel wrote:
> 
> As recommended by Christoph Hellwig, even if we can't rely on the userspace
> firmware loader so early at boot, at least use normal syscall (as in
> init/do_mounts_*.c). Similarly, use kfree() instead of ACPI_FREE().

So I'm missing a lot of the background here.

I don't think "sys_open()" is in any way preferable to the alternatives, 
especially since it depends on thread-global state (the file descriptor 
table) rather than much more local state ("struct file" that you've 
opened).

I think the calls to sys_open() in init do_dounts etc are very different: 
they really are more about a real kernel-level almost-user-mode thread 
than a core driver. 

I *also* think this patch is just fundamentally broken regardless. You 
can't just cast a kernel pointer to (char __user *). The two can be in 
totally different address spaces. There's a reason why it used to do that 
whole dance with oldfs.

[ Of course, on platforms where ACPI actually runs this is not the case, 
  but that is not an excuse for doing things wrong ]

So I would NAK this patch - it looks buggy, and the reason for it is not 
sufficiently explained in the first place.

		Linus
