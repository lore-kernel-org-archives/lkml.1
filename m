Return-Path: <linux-kernel-owner+w=401wt.eu-S1757912AbZAOLjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757912AbZAOLjv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 06:39:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752127AbZAOLjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 06:39:43 -0500
Received: from hera.kernel.org ([140.211.167.34]:33567 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505AbZAOLjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 06:39:42 -0500
Message-ID: <496F2032.5080502@kernel.org>
Date: Thu, 15 Jan 2009 20:38:26 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "H. Peter Anvin" <hpa@zytor.com>, Brian Gerst <brgerst@gmail.com>,
       ebiederm@xmission.com, cl@linux-foundation.org, rusty@rustcorp.com.au,
       travis@sgi.com, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       steiner@sgi.com, hugh@veritas.com
Subject: Re: [patch] add optimized generic percpu accessors
References: <1231843097-18003-1-git-send-email-tj@kernel.org> <496C717F.70204@kernel.org> <73c1f2160901130527s2d61f4ewf0725c3bf1b36a1a@mail.gmail.com> <496C9FB7.9050907@kernel.org> <496D8CEB.5060402@zytor.com> <20090114093834.GA19799@elte.hu> <496F0F50.6070200@kernel.org> <20090115113045.GG22850@elte.hu>
In-Reply-To: <20090115113045.GG22850@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 15 Jan 2009 11:38:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Ingo Molnar wrote:
> The new ops are a pretty nice and clean solution i think.
> 
> Firstly, accessing the current CPU is the only safe shortcut anyway (there 
> is where we can do %fs/%gs / rip-relative addressing modes), and the 
> generic per_cpu() APIs dont really provide that guarantee for us. We might 
> be able to hook into __get_cpu_var() but those both require to be an 
> lvalue and are also relatively rarely used.
> 
> So introducing the new, rather straightforward APIs and using them 
> wherever they matter for performance is good. Your patchset already shaved 
> off an instruction from ordinary per_cpu() accesses, so it's all moving 
> rather close to the most-optimal situation already.

Yeah, I don't think we can do much better than those ops.  I have two
issues tho.

1. percpu_and() is missing.  I added it for completeness's sake.

2. The generic percpu_op() should be local to the cpu, so it should
   expand to...

   do { get_cpu_var(var) OP (val); put_cpu_var(var) } while (0)

   as the original x86_OP_percpu() did.  Right?

Thanks.

-- 
tejun
