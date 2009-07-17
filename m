Return-Path: <linux-kernel-owner+w=401wt.eu-S1754115AbZGQUTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115AbZGQUTm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 16:19:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753545AbZGQUTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 16:19:39 -0400
Received: from kroah.org ([198.145.64.141]:43053 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753439AbZGQUTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 16:19:37 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Jul 17 13:12:28 2009
Message-Id: <20090717201227.992856604@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 17 Jul 2009 13:08:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Eugene Teo <eugeneteo@kernel.sg>, Eric Paris <eparis@redhat.com>,
       Wang Cong <amwang@redhat.com>
Subject: [patch 01/24] Add -fno-delete-null-pointer-checks to gcc CFLAGS
References: <20090717200851.907421303@mini.kroah.org>
Content-Disposition: inline; filename=add-fno-delete-null-pointer-checks-to-gcc-cflags.patch
In-Reply-To: <20090717201639.GA14209@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eugene Teo <eteo@redhat.com>

commit a3ca86aea507904148870946d599e07a340b39bf upstream.

Turning on this flag could prevent the compiler from optimising away
some "useless" checks for null pointers.  Such bugs can sometimes become
exploitable at compile time because of the -O2 optimisation.

See http://gcc.gnu.org/onlinedocs/gcc-4.1.2/gcc/Optimize-Options.html

An example that clearly shows this 'problem' is commit 6bf67672.

 static void __devexit agnx_pci_remove(struct pci_dev *pdev)
 {
     struct ieee80211_hw *dev = pci_get_drvdata(pdev);
-    struct agnx_priv *priv = dev->priv;
+    struct agnx_priv *priv;
     AGNX_TRACE;

     if (!dev)
         return;
+    priv = dev->priv;

By reverting this patch, and compile it with and without
-fno-delete-null-pointer-checks flag, we can see that the check for dev
is compiled away.

    call    printk  #
-   testq   %r12, %r12  # dev
-   je  .L94    #,
    movq    %r12, %rdi  # dev,

Clearly the 'fix' is to stop using dev before it is tested, but building
with -fno-delete-null-pointer-checks flag at least makes it harder to
abuse.

Signed-off-by: Eugene Teo <eugeneteo@kernel.sg>
Acked-by: Eric Paris <eparis@redhat.com>
Acked-by: Wang Cong <amwang@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 Makefile |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/Makefile
+++ b/Makefile
@@ -351,7 +351,8 @@ KBUILD_CPPFLAGS := -D__KERNEL__
 
 KBUILD_CFLAGS   := -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs \
 		   -fno-strict-aliasing -fno-common \
-		   -Werror-implicit-function-declaration
+		   -Werror-implicit-function-declaration \
+		   -fno-delete-null-pointer-checks
 KBUILD_AFLAGS   := -D__ASSEMBLY__
 
 # Read KERNELRELEASE from include/config/kernel.release (if it exists)


