Return-Path: <linux-kernel-owner+w=401wt.eu-S1759279AbZAaDOH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759279AbZAaDOH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 22:14:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757534AbZAaCrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 21:47:55 -0500
Received: from kroah.org ([198.145.64.141]:55694 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756193AbZAaCrs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 21:47:48 -0500
Date: Fri, 30 Jan 2009 18:44:59 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
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
       alan@lxorguk.ukuu.org.uk, Dan Williams <dan.j.williams@intel.com>,
       wd@denx.de, Yuri Tikhonov <yur@emcraft.com>
Subject: [patch 41/43] dmaengine: fix dependency chaining
Message-ID: <20090131024459.GP12368@kroah.com>
References: <20090131022548.656772939@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="dmaengine-fix-dependency-chaining.patch"
In-Reply-To: <20090131024158.GA12368@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Yuri Tikhonov <yur@emcraft.com>

commit dd59b8537f6cb53ab863fafad86a5828f1e889a2 upstream


 ASYNC_TX: fix dependency chaining

 In ASYNC_TX we track the dependencies between the descriptors
using the 'next' pointers of the structures. These pointers are
set to NULL as soon as the corresponding descriptor has been
submitted to the channel (in async_tx_run_dependencies()).
 But, the first 'next' in chain still remains set, regardless
the fact, that tx->next is already submitted. This may lead to
multiple submisions of the same descriptor. This patch fixes this.

Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 crypto/async_tx/async_tx.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/crypto/async_tx/async_tx.c
+++ b/crypto/async_tx/async_tx.c
@@ -124,6 +124,8 @@ void async_tx_run_dependencies(struct dm
 	if (!dep)
 		return;
 
+	/* we'll submit tx->next now, so clear the link */
+	tx->next = NULL;
 	chan = dep->chan;
 
 	/* keep submitting up until a channel switch is detected

