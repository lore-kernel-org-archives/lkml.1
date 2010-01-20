Return-Path: <linux-kernel-owner+w=401wt.eu-S1752682Ab0ATW62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682Ab0ATW62 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 17:58:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191Ab0ATW61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 17:58:27 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46575 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752074Ab0ATW60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 17:58:26 -0500
Subject: Re: issues with kmemleak backport
From: Catalin Marinas <catalin.marinas@arm.com>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Linux kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4B574297.7070504@nortel.com>
References: <4B55F3EF.9020408@nortel.com> <4B561D8D.1000003@nortel.com>
	 <4B574297.7070504@nortel.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Wed, 20 Jan 2010 22:58:19 +0000
Message-Id: <1264028299.5185.20.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Jan 2010 22:58:19.0620 (UTC) FILETIME=[0F17D240:01CA9A24]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

First of all, apart from backporting the kmemleak patches I would
suggest you do a kernel grep for kmemleak_* function calls as there may
be explicit cases where allocated memory blocks are ignored from
scanning (like the AGP aperture which is unmapped from the standard
kernel linear mapping).

On Wed, 2010-01-20 at 17:51 +0000, Chris Friesen wrote:
> root@10:/root> BUG: unable to handle kernel paging request at 8152a79c
> IP: [<c048ad52>] scan_block+0xd2/0x120
[...]
> The code is failing at the "pointer = *ptr;" line in scan_block().

This happens when kmemleak was told about a memory block being allocated
but there isn't any valid virtual address for that location.

I can't really tell where it came from but I would suggest that you
disable the kmemleak automatic scanning and do an "echo dump=0x815sa79c
> /sys/kernel/debug/kmemleak" and you should get the information that
kmemleak has about that location.

Alternatively, until you get this to work, just modify kmemleak to dump
information it has about every object it scans via dump_object_info()
called from scan_object(). The amount of information is quite large but
at least you should see the last block that it fails to scan and maybe
add a kmemleak_ignore() on the block allocation site.

-- 
Catalin

