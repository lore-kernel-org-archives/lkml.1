Return-Path: <linux-kernel-owner+w=401wt.eu-S1755261AbYEPQIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261AbYEPQIB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 12:08:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752012AbYEPQHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 12:07:53 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:38185 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbYEPQHw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 12:07:52 -0400
Message-Id: <482DCD89.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Fri, 16 May 2008 17:08:09 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <sam@ravnborg.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: your change to prevent needless re-building of vmlinux.o
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam,

while also looking into this issue (found time only now) I realized this is
already worked around in .26-rc2. However, it would seem to me that
suppressing the dependency on init/built-in.o altogether is likely to
cause problems in the future. Going through the version generating
logic again I realized that since vmlinux.o is always built before the first
of the (perhaps multiple, due to kallsyms) final linking stages, it ought
to be possible to simply move the version generation into the vmlinux.o
rule. And indeed, this

define rule_vmlinux-modpost
	:
	+$(call cmd,vmlinux_version)
	+$(call cmd,vmlinux-modpost)
	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modpost $@
	$(Q)echo 'cmd_$@ := $(cmd_vmlinux-modpost)' > $(dot-target).cmd
endef

with the two other invocations of vmlinux_version removed, seems to
do what is wanted.

What do you think? Am I overlooking some aspect here?

Btw., another slight anomaly I noticed is that modpost on the modules
is always performed (even when nothing changed in the tree), while
on vmlinux.o it is only performed when something caused a re-link. Is
that intentional, or just a to-be-tolerated side effect?

Thanks, Jan

