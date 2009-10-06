Return-Path: <linux-kernel-owner+w=401wt.eu-S1752355AbZJFE0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355AbZJFE0T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 00:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751452AbZJFE0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 00:26:19 -0400
Received: from mail-yx0-f199.google.com ([209.85.210.199]:38349 "EHLO
	mail-yx0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbZJFE0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 00:26:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=TPc7pER9sxdzetz9h9rrjrka6WeXMvetsMYc0AZQ6Rh3u0k4gdRU4FCf8A1QITEV1a
         WykqyQIgxBoEMjAT4KnfvGq4soy8/Nh98rZJ4jW18+4zGvkYeTs3tTrVXhuTb+OTdg+E
         +XXzJx7somjKnqCPnRH14/bCyD9a7jluZCgjQ=
MIME-Version: 1.0
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 6 Oct 2009 00:25:22 -0400
Message-ID: <8bd0f97a0910052125m4327fef3i47e3b549938802f9@mail.gmail.com>
Subject: userspace firmware loader, vmap, and nommu
To: David Howells <dhowells@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       uclinux-dist-devel <uclinux-dist-devel@blackfin.uclinux.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

semi-recently (9 Apr 2009), the userspace firmware code was rewritten
to use vmap().  this causes problems for nommu systems as it isnt
possible to create a virtually contiguous map with physically
discontiguous pages.  the firmware loader used to work before this
change because it would handle the realloc steps itself (allocate
larger contiguous memory, copy over older data, release older memory)
and vmalloc() on nommu is simply kmalloc().

this could be handled transparently on nommu systems by moving this
scatter gathering of pages into vmap:
void *vmap(struct page **pages, unsigned int count, unsigned long
flags, pgprot_t prot)
{
    unsigned int i;
    void *new_map, *page_data;

    new_map = kmalloc(count << PAGE_SHIFT, GFP_KERNEL);
    if (!new_map)
        return NULL;

    for (i = 0; i < count; ++i) {
        page_data = kmap(pages[i]);
        memcpy(new_map + (i << PAGE_SHIFT), page_data, PAGE_SIZE);
        kunmap(page_data);
    }

    return new_map;
}
void vunmap(const void *addr)
{
    kfree(addr);
}

or we could add nommu-specific code to the firmware loader to not use
vmap().  how would you like to go David (Howells) ?

there is a possibility for the semi-common case of vmap-ing only one
page.  but i'm not familiar enough with the mm code to figure that
case out.
-mike
