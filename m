Return-Path: <linux-kernel-owner+w=401wt.eu-S1758559AbZAaCtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758559AbZAaCtk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 21:49:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753538AbZAaCql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 21:46:41 -0500
Received: from kroah.org ([198.145.64.141]:54779 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753231AbZAaCqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 21:46:40 -0500
Date: Fri, 30 Jan 2009 18:39:57 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
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
       alan@lxorguk.ukuu.org.uk, Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Richard Henderson <rth@twiddle.net>,
       Tobias Klausmann <klausman@schwarzvogel.de>
Subject: [patch 08/32] alpha: nautilus - fix compile failure with gcc-4.3
Message-ID: <20090131023957.GI12147@kroah.com>
References: <20090131023411.032399235@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="alpha-nautilus-fix-compile-failure-with-gcc-4.3.patch"
In-Reply-To: <20090131023906.GA12147@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>

commit 70b66cbfd3316b792a855cb9a2574e85f1a63d0f upstream.

init_srm_irq() deals with irq's #16 and above, but size of irq_desc
array on nautilus and some other system types is 16. So gcc-4.3
complains that "array subscript is above array bounds", even though
this function is never called on those systems.

This adds a check for NR_IRQS <= 16, which effectively optimizes
init_srm_irq() code away on problematic platforms.

Thanks to Daniel Drake <dsd@gentoo.org> for detailed analysis
of the problem.

Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Richard Henderson <rth@twiddle.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tobias Klausmann <klausman@schwarzvogel.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/alpha/kernel/irq_srm.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/alpha/kernel/irq_srm.c
+++ b/arch/alpha/kernel/irq_srm.c
@@ -63,6 +63,8 @@ init_srm_irqs(long max, unsigned long ig
 {
 	long i;
 
+	if (NR_IRQS <= 16)
+		return;
 	for (i = 16; i < max; ++i) {
 		if (i < 64 && ((ignore_mask >> i) & 1))
 			continue;

