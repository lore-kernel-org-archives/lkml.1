Return-Path: <linux-kernel-owner+w=401wt.eu-S1755353AbZFMFU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353AbZFMFU0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 01:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752382AbZFMFUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 01:20:18 -0400
Received: from ozlabs.org ([203.10.76.45]:35218 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751741AbZFMFUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 01:20:17 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tony Luck <tony.luck@intel.com>
Subject: Re: [PULL] module and parameter
Date: Sat, 13 Jun 2009 14:50:15 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Amerigo Wang <amwang@redhat.com>,
       alex@shark-linux.de, David Miller <davem@davemloft.net>,
       rth@twiddle.net, sfr@canb.auug.org.au
References: <200906122205.57362.rusty@rustcorp.com.au> <12c511ca0906121405x5ccd0a60k4b804266a87a7896@mail.gmail.com>
In-Reply-To: <12c511ca0906121405x5ccd0a60k4b804266a87a7896@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906131450.16211.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Jun 2009 06:35:46 am Tony Luck wrote:
> On Fri, Jun 12, 2009 at 5:35 AM, Rusty Russell<rusty@rustcorp.com.au> wrote:
> > The following changes since commit
> > 8ebf975608aaebd7feb33d77f07ba21a6380e086: Randy Dunlap (1):
>
> ...
>
> >      module: trim exception table on init free.
>
> This is causing build errors for ia64:
>
> arch/ia64/mm/extable.c: In function 'ex_to_addr':
> arch/ia64/mm/extable.c:58: error: 'const struct exception_table_entry'
> has no member named 'insn'
> arch/ia64/mm/extable.c:58: error: 'const struct exception_table_entry'
> has no member named 'insn'

Sorry, very sloppy of me.  Does this repair it?

> I note that this commit has been reverted in linux-next.  What's going on?

Hmm, older version broke sparc, but Stephen patched that one...

Rusty.

Subject: fix compile error in arch/ia64/mm/extable.c

ad6561dffa17f17bb68d7207d422c26c381c4313 ("module: trim exception table on init
free.") put a bogus trim_init_extable() function into ia64 which didn't compile.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/arch/ia64/mm/extable.c b/arch/ia64/mm/extable.c
--- a/arch/ia64/mm/extable.c
+++ b/arch/ia64/mm/extable.c
@@ -8,7 +8,7 @@
 #include <linux/sort.h>
 
 #include <asm/uaccess.h>
-#include <asm/module.h>
+#include <linux/module.h>
 
 static int cmp_ex(const void *a, const void *b)
 {
@@ -55,7 +55,7 @@ void sort_extable (struct exception_tabl
 
 static inline unsigned long ex_to_addr(const struct exception_table_entry *x)
 {
-	return (unsigned long)&x->insn + x->insn;
+	return (unsigned long)&x->addr + x->addr;
 }
 
 #ifdef CONFIG_MODULES

