Return-Path: <linux-kernel-owner+w=401wt.eu-S1752322AbZK1Pkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322AbZK1Pkq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 10:40:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751801AbZK1Pkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 10:40:45 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:44142 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbZK1Pko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 10:40:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=IqUktbWpYRwUfOh/EJnRTNrLf5JugfvgM+/egdcGZMcbNV7kzVViYsiJCbvh07JNrY
         4d01oDMZnDPX3GubcXqazXVqYDguC61YV2LiYMjmHpoo75o9MNwXyKAE55SjhEBlVp1Y
         sFkfH/nts4TAiqvF4w7jxtd4/1rhQngiDxFWM=
MIME-Version: 1.0
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sat, 28 Nov 2009 10:40:30 -0500
Message-ID: <8bd0f97a0911280740p24ad49bal64b924a427abfa39@mail.gmail.com>
Subject: avoiding duplicate icache flushing of shared maps on nommu
To: David Howells <dhowells@redhat.com>, Paul Mundt <lethal@linux-sh.org>,
       Bernd Schmidt <bernds_cb1@t-online.de>,
       Jie Zhang <jie.zhang@analog.com>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       uclinux-dist-devel <uclinux-dist-devel@blackfin.uclinux.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

when working with FDPIC, there are many shared maps of read only text
regions (the C library, applet packages like busybox, ...) between
applications.  but the current mm/nommu.c:do_mmap_pgoff() function
will issue an icache flush whenever a vma is added to a mm instead of
only doing it when the map is initially created.  am i missing
something obvious here, or would a change like below be OK ?  this
easily cuts the number of icache flushes during boot by 50% if not
more.

(yes, this now does the icache flush while holding the
nommu_region_sem, but i'm interested if the _idea_ is OK)

--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1409,14 +1409,14 @@ unsigned long do_mmap_pgoff(struct file *file,

    current->mm->total_vm += len >> PAGE_SHIFT;

+   if (prot & PROT_EXEC)
+       flush_icache_range(result, result + len);
+
 share:
    add_vma_to_mm(current->mm, vma);

    up_write(&nommu_region_sem);

-   if (prot & PROT_EXEC)
-       flush_icache_range(result, result + len);
-
    kleave(" = %lx", result);
    return result;

-mike
