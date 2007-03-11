Return-Path: <linux-kernel-owner+w=401wt.eu-S965116AbXCKTip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965116AbXCKTip (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 15:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965122AbXCKTip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 15:38:45 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:45019 "EHLO
	netops-testserver-4.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965116AbXCKTio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 15:38:44 -0400
Date: Sun, 11 Mar 2007 12:38:43 -0700
From: Paul Jackson <pj@sgi.com>
To: vatsa@in.ibm.com
Cc: menage@google.com, sekharan@us.ibm.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, dev@sw.ru,
       containers@lists.osdl.org, ebiederm@xmission.com, mbligh@google.com,
       winget@google.com, rohitseth@google.com, serue@us.ibm.com,
       devel@openvz.org
Subject: Re: [ckrm-tech] [PATCH 1/7] containers (V7): Generic container
 system abstracted from cpusets code
Message-Id: <20070311123843.a16a1555.pj@sgi.com>
In-Reply-To: <20070308103808.GH6504@in.ibm.com>
References: <20070212081521.808338000@menage.corp.google.com>
	<20070212085104.130746000@menage.corp.google.com>
	<20070307122117.GB2336@in.ibm.com>
	<6599ad830703071250p6c92a357g51391a23ee3d78d8@mail.gmail.com>
	<20070308103808.GH6504@in.ibm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

vatsa wrote:
> Yes, that way only the hierarchy hosting cpusets takes the hit of
> double-locking. cpuset_subsys->create/destroy can take this additional lock 
> inside cpuset.c.

The primary reason for the cpuset double locking, as I recall, was because
cpusets needs to access cpusets inside the memory allocator.  A single,
straight forward, cpuset lock failed under the following common scenario:
 1) user does cpuset system call (writes some file below /dev/cpuset, e.g.)
 2) kernel cpuset code locks its lock
 3) cpuset code asks to allocate some memory for some cpuset structure
 4) memory allocator tries to lock the cpuset lock - deadlock!

The reason that the memory allocator needs the cpuset lock is to check
whether the memory nodes the current task is allowed to use have changed,
due to changes in the current tasks cpuset.

A secondary reason that the cpuset code needs two locks is because the
main cpuset lock is a long held, system wide lock, and various low
level bits of performance critical code sometimes require quick,
read-only access to cpusets.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
