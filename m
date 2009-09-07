Return-Path: <linux-kernel-owner+w=401wt.eu-S1754101AbZIGR4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101AbZIGR4d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 13:56:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752164AbZIGR4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 13:56:32 -0400
Received: from goliath.siemens.de ([192.35.17.28]:21868 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549AbZIGR4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 13:56:30 -0400
X-Greylist: delayed 2016 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Sep 2009 13:56:29 EDT
Message-ID: <4AA54150.3000101@siemens.com>
Date: Mon, 07 Sep 2009 19:22:24 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Avi Kivity <avi@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: HW breakpoints vs. KVM context switches
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

as we currently face some abstraction issue around hardware breakpoints
in kvm, I had a look again at the state of your work. I assume it's on a
good way towards mainline, right?

So far kvm (on x86) switches debug registers between host and guest
fairly conservatively: If the guest has some breakpoint in use, the host
registers are read from the hardware and restored to it on return. This
is not really optimal, specifically as dr6/dr7 are currently touched
unconditionally.

Now Avi's idea is to skip saving the registers as we could also restore
them from current->thread.debugregX whenever required. IIUC this will no
longer be true when hw-breakpoints hit mainline. It is already wrong for
kgdb as that breakpoint user touches the registers without asking anyone
(or at least informing others).

My question is now if we could extend the hw-breakpoint interface in a
way, either arch-specific or even generic, that kvm could easily use it
to restore the host's debug register state if required.

Moreover, I think we also need some interface extension for kgdb. I
guess it wants ultimate access to the registers on all CPUs, and it
likely don't want to debate about this with the kernel (==acquire
locks). Still the hw-breakpoint layer would likely want to know if kgdb
is claiming the hardware so that it can step back from touching them.
Also kvm would like to hear about this + access to their (cached)
content for proper restoration.

So far the theory. Before starting to craft any prototypes, I would like
to hear your opinion on this.

Jan

-- 
Siemens AG, Corporate Technology, CT SE 2
Corporate Competence Center Embedded Linux
