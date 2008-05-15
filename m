Return-Path: <linux-kernel-owner+w=401wt.eu-S1758364AbYEOK4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758364AbYEOK4S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 06:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754057AbYEOK4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 06:56:05 -0400
Received: from sacred.ru ([62.205.161.221]:59497 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753081AbYEOK4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 06:56:04 -0400
Message-ID: <482C15FE.7070300@openvz.org>
Date: Thu, 15 May 2008 14:52:46 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Oleg Nesterov <oleg@tv-sign.ru>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/10] Make bsd process accounting work in pid namespaces
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Thu, 15 May 2008 14:55:08 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After I fixed access to task->tgid in kernel/acct.c, Oleg 
pointed out some bad side effects with this accounting vs pid 
namespaces interaction. I.e. when some task in pid namespace 
sets this accounting up, this blocks all the others from doing 
the same. Restricting this to init namespace only could help, 
but didn't look as a grace solution.

So here is the approach to make this accounting work with pid
namespaces properly.

The idea is simple - when a task dies it accounts itself in 
each namespace it is visible from and which set the accounting 
up. 

For example here are the commands run and the output of lastcomm 
from init and sub namespaces:

init_ns# accton pacct
 sub_ns# accton pacct (this is a different file - sub ns is run in
                       a chroot-ed environment)
init_ns# cat /dev/null
 sub_ns# ls /dev/null
init_ns# accton
 sub_ns# accton

 sub_ns#  lastcomm -f pacct
ls                      0        [136,0]    0.00 secs Thu May 15 10:30
accton                  0        [136,0]    0.00 secs Thu May 15 10:30

init_ns# lastcomm -f pacct
accton                  root     pts/0      0.00 secs Thu May 15 14:30 << got from sub
cat                     root     pts/1      0.00 secs Thu May 15 14:30
ls                      root     pts/0      0.00 secs Thu May 15 14:30 << got from sub
accton                  root     pts/1      0.00 secs Thu May 15 14:30

That was the summary, the details are in patches.

The set was sent for RFC a month ago, but I got only one, but
positive response from Oleg. Hopefully, he can confirm one now.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
