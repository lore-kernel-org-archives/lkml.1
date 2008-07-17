Return-Path: <linux-kernel-owner+w=401wt.eu-S1760088AbYGQAxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760088AbYGQAxv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 20:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752227AbYGQAxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 20:53:43 -0400
Received: from relais.videotron.ca ([24.201.245.36]:42577 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbYGQAxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 20:53:42 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Message-id: <487E9815.6060803@gmail.com>
Date: Wed, 16 Jul 2008 20:53:41 -0400
From: Marc Dionne <marc.c.dionne@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
To: eparis@redhat.com, LKML <linux-kernel@vger.kernel.org>
Subject: /proc/mounts unreadable - bisected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With current git, /proc/mounts is unreadable on my system, with any attempts to 
read it returning EINVAL.  This breaks many init scripts, among other things.

I bisected it down to this commit:

commit 2069f457848f846cb31149c9aa29b330a6b66d1b
Author: Eric Paris <eparis@redhat.com>
Date:   Fri Jul 4 09:47:13 2008 +1000

     LSM/SELinux: show LSM mount options in /proc/mounts

     This patch causes SELinux mount options to show up in /proc/mounts.  As
     with other code in the area seq_put errors are ignored.  Other LSM's
     will not have their mount options displayed until they fill in their own
     security_sb_show_options() function.

In my case, selinux_get_mnt_opts() never gets very far because 
sbsec->initialized never becomes true, and the function systematically returns 
EINVAL which is then passed back up to the reader of /proc/mounts.

Changing show_sb_opts() to always return 0 (it was a void function before this 
commit) makes the system behave normally.

Now it's possible that my selinux config is hosed - I have it enabled in 
permissive mode but I don't pay much attention to it - but the failure mode in 
that case should probably be more graceful.  Seems like it would be better to 
print out the available mount info minus the LSM options than to bail out 
completely?

Thanks,
Marc
