Return-Path: <linux-kernel-owner+w=401wt.eu-S1757671AbXIIOnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757671AbXIIOnx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 10:43:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756164AbXIIOno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 10:43:44 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:61320 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554AbXIIOnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 10:43:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=ijFaKdT2UmVUSVbOe7DFrAlLLmy8tnVrWOT8BOvqhWLzOBddbRVKGGB4q6rL155vcshcRbAzE0vEh17pTavV6Ovjy1xAA6DnC4fLjDdmixjgBsd0IUq688GglUZqd+zU6ooZRPH2MlzVwdLU+m8M88onn4/oSIaHYATShgunN1A=
Message-ID: <46E40699.7060000@gmail.com>
Date: Sun, 09 Sep 2007 16:43:37 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sourceforge.net, airlied@linux.ie
Subject: Re: X freezes kernel during exit [Re: 2.6.23-rc3-mm1]
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <46D17A7A.70609@gmail.com> <46D409FC.1070305@gmail.com> <46E3DCB8.5010709@gmail.com> <20070909054751.cbb27081.akpm@linux-foundation.org> <46E3FE6B.7010209@gmail.com> <20070909141730.GB25798@one.firstfloor.org> <46E4028E.9050007@gmail.com> <20070909143324.GC25798@one.firstfloor.org>
In-Reply-To: <20070909143324.GC25798@one.firstfloor.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2007 04:33 PM, Andi Kleen wrote:
> On Sun, Sep 09, 2007 at 04:26:22PM +0200, Jiri Slaby wrote:
>> BTW it is reproducible for me on two different machines (i386-x86_64,
>> radeon-intel), don't you have the problem too?
> 
> No problems here with a radeon, no.
> 
> Does your CPU have clflush or not in /proc/cpuinfo?

BTW this is how my flush_kernel_map looks like:

static void flush_kernel_map(void *arg)
{
        struct flush_arg *a = (struct flush_arg *)arg;
        struct page *pg;
        unsigned int xx = 0;

        /* When clflush is available use it because it is
           much cheaper than WBINVD. */
        printk("%s: 1\n", __func__);
        if (a->full_flush || !cpu_has_clflush)
                asm volatile("wbinvd" ::: "memory");
        else list_for_each_entry(pg, &a->l, lru) {
        printk("%s: %10u 1a\n", __func__, xx++);
                if (PageFlush(pg))
                        clflush_cache_range(page_address(pg), PAGE_SIZE);
        }
        printk("%s: 2\n", __func__);
        __flush_tlb_all();
        printk("%s: 3\n", __func__);
}

It outputs 1a in the infinite loop with incrementing xx. But only in this case,
some global_flush_tlb are OK. e.g.:
Sep 10 01:39:19 localhost kernel: agpgart: Detected an Intel G33 Chipset.
Sep 10 01:39:19 localhost kernel: global_flush_tlb: 1
Sep 10 01:39:19 localhost kernel: flush_kernel_map: 1
Sep 10 01:39:19 localhost kernel: flush_kernel_map:          0 1a
Sep 10 01:39:19 localhost kernel: flush_kernel_map:          1 1a
Sep 10 01:39:19 localhost kernel: flush_kernel_map: 2
Sep 10 01:39:19 localhost kernel: flush_kernel_map: 3
Sep 10 01:39:19 localhost kernel: flush_kernel_map: 1
Sep 10 01:39:19 localhost kernel: flush_kernel_map:          0 1a
Sep 10 01:39:19 localhost kernel: flush_kernel_map:          1 1a
Sep 10 01:39:19 localhost kernel: flush_kernel_map: 2
Sep 10 01:39:19 localhost kernel: flush_kernel_map: 3
Sep 10 01:39:19 localhost kernel: global_flush_tlb: 2
Sep 10 01:39:19 localhost kernel: global_flush_tlb: 3
Sep 10 01:39:19 localhost kernel: agpgart: Detected 6140K stolen memory.

It seems, that the list is broken only on X shutdown. How can be deferred-pages
list inited in some bad manner, when list_replace_init is called on it? Weird.

-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
