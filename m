Return-Path: <linux-kernel-owner+w=401wt.eu-S1757261AbZHGJCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261AbZHGJCo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 05:02:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757024AbZHGJCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 05:02:43 -0400
Received: from mail-pz0-f195.google.com ([209.85.222.195]:56617 "EHLO
	mail-pz0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754811AbZHGJCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 05:02:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=LoUpKd0KknWy29QzT/3iBbX9BFtofZXmBgCwYYWAuyilwueGySLjw1FIqaF0/PdPtV
         CiBY+whgYHyZdMmAEreOFqRnjP/6qxrVrh50/JimLDRji4l0QjZG7idWE9qTaNtJZtIf
         Xs2jl6ufzEd617a9d6+XmoY3Hrv79DalOqLTE=
MIME-Version: 1.0
Date: Fri, 7 Aug 2009 17:02:43 +0800
Message-ID: <2df346410908070202i6c16008ckc145559a474129c6@mail.gmail.com>
Subject: [UBI UBIFS] replace vmalloc with kmalloc
From: JiSheng Zhang <jszhang3@gmail.com>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org, rmk@arm.linux.org.uk,
       adrian.hunter@nokia.com, Artem.Bityutskiy@nokia.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If nandflash driver use DMA to support UBI and UBIFS i/o, there will
be panic like
the following. This is because UBI and UBIFS use vmalloced buffer
somewhere while
nandflash driver put the buffer under DMA and DMA support doesn't like vmalloced
memory.
[  412.369280] UBIFS: default file-system created
[  412.374879] Unable to handle kernel NULL pointer dereference at
virtual address 00000000
[  412.383177] UBIFS: background thread "ubifs_bgt0_0" started, PID 887
[  412.389656] pgd = c0004000
[  412.392419] [00000000] *pgd=00000000
[  412.396117] Internal error: Oops: 817 [#1] PREEMPT

Yes, I know kmalloc may fail when memory get fragmented, but I grep the UBI and
UBIFS's source, there are six .c files and seven .c files using
vmalloc, the function
which call vmalloc are all called during the ubi being attached and
the volume being
mounted. In embedded system, this mainly happen during kernel boot, it
should succeed.

After replacing vmalloc with kmalloc, ubi and ubifs runs fine on my
board. I can alos upload
a patch.

Comments are welcomed!

Jisheng
