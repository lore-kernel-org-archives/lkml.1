Return-Path: <linux-kernel-owner+w=401wt.eu-S1753963AbZCBUlI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963AbZCBUlI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 15:41:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751915AbZCBUkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 15:40:55 -0500
Received: from madara.hpl.hp.com ([192.6.19.124]:54305 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751474AbZCBUkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 15:40:55 -0500
Message-Id: <200903022040.n22KeX20030383@pobox-pa.hpl.hp.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: Jeffrey Mogul <Jeff.Mogul@hp.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org
In-reply-to: Your message of "Sat, 28 Feb 2009 14:36:00 +0300."
             <20090228113559.GA3449@x200.localdomain> 
From: Jeffrey Mogul <Jeff.Mogul@hp.com>
X-Organization: Hewlett-Packard Labs, Large Scale Systems group
Date: Mon, 02 Mar 2009 12:40:33 -0800
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: jeff.mogul@hp.com
Subject: Re: [PATCH] proc: /proc/kpageflags: incorrect arg order in kpf_copy_bits()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


    On Fri, Feb 27, 2009 at 05:56:39PM -0800, Jeffrey Mogul wrote:
    > The code in fs/proc/page.c that implements /proc/kpageflags has
    
    Already fixed in mainline:
    
    commit e07a4b9217d1e97d2f3a62b6b070efdc61212110
    Author: Helge Bahmann <helge.bahmann@secunet.com>
    Date:   Fri Feb 20 16:24:12 2009 +0300
    
        proc: fix PG_locked reporting in /proc/kpageflags
        
        Expr always evaluates to zero.
        
Unfortunately, I think that only fixes one of the two bugs
I reported.  The other one is that the argument order for the
kpf_copy_bits macro definition does not match the arg order
for all of the uses (including the one that was already "fixed").

Thanks
-Jeff

The kpf_copy_bits() macro was defined with argument order
(flags, srcpos, dstpos), which is the logical order, but all
but one of the uses of this macro invoke it instead in the order
(flags, dstpos, srcpos).  This only affects the output for a few
flags, since in most -- but not all! -- cases, srcpos == dstpos.

I fixed this by changing the macro definition rather than the macro
uses, which minimizes the number of lines to change but which might
not be the most obvious/logical design.

These bugs appear to have been in the code since /proc/kpageflags
was introduced (2.6.25).

CC: stable@kernel.org
Signed-off-by: Jeff Mogul <Jeff.Mogul@hp.com>
---

--- linux-2.6.28.7/fs/proc/page.c.orig  2009-02-26 17:16:42.000000000 -0800
+++ linux-2.6.28.7/fs/proc/page.c       2009-02-26 17:18:04.000000000 -0800
@@ -80,7 +80,8 @@ static const struct file_operations proc
 #define KPF_RECLAIM    9
 #define KPF_BUDDY     10
 
-#define kpf_copy_bit(flags, srcpos, dstpos) (((flags >> srcpos) & 1) << dstpos)
+/* Arg order is dstpos,srcpos because that's how this macro is used below */
+#define kpf_copy_bit(flags, dstpos, srcpos) (((flags >> srcpos) & 1) << dstpos)
 
