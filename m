Return-Path: <linux-kernel-owner+w=401wt.eu-S1422671AbXBUQqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422671AbXBUQqZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 11:46:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422672AbXBUQqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 11:46:24 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:55257 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422671AbXBUQqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 11:46:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=K6UQqX+V3LDz9FOucEAmSHGWuKlzMa4xn9Fp0u2+3IJyZ5QaZZMUiHAEJw7Uds8eky0AnxTdC0pmvkg6ojqVibQNDx64U3Or3KJa0CWRVNQlWcpFBwUNfeeDQRdcmZZkjpvxy8F2GsfELnT52PTj84C9qDJ+PNSgk1KcNdKxsvE=
Message-ID: <45a44e480702210846u218045bmfe6854fb894d7bbd@mail.gmail.com>
Date: Wed, 21 Feb 2007 11:46:21 -0500
From: "Jaya Kumar" <jayakumar.lkml@gmail.com>
To: "Paul Mundt" <lethal@linux-sh.org>,
       "Jaya Kumar" <jayakumar.lkml@gmail.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, jsimmons@infradead.org,
       Geert.Uytterhoeven@sonycom.com
Subject: Re: [PATCH 2.6.20 1/1] fbdev,mm: hecuba/E-Ink fbdev driver
In-Reply-To: <45a44e480702192211i78b8f4b1lecb3dfc284fb9eea@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070217104215.GB25512@localhost> <1171715652.5186.7.camel@lappy>
	 <45a44e480702170525n9a15fafpb370cb93f1c1fcba@mail.gmail.com>
	 <20070217135922.GA15373@linux-sh.org>
	 <45a44e480702180331t7e76c396j1a9861f689d4186b@mail.gmail.com>
	 <20070218235741.GA22298@linux-sh.org>
	 <45a44e480702192013s7d49d05ai31e576f0448a485e@mail.gmail.com>
	 <20070220043848.GA4092@linux-sh.org>
	 <45a44e480702192211i78b8f4b1lecb3dfc284fb9eea@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/20/07, Jaya Kumar <jayakumar.lkml@gmail.com> wrote:
> On 2/19/07, Paul Mundt <lethal@linux-sh.org> wrote:
> > That works for me, though I'd prefer for struct page_list to be done with
> > a scatterlist, then it's trivial to setup from the workqueue context
> > without having to shuffle things around.
> >
>
> Ok. Will check out when implementing.
>

Took  a quick look. If I used scatterlist, I'd still need to build a
list of scatterlist to pass to the driver callback. The alternative
being a preallocated array of scatterlist based on the page count of
the framebuffer, which seems expensive since scatterlist has page,
offset, dma and length.

On a separate note, Peter pointed out that it may be possible to reuse
page->lru instead of using a struct page_list. This would enable
something like:

in mkwrite:
mutex_lock
list_add(page->lru, defio->pagelist)
mutex_unlock

in deferred handler:
mutex_lock
for_each page {
lock_page
mkclean
unlock_page
}
callback(fb_info, pagelist)
for_each page {
list_del
}
mutex_unlock

The advantage of reusing page->lru is that avoids needing the struct
page_list and allocation in mkwrite. Is the above exploitation of
->lru ok with mm folk?

In above, we're iterating over the page list twice. I have to mkclean
before calling the callback to avoid the situation where a touched
page is missed by the callback. I don't see a way around that part.

Thanks,
jaya
