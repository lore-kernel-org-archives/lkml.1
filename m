Return-Path: <linux-kernel-owner+w=401wt.eu-S965056AbXAYBDG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965056AbXAYBDG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 20:03:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965007AbXAYBDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 20:03:05 -0500
Received: from mailx.hitachi.co.jp ([133.145.228.49]:41890 "EHLO
	mailx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965056AbXAYBDD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 20:03:03 -0500
Message-ID: <45B800CF.1020800@hitachi.com>
Date: Thu, 25 Jan 2007 09:58:55 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: ananth@in.ibm.com, Andrew Morton <akpm@osdl.org>
Cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Satoshi Oshima <soshima@redhat.com>, Hideo Aoki <haoki@redhat.com>,
       Yumiko Sugita <yumiko.sugita.yf@hitachi.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       SystemTAP <systemtap@sources.redhat.com>,
       "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
Subject: [PATCH][kprobe]replace magic numbers with enum (Re: Warning in kprobes.c)
References: <20070123091208.GA21724@in.ibm.com> <45B60065.2040207@hitachi.com> <20070124041750.GA11084@in.ibm.com>
In-Reply-To: <20070124041750.GA11084@in.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-MIME-Autoconverted: from 8bit to quoted-printable by maila.sdl.hitachi.co.jp id l0P0wtJ3010244
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ananth N Mavinakayanahalli wrote:
[snip]
>>> I get this warning:
>>>
>>> kernel/kprobes.c: In function ‘collect_garbage_slots’:
>>> kernel/kprobes.c:215: warning: comparison is always false due to limited
>>> range of data type
>>>
>>> when building 2.6.20-rc5 on powerpc. Not strange though, since the
>>> powerpc compiler is more unforgiving than most other arch compilers. The
>>> line in question is:
>>>
>>>                         if (kip->slot_used[i] == -1 &&
>>>
>>> and kip->slot_used is a char array and -1 is apparently an invalid char
>>> assignment. Is there a way to get rid of the warning?
>> As far as I searched, on powerpc and arm, the default type of char is
>> 'unsigned char' whereas that is 'signed' on most other arch. So, your
>> compiler warned "due to limited range of data type".
>>
>> I think a good solution is that we just replace -1 with 2.
>> Could you test the patch attached to this mail?
> 
> Thanks for taking care of this, the patch fixes the warning.
> 
> I think however, instead of having magic numbers 0, 1, 2, why not an
> enum? It makes the code easier to read. Comments?

It's a good idea. Same thing was pointed out by my boss too.
Here is a patch which uses an enum to express the slot status.

Thanks,

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

---
 This patch replaces the magic numbers with an enum, and
 gets rid of a warning on the specific architectures (ex. powerpc)
 on which the compiler considers 'char' as 'unsigned char'.

 kernel/kprobes.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

Index: linux-2.6.20-rc5/kernel/kprobes.c
===================================================================
--- linux-2.6.20-rc5.orig/kernel/kprobes.c
+++ linux-2.6.20-rc5/kernel/kprobes.c
@@ -87,6 +87,12 @@ struct kprobe_insn_page {
 	int ngarbage;
 };

+enum kprobe_slot_state {
+	SLOT_CLEAN = 0,
+	SLOT_DIRTY = 1,
+	SLOT_USED = 2,
+};
+
 static struct hlist_head kprobe_insn_pages;
 static int kprobe_garbage_slots;
 static int collect_garbage_slots(void);
@@ -130,8 +136,8 @@ kprobe_opcode_t __kprobes *get_insn_slot
 		if (kip->nused < INSNS_PER_PAGE) {
 			int i;
 			for (i = 0; i < INSNS_PER_PAGE; i++) {
-				if (!kip->slot_used[i]) {
-					kip->slot_used[i] = 1;
+				if (kip->slot_used[i] == SLOT_CLEAN) {
+					kip->slot_used[i] = SLOT_USED;
 					kip->nused++;
 					return kip->insns + (i * MAX_INSN_SIZE);
 				}
@@ -163,8 +169,8 @@ kprobe_opcode_t __kprobes *get_insn_slot
 	}
 	INIT_HLIST_NODE(&kip->hlist);
 	hlist_add_head(&kip->hlist, &kprobe_insn_pages);
-	memset(kip->slot_used, 0, INSNS_PER_PAGE);
-	kip->slot_used[0] = 1;
+	memset(kip->slot_used, SLOT_CLEAN, INSNS_PER_PAGE);
+	kip->slot_used[0] = SLOT_USED;
 	kip->nused = 1;
 	kip->ngarbage = 0;
 	return kip->insns;
@@ -173,7 +179,7 @@ kprobe_opcode_t __kprobes *get_insn_slot
 /* Return 1 if all garbages are collected, otherwise 0. */
 static int __kprobes collect_one_slot(struct kprobe_insn_page *kip, int idx)
 {
-	kip->slot_used[idx] = 0;
+	kip->slot_used[idx] = SLOT_CLEAN;
 	kip->nused--;
 	if (kip->nused == 0) {
 		/*
@@ -212,7 +218,7 @@ static int __kprobes collect_garbage_slo
 			continue;
 		kip->ngarbage = 0;	/* we will collect all garbages */
 		for (i = 0; i < INSNS_PER_PAGE; i++) {
-			if (kip->slot_used[i] == -1 &&
+			if (kip->slot_used[i] == SLOT_DIRTY &&
 			    collect_one_slot(kip, i))
 				break;
 		}
@@ -232,7 +238,7 @@ void __kprobes free_insn_slot(kprobe_opc
 		    slot < kip->insns + (INSNS_PER_PAGE * MAX_INSN_SIZE)) {
 			int i = (slot - kip->insns) / MAX_INSN_SIZE;
 			if (dirty) {
-				kip->slot_used[i] = -1;
+				kip->slot_used[i] = SLOT_DIRTY;
 				kip->ngarbage++;
 			} else {
 				collect_one_slot(kip, i);


