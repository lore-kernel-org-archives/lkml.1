Return-Path: <linux-kernel-owner+w=401wt.eu-S1757870AbYJXEsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757870AbYJXEsV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 00:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753186AbYJXEjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 00:39:41 -0400
Received: from kroah.org ([198.145.64.141]:51977 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751735AbYJXEjf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 00:39:35 -0400
Date: Thu, 23 Oct 2008 21:35:27 -0700
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
       alan@lxorguk.ukuu.org.uk,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [patch 26/27] PCI hotplug: cpqphp: fix kernel NULL pointer
	dereference
Message-ID: <20081024043527.GA30828@kroah.com>
References: <20081024042023.054190751@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="pci-hotplug-cpqphp-fix-kernel-null-pointer-dereference.patch"
In-Reply-To: <20081024043303.GA30828@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us 
know.

------------------
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

commit d2174c3c07adad88dd9ba37a731e0b00b746822a upstream

The following patch fixes the regression in 2.6.27 that causes kernel
NULL pointer dereference at cpqphp driver probe time.  This patch should
be backported to the .27 stable series.

Seems to have been introduced by
f46753c5e354b857b20ab8e0fe7b2579831dc369.

The root cause of this problem seems that cpqphp driver calls
pci_hp_register() wrongly. In current implementation, cpqphp driver
passes 'ctrl->pci_dev->subordinate' as a second parameter for
pci_hp_register(). But because hotplug slots and it's hotplug controller
(exists as a pci funcion) are on the same bus, it should be
'ctrl->pci_dev->bus' instead.

Tested-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/hotplug/cpqphp_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pci/hotplug/cpqphp_core.c
+++ b/drivers/pci/hotplug/cpqphp_core.c
@@ -435,7 +435,7 @@ static int ctrl_slot_setup(struct contro
 				slot->number, ctrl->slot_device_offset,
 				slot_number);
 		result = pci_hp_register(hotplug_slot,
-					 ctrl->pci_dev->subordinate,
+					 ctrl->pci_dev->bus,
 					 slot->device);
 		if (result) {
 			err("pci_hp_register failed with error %d\n", result);

-- 
