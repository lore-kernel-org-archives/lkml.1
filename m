Return-Path: <linux-kernel-owner+w=401wt.eu-S1761329AbZAaDN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761329AbZAaDN0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 22:13:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757516AbZAaCry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 21:47:54 -0500
Received: from kroah.org ([198.145.64.141]:55666 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752767AbZAaCrq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 21:47:46 -0500
Date: Fri, 30 Jan 2009 18:44:55 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, greg@kroah.com
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Suresh Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Daniel.Beschorner@facton.com,
       pageexec@freemail.hu
Subject: [patch 39/43] x86, pat: fix PTE corruption issue while mapping RAM
	using /dev/mem
Message-ID: <20090131024455.GN12368@kroah.com>
References: <20090131022548.656772939@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-pat-fix-pte-corruption-issue-while-mapping-ram-using-dev-mem.patch"
In-Reply-To: <20090131024158.GA12368@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Suresh Siddha <suresh.b.siddha@intel.com>

commit 9597134218300c045cf219be3664615e97cb239c upstream.

Beschorner Daniel reported:
> hwinfo problem since 2.6.28, showing this in the oops:
>   Corrupted page table at address 7fd04de3ec00

Also, PaX Team reported a regression with this commit:

>   commit 9542ada803198e6eba29d3289abb39ea82047b92
>   Author: Suresh Siddha <suresh.b.siddha@intel.com>
>   Date:   Wed Sep 24 08:53:33 2008 -0700
>
>       x86: track memtype for RAM in page struct

This commit breaks mapping any RAM page through /dev/mem, as the
reserve_memtype() was not initializing the return attribute type and as such
corrupting the PTE entry that was setup with the return attribute type.

Because of this bug, application mapping this RAM page through /dev/mem
will die with "Corrupted page table at address xxxx" message in the kernel
log and also the kernel identity mapping which maps the underlying RAM
page gets converted to UC.

Fix this by initializing the return attribute type before calling
reserve_ram_pages_type()

Reported-by: PaX Team <pageexec@freemail.hu>
Reported-and-tested-by: Beschorner Daniel <Daniel.Beschorner@facton.com>
Tested-and-Acked-by: PaX Team <pageexec@freemail.hu>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/mm/pat.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -333,6 +333,9 @@ int reserve_memtype(u64 start, u64 end, 
 					      req_type & _PAGE_CACHE_MASK);
 	}
 
+	if (new_type)
+		*new_type = actual_type
+
 	/*
 	 * For legacy reasons, some parts of the physical address range in the
 	 * legacy 1MB region is treated as non-RAM (even when listed as RAM in
@@ -356,9 +359,6 @@ int reserve_memtype(u64 start, u64 end, 
 	new->end	= end;
 	new->type	= actual_type;
 
-	if (new_type)
-		*new_type = actual_type;
-
 	spin_lock(&memtype_lock);
 
 	if (cached_entry && start >= cached_start)

