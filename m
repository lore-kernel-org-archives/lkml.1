Return-Path: <linux-kernel-owner+w=401wt.eu-S1754672AbYG1NPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbYG1NPl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 09:15:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751192AbYG1NPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 09:15:32 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:64718 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750728AbYG1NPb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 09:15:31 -0400
Date: Mon, 28 Jul 2008 22:14:44 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Huang Ying <ying.huang@intel.com>, Vivek Goyal <vgoyal@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, ebiederm@xmission.com,
       linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: sh kexec build error
Message-ID: <20080728131444.GA15942@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian Bunk <bunk@kernel.org>, Huang Ying <ying.huang@intel.com>,
	Vivek Goyal <vgoyal@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>, ebiederm@xmission.com,
	linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080728130613.GB30612@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080728130613.GB30612@cs181140183.pp.htv.fi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2008 at 04:06:13PM +0300, Adrian Bunk wrote:
> Commit 3ab83521378268044a448113c6aa9a9e245f4d2f (kexec jump)
> causes the following build error on sh:
> 
> <--  snip  -->
> 
> ...
>   CC      kernel/kexec.o
> {standard input}: Assembler messages:
> {standard input}:1518: Error: offset to unaligned destination
> make[2]: *** [kernel/kexec.o] Error 1
> 
> <--  snip  -->
> 
> If I understand the assembler correctly it fails at
> include/asm-sh/kexec.h:59
> 
Indeed. This should fix it:

---

diff --git a/include/asm-sh/processor_32.h b/include/asm-sh/processor_32.h
index c6583f2..0dadd75 100644
--- a/include/asm-sh/processor_32.h
+++ b/include/asm-sh/processor_32.h
@@ -19,7 +19,7 @@
  * Default implementation of macro that returns current
  * instruction pointer ("program counter").
  */
-#define current_text_addr() ({ void *pc; __asm__("mova	1f, %0\n1:":"=z" (pc)); pc; })
+#define current_text_addr() ({ void *pc; __asm__("mova	1f, %0\n.align 2\n1:":"=z" (pc)); pc; })
 
 /* Core Processor Version Register */
 #define CCN_PVR		0xff000030
