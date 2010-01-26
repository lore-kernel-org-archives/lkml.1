Return-Path: <linux-kernel-owner+w=401wt.eu-S1752611Ab0AZBBN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611Ab0AZBBN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 20:01:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751325Ab0AZBBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 20:01:12 -0500
Received: from mail-pz0-f189.google.com ([209.85.222.189]:33231 "EHLO
	mail-pz0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084Ab0AZBBL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 20:01:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HPjGjDxmjhWyv/qisyduJf/4MUqpduf1oUSgwfOODn5u/9Dzyoykvq+mYTLj1fy2J7
         UMoqsDETVXFpZAwY3Vst/O1f96xfHIqGBe6zysZrdXox0j4YDKvGAJG6BcVKFsEtjva5
         p7///0vyAHC+bKVxdUjU3kISqIK39CozCpBMw=
MIME-Version: 1.0
In-Reply-To: <20100125115814.156d401d.akpm@linux-foundation.org>
References: <979dd0561001202107v4ddc1eb7xa59a7c16c452f7a2@mail.gmail.com>
	 <20100125133308.GA26799@desktop>
	 <20100125115814.156d401d.akpm@linux-foundation.org>
Date: Tue, 26 Jan 2010 09:01:10 +0800
Message-ID: <979dd0561001251701y76f35b8as545c390135b34da2@mail.gmail.com>
Subject: Re: [PATCH] Flush dcache before writing into page to avoid alias
From: anfei zhou <anfei.zhou@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux@arm.linux.org.uk, Jamie Lokier <jamie@shareable.org>,
       linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26, 2010 at 3:58 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Mon, 25 Jan 2010 21:33:08 +0800 anfei <anfei.zhou@gmail.com> wrote:
>
>> Hi Andrew,
>>
>> On Thu, Jan 21, 2010 at 01:07:57PM +0800, anfei zhou wrote:
>> > The cache alias problem will happen if the changes of user shared mapping
>> > is not flushed before copying, then user and kernel mapping may be mapped
>> > into two different cache line, it is impossible to guarantee the coherence
>> > after iov_iter_copy_from_user_atomic.  So the right steps should be:
>> >     flush_dcache_page(page);
>> >     kmap_atomic(page);
>> >     write to page;
>> >     kunmap_atomic(page);
>> >     flush_dcache_page(page);
>> > More precisely, we might create two new APIs flush_dcache_user_page and
>> > flush_dcache_kern_page to replace the two flush_dcache_page accordingly.
>> >
>> > Here is a snippet tested on omap2430 with VIPT cache, and I think it is
>> > not ARM-specific:
>> >     int val = 0x11111111;
>> >     fd = open("abc", O_RDWR);
>> >     addr = mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
>> >     *(addr+0) = 0x44444444;
>> >     tmp = *(addr+0);
>> >     *(addr+1) = 0x77777777;
>> >     write(fd, &val, sizeof(int));
>> >     close(fd);
>> > The results are not always 0x11111111 0x77777777 at the beginning as expected.
>> >
>> Is this a real bug or not necessary to support?
>
> Bug.  If variable `addr' has type int* then the contents of that file
> should be 0x11111111 0x77777777.  You didn't tell us what the contents
> were in the incorrect case, but I guess it doesn't matter.
>
Sorry, I didn't give the details, here is the old thread with more details:
  http://linux.derkeiler.com/Mailing-Lists/Kernel/2010-01/msg07124.html

Regards,
Anfei.
>
>
