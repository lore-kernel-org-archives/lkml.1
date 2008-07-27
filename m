Return-Path: <linux-kernel-owner+w=401wt.eu-S1758074AbYG0Pmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758074AbYG0Pmo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 11:42:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752046AbYG0Pmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 11:42:36 -0400
Received: from gw.goop.org ([64.81.55.164]:57302 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751070AbYG0Pmg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 11:42:36 -0400
Message-ID: <488C9768.8090000@goop.org>
Date: Sun, 27 Jul 2008 08:42:32 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH] x86: fix initialization of 'l' bit in ldt descriptors
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure that fill_ldt() initializes the 'l' bit in the descriptor.
It always sets it to 0, ignoring 'lm' in user_desc, preserving original
x86_64 behaviour.

Previously it was leaving 'l' uninitialized.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 include/asm-x86/desc.h |    5 +++++
 1 file changed, 5 insertions(+)

diff -r c79984cfb996 include/asm-x86/desc.h
--- a/include/asm-x86/desc.h	Fri Jul 25 16:09:12 2008 -0700
+++ b/include/asm-x86/desc.h	Sun Jul 27 08:31:08 2008 -0700
@@ -24,6 +24,9 @@
 	desc->d = info->seg_32bit;
 	desc->g = info->limit_in_pages;
 	desc->base2 = (info->base_addr & 0xff000000) >> 24;
+	/* Don't allow setting of the lm bit. It is useless anyways
+	   because 64bit system calls require __USER_CS. */
+	desc->l = 0;
 }
 
 extern struct desc_ptr idt_descr;


