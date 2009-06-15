Return-Path: <linux-kernel-owner+w=401wt.eu-S1752485AbZFOCMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485AbZFOCMv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 22:12:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751006AbZFOCMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 22:12:44 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:23168 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbZFOCMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 22:12:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Y7YmUnUliAcH16bx0w/GS3gFmf8I6WLZfhSz0Zal/HR5GO8vjmAd3Xo8/D1d7vmqNs
         UuTYhPQ1f6aUs6zMXoXsln+nLnA4kStdAYHrJLi8LG+XLsUMudddz9Xb48hv3IoeAAPG
         gXmrhfC1MlRHq2JMy5O4HMLCfdXdmjkpNbLmY=
Date: Mon, 15 Jun 2009 10:14:57 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Amerigo Wang <xiyou.wangcong@gmail.com>, Tao Ma <tao.ma@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [Patch BUGFIX] kcore: fix its wrong size on x86_64
Message-ID: <20090615021457.GA3388@cr0.nay.redhat.com>
References: <20090608015242.GB2596@cr0.nay.redhat.com> <4A2CA96D.3090502@oracle.com> <2375c9f90906072341o2cded749m45bdddfdb499469@mail.gmail.com> <4A2CC52B.9010602@oracle.com> <2375c9f90906081743p77934f47n8ba1a018d333b95b@mail.gmail.com> <m1ab4i11zx.fsf@fess.ebiederm.org> <20090611050929.GA2706@cr0.nay.redhat.com> <m11vpqvozl.fsf@fess.ebiederm.org> <20090613040958.GA2959@cr0> <m17hzg7oil.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m17hzg7oil.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 09:20:50PM -0700, Eric W. Biederman wrote:
>Amerigo Wang <xiyou.wangcong@gmail.com> writes:
>
>> Fix wrong /proc/kcore size on x86_64.
>
>How does that change anything?

Please check the description below.

>
>> x86_64 uses __va() macro to caculate the virtual address passed to kclist_add()
>> but decodes it with its own macro kc_vadd_to_offset(). This is wrong.
>>
>> Also, according to Documentation/x86/x86_64/mm.txt, kc_vaddr_to_offset()
>> is wrong too.
>>
>> So just remove them, use the generic macro.
>>
>> BTW, the man page for /proc/kcore is wrong, its size can be more than
>> the physical memory size, because it also contains memory area of
>> vmalloc(), vsyscall etc...
>
>The set of offsets that are usable sure.

We have generic kc_vaddr_to_offset() etc. in fs/proc/kcore.c.


>
>However the size from stat is:
>          proc_root_kcore->size = (size_t)high_memory - PAGE_OFFSET + PAGE_SIZE;
>
>Which can not be different than the physical memory size.

I never say this is not different, of course they are same, but what Tao
reported is the wrong size after a read operation, please try the following:

#ls -l /proc/kcore
#readelf -l /proc/kcore
#ls -l /proc/kcore

You will find the *second* 'ls -l /proc/kcore' reports a size much more
than the physical mem size.

And you will notice the difference of it after this patch applied.

