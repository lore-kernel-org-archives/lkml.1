Return-Path: <linux-kernel-owner+w=401wt.eu-S933402AbYBGWa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933402AbYBGWa3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 17:30:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758059AbYBGWaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 17:30:14 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:32598 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757170AbYBGWaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 17:30:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:content-transfer-encoding:message-id:content-type:to:from:subject:date:x-mailer;
        b=PaogST8V/Z9VjKRkn9G2wRlN0joHutN1GYpAUy7P7VjlWzIbtfnoTnOuWx7S0rqV41quXdApDVVApMREdyL4tbIeujN9DqfZ6PqUfU5Ai9VKIKVHmq8xyo/QSHAdb+N66nI8Oe/S7Uk/rq1xpnO0eq/h1ReqB6O+1Ee1eeTn2Q4=
Mime-Version: 1.0 (Apple Message framework v753)
Content-Transfer-Encoding: 7bit
Message-Id: <BF56C133-8810-4AA7-B8AF-325424869A76@gmail.com>
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
To: linux-kernel@vger.kernel.org
From: William Dinkel <wdinkel@gmail.com>
Subject: Invalid size values in /proc/mtrr output
Date: Thu, 7 Feb 2008 16:30:01 -0600
X-Mailer: Apple Mail (2.753)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Has anyone else seen extraordinarily large sizes in /proc/mtrr  
output?  We're running v2.6.24 on some Tyan S5383 dual-socket systems  
with the following characteristics:
  - qty(1) Intel(R) Xeon(R) CPU E5345 @ 2.33GHz (quad-core, the other  
socket is unoccupied)
  - 32GB RAM (qty(16) 2GB DIMMS)
  - MTRR Discrete ENABLED in the BIOS
  - PCI Memory Hole set to 512MB in the BIOS (other options are  
256MB, 1GB and 2GB, all of which produce similar results)
  - CONFIG_MTRR, CONFIG_SMP and CONFIG_MCORE2 enabled

Here's some relevant output from a shell session:
---
[root@node003 ~]# uname -r
2.6.24
[root@node003 ~]# free -m
              total       used       free     shared    buffers      
cached
Mem:         32245        320      31925          0         15         
162
-/+ buffers/cache:        142      32103
Swap:         2047          0       2047
[root@node003 ~]# cat /proc/mtrr
reg00: base=0x00000000 (   0MB), size=198656MB: write-back, count=1
reg01: base=0x80000000 (2048MB), size=197632MB: write-back, count=1
reg02: base=0x100000000 (4096MB), size=200704MB: write-back, count=1
reg03: base=0x200000000 (8192MB), size=204800MB: write-back, count=1
reg04: base=0x400000000 (16384MB), size=212992MB: write-back, count=1
reg05: base=0x800000000 (32768MB), size=197632MB: write-back, count=1
reg06: base=0xbff80000 (3071MB), size=196608MB: uncachable, count=1
---

I have a hunch that those 192GB+ sizes aren't "correct."  We're in  
communication with Tyan, and they say the MTRRs look OK from their  
end on a similarly configured system (using a utility unknown to me):

---
Here is the MTRR that we dumped from S5383 with 32G memory,BIOS SETUP  
for PCI memory hole 512MB and MTRR discrete ENABLED:

MSR                 EDX                  EAX                   
description
200H                 00000000H        00000006H        MTRR physical  
base 0,start at address 0
201H                 0000000FH        80000800H        MTRR physical  
mask 0,size 2G
202H                 00000000H        80000006H        MTRR physical  
base 1,start at address 2G
203H                 0000000FH        C0000800H       MTRR physical  
mask 1,size 1G
204H                 00000001H        00000006H        MTRR physical  
base 2,start at address 4G
205H                 0000000FH        00000800H        MTRR physical  
mask2,size 4G
206H                 00000002H        00000006H        MTRR physical  
base 3,start at address 8G
207H                 0000000EH       00000800H        MTRR physical  
mask3,size 8G
208H                 00000004H        00000006H        MTRR physical  
base 4,start at address 16G
209H                 0000000CH       00000800H        MTRR physical  
mask 4,size 16G
20AH                00000008H        00000006H        MTRR physical  
base 5,start at address 32G
20BH                0000000FH        C0000800H       MTRR physical  
mask 5,size 1G
20CH                00000000H        BFF80000H       MTRR physical  
base 6,start at address 3G-512K
20DH                0000000FH        FFF80800H       MTRR physical  
mask6 ,size 512K
20EH                00000000H        00000000H        MTRR physical  
base 7
20FH                00000000H        00000000H        MTRR physical  
mask7
---

Although it's not running v2.6.24 at the moment, we also have an  
Intel S5400SF system exhibiting similar behavior:

---
[root@head ~]# ssh n00001 uname -r
2.6.18-8.1.15.el5
[root@head ~]# ssh n00001 free -m
              total       used       free     shared    buffers      
cached
Mem:         16039        425      15613          0          0         
335
-/+ buffers/cache:         89      15949
Swap:            0          0          0
[root@head ~]# ssh n00001 cat /proc/mtrr
reg00: base=0x00000000 (   0MB), size=198656MB: write-back, count=1
reg01: base=0x80000000 (2048MB), size=197120MB: write-back, count=1
reg02: base=0x9fc00000 (2556MB), size=196612MB: uncachable, count=1
reg03: base=0x100000000 (4096MB), size=200704MB: write-back, count=1
reg04: base=0x200000000 (8192MB), size=204800MB: write-back, count=1
reg05: base=0x400000000 (16384MB), size=212992MB: write-back, count=1
---

We'll continue to work with the board vendors on this, but we wanted  
to get feedback from any MTRR experts out there.

Please CC me when replying.  Thanks.

Will Dinkel
wdinkel@gmail.com



