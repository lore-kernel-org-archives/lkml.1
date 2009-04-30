Return-Path: <linux-kernel-owner+w=401wt.eu-S933410AbZD3Rfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933410AbZD3Rfp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764697AbZD3RI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:08:27 -0400
Received: from kroah.org ([198.145.64.141]:56772 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764654AbZD3RIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:08:10 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Apr 30 09:57:47 2009
Message-Id: <20090430165747.692211511@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 30 Apr 2009 09:56:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, mtosatti@redhat.com, avi@redhat.com,
       Nitin A Kamble <nitin.a.kamble@intel.com>
Subject: [patch 63/88] KVM: Fix cpuid iteration on multiple leaves per eac
References: <20090430165549.117010404@mini.kroah.org>
Content-Disposition: inline; filename=kvm-fix-cpuid-iteration-on-multiple-leaves-per-eac.patch
In-Reply-To: <20090430170122.GA16015@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Nitin A Kamble <nitin.a.kamble@intel.com>

(cherry picked from 0fdf8e59faa5c60e9d77c8e14abe3a0f8bfcf586)

The code to traverse the cpuid data array list for counting type of leaves is
currently broken.

This patches fixes the 2 things in it.

 1. Set the 1st counting entry's flag KVM_CPUID_FLAG_STATE_READ_NEXT. Without
    it the code will never find a valid entry.

 2. Also the stop condition in the for loop while looking for the next unflaged
    entry is broken. It needs to stop when it find one matching entry;
    and in the case of count of 1, it will be the same entry found in this
    iteration.

Signed-Off-By: Nitin A Kamble <nitin.a.kamble@intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kvm/x86.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1188,6 +1188,7 @@ static void do_cpuid_ent(struct kvm_cpui
 		int t, times = entry->eax & 0xff;
 
 		entry->flags |= KVM_CPUID_FLAG_STATEFUL_FUNC;
+		entry->flags |= KVM_CPUID_FLAG_STATE_READ_NEXT;
 		for (t = 1; t < times && *nent < maxnent; ++t) {
 			do_cpuid_1_ent(&entry[t], function, 0);
 			entry[t].flags |= KVM_CPUID_FLAG_STATEFUL_FUNC;
@@ -2729,7 +2730,7 @@ static int move_to_next_stateful_cpuid_e
 
 	e->flags &= ~KVM_CPUID_FLAG_STATE_READ_NEXT;
 	/* when no next entry is found, the current entry[i] is reselected */
-	for (j = i + 1; j == i; j = (j + 1) % nent) {
+	for (j = i + 1; ; j = (j + 1) % nent) {
 		struct kvm_cpuid_entry2 *ej = &vcpu->arch.cpuid_entries[j];
 		if (ej->function == e->function) {
 			ej->flags |= KVM_CPUID_FLAG_STATE_READ_NEXT;


