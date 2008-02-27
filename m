Return-Path: <linux-kernel-owner+w=401wt.eu-S1756710AbYB0Nr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710AbYB0Nr4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 08:47:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755345AbYB0Nrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 08:47:49 -0500
Received: from sacred.ru ([62.205.161.221]:51318 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754307AbYB0Nrs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 08:47:48 -0500
Message-ID: <47C569DE.9060208@openvz.org>
Date: Wed, 27 Feb 2008 16:47:10 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3]Sysctl: clean the code and prepare for secure use in containers
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Wed, 27 Feb 2008 16:47:01 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many (most of) sysctls do not have a per-container sense. E.g. 
kernel.print_fatal_signals, vm.panic_on_oom, net.core.netdev_budget 
and so on and so forth. Besides, tuning then from inside a container
is not even secure. On the other hand, hiding them completely from
the container's tasks sometimes causes user-space to stop working.

When developing net sysctl, the common practice was to duplicate
a table and drop the write bits in table->mode, but this approach
was not very elegant, lead to excessive memory consumption and
was not suitable in general.

Here's the alternative solution. To facilitate the per-container
sysctls ctl_table_root-s were introduced. Each root contains a 
list of ctl_table_header-s that are visible to different namespaces. 
The idea of this set is to add the permissions() callback on the 
ctl_table_root to allow ctl root limit permissions to the same 
ctl_table-s.

The main user of this functionality is the net-namespaces code, 
but later this will (should) be used by more and more namespaces,
containers and control groups.

Actually, this idea's core is in a single hunk in the third patch.
First two patches are cleanups for sysctl code, while the third
one mostly extends the arguments set of some sysctl functions.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
