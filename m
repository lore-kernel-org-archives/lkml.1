Return-Path: <linux-kernel-owner+w=401wt.eu-S1759313AbZCWQku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759313AbZCWQku (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 12:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758420AbZCWQkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 12:40:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:39946 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756722AbZCWQkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 12:40:23 -0400
Date: Mon, 23 Mar 2009 16:39:26 GMT
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, jeremy.fitzhardinge@citrix.com, jeremy@goop.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, jeremy.fitzhardinge@citrix.com, jeremy@goop.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49C6B23C.2040308@goop.org>
References: <49C6B23C.2040308@goop.org>
Subject: [tip:x86/setup] x86/dmi: fix dmi_alloc() section mismatches
Message-ID: <tip-c8608d6b58981a58ca4aee8308576666c5f7ab0c@git.kernel.org>
Git-Commit-ID: c8608d6b58981a58ca4aee8308576666c5f7ab0c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 23 Mar 2009 16:39:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c8608d6b58981a58ca4aee8308576666c5f7ab0c
Gitweb:     http://git.kernel.org/tip/c8608d6b58981a58ca4aee8308576666c5f7ab0c
Author:     Jeremy Fitzhardinge <jeremy@goop.org>
AuthorDate: Sun, 22 Mar 2009 14:48:44 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 23 Mar 2009 17:20:50 +0100

x86/dmi: fix dmi_alloc() section mismatches

Impact: section mismatch fix

Ingo reports these warnings:
> WARNING: vmlinux.o(.text+0x6a288e): Section mismatch in reference from
> the function dmi_alloc() to the function .init.text:extend_brk()
> The function dmi_alloc() references
> the function __init extend_brk().
> This is often because dmi_alloc lacks a __init annotation or the
> annotation of extend_brk is wrong.

dmi_alloc() is a static inline, and so should be immune to this
kind of error.  But force it to be inlined and make it __init
anyway, just to be extra sure.

All of dmi_alloc()'s callers are already __init.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <49C6B23C.2040308@goop.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/dmi.h |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/dmi.h b/arch/x86/include/asm/dmi.h
index aa32f7e..fd8f9e2 100644
--- a/arch/x86/include/asm/dmi.h
+++ b/arch/x86/include/asm/dmi.h
@@ -1,10 +1,13 @@
 #ifndef _ASM_X86_DMI_H
 #define _ASM_X86_DMI_H
 
+#include <linux/compiler.h>
+#include <linux/init.h>
+
 #include <asm/io.h>
 #include <asm/setup.h>
 
-static inline void *dmi_alloc(unsigned len)
+static __always_inline __init void *dmi_alloc(unsigned len)
 {
 	return extend_brk(len, sizeof(int));
 }
