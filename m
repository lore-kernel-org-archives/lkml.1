Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab0CHCVR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 21:21:17 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55012 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427Ab0CHCVH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 21:21:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=Zre1EWJlSZa20aFfKT33jcmE6LJ5Fv+uYMMnGoA9Dp/94hLYLdpnqaQbTramltCxmR
         dfPYGRd/++niV7kbu6yA2k8jEI/m79wzVh6F0LTPKweQTt2klw+KJ3eCU1UYldOC1/BW
         /Q15v3a9zYW+TS54HBuqGApvjl99OwxdFNStI=
MIME-Version: 1.0
Date: Mon, 8 Mar 2010 10:21:06 +0800
Message-ID: <c4db4e681003071821x1b71e541l71c3f1fdae466e8@mail.gmail.com>
Subject: Why should check "current" consistency?
From: real yr <realyr@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The source code is listed as follows:
This code is inserted into do_fork() function
============================================
struct asmp_cpu_info *info;
......
restart:
if ((info = current->asmp->cpu)) {
dprintk("forking tsk=%p current=%p #tasks=%d\n", p, current,
info->num_tasks);
spin_lock_irqsave(&info->lock, flags);
                /* MY PROBLEM */
if (info != current->asmp->cpu) {
spin_unlock_irqrestore(&info->lock, flags);
goto restart;
}
WARN_ON(info->shielded != 1);
WARN_ON(info->num_tasks == 0);
p->asmp->cpu = info;
list_add_tail(&p->asmp->list, &info->tasks);
++info->num_tasks;
spin_unlock_irqrestore(&info->lock, flags);
}
=========================================
Please see the code with comments "/* MY PROBLEM */", since info is a
local variable,
even if this code was preempted or interrupted, when the attached
process resumes its
state, it will continues from where it was interrupted and the
"current" macro shold be the same.
So, Why should check "if (info != current->asmp->cpu) {" ?

Thanks in advance!
