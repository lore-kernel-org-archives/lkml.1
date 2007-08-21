Return-Path: <linux-kernel-owner+w=401wt.eu-S1761476AbXHUGzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761476AbXHUGzp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 02:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760601AbXHUGx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 02:53:28 -0400
Received: from canuck.infradead.org ([209.217.80.40]:44207 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760592AbXHUGx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 02:53:27 -0400
Date: Mon, 20 Aug 2007 23:55:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 10/20] AVR32: Fix atomic_add_unless() and
	atomic_sub_unless()
Message-ID: <20070821065512.GK5275@kroah.com>
References: <20070821064251.972690753@blue.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="avr32-fix-atomic_add_unless-and-atomic_sub_unless.patch"
In-Reply-To: <20070821065210.GA5275@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Haavard Skinnemoen <hskinnemoen@atmel.com>

These functions depend on "result" being initalized to 0, but "result"
is not included as an input constraint to the inline assembly block
following its initialization, only as an output constraint. Thus gcc
thinks it doesn't need to initialize it, so result ends up undefined
if the "unless" condition is true.

This fixes an oops in sunrpc where the faulty atomics caused
rpciod_up() to not start the workqueue as it should.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/asm-avr32/atomic.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/asm-avr32/atomic.h
+++ b/include/asm-avr32/atomic.h
@@ -101,7 +101,7 @@ static inline int atomic_sub_unless(atom
 		"	mov	%1, 1\n"
 		"1:"
 		: "=&r"(tmp), "=&r"(result), "=o"(v->counter)
-		: "m"(v->counter), "rKs21"(a), "rKs21"(u)
+		: "m"(v->counter), "rKs21"(a), "rKs21"(u), "1"(result)
 		: "cc", "memory");
 
 	return result;
@@ -137,7 +137,7 @@ static inline int atomic_add_unless(atom
 			"	mov	%1, 1\n"
 			"1:"
 			: "=&r"(tmp), "=&r"(result), "=o"(v->counter)
-			: "m"(v->counter), "r"(a), "ir"(u)
+			: "m"(v->counter), "r"(a), "ir"(u), "1"(result)
 			: "cc", "memory");
 	}
 

-- 
