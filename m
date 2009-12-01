Return-Path: <linux-kernel-owner+w=401wt.eu-S1753292AbZLAOut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292AbZLAOut (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 09:50:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751944AbZLAOus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 09:50:48 -0500
Received: from hera.kernel.org ([140.211.167.34]:37792 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751898AbZLAOur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 09:50:47 -0500
Message-ID: <4B152D22.9070001@kernel.org>
Date: Tue, 01 Dec 2009 23:50:10 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: michal.simek@petalogix.com, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: problems in linux-next (Was: Re: linux-next: Tree for December
 1)
References: <20091201190301.0fb7abad.sfr@canb.auug.org.au>	<4B14D6E2.2040704@petalogix.com> <20091201210343.f0a1d353.sfr@canb.auug.org.au>
In-Reply-To: <20091201210343.f0a1d353.sfr@canb.auug.org.au>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/01/2009 07:03 PM, Stephen Rothwell wrote:
>> WARNING: at include/linux/percpu.h:157 __create_workqueue_key+0x1c0/0x1d0()
>> Modules linked in:

Argh... The warning is about requested alignment larger than
SMP_CACHE_BYTES.  93fba1c02ec10870a9d41085ef036b6a44cb0234 aligns cwqs
to 8 bytes and later one will push it to 128 bytes so that color codes
for flushes can be put there too.  As the number of cwqs will be
significantly reduced and cwq is supposed to be aligned to cacheline
anyway, 128 byte alignment in itself isn't too bad and percpu
allocator can handle it just fine.

The problem is that on UP configurations.  Percpu memory allocator
becomes a simple wrapper around kmalloc and there's no way to specify
larger alignment when requesting memory from kmalloc.

It would be best if there's a clean way to allocate memory with
alignment larger than SMP_CACHE_BYTES.  If not, I think I'll add a
separate cache for cwqs on UP so that the alignment requirement can be
met.  Is there any way to get better aligned memory without creating a
separate cache or allocating larger memory and aligning by chopping
off?

Thanks.

-- 
tejun
