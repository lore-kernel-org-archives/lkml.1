Return-Path: <linux-kernel-owner+w=401wt.eu-S1752865AbYKKU5K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865AbYKKU5K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 15:57:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751696AbYKKU4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 15:56:52 -0500
Received: from mx2.redhat.com ([66.187.237.31]:39776 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751592AbYKKU4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 15:56:52 -0500
Message-ID: <4919F159.6090706@redhat.com>
Date: Tue, 11 Nov 2008 15:55:53 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, David Miller <davem@davemloft.net>,
       Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: [PATCH 0/7] kprobes: Support probing __init and __exit functions
 in modules
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series of patches allows kprobes to probe module's __init and
__exit functions. This means, you can probe driver initialization
and terminating.

Currently, kprobes can't probe __init function because these functions
are freed after module initialization. And it also can't probe module
__exit functions because kprobe increments reference count of target
module and user can't unload it. this means __exit functions never be
called unless removing probes from the module.

To solve both cases, this series of patches introduces GONE flag and
sets it when the target code is freed(for this purpose, kprobes hooks
MODULE_STATE_* events). This also removes refcount incrementing for
allowing user to unload target module. Users can check which probes
are GONE by debugfs interface. For taking timing of freeing module's
.init text, these also include a patch which adds module's notifier of
MODULE_STATE_LIVE event.

This series of patches can be applied after applying below patches on
2.6.28-rc4.

http://lkml.org/lkml/2008/11/6/236
http://lkml.org/lkml/2008/11/5/346

Thank you,

 Documentation/kprobes.txt     |    5
 arch/arm/kernel/kprobes.c     |    2
 arch/ia64/kernel/kprobes.c    |    8 -
 arch/powerpc/kernel/kprobes.c |    7 -
 arch/s390/kernel/kprobes.c    |    7 -
 arch/x86/kernel/kprobes.c     |    7 -
 include/linux/kprobes.h       |   15 +-
 include/linux/module.h        |   12 +
 kernel/kprobes.c              |  260 ++++++++++++++++++++++++++----------------
 kernel/module.c               |   27 +---
 10 files changed, 220 insertions(+), 130 deletions(-)

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

