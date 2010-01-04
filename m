Return-Path: <linux-kernel-owner+w=401wt.eu-S1753481Ab0ADPnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481Ab0ADPnu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 10:43:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753371Ab0ADPns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 10:43:48 -0500
Received: from mtagate7.de.ibm.com ([195.212.17.167]:42570 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286Ab0ADPnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 10:43:47 -0500
Date: Mon, 4 Jan 2010 16:43:45 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: strict copy_from_user checks issues?
Message-ID: <20100104154345.GA5671@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arjan,

I was just about to port the strict copy_from_user checks to s390, but
I have some issues with it:

Is there a reason why there isn't a generic infrastructure that simply
can be 'selected' by each architecure? I guess there isn't ;)

x86_32 and x86_64 have different copy_from_user wrappers where only the
32 bit version will generate compile warnings. Is that intentional or was
the 64 bit version just forgotten when updating?

x86 and sparc return -EFAULT in copy_from_user instead of the number of
not copied bytes as it should in case of a detected buffer overflow.
That might have unwanted side effects. I would guess that is a bug.

Warnings cannot be switched off anymore as it was the case in your first
version. However gcc seems to report quite a few false positives so
it would be good if it could be turned off again.

E.g. this one with gcc 4.4.0:

In file included from /home2/heicarst/linux-2.6/arch/s390/include/asm/mmu_context.h:13,
                 from /home2/heicarst/linux-2.6/arch/s390/include/asm/elf.h:133,
                 from include/linux/elf.h:7,
                 from include/linux/module.h:14,
                 from kernel/kprobes.c:39:
In function 'copy_from_user',
    inlined from 'write_enabled_file_bool' at kernel/kprobes.c:1527:
/home2/heicarst/linux-2.6/arch/s390/include/asm/uaccess.h:295: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct

Even though I'm wondering why the reported function isn't simply using
get_user(). But that is a different story.

Instead of going the easy way and implementing the 3rd arch specific version
I also could address all of these issues :)
