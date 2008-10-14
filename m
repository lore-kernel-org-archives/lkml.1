Return-Path: <linux-kernel-owner+w=401wt.eu-S1753758AbYJNRKF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758AbYJNRKF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 13:10:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751944AbYJNRJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 13:09:55 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:2191 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbYJNRJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 13:09:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=pEbq2HWSWJvM2SaWfj7/f/1lMAeJYwgcR/cL/Mw54yVxiLJsXOLv0TllamntB3UWXQ
         JszaqzuYob/OP6hU4QIct8aHjD1Omy2jf/cpFdrDxc9saRF0xBVpisXQpdqTjw7jdvdC
         Jt0w6YWrWWWQG63jrse6ajCwLILnwmBfQS58M=
Message-ID: <86802c440810141009u5cfeee4fme4a9bd7ed0c66d1d@mail.gmail.com>
Date: Tue, 14 Oct 2008 10:09:53 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Shaohua Li" <shaohua.li@intel.com>
Subject: Re: [patch]x86: arch_add_memory round up address
Cc: "Yasunori Goto" <y-goto@jp.fujitsu.com>,
       lkml <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@redhat.com>
In-Reply-To: <20081014073011.GA1556@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440810082340r101f99aem3839d55360451851@mail.gmail.com>
	 <20081009070634.GA12715@sli10-desk.sh.intel.com>
	 <20081014140608.AD63.E1E9C6FF@jp.fujitsu.com>
	 <20081014073011.GA1556@sli10-desk.sh.intel.com>
X-Google-Sender-Auth: ff81495beb07e740
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2008 at 12:30 AM, Shaohua Li <shaohua.li@intel.com> wrote:
> On Tue, Oct 14, 2008 at 01:16:46PM +0800, Yasunori Goto wrote:
>> > On Thu, Oct 09, 2008 at 02:40:34PM +0800, Yinghai Lu wrote:
>> > > On Wed, Oct 8, 2008 at 11:28 PM, Shaohua Li <shaohua.li@intel.com> wrote:
>> > > > On Thu, Oct 09, 2008 at 02:22:50PM +0800, Yinghai Lu wrote:
>> > > >> On Wed, Oct 8, 2008 at 11:08 PM, Shaohua Li <shaohua.li@intel.com> wrote:
>> > > >> > On Thu, 2008-10-09 at 14:04 +0800, Yinghai Lu wrote:
>> > > >> >> On Wed, Oct 8, 2008 at 10:31 PM, Shaohua Li <shaohua.li@intel.com> wrote:
>> > > >> >> > Round up address to a page, otherwise the last page isn't mapped.
>> > > >> >> >
>> > > >> >> > Signed-off-by: Shaohua Li <shaohua.li@intel.com>
>> > > >> >> > ---
>> > > >> >> >  arch/x86/mm/init_64.c |    3 ++-
>> > > >> >> >  1 file changed, 2 insertions(+), 1 deletion(-)
>> > > >> >> >
>> > > >> >> > Index: linux/arch/x86/mm/init_64.c
>> > > >> >> > ===================================================================
>> > > >> >> > --- linux.orig/arch/x86/mm/init_64.c    2008-10-09 11:42:33.000000000 +0800
>> > > >> >> > +++ linux/arch/x86/mm/init_64.c 2008-10-09 11:43:22.000000000 +0800
>> > > >> >> > @@ -721,7 +721,8 @@ int arch_add_memory(int nid, u64 start,
>> > > >> >> >        unsigned long nr_pages = size >> PAGE_SHIFT;
>> > > >> >> >        int ret;
>> > > >> >> >
>> > > >> >> > -       last_mapped_pfn = init_memory_mapping(start, start + size-1);
>> > > >> >> > +       last_mapped_pfn = init_memory_mapping(start,
>> > > >> >> > +               round_up(start + size-1, PAGE_SIZE));
>> > > >> >> >        if (last_mapped_pfn > max_pfn_mapped)
>> > > >> >> >                max_pfn_mapped = last_mapped_pfn;
>> > > >> >>
>> > > >> >> should use
>> > > >> >>
>> > > >> >> last_mapped_pfn = init_memory_mapping(start, start + size);
>> > > >> > No, this still can't guarantee page aligned, though this works in my
>> > > >> > test
>> > > >>
>> > > >> who will call arch_add_memory? that should be start and size already
>> > > >> be page aligned.
>> > > > It's memory hotplug. Doing a round up is always ok and safe even it might be already aligned.
>> > > >
>> > >
>> > > it seems rounding up in that case is wrong...
>> > >
>> > > if the caller call that funtion with extra half page, you don't need
>> > > map that half page, because you can not use it.
>> > shouldn't we mark such page as reserved and so it will not be used? This is the way we handle hole.
>>
>> Just curious,
>> have you ever seen a real machine which needs this patch?
> No, I just did some experiments on a desktop for memory hotplug and this bug
> triggered a crash in my test.
> Yinghai's suggestion also fixed the bug. I just want to have safer method. Anyway, either approach is ok to me.

good, please resubmit updated one with

 last_mapped_pfn = init_memory_mapping(start, start + size);

Thanks

YH
