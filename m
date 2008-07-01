Return-Path: <linux-kernel-owner+w=401wt.eu-S1753371AbYGAC6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbYGAC6b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 22:58:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752639AbYGAC5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 22:57:13 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:52176 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514AbYGAC5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 22:57:07 -0400
Subject: [PATCH 7/7] Fix the case of jiffies wrapping in mm/pdflush.c
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, hirofumi@mail.parknet.co.jp
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Tue, 01 Jul 2008 11:57:04 +0900
Message-ID: <a553a85a3e848699d00711608.ps@mail.parknet.co.jp>
References: <9edbdefc3e848699cfe111608.ps@mail.parknet.co.jp>
	<129170883e848699cff211608.ps@mail.parknet.co.jp>
	<d3ce91fd3e848699cff311608.ps@mail.parknet.co.jp>
	<5be8ad613e848699cff411608.ps@mail.parknet.co.jp>
	<555b858b3e848699cff511608.ps@mail.parknet.co.jp>
	<670df4283e848699cff611608.ps@mail.parknet.co.jp>
In-Reply-To: <670df4283e848699cff611608.ps@mail.parknet.co.jp>
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 mm/pdflush.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/pdflush.c~pdfluh-jiffies-check-fix mm/pdflush.c
--- linux-2.6/mm/pdflush.c~pdfluh-jiffies-check-fix	2008-07-01 10:19:07.000000000 +0900
+++ linux-2.6-hirofumi/mm/pdflush.c	2008-07-01 10:19:07.000000000 +0900
@@ -130,7 +130,7 @@ static int __pdflush(struct pdflush_work
 		 * Thread creation: For how long have there been zero
 		 * available threads?
 		 */
-		if (jiffies - last_empty_jifs > 1 * HZ) {
+		if (time_after(jiffies, last_empty_jifs + 1 * HZ)) {
 			/* unlocked list_empty() test is OK here */
 			if (list_empty(&pdflush_list)) {
 				/* unlocked test is OK here */
@@ -151,7 +151,7 @@ static int __pdflush(struct pdflush_work
 		if (nr_pdflush_threads <= MIN_PDFLUSH_THREADS)
 			continue;
 		pdf = list_entry(pdflush_list.prev, struct pdflush_work, list);
-		if (jiffies - pdf->when_i_went_to_sleep > 1 * HZ) {
+		if (time_after(jiffies, pdf->when_i_went_to_sleep + 1 * HZ)) {
 			/* Limit exit rate */
 			pdf->when_i_went_to_sleep = jiffies;
 			break;					/* exeunt */
_
