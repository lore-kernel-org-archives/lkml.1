Return-Path: <linux-kernel-owner+w=401wt.eu-S1756220AbZJAXiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220AbZJAXiW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 19:38:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756101AbZJAXiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 19:38:19 -0400
Received: from kroah.org ([198.145.64.141]:42042 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755539AbZJAXiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 19:38:13 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 16:33:21 2009
Message-Id: <20091001233320.964047795@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 16:31:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mark McLoughlin <markmc@redhat.com>, avi@redhat.com
Subject: [patch 15/30] KVM: fix cpuid E2BIG handling for extended request types
References: <20091001233116.947658905@mini.kroah.org>
Content-Disposition: inline; filename=kvm-fix-cpuid-e2big-handling-for-extended-request-types.patch
In-Reply-To: <20091001233504.GA17709@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Mark McLoughlin <markmc@redhat.com>

(cherry picked from commit cb007648de83cf226d69ec76e1c01848b4e8e49f)

If we run out of cpuid entries for extended request types
we should return -E2BIG, just like we do for the standard
request types.

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kvm/x86.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1438,6 +1438,10 @@ static int kvm_dev_ioctl_get_supported_c
 	for (func = 0x80000001; func <= limit && nent < cpuid->nent; ++func)
 		do_cpuid_ent(&cpuid_entries[nent], func, 0,
 			     &nent, cpuid->nent);
+	r = -E2BIG;
+	if (nent >= cpuid->nent)
+		goto out_free;
+
 	r = -EFAULT;
 	if (copy_to_user(entries, cpuid_entries,
 			 nent * sizeof(struct kvm_cpuid_entry2)))


