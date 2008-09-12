Return-Path: <linux-kernel-owner+w=401wt.eu-S1755374AbYILBie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374AbYILBie (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 21:38:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752722AbYILBiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 21:38:25 -0400
Received: from services110.cs.uwaterloo.ca ([129.97.152.166]:53633 "EHLO
	services110.cs.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752490AbYILBiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 21:38:24 -0400
Message-ID: <48C9C7FD.3060609@users.sourceforge.net>
Date: Thu, 11 Sep 2008 21:38:05 -0400
From: Elad Lahav <elad_lahav@users.sourceforge.net>
User-Agent: Thunderbird 2.0.0.16 (X11/20080726)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Soft IRQ statistics under /proc/stat
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Miltered: at mailchk-m01 with ID 48C9C80E.000 by Joe's j-chkmail (http://j-chkmail.ensmp.fr)!
X-UUID: 0b15b41d-3e03-4ae3-a308-29aabfe88152
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been observing some oddities in the statistics produced by mpstat 
with respect to soft IRQs (for example, considerable soft IRQ time on 
processors sending UDP packets on dummy NICs). While looking at the 
kernel code, I noticed that ticks are attributed to soft IRQs when 
softirq_count() is greater than 0. This happens in __local_bh_disable(), 
which is called from __do_softirq(), but also from local_bh_disable(). 
Thus, the number of ticks reported in /proc/stat refers to any execution 
path that runs with soft IRQs disabled, not just code called from 
__do_softirq().
I hacked the kernel to differentiate between the two cases, and indeed 
the anomalies I saw can be explained as code executing under 
local_bh_disable().

Is this behaviour by design? References to /proc/stat on the web refer 
to this number simply as "soft IRQ time" (e.g., 
http://www.redhat.com/docs/manuals/enterprise/RHEL-4-Manual/en-US/Reference_Guide/s2-proc-stat.html). 
I would have expected that to include only execution paths starting from 
__do_softirq().

Elad
