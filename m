Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096Ab0CJDHa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 22:07:30 -0500
Received: from services04.student.cs.uwaterloo.ca ([129.97.152.11]:60190 "EHLO
	services04.student.cs.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755925Ab0CJDH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 22:07:28 -0500
X-Greylist: delayed 2118 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Mar 2010 22:07:27 EST
Date: Tue, 9 Mar 2010 21:31:43 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Pirko <jpirko@redhat.com>, "David S. Miller" <davem@davemloft.net>
Subject: [Regression, bisected] tcpdump broken in 2.6.34-rc1
Message-ID: <20100310023143.GA20402@cpu18.student.cs>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (services04.student.cs.uwaterloo.ca [129.97.152.11]); Tue, 09 Mar 2010 21:31:50 -0500 (EST)
X-Miltered: at mailchk-w04 with ID 4B970494.000 by Joe's j-chkmail (http://j-chkmail.ensmp.fr)!
X-UUID: 4bea0794-f4b0-407d-85ce-ffe73114471b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After upgrading to 2.6.34-rc1, tcpdump fails with the following message:

  tcpdump: setsockopt: Invalid argument

The issue is reproducable on two very different machines: one using
iwlagn and the other using et131x.  Bisection reveals the following and
reverting the implicated commit resolves the issue.

914c8ad2d18b62ad1420f518c0cab0b0b90ab308 is the first bad commit
commit 914c8ad2d18b62ad1420f518c0cab0b0b90ab308
Author: Jiri Pirko <jpirko@redhat.com>
Date:   Wed Feb 24 23:57:04 2010 +0000

    af_packet: do not accept mc address smaller then dev->addr_len in packet_mc_add()
    
    There is no point of accepting an address of smaller length than dev->addr_len
    here. Therefore change this for stonger check.
    
    Signed-off-by: Jiri Pirko <jpirko@redhat.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

:040000 040000 e76af2835c200aea1f3b1268f5e2e7c930ece887 87d5869972605cc130372168f450ee0def0b169b M	net

git bisect start
# bad: [57d54889cd00db2752994b389ba714138652e60c] Linux 2.6.34-rc1
git bisect bad 57d54889cd00db2752994b389ba714138652e60c
# good: [baac35c4155a8aa826c70acee6553368ca5243a2] security: fix error return path in ima_inode_alloc
git bisect good baac35c4155a8aa826c70acee6553368ca5243a2
# bad: [47871889c601d8199c51a4086f77eebd77c29b0b] Merge branch 'master' of /home/davem/src/GIT/linux-2.6/
git bisect bad 47871889c601d8199c51a4086f77eebd77c29b0b
# good: [e0d272429a34ff143bfa04ee8e29dd4eed2964c7] Merge branch 'tracing-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
git bisect good e0d272429a34ff143bfa04ee8e29dd4eed2964c7
# good: [b3b3f04fb587ecb61b5baa6c1c5f0e666fd12d73] tg3: Update driver version to 3.107
git bisect good b3b3f04fb587ecb61b5baa6c1c5f0e666fd12d73
# good: [19bc291c99f018bd4f2c38bbf69144086dca903f] Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next-2.6
git bisect good 19bc291c99f018bd4f2c38bbf69144086dca903f
# good: [f66ffdedbf0fc059a92219bb08c1dbcac88f074b] Merge branch 'sched-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
git bisect good f66ffdedbf0fc059a92219bb08c1dbcac88f074b
# bad: [46976c042ba1ff59253f2f7a513099175c24794e] Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/holtmann/bluetooth-next-2.6
git bisect bad 46976c042ba1ff59253f2f7a513099175c24794e
# bad: [b914a250e7b390c713b36a9405a39c4c11abad80] Bluetooth: Convert Marvell driver to use per adapter debugfs
git bisect bad b914a250e7b390c713b36a9405a39c4c11abad80
# good: [a4dde3abbf87a495154a876576e1ab34b17b5ef1] cnic: Use union for the status blocks of different devices.
git bisect good a4dde3abbf87a495154a876576e1ab34b17b5ef1
# bad: [738b0343e73604750feb107e063c28b3ca36cb84] Revert "ethtool: Add n-tuple string length to drvinfo and return it"
git bisect bad 738b0343e73604750feb107e063c28b3ca36cb84
# bad: [e5e26d75f490d7d41f25a4b39ed6db1713beb417] netdev: use list_first_entry macro
git bisect bad e5e26d75f490d7d41f25a4b39ed6db1713beb417
# good: [2a3f279034b46204b50408aa2c25ee0882120147] myri10ge: optimize 4k-boundary check when stocking rx pages
git bisect good 2a3f279034b46204b50408aa2c25ee0882120147
# bad: [4edb246626be6e031950205c885bdf29fb2ff1eb] rtnetlink: clean up SR-IOV config interface
git bisect bad 4edb246626be6e031950205c885bdf29fb2ff1eb
# bad: [914c8ad2d18b62ad1420f518c0cab0b0b90ab308] af_packet: do not accept mc address smaller then dev->addr_len in packet_mc_add()
git bisect bad 914c8ad2d18b62ad1420f518c0cab0b0b90ab308
