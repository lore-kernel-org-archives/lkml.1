Return-Path: <linux-kernel-owner+w=401wt.eu-S1757039AbYBKQmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757039AbYBKQmq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 11:42:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757577AbYBKQme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 11:42:34 -0500
Received: from gecko.sbs.de ([194.138.37.40]:21570 "EHLO gecko.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755344AbYBKQmd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 11:42:33 -0500
Message-ID: <47B07AAC.9080802@siemens.com>
Date: Mon, 11 Feb 2008 17:41:16 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Frank Ch. Eigler" <fche@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] kgdb-light -v8,
References: <20080211015321.GA27376@one.firstfloor.org> <y0mhcgf4ig1.fsf@ton.toronto.redhat.com> <20080211162141.GA31434@elte.hu>
In-Reply-To: <20080211162141.GA31434@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> In any case, if there are any open issues we are very much ready and 
> willing to address them now or after any potential upstream merge of 
> this codebase. This has meanwhile become one of the best-reviewed pieces 
> of kernel code in living memory ;-)
> 

I spotted one... :)

> +int __weak kgdb_validate_break_address(unsigned long addr)
> +{
> +	char tmp_variable[BREAK_INSTR_SIZE];
> +
> +	return probe_kernel_read((char *)addr, tmp_variable, BREAK_INSTR_SIZE);

...dst and src are twisted. Fix below (should make sw-breakpoints work
again).

Jan


diff --git a/kernel/kgdb.c b/kernel/kgdb.c
index dce89d1..10fe113 100644
--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -153,14 +153,14 @@ int __weak kgdb_validate_break_address(unsigned long addr)
 {
 	char tmp_variable[BREAK_INSTR_SIZE];
 
-	return probe_kernel_read((char *)addr, tmp_variable, BREAK_INSTR_SIZE);
+	return probe_kernel_read(tmp_variable, (char *)addr, BREAK_INSTR_SIZE);
 }
 
 int __weak kgdb_arch_set_breakpoint(unsigned long addr, char *saved_instr)
 {
 	int err;
 
-	err = probe_kernel_read((char *)addr, saved_instr, BREAK_INSTR_SIZE);
+	err = probe_kernel_read(saved_instr, (char *)addr, BREAK_INSTR_SIZE);
 	if (err)
 		return err;
 

