Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198Ab0B1Xu6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 18:50:58 -0500
Received: from hera.kernel.org ([140.211.167.34]:48181 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751948Ab0B1Xup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 18:50:45 -0500
Message-ID: <4B8B0113.1020103@kernel.org>
Date: Sun, 28 Feb 2010 15:49:39 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] PCI changes for 2.6.34  - pci rom rom fail list
References: <20100226093957.7b99d09c@jbarnes-piketon> <alpine.LFD.2.00.1002281227300.3851@localhost.localdomain> <alpine.LFD.2.00.1002281246120.3637@localhost.localdomain> <33223F6C-10BD-4671-937D-6D5E4956DD3F@kernel.org> <alpine.LFD.2.00.1002281314110.3637@localhost.localdomain> <4B8AF121.2060106@kernel.org>
In-Reply-To: <4B8AF121.2060106@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

please check

[PATCH] pci: don't reassign to ROM res if it is not going to be enabled

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/setup-bus.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/pci/setup-bus.c
===================================================================
--- linux-2.6.orig/drivers/pci/setup-bus.c
+++ linux-2.6/drivers/pci/setup-bus.c
@@ -101,9 +101,17 @@ static void __assign_resources_sorted(st
 	for (list = head->next; list;) {
 		res = list->res;
 		idx = res - &list->dev->resource[0];
+
 		if (pci_assign_resource(list->dev, idx)) {
-			if (fail_head && !pci_is_root_bus(list->dev->bus))
-				add_to_failed_list(fail_head, list->dev, res);
+			if (fail_head && !pci_is_root_bus(list->dev->bus)) {
+				/*
+				 * if the failed res is for ROM BAR, and it will
+				 * be enabled later, don't add it to the list
+				 */
+				if (!((idx == PCI_ROM_RESOURCE) &&
+				      (!(res->flags & IORESOURCE_ROM_ENABLE))))
+					add_to_failed_list(fail_head, list->dev, res);
+			}
 			res->start = 0;
 			res->end = 0;
 			res->flags = 0;

