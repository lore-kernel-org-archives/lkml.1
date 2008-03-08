Return-Path: <linux-kernel-owner+w=401wt.eu-S1753064AbYCHJJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064AbYCHJJG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 04:09:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751219AbYCHJIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 04:08:40 -0500
Received: from mail.issp.bas.bg ([195.96.236.10]:59299 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751157AbYCHJIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 04:08:37 -0500
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: linux-kernel@vger.kernel.org
Subject: guard against buggy poll() return value
Date: Sat, 8 Mar 2008 11:10:51 +0200
User-Agent: KMail/1.9.7
Cc: Jeff Garzik <jgarzik@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803081110.52126.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Looking in net/core/dev.c I see:

WARN_ON_ONCE(work > weight);

which is a guard against buggy net drivers returning
more work from their poll method than they should.

Few lines bellow a check is done:

if (unlikely(work == weight)) 

which excludes the buggy outcome. 
Should not it be changed to:

if (unlikely(work >= weight)) 

If you find it worth, here is a patch against 2.6.24.3.

Regards.

Marin Mitov

Signed-off-by: Marin Mitov <mitov@issp.bas.bg>
-------------------------------------------
--- a/net/core/dev.c	2008-03-08 10:37:50.000000000 +0200
+++ b/net/core/dev.c	2008-03-08 10:39:09.000000000 +0200
@@ -2207,7 +2207,7 @@ static void net_rx_action(struct softirq
 		 * still "owns" the NAPI instance and therefore can
 		 * move the instance around on the list at-will.
 		 */
-		if (unlikely(work == weight)) {
+		if (unlikely(work >= weight)) {
 			if (unlikely(napi_disable_pending(n)))
 				__napi_complete(n);
 			else

