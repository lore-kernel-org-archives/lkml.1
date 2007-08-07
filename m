Return-Path: <linux-kernel-owner+w=401wt.eu-S935569AbXHGUxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935569AbXHGUxS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 16:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935101AbXHGUs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:48:29 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56078 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935245AbXHGUs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:48:27 -0400
Date: Tue, 7 Aug 2007 13:44:10 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@stusta.de,
       Alexander Shmelev <ashmelev@task.sun.mcst.ru>,
       "David S. Miller" <davem@davemloft.net>
Subject: [2.6.22.2 review 17/84] Fix sparc32 memset()
Message-ID: <20070807204410.GR23028@kroah.com>
References: <20070807204034.882009319@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-sparc32-memset.patch"
In-Reply-To: <20070807204157.GA23028@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Shmelev <ashmelev@task.sun.mcst.ru>

[SPARC32]: Fix bug in sparc optimized memset.

Sparc optimized memset (arch/sparc/lib/memset.S) does not fill last
byte of the memory area, if area size is less than 8 bytes and start
address is not word (4-bytes) aligned.

Here is code chunk where bug located:
/* %o0 - memory address, %o1 - size, %g3 - value */
8:
     add    %o0, 1, %o0
    subcc    %o1, 1, %o1
    bne,a    8b
     stb %g3, [%o0 - 1]

This code should write byte every loop iteration, but last time delay
instruction stb is not executed because branch instruction sets
"annul" bit.

Patch replaces bne,a by bne instruction.

Error can be reproduced by simple kernel module:

--------------------
#include <linux/module.h>
#include <linux/config.h>
#include <linux/kernel.h>
#include <linux/errno.h>
#include <string.h>

static void do_memset(void **p, int size)
{
        memset(p, 0x00, size);
}

static int __init memset_test_init(void)
{
    char fooc[8];
    int *fooi;
    memset(fooc, 0xba, sizeof(fooc));

    do_memset((void**)(fooc + 3), 1);

    fooi = (int*) fooc;
    printk("%08X %08X\n", fooi[0], fooi[1]);

    return -1;
}

static void __exit memset_test_cleanup(void)
{
    return;
}

module_init(memset_test_init);
module_exit(memset_test_cleanup);

MODULE_LICENSE("GPL");
EXPORT_NO_SYMBOLS;
------------------------

Signed-off-by: Alexander Shmelev <ashmelev@task.sun.mcst.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sparc/lib/memset.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/sparc/lib/memset.S
+++ b/arch/sparc/lib/memset.S
@@ -162,7 +162,7 @@ __bzero:
 8:
 	 add	%o0, 1, %o0
 	subcc	%o1, 1, %o1
-	bne,a	8b
+	bne	8b
 	 EX(stb	%g3, [%o0 - 1], add %o1, 1)
 0:
 	retl

-- 
