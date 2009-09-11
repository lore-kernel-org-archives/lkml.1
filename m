Return-Path: <linux-kernel-owner+w=401wt.eu-S1752914AbZIKLRF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914AbZIKLRF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 07:17:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752653AbZIKLRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 07:17:05 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:54026 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752256AbZIKLRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 07:17:04 -0400
Subject: Re: [2.6.31] Memory leak in load_module()?
From: Catalin Marinas <catalin.marinas@arm.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
In-Reply-To: <200909111958.HFG60925.OOQLHFFVtSJOMF@I-love.SAKURA.ne.jp>
References: <200909111638.IDC17135.FOHJOtFFMQSVLO@I-love.SAKURA.ne.jp>
	 <tnxhbv97rt6.fsf@pc1117.cambridge.arm.com>
	 <200909111958.HFG60925.OOQLHFFVtSJOMF@I-love.SAKURA.ne.jp>
Content-Type: text/plain
Organization: ARM Ltd
Date: Fri, 11 Sep 2009 12:16:58 +0100
Message-Id: <1252667819.29620.7.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Sep 2009 11:16:59.0804 (UTC) FILETIME=[617435C0:01CA32D1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-11 at 19:58 +0900, Tetsuo Handa wrote:
> OK. Here is the output with CONFIG_FRAME_POINTER=y .
> Do I need to enable some other debug options?
> 
> unreferenced object 0xdd7c1718 (size 32):
>   comm "insmod", pid 2859, jiffies 4294757534
>   backtrace:
>     [<c048a210>] create_object+0x135/0x202
>     [<c048a302>] kmemleak_alloc+0x25/0x49
>     [<c04865bd>] kmemleak_alloc_recursive+0x1c/0x22
>     [<c0486e27>] __kmalloc_track_caller+0x66/0xb3
>     [<c0473980>] kstrdup+0x2c/0x4e
>     [<c044716a>] setup_modinfo_srcversion+0x12/0x1b
>     [<c0448725>] load_module+0x866/0x124a
>     [<c0449180>] sys_init_module+0x49/0x1b9
>     [<c0402a24>] sysenter_do_call+0x12/0x22
>     [<ffffffff>] 0xffffffff

The object above was allocated by kstrdup via setup_modinfo_srcversion
but the module loading failed and no other kernel part freed the
mod->filed object. I think it's a real leak but you could try a few
"echo scan" to make sure it's not just a temporary false positive.

(the kmemleak branch on git://linux-arm.org/linux-2.6.git has a patch
which dumps the first few bytes from the object and sometimes this
helps; I'll send a pull request to Linus sometime today)

-- 
Catalin

