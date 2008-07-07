Return-Path: <linux-kernel-owner+w=401wt.eu-S1754360AbYGGL2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360AbYGGL2U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 07:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752911AbYGGL2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 07:28:05 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:44925 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653AbYGGL2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 07:28:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=GLire4vuQvvYBgZVE+kn7w0wY/Qd0+7xA7lQyqX1BwVHdJy1lLKZNhOw813LAsE9j6
         xjBeafVUTetCyoGcdf8HIEeOSRE7w80fX/r5UNvWSu4M6OnFYKtoesrDsXOZjK6R2330
         5uQc9Tuci5lXSGKEWnOpN3X28n8C0iiQkzEro=
Message-ID: <19f34abd0807070427w5398c617uae0a4e8e40fd8f0e@mail.gmail.com>
Date: Mon, 7 Jul 2008 13:27:58 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Mattias Nissler" <mattias.nissler@gmx.de>,
       "Stefano Brivio" <stefano.brivio@polimi.it>,
       "John W. Linville" <linville@tuxdriver.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Use of uninitialized memory in rate_control_pid_alloc()
Cc: "Ingo Molnar" <mingo@elte.hu>, "Pekka Enberg" <penberg@cs.helsinki.fi>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

kmemcheck found this in next-20080704:

This patch:

commit 1946b74ce03c4edecabde80d027da00a7eab56ca
Author: Mattias Nissler <mattias.nissler@gmx.de>
Date:   Thu Dec 20 13:27:26 2007 +0100

    rc80211-pid: export tuning parameters through debugfs

contained this hunk (net/mac80211/rc80211_pid_algo.c):

@@ -363,10 +375,10 @@ static void *rate_control_pid_alloc(struct ieee80211_local
        for (i = 0; i < mode->num_rates; i++) {
                rinfo[i].index = i;
                rinfo[i].rev_index = i;
-               if (RC_PID_FAST_START)
+               if (pinfo->fast_start)
                        rinfo[i].diff = 0;
                else
-                       rinfo[i].diff = i * RC_PID_NORM_OFFSET;
+                       rinfo[i].diff = i * pinfo->norm_offset;
        }
        for (i = 1; i < mode->num_rates; i++) {
                s = 0;

which is obviously wrong, since "pinfo" is allocated just above and
has never been initialized.

It seems that this is present (unfixed) in mainline as well.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
