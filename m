Return-Path: <linux-kernel-owner+w=401wt.eu-S1750881Ab0AUFAH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750881Ab0AUFAH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 00:00:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753399Ab0AUE76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 23:59:58 -0500
Received: from mail-px0-f182.google.com ([209.85.216.182]:49961 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708Ab0AUE76 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 23:59:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=abXG4eAflwg/FrTZkm97qbO3H3P/+q/PKbVB2fpabt0mblzfrMNHqZYhb1KZpjrVpO
         y3PjgeehSWHyqQbIwbcOerFEKl3rFC7Tiy+WepiOxpOfnY176NRvmkR0JNfruMfkUfze
         tNXPMxizT4EVI4M+VO4wbyCmt2DK749p/l3w4=
MIME-Version: 1.0
In-Reply-To: <20100121094733.3778.A69D9226@jp.fujitsu.com>
References: <20100120174630.4071.A69D9226@jp.fujitsu.com>
	 <20100120095242.GA5672@desktop>
	 <20100121094733.3778.A69D9226@jp.fujitsu.com>
Date: Thu, 21 Jan 2010 12:59:57 +0800
Message-ID: <979dd0561001202059v1870870oaa4df876aa12a756@mail.gmail.com>
Subject: Re: cache alias in mmap + write
From: anfei zhou <anfei.zhou@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux@arm.linux.org.uk,
       jamie@shareable.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 21, 2010 at 9:10 AM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> On Wed, Jan 20, 2010 at 06:10:11PM +0900, KOSAKI Motohiro wrote:
>> > Hello,
>> >
>> > > diff --git a/mm/filemap.c b/mm/filemap.c
>> > > index 96ac6b0..07056fb 100644
>> > > --- a/mm/filemap.c
>> > > +++ b/mm/filemap.c
>> > > @@ -2196,6 +2196,9 @@ again:
>> > >           if (unlikely(status))
>> > >                   break;
>> > >
>> > > +         if (mapping_writably_mapped(mapping))
>> > > +                 flush_dcache_page(page);
>> > > +
>> > >           pagefault_disable();
>> > >           copied = iov_iter_copy_from_user_atomic(page, i, offset, bytes);
>> > >           pagefault_enable();
>> >
>> > I'm not sure ARM cache coherency model. but I guess correct patch is here.
>> >
>> > +           if (mapping_writably_mapped(mapping))
>> > +                   flush_dcache_page(page);
>> > +
>> >             pagefault_disable();
>> >             copied = iov_iter_copy_from_user_atomic(page, i, offset, bytes);
>> >             pagefault_enable();
>> > -           flush_dcache_page(page);
>> >
>> > Why do we need to call flush_dcache_page() twice?
>> >
>> The latter flush_dcache_page is used to flush the kernel changes
>> (iov_iter_copy_from_user_atomic), which makes the userspace to see the
>> write,  and the one I added is used to flush the userspace changes.
>> And I think it's better to split this function into two:
>>       flush_dcache_user_page(page);
>>       kmap_atomic(page);
>>       write to  page;
>>       kunmap_atomic(page);
>>       flush_dcache_kern_page(page);
>> But currently there is no such API.
>
> Why can't we create new api? this your pseudo code looks very fine to me.
>
I will resend the patch, if this patch is acceptable, I will create
another patch
to introduce this new API.
>
> note: if you don't like to create new api. I can agree your current patch.
> but I have three requests.
>  1. Move flush_dcache_page() into iov_iter_copy_from_user_atomic().
>    Your above explanation indicate it is real intention. plus, change
>    iov_iter_copy_from_user_atomic() fixes fuse too.

There is a check on mapping, that's not passed into
iov_iter_copy_from_user_atomic, and this function is only called a few places,
So I just add flush_dcache_page directly.

>  2. Add some commnet. almost developer only have x86 machine. so, arm
>    specific trick need additional explicit explanation. otherwise anybody
>    might break this code in the future.
>  3. Resend the patch. original mail isn't good patch format. please consider
>    to reduce akpm suffer.
>
I will send it soon.

Thanks,
Anfei.
>
>
>
