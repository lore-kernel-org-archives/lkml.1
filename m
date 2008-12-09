Return-Path: <linux-kernel-owner+w=401wt.eu-S1753371AbYLIMAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbYLIMAQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 07:00:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753830AbYLIL74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 06:59:56 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:45326 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685AbYLIL7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 06:59:55 -0500
Subject: [Patch] Fix sys_time to handle intra-tick correction
From: Vinay Sridhar <vinay@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: jstultz@us.ibm.com
Content-Type: text/plain
Date: Tue, 09 Dec 2008 17:28:58 +0530
Message-Id: <1228823938.11639.7.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

This fix changes sys_time to use do_gettimeofday instead of get_seconds.
Running the stime01 test from LTP triggers this error. Calling sys_stime
and then calling sys_time causes this. "do_settimeofday" subtracts the
nsec offset from the nsec value(0 in this case) passed to it.
Subsequently, "set_normalized_timespec" modifies sec and nsec
accordingly. This compensation is handled in the do_gettimeofday path.
However, sys_time does not handle this case and reports an incorrect
seconds value.


signed-off by : Vinay Sridhar <vinay@linux.vnet.ibm.com>

--- time.c.orig	2008-12-04 06:30:12.000000000 -0600
+++ time.c	2008-12-04 06:31:25.000000000 -0600
@@ -61,7 +61,12 @@ EXPORT_SYMBOL(sys_tz);
  */
 asmlinkage long sys_time(time_t __user * tloc)
 {
-	time_t i = get_seconds();
+	struct timeval t;	
+	time_t i;
+
+	do_gettimeofday(&t);
+
+	i = t.tv_sec;
 
 	if (tloc) {
 		if (put_user(i,tloc))


