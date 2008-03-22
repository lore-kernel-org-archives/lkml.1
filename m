Return-Path: <linux-kernel-owner+w=401wt.eu-S1756397AbYCVLZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397AbYCVLZi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 07:25:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753584AbYCVLZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 07:25:31 -0400
Received: from mail.gmx.net ([213.165.64.20]:39797 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753485AbYCVLZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 07:25:30 -0400
X-Authenticated: #19095397
X-Provags-ID: V01U2FsdGVkX1+yu0Vop9qyJ40VL9Cf5ekD747HhqnKY2O4zn0B5Q
	Ex7xgksonBzWst
From: Bernd Schubert <bernd-schubert@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: deadline unfairness
Date: Sat, 22 Mar 2008 12:25:26 +0100
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803221225.26728.bernd-schubert@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

some it seems the deadline scheduler is rather unfair. Below is an example
of md-raid6 initialization of md3, md4 and md5. All three md-devices
do share the same blockdevices (we have patched md to allow
parallel rebuild of shared block devices, since for us the cpu is the 
bottleneck and not the block device).

All rebuilds started basically at the same time, as you can see, md3 is already
done and now md4 rebuilds substantially faster than md5.


md5 : active raid6 sdk3[0] sde3[5] sdi3[4] sdm3[3] sdc3[2] sdg3[1]
      6834869248 blocks level 6, 256k chunk, algorithm 2 [6/6] [UUUUUU]
      [=============>.......]  resync = 65.8% (1124909328/1708717312) finish=272.2min speed=35734K/sec

md4 : active raid6 sdk2[0] sde2[5] sdi2[4] sdm2[3] sdc2[2] sdg2[1]
      6834869248 blocks level 6, 256k chunk, algorithm 2 [6/6] [UUUUUU]
      [===============>.....]  resync = 77.6% (1327362312/1708717312) finish=123.9min speed=51283K/sec

md3 : active raid6 sdk1[0] sde1[5] sdi1[4] sdm1[3] sdc1[2] sdg1[1]
      6834869248 blocks level 6, 256k chunk, algorithm 2 [6/6] [UUUUUU]


Reducing write_expire to 2000ms did improve the situation a bit, but noop and 
the other schedulers are still by far more fair.

Here with noop:

md5 : active raid6 sdk3[0] sde3[5] sdi3[4] sdm3[3] sdc3[2] sdg3[1]
      6834869248 blocks level 6, 256k chunk, algorithm 2 [6/6] [UUUUUU]
      [=============>.......]  resync = 67.3% (1150741776/1708717312) finish=216.8min speed=42875K/sec

md4 : active raid6 sdk2[0] sde2[5] sdi2[4] sdm2[3] sdc2[2] sdg2[1]
      6834869248 blocks level 6, 256k chunk, algorithm 2 [6/6] [UUUUUU]
      [===============>.....]  resync = 79.3% (1355377160/1708717312) finish=134.8min speed=43659K/sec

md3 : active raid6 sdk1[0] sde1[5] sdi1[4] sdm1[3] sdc1[2] sdg1[1]
      6834869248 blocks level 6, 256k chunk, algorithm 2 [6/6] [UUUUUU]


This is basically with a 2.6.22 kernel + lustre + md-backports, but nothing
done to the scheduler.


Cheers,
Bernd
