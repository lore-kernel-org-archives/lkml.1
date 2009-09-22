Return-Path: <linux-kernel-owner+w=401wt.eu-S1756942AbZIVQeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942AbZIVQeo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 12:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755265AbZIVQem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 12:34:42 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:52908 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754862AbZIVQem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 12:34:42 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4AB8FC88.8020608@s5r6.in-berlin.de>
Date: Tue, 22 Sep 2009 18:34:16 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.22) Gecko/20090630 SeaMonkey/1.1.17
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Vegard Nossum <vegard.nossum@gmail.com>,
       Eric B Munson <ebmunson@us.ibm.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       Dave Airlie <airlied@linux.ie>
Subject: v2.6.31-7381-g7fa0772: new build warnings: kmemcheck, __deprecated,
 hugetlb, radeon
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Latest git compiles with extreme noise:

In file included from include/net/inet_connection_sock.h:23,
                  from include/linux/tcp.h:178,
                  from include/linux/ipv6.h:215,
                  from include/net/ipv6.h:16,
                  from include/linux/sunrpc/clnt.h:25,
                  from include/linux/nfs_fs.h:52,
                  from kernel/sysctl.c:48:
include/net/inet_sock.h: In function 'inet_reqsk_alloc':
include/net/inet_sock.h:208: warning: ISO C90 forbids mixed declarations 
and code

Vegard, this is obviously caused by commit 
45e3ff82708c65c895d5c5882aff17ecf62a80b5.

$ grep KMEMCH .config
CONFIG_HAVE_ARCH_KMEMCHECK=y

(I.e. CONFIG_KMEMCHECK is off.)

More kmemcheck bogosity:

   CC      net/core/skbuff.o
In file included from include/net/ip.h:30,
                  from include/linux/errqueue.h:27,
                  from net/core/skbuff.c:59:
include/net/inet_sock.h: In function 'inet_reqsk_alloc':
include/net/inet_sock.h:208: warning: ISO C90 forbids mixed declarations 
and code
net/core/skbuff.c: In function '__alloc_skb':
net/core/skbuff.c:205: warning: ISO C90 forbids mixed declarations and code
net/core/skbuff.c:206: warning: ISO C90 forbids mixed declarations and code
net/core/skbuff.c:227: warning: ISO C90 forbids mixed declarations and code
net/core/skbuff.c:228: warning: ISO C90 forbids mixed declarations and code
net/core/skbuff.c: In function 'skb_clone':
net/core/skbuff.c:645: warning: ISO C90 forbids mixed declarations and code
net/core/skbuff.c:646: warning: ISO C90 forbids mixed declarations and code


This one is older:

   CC      net/ethernet/eth.o
[...kmemcheck noise from inet_sock.h:208, and then...:]
net/ethernet/eth.c: At top level:
net/ethernet/eth.c:402: warning: 'print_mac' is deprecated (declared at 
net/ethernet/eth.c:398)
net/ethernet/eth.c:402: warning: 'print_mac' is deprecated (declared at 
net/ethernet/eth.c:398)

Obviously added by b5eb0589937eae2d58fca17fa45ed44152e772ed.
Johannes, can't the __deprecated logic be suppressed when print_mac is 
used in EXPORT_SYMBOL?


Next one:

   CC      mm/mmap.o
mm/mmap.c: In function 'do_mmap_pgoff':
mm/mmap.c:953: warning: unused variable 'user'

Eric, this was added by 4e52780d41a741fb4861ae1df2413dd816ec11b1.

$ grep HUGETLB .config
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set


Next one:

   CC [M]  drivers/gpu/drm/radeon/radeon_ttm.o
drivers/gpu/drm/radeon/radeon_ttm.c: In function 'radeon_ttm_debugfs_init':
drivers/gpu/drm/radeon/radeon_ttm.c:714: warning: unused variable 'i'
drivers/gpu/drm/radeon/radeon_ttm.c: At top level:
drivers/gpu/drm/radeon/radeon_ttm.c:692: warning: 
'radeon_mem_types_list' defined but not used
drivers/gpu/drm/radeon/radeon_ttm.c:693: warning: 
'radeon_mem_types_names' defined but not used

Dave, added by fa8a123855e20068204982596b8fafceb1a67f0b.

$ grep -e RADEON -e DEBUG_FS .config
CONFIG_DRM_RADEON=m
CONFIG_FB_RADEON=y
CONFIG_FB_RADEON_I2C=y
# CONFIG_FB_RADEON_BACKLIGHT is not set
# CONFIG_FB_RADEON_DEBUG is not set
# CONFIG_DEBUG_FS is not set

-- 
Stefan Richter
-=====-==--= =--= =-==-
http://arcgraph.de/sr/
