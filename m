Return-Path: <linux-kernel-owner+w=401wt.eu-S1754611AbZIUX54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611AbZIUX54 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 19:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754532AbZIUX5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 19:57:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6301 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754317AbZIUX5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 19:57:54 -0400
Date: Mon, 21 Sep 2009 17:40:47 -0400
From: Dave Jones <davej@redhat.com>
To: Siarhei Liakh <sliakh.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-next@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH v6] RO/NX protection for loadable kernel modules
Message-ID: <20090921214046.GA17243@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Siarhei Liakh <sliakh.lkml@gmail.com>, linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-next@vger.kernel.org,
	Arjan van de Ven <arjan@infradead.org>,
	James Morris <jmorris@namei.org>,
	Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Stephen Rothwell <sfr@canb.auug.org.au>
References: <817ecb6f0909101950v2fc6dc6u5cbc40cd9a9dde77@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <817ecb6f0909101950v2fc6dc6u5cbc40cd9a9dde77@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 10, 2009 at 10:50:47PM -0400, Siarhei Liakh wrote:
 > This patch is a logical extension of the protection provided by
 > CONFIG_DEBUG_RODATA to LKMs. The protection is provided by splitting
 > module_core and module_init into three logical parts each and setting
 > appropriate page access permissions for each individual section:
 > 
 >  1. Code: RO+X
 >  2. RO data: RO+NX
 >  3. RW data: RW+NX

Hi Siarhei,
 I tried out this patch on 2.6.31, and got the following trace during bootup..

------------[ cut here ]------------
WARNING: at kernel/trace/ftrace.c:1003 ftrace_bug+0x198/0x27e() (Not tainted)
Hardware name: VGN-Z540N
Modules linked in: output(+)
Pid: 115, comm: modprobe Not tainted 2.6.31-23.fc12.x86_64 #1
Call Trace:
 [<ffffffff81064244>] warn_slowpath_common+0x95/0xc3
 [<ffffffffa0000193>] ? video_output_register+0x11/0x10a [output]
 [<ffffffff81064299>] warn_slowpath_null+0x27/0x3d
 [<ffffffff810d4a0e>] ftrace_bug+0x198/0x27e
 [<ffffffffa0000193>] ? video_output_register+0x11/0x10a [output]
 [<ffffffff810d5c66>] ftrace_convert_nops+0x201/0x2b9
 [<ffffffffa0000193>] ? video_output_register+0x11/0x10a [output]
 [<ffffffff810d5d6a>] ftrace_module_notify+0x4c/0x7f
 [<ffffffff815099c5>] notifier_call_chain+0x72/0xba
 [<ffffffff81086db1>] ? __blocking_notifier_call_chain+0x4c/0x8e
 [<ffffffff81086dc8>] __blocking_notifier_call_chain+0x63/0x8e
 [<ffffffff81086e1a>] blocking_notifier_call_chain+0x27/0x3d
 [<ffffffff810a466a>] sys_init_module+0xb7/0x249
 [<ffffffff81011f42>] system_call_fastpath+0x16/0x1b
---[ end trace 95b33ebf87286ae6 ]---
ftrace faulted on writing [<ffffffffa0000193>] video_output_register+0x11/0x10a [output]


I guess ftrace is trying to NOP out something in the modules which
are marked read-only ?

	Dave

