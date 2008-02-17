Return-Path: <linux-kernel-owner+w=401wt.eu-S1754672AbYBQD3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbYBQD3T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 22:29:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751102AbYBQD3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 22:29:12 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45486 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750919AbYBQD3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 22:29:11 -0500
Date: Sat, 16 Feb 2008 21:29:01 -0600
From: Paul Jackson <pj@sgi.com>
To: Paul Menage <menage@google.com>
Cc: balbir@in.ibm.com, xemul@openvz.org, kamezawa.hiroyu@jp.fujitsu.com,
       vatsa@linux.vnet.ibm.com, akpm@linux-foundation.org,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 7/7] CGroup API: Update cpusets to use cgroup
 structured file API
Message-Id: <20080216212901.70fe35ce.pj@sgi.com>
In-Reply-To: <20080215204821.778088000@menage.corp.google.com>
References: <20080215204418.535025000@menage.corp.google.com>
	<20080215204821.778088000@menage.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok ... this would (I suspect, just from code reading, no bytes were
harmed in actual testing of this) have a minor change to how white
space is handled writing integer flags to cpuset files, and a minor
inconstency.

 1) Existing cpuset code lets you set a flag (e.g. cpu_exclusive) by doing:
	echo '1 rumplestiltskin' > cpu_exclusive   # same as: echo 1 > cpu_exclusive
    With this patch, that probably fails, EINVAL.

 2) With this patch, one can write "1" or "1\n" to cpuset integer files, but one
    cannot successfully write "1\r\n" or "1 " or "1 \n".  However, for the cpuset
    control files that take strings, not single integers, one -can- have any mix
    of trailing white space.

So far as I know, I have no requirement to write rumplestiltskin to cpuset files ;).
So I'm content to let the minor change in (1) pass without further comment.

I'd like to recommend consideration of the following patch, to address the
minor inconsistency of (2), and to save a few bytes of kernel text space.

=======

From: Paul Jackson <pj@sgi.com>

Strip all trailing whitespace (such as carriage returns)
when parsing integer writes to cgroup files, not just
one trailing newline if present.

Signed-off-by: Paul Jackson <pj@sgi.com>
Cc: Paul Menage <menage@google.com>

---
 kernel/cgroup.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- 2.6.24-mm1.orig/kernel/cgroup.c	2008-02-16 04:20:33.000000000 -0800
+++ 2.6.24-mm1/kernel/cgroup.c	2008-02-16 19:00:41.207478218 -0800
@@ -1321,10 +1321,7 @@ static ssize_t cgroup_write_uint(struct 
 		return -EFAULT;
 
 	buffer[nbytes] = 0;     /* nul-terminate */
-
-	/* strip newline if necessary */
-	if (nbytes && (buffer[nbytes-1] == '\n'))
-		buffer[nbytes-1] = 0;
+	strstrip(buffer);	/* strip -just- trailing whitespace */
 	val = simple_strtoull(buffer, &end, 0);
 	if (*end)
 		return -EINVAL;


-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
