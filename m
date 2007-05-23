Return-Path: <linux-kernel-owner+w=401wt.eu-S1765855AbXEWSIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765855AbXEWSIR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 14:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762618AbXEWSH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 14:07:57 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:29828 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760032AbXEWSH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 14:07:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=DCow5k9tDu0vcq7z8ww4qKdn6EqEg1RfApSS34AJxOVD6YJ1R1w3emMtXPQ/fJvnt1g6xu8QU32art9vmzvFHeZbiEBMIjWqyjc6eAA0VOQPfxVj57YenYFO+dUiel+aRb7W1drFczw6FMbwtljgfeY/W7pFaaX9G1KWlgATbF4=
Subject: [RFC 4/5] inode reservation v0.1 (benchmark result)
From: coly <colyli@gmail.com>
To: linux-ext4 <linux-ext4@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 24 May 2007 02:08:17 +0800
Message-Id: <1179943697.4179.55.camel@coly-t43.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Current patch avoids inodes from different directories mixed together in
the inode table. Therefore the benchmakr emulate a situation that mixes
inodes of different sub-directories together. and record the time on
removing them all.

In the first part, reserving 16 inodes for each new created directory.
Therefore 14 files can only use 1 reserved block for each directory in
inode table, obviously, the result of benchmark is the best case :-)

Enviornment:
1) create 9890 directory, create files in each directory alternatively
2) kernel version 2.6.20-mm, the ext4 subdir-inode-reservation is
patched based on 2.6.20-mm
3) 14 files in each subdirectory. 9890 sub directories in
mount_point/mailbox/
4) mount with option data=writeback
5) each operation followed by a reboot
6) EXT4_INIT_RESERVE_INODES = 16

===================== data=writeback ================================
remove directories and files by rm -rf:
* ext3
read 16m56.979s
user 0m0.156s
sys 0m21.449s

* ext4org
real 18m38.809s
user 0m0.636s
sys 0m37.422s

* ext4inores
real 7m57.437s
user 0m0.452s
sys 0m34.698s


===================== data=ordered ================================
remove directories and files by rm -rf:
* ext3
real 17m23.435s
user 0m0.140s
sys 0m21.709s

* ext4org
real 17m39.515s
user 0m0.120s
sys 0.22.097s

* ext4inores
real 7m41.365s
user 0m0.196s
sys 0m24.210s

===================== data=journal ================================
remove directories and files by rm -rf:
* ext3
real 12m50.545s
user 0m0.152s
sys 0m22.725s

* ext4org
real 13m43.910s
user 0m0.196s
sys 0m23.161s

* ext4inores
real 7m49.915s
user 0m0.168s
sys 0m23.633s


Due to the bad design of magic inode and the on-disk layout of magic
inode. When 30 files created alternatively in each directory, no
performance advantage exists. When 50 files created alternatively in
each directory, the patched ext4 will use double time on removing all
the files and directories.

Therefore, in the next version a new on-disk layout will be used.

