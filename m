Return-Path: <linux-kernel-owner+w=401wt.eu-S1755916AbYEGLhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916AbYEGLhs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 07:37:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752602AbYEGLhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 07:37:35 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:56278 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbYEGLhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 07:37:34 -0400
Message-Id: <20080507113553.395937000@bull.net>
User-Agent: quilt/0.45-1
Date: Wed, 07 May 2008 13:35:53 +0200
From: Nadia.Derbey@bull.net
To: manfred@colorfullife.com, paulmck@linux.vnet.ibm.com,
       lnxninja@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, efault@gmx.de, akpm@linux-foundation.org
Subject: [PATCH 0/9] Scalability requirements for sysv ipc - v3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


After scalability problems have been detected when using the sysV ipcs, I
have proposed to use an RCU based implementation of the IDR api instead (see
threads http://lkml.org/lkml/2008/4/11/212 and
http://lkml.org/lkml/2008/4/29/295).

This resulted in many people asking to convert the idr API and make it
rcu safe (because most of the code was duplicated and thus unmaintanable
and unreviewable).

So here is a first attempt.

The important change wrt to the idr API itself is during idr removes:
idr layers are freed after a grace period, instead of being moved to the
free list.

The important change wrt to ipcs, is that idr_find() can now be called
locklessly inside a rcu read critical section.

Here are the results I've got for the pmsg test sent by Manfred: 

   2.6.25-rc3-mm1   2.6.25-rc3-mm1+   2.6.25-mm1   Patched 2.6.25-mm1
1         1168441           1064021       876000               947488
2         1094264            921059      1549592              1730685
3         2082520           1738165      1694370              2324880
4         2079929           1695521       404553              2400408
5         2898758            406566       391283              3246580
6         2921417            261275       263249              3752148
7         3308761            126056       191742              4243142
8         3329456            100129       141722              4275780

1st column: stock 2.6.25-rc3-mm1
2nd column: 2.6.25-rc3-mm1 + ipc patches (store ipcs into idrs)
3nd column: stock 2.6.25-mm1
4th column: 2.6.25-mm1 + this pacth series.

I'll send a chart as an answer to this mail: don't know how to do that
with quilt :-(


Reviewers are more than ever welcome!

Patches should be applied on linux-2.6.25-mm1, in the following order:

[ PATCH 01/09 ] : idr_add_rcu_head.patch
[ PATCH 02/09 ] : idr_rename_routines.patch
[ PATCH 03/09 ] : idr_fix_printk.patch
[ PATCH 04/09 ] : idr_rc_to_errno.patch
[ PATCH 05/09 ] : idr_get_new_rcu_safe.patch
[ PATCH 06/09 ] : idr_find_rcu_safe.patch
[ PATCH 07/09 ] : idr_remove_rcu_safe.patch
[ PATCH 08/09 ] : ipc_fix_ipc_lock.patch
[ PATCH 09/09 ] : remove_ipc_lock_down.patch

Patches 2, 3 and 4 do not introduce actual changes.

I won't be available before next Tuesday, so, please, don't be mad at me if
I'm not answering fast enough.

Regards,
Nadia

--
