Return-Path: <linux-kernel-owner+w=401wt.eu-S1754736AbYICRcJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736AbYICRcJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 13:32:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbYICRby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 13:31:54 -0400
Received: from ns1.suse.de ([195.135.220.2]:50123 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754575AbYICRbw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 13:31:52 -0400
Date: Wed, 3 Sep 2008 10:25:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
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
       alan@lxorguk.ukuu.org.uk, Matthew Wilcox <matthew@wil.cx>,
       Alex Chiang <achiang@hp.com>, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [patch 02/42] PCI: fix reference leak in pci_get_dev_by_id()
Message-ID: <20080903172518.GC7731@suse.de>
References: <20080903171927.534216229@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="pci-fix-reference-leak-in-pci_get_dev_by_id.patch"
In-Reply-To: <20080903172447.GA7731@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Greg Kroah-Hartman <gregkh@suse.de>

commit ebca4f1bce1eb7b91a63c515db66316db9391221 upstream

Alex Chiang and Matthew Wilcox pointed out that pci_get_dev_by_id() does
not properly decrement the reference on the from pointer if it is
present, like the documentation for the function states it will.

It fixes a pretty bad leak in the hotplug core (we were leaking an
entire struct pci_dev for each function of each offlined card, the first
time around; subsequent onlines/offlines were ok).

Cc: Matthew Wilcox <matthew@wil.cx>
Tested-by: Alex Chiang <achiang@hp.com>
Acked-by: Alex Chiang <achiang@hp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>

---
 drivers/pci/search.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/pci/search.c
+++ b/drivers/pci/search.c
@@ -280,6 +280,8 @@ static struct pci_dev *pci_get_dev_by_id
 			      match_pci_dev_by_id);
 	if (dev)
 		pdev = to_pci_dev(dev);
+	if (from)
+		pci_dev_put(from);
 	return pdev;
 }
 

-- 
