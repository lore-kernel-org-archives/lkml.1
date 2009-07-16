Return-Path: <linux-kernel-owner+w=401wt.eu-S932451AbZGPPT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932451AbZGPPT7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 11:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932416AbZGPPT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 11:19:58 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:34243 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932413AbZGPPT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 11:19:57 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [KVM PATCH] xinterface
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, glommer@redhat.com,
       aliguori@us.ibm.com
Date: Thu, 16 Jul 2009 11:19:40 -0400
Message-ID: <20090716150323.29318.17714.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Applies to kvm.git/master:84a3c081)

For details, please read the patch header.

Background: The original vbus code was tightly integrated with kvm.ko.  Avi
suggested that we abstract the interfaces such that it could live outside
of kvm.  Part of that discussion turned into what is now irqfd/ioeventfd
checked into kvm.git.  The other part of the discussion (pointer-translation)
was suggested to be addressed by having the memory-slot info replicated
across interested modules.

I was looking into what is required for essentially hooking the
SET_MEMORY_REGION operations in QEMU yesterday by talking to Anthony and
Glauber on IRC.  We came to the conclusion that we could possibly
do a minor cleanup on the various callsites of SET_MEMORY_REGION so that
a wrapper function was used.  I could then add a hook at this wrapper
to essentially get notification events whenever memory-slots change, and
could forward this info to my module appropriate.

Anthony made the observation that replicating the slots info is
not the cleanest design, and I tend to agree with him.  Its replicating
data and is going to be prone to synchronization problems, etc.  He
also mentioned that other modules like virtio-net would want access
to this same information at some point, so perhaps a general solution was in
order. 

Therefore, I stepped back from that initial approach of replicating slots
and instead provided a abstract mechanism to utilize the original structures.

This code has been tested with a prototype of the vbus-v4 code and appears
to function properly.

Comments/suggestions?

Regards,
-Greg

---

Gregory Haskins (1):
      KVM: introduce "xinterface" API for external interaction with guests


 arch/x86/Kbuild                |    4 +
 arch/x86/kvm/Makefile          |    4 +
 arch/x86/kvm/x86.c             |    1 
 include/linux/kvm.h            |    2 +
 include/linux/kvm_host.h       |    6 ++
 include/linux/kvm_xinterface.h |   58 ++++++++++++++++
 virt/kvm/kvm_main.c            |   72 ++++++++++++++++++++
 virt/kvm/xinterface.c          |  147 ++++++++++++++++++++++++++++++++++++++++
 8 files changed, 293 insertions(+), 1 deletions(-)
 create mode 100644 include/linux/kvm_xinterface.h
 create mode 100644 virt/kvm/xinterface.c

-- 
Signature
