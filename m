Return-Path: <linux-kernel-owner+w=401wt.eu-S1754794AbZARXf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbZARXf5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 18:35:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753260AbZARXfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 18:35:48 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:28776 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057AbZARXfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 18:35:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=ccDIGdTPfb60sC1tl8+ucTHHYRIk1uEf9MOSZc+/HIGIx9DzqYEYc63MbgGRwTJbnh
         DQygLlp5jC65KwI3iohEhGXWTzAPM+L8neHxIRQyLSdzz1xm9LJzk27OB13BJTlyTK/r
         wAUZCvn54ANlpUYuGCnTTn/dSCrQcVjo/+qx0=
Message-ID: <4973BCD3.6080803@gmail.com>
Date: Mon, 19 Jan 2009 00:35:47 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: mchehab@redhat.com
CC: video4linux-list@redhat.com, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] DVB: negative internal->sub_range won't get noticed
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

internal->sub_range is unsigned, a negative won't get noticed.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/media/dvb/frontends/stb0899_algo.c b/drivers/media/dvb/frontends/stb0899_algo.c
index 83dc7e1..2ea32da 100644
--- a/drivers/media/dvb/frontends/stb0899_algo.c
+++ b/drivers/media/dvb/frontends/stb0899_algo.c
@@ -464,13 +464,14 @@ static void next_sub_range(struct stb0899_state *state)
 
 	if (internal->sub_dir > 0) {
 		old_sub_range = internal->sub_range;
-		internal->sub_range = MIN((internal->srch_range / 2) -
+		if (internal->tuner_offst + internal->sub_range / 2 >=
+				internal->srch_range / 2)
+			internal->sub_range = 0;
+		else
+			internal->sub_range = MIN((internal->srch_range / 2) -
 					  (internal->tuner_offst + internal->sub_range / 2),
 					   internal->sub_range);
 
-		if (internal->sub_range < 0)
-			internal->sub_range = 0;
-
 		internal->tuner_offst += (old_sub_range + internal->sub_range) / 2;
 	}
 

