Return-Path: <linux-kernel-owner+w=401wt.eu-S1757026AbZJBBrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757026AbZJBBrU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756652AbZJBBdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:33:36 -0400
Received: from kroah.org ([198.145.64.141]:33264 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756253AbZJBBdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:33:31 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:18 2009
Message-Id: <20091002012418.125547921@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:17:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mark McLoughlin <markmc@redhat.com>, avi@redhat.com
Subject: [074/136] KVM: fix cpuid E2BIG handling for extended request types
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=kvm-fix-cpuid-e2big-handling-for-extended-request-types.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.31-stable review patch.  If anyone has any objections, please let us know.

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
@@ -1448,6 +1448,10 @@ static int kvm_dev_ioctl_get_supported_c
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


