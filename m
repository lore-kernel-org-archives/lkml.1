Return-Path: <linux-kernel-owner+w=401wt.eu-S1756026AbZJFFEM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026AbZJFFEM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 01:04:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753054AbZJFFEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 01:04:11 -0400
Received: from mail-yx0-f199.google.com ([209.85.210.199]:41489 "EHLO
	mail-yx0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253AbZJFFEK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 01:04:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Mtd4HpFgCBELdDc7DMP1Ow2ZaZYuhZyhRosiG+NM6pnadFQPSKoSGDt6HyqvGtPwsy
         uRR+aBQ9UWzJ3h+IYyR+QTzBFi9WV0LhdCIbv5q6IVh4rZ4T4hEq3hwMz0B0ZInXhAyZ
         JVP2qtftj6vTyBCej1ZRvN6/eY0lDXMR8SwE8=
MIME-Version: 1.0
In-Reply-To: <1254803939.14541.49.camel@macbook.infradead.org>
References: <8bd0f97a0910052125m4327fef3i47e3b549938802f9@mail.gmail.com> 
	<1254803939.14541.49.camel@macbook.infradead.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 6 Oct 2009 00:56:19 -0400
Message-ID: <8bd0f97a0910052156o7aeb704cpf72586ca2e196277@mail.gmail.com>
Subject: Re: userspace firmware loader, vmap, and nommu
To: David Woodhouse <dwmw2@infradead.org>
Cc: David Howells <dhowells@redhat.com>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       uclinux-dist-devel <uclinux-dist-devel@blackfin.uclinux.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 6, 2009 at 00:38, David Woodhouse wrote:
> On Tue, 2009-10-06 at 00:25 -0400, Mike Frysinger wrote:
>>  the firmware loader used to work before this
>> change because it would handle the realloc steps itself (allocate
>> larger contiguous memory, copy over older data, release older memory)
>> and vmalloc() on nommu is simply kmalloc().
>>
>> this could be handled transparently on nommu systems by moving this
>> scatter gathering of pages into vmap:
>> void *vmap(struct page **pages, unsigned int count, unsigned long
>> flags, pgprot_t prot)
>> {
>>     unsigned int i;
>>     void *new_map, *page_data;
>>
>>     new_map = kmalloc(count << PAGE_SHIFT, GFP_KERNEL);
>>     if (!new_map)
>>         return NULL;
>>
>>     for (i = 0; i < count; ++i) {
>>         page_data = kmap(pages[i]);
>>         memcpy(new_map + (i << PAGE_SHIFT), page_data, PAGE_SIZE);
>>         kunmap(page_data);
>>     }
>>
>>     return new_map;
>
> I wouldn't necessarily want to do that for _all_ vmap() calls,

there arent any vmap() callers currently on nommu systems since the
functions currently BUG().  looking at lxr for 2.6.31 indicates that
there are very few relevant vmap() callers in general.

> but doing
> it just for the firmware loader might make some sense. It does mean you
> have to have _twice_ as much memory available as the size of the
> firmware in question. And you have to have a contiguous chunk even
> _after_ allocating it once piecemeal.

yes, but this is how it worked before and no one complained ;).
firmware files after all tend to be on the "small" side, so getting a
small physically contiguous mapping isnt that hard.

>> void vunmap(const void *addr)
>> {
>>     kfree(addr);
>> }
>>
>> or we could add nommu-specific code to the firmware loader to not use
>> vmap().  how would you like to go David (Howells) ?
>
> Or we could add _generic_ code not to use vmap(). Just teach the users
> that you don't get a virtually contiguous blob back from
> request_firmware(); you get an array of pages instead.

wouldnt that non-trivially increase the code work for callers of the
firmware functions ?  seems like a hefty penalty for a minority
(nommu) to impose on the majority (mmu).
-mike
