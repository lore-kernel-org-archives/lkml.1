Return-Path: <linux-kernel-owner+w=401wt.eu-S1755210AbZJVLhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210AbZJVLhZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 07:37:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754812AbZJVLhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 07:37:24 -0400
Received: from kuber.nabble.com ([216.139.236.158]:40520 "EHLO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754802AbZJVLhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 07:37:23 -0400
Message-ID: <26008418.post@talk.nabble.com>
Date: Thu, 22 Oct 2009 04:37:28 -0700 (PDT)
From: pajko <kpajko79@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v4 9/9] tracing: add function graph tracer support for
 MIPS
In-Reply-To: <53bdfdd95ec4fa00d4cc505bb5972cf21243a14d.1256135456.git.wuzhangjin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Nabble-From: kpajko79@gmail.com
References: <028867b99ec532b84963a35e7d552becc783cafc.1256135456.git.wuzhangjin@gmail.com> <2f73eae542c47ac5bbb9f7280e6c0271d193e90d.1256135456.git.wuzhangjin@gmail.com> <3f0d3515f74a58f4cfd11e61b62a129fdc21e3a7.1256135456.git.wuzhangjin@gmail.com> <96110ea5dd4d3d54eb97d0bb708a5bd81c7a50b5.1256135456.git.wuzhangjin@gmail.com> <af3ec1b5cd06b6f6a461c9fa7d09a51fabccb08d.1256135456.git.wuzhangjin@gmail.com> <a6f2959a69b6a77dd32cc36a5c8202f97d524f1e.1256135456.git.wuzhangjin@gmail.com> <53bdfdd95ec4fa00d4cc505bb5972cf21243a14d.1256135456.git.wuzhangjin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Wu Zhangjin wrote:
> 
> 
> in MIPS, gcc(with -pg) only transfer the caller's return address(at) and
> the _mcount's return address(ra) to us.
> 
> move at, ra
> jal _mcount
> 
> in the function is a leaf, it will no save the return address(ra):
> 
> ffffffff80101298 <au1k_wait>:
> ffffffff80101298:       67bdfff0        daddiu  sp,sp,-16
> ffffffff8010129c:       ffbe0008        sd      s8,8(sp)
> ffffffff801012a0:       03a0f02d        move    s8,sp
> ffffffff801012a4:       03e0082d        move    at,ra
> ffffffff801012a8:       0c042930        jal     ffffffff8010a4c0 <_mcount>
> ffffffff801012ac:       00020021        nop
> 
> so, we can hijack it directly in _mcount, but if the function is non-leaf,
> the
> return address is saved in the stack.
> 
> ffffffff80133030 <copy_process>:
> ffffffff80133030:       67bdff50        daddiu  sp,sp,-176
> ffffffff80133034:       ffbe00a0        sd      s8,160(sp)
> ffffffff80133038:       03a0f02d        move    s8,sp
> ffffffff8013303c:       ffbf00a8        sd      ra,168(sp)
> ffffffff80133040:       ffb70098        sd      s7,152(sp)
> ffffffff80133044:       ffb60090        sd      s6,144(sp)
> ffffffff80133048:       ffb50088        sd      s5,136(sp)
> ffffffff8013304c:       ffb40080        sd      s4,128(sp)
> ffffffff80133050:       ffb30078        sd      s3,120(sp)
> ffffffff80133054:       ffb20070        sd      s2,112(sp)
> ffffffff80133058:       ffb10068        sd      s1,104(sp)
> ffffffff8013305c:       ffb00060        sd      s0,96(sp)
> ffffffff80133060:       03e0082d        move    at,ra
> ffffffff80133064:       0c042930        jal     ffffffff8010a4c0 <_mcount>
> ffffffff80133068:       00020021        nop
> 
> but we can not get the exact stack address(which saved ra) directly in
> _mcount, we need to search the content of at register in the stack space
> or search the "s{d,w} ra, offset(sp)" instruction in the text. 'Cause we
> can not prove there is only a match in the stack space, so, we search
> the text instead.
> 
> 

All this stuff can be avoided having PROFILE_BEFORE_PROLOGUE enabled in GCC
(gcc/config/mips/mips.h), like it is done one several other architectures.
Some of them even require it to be set for a working _mcount. 
Putting the call of _mcount before the function prologue should make no harm
(it's working for me), and this way RA can be hooked for function graph
tracing
before it is saved to stack in the function prologue. Thus there will be no
difference between leaf and non-leaf functions.
This change is no big deal as GCC has to be patched anyway to get dynamic
ftracing (and with 4.2.1 I had to patch it to get ftracing in modules
working
- using -mlong-calls -, but it's possible that this is fixed in the newer
releases).

Regards,
Patrik

-- 
View this message in context: http://www.nabble.com/-PATCH--v4-1-9--tracing%3A-convert-trace_clock_local%28%29-as-weak-function-tp25993719p26008418.html
Sent from the linux-kernel mailing list archive at Nabble.com.

