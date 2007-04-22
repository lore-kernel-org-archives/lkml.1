Return-Path: <linux-kernel-owner+w=401wt.eu-S1754017AbXDVSAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbXDVSAa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 14:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754250AbXDVSAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 14:00:30 -0400
Received: from eagle.jhcloos.com ([207.210.242.212]:2390 "EHLO
	eagle.jhcloos.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017AbXDVSA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 14:00:28 -0400
X-Greylist: delayed 561 seconds by postgrey-1.27 at vger.kernel.org; Sun, 22 Apr 2007 14:00:28 EDT
X-Hashcash: 1:23:070422:linux-rt-users@vger.kernel.org::lt++acP+rDRth09Z:0000000000000000000000000000000JuYL
From: James Cloos <cloos@jhcloos.com>
To: linux-kernel@vger.kernel.org
Cc: linux-rt-users@vger.kernel.org
Subject: using the rt patch with rc7 (or git HEAD)
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/23.0.0 (gnu/linux)
Face: iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAMnRFWHRUaXRsZQAvbWF4dG9y
 L2Nsb29zL2luY29taW5nLzIwMDQvMDIvUFdHL0pIQzE2LnBuZyJMlEwAAAAadEVYdFNvZnR3YXJl
 AEdOT01FIEljb24gRWRpdG9ynioKbAAAAHFJREFUeJzFk8EKwCAMQ1/ED9cvzw6iuM0N9WIvDTWE
 1KjAxmKnLBEBjLcEIBCeI2nccy5YKrjxwbbvAvZ37zlo4GB9iRMC/cq/AppItwmMyJ5I98wd9G7P
 xxgrSKlYS2lMrOcV13o95aVSKA7E5ndGXG+IIzcl4BNfAAAAAElFTkSuQmCC
Copyright: Copyright 2007 James Cloos
OpenPGP-Key: 1024D/ED7DAEA6
OpenPGP-Fingerprint: E9E9 F828 61A4 6EA9 0F2B  63E7 997A 9F17 ED7D AEA6
X-Hashcash: 1:23:070422:linux-kernel@vger.kernel.org::jkl1uJENtYZfHkOQ:0000000000000000000000000000000000KtU
Date: Sun, 22 Apr 2007 13:50:27 -0400
Message-ID: <m3irbo2t8l.fsf@lugabout.jhcloos.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This recipe results in only two conflicts.  The obvious and easily fixed
EXTRAVERSION conflict as well as the conflict shown below from kernel/sched.c:

#!/bin/sh
git clone -n git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git 2.6.21-rc7-rt
cd 2.6.21-rc7-rt
git branch rc6 v2.6.21-rc6
git branch rc7 v2.6.21-rc7
git branch rc6-rt0 rc6
git checkout rc6-rt0
git pull git://people.freedesktop.org/~cloos/rt-2.6.git 2.6.21-rc6-rt0
git branch rc7-rt
git checkout rc7-rt
git pull . rc7

The conlict is:

,----( conflict from kernel/sched.c from pulling rc7 into rc6-rt0 )
| <<<<<<< HEAD:kernel/sched.c
| static inline struct task_struct *eldest_child(struct task_struct *p)
| {
|         if (list_empty(&p->children))
|                 return NULL;
|         return list_entry(p->children.next,struct task_struct,sibling);
| }
| 
| static inline struct task_struct *older_sibling(struct task_struct *p)
| {
|         if (p->sibling.prev==&p->parent->children)
|                 return NULL;
|         return list_entry(p->sibling.prev,struct task_struct,sibling);
| }
| 
| static inline struct task_struct *younger_sibling(struct task_struct *p)
| {
|         if (p->sibling.next==&p->parent->children)
|                 return NULL;
|         return list_entry(p->sibling.next,struct task_struct,sibling);
| }
| 
| static const char stat_nam[] = "RMSDTtZX";
| =======
| static const char stat_nam[] = "RSDTtZX";
| >>>>>>> 94a05509a9e11806acd797153d03019706e466f1:kernel/sched.c
`----

Resolving that conflict (I tried using the <<<<<<< version) and the
EXTRAVERSION conflict allows a subsequent git pull . master to complete
w/o conflicts.

Obviously keeping the three functions in won't harm the resulting
kernel, but is leaving the M in stat_nam[] the correct resolution?

I'll be testing this kernel later this afternoon.  (As soon as I
can do the reboot.)

Incidently, has anyone tried combining the rt patches with any of
the scheduler patches?

-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
