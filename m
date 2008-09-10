Return-Path: <linux-kernel-owner+w=401wt.eu-S1753371AbYIJR1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbYIJR1w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 13:27:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751446AbYIJR1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 13:27:45 -0400
Received: from gw.goop.org ([64.81.55.164]:43364 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208AbYIJR1o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 13:27:44 -0400
Message-ID: <48C8038B.40107@goop.org>
Date: Wed, 10 Sep 2008 10:27:39 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Avi Kivity <avi@qumranet.com>, Ingo Molnar <mingo@elte.hu>,
       Xen Devel <xen-devel@lists.xensource.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Xen-devel] Re: [PATCH 1 of 7] x86: add _PAGE_IOMAP pte flag
 for IO mappings
References: <4d93ba619c716c45cca0.1220826073@localhost> <48C7998D.1030408@qumranet.com> <48C7F80C.6000807@goop.org> <200809110255.03580.nickpiggin@yahoo.com.au>
In-Reply-To: <200809110255.03580.nickpiggin@yahoo.com.au>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> It complements vm_normal_page, which was there first (and coined by
> Linus). It is the opposite of normal. This question always comes up
> and my answer is always yes, if you can convince Linus to rename
> vm_normal_page to the corresponding term :)
>   

Not really.  Normal is normal, but "special" doesn't tell us what kind
of special it is.

> It's not exactly _PAGE_NOSTRUCTPAGE. There can be struct pages under
> there, but you're not to touch them.
>   

To the extent that the struct page may as well not exist?  Does it
contain any meaningful state?  Are they always IO mappings?  Could we
just use _PAGE_IOMAP as the name for _PAGE_SPECIAL?

>>>   And not having a struct page should correspond well to a pte not
>>> requiring pfn->mfn conversion and being an I/O page.
>>>       
>> But _PAGE_SPECIAL is only set in a few places.  It's not set in ioremap
>> mappings and so on.  Should it be?
>>     
>
> Kernel address space, you mean? No, it is only ever used on user
> addresses.
>   

Right.  But if we fold _PAGE_SPECIAL and _PAGE_IOMAP together, it would
start getting used on kernel addresses (and obviously we'd need to
rearrange _PAGE_CPA_TEST).

>> There's also the hiccup that it gets set in a pte with pte_mkspecial() -
>> but at that point its too late because you've already constructed the
>> pte and done the pfn->mfn conversion.  _PAGE_IOMAP can only be set when
>> you initially construct the pte out of a frame number and a pgprot.
>>     
>
> I don't see this would be any problem because the pte is always constructed
> in a single line in both places where it is used.
>   

OK.  If we were to fold these two together, then pte_mkspecial() would
have to go, since it wouldn't possible to use correctly in my use case.

    J
