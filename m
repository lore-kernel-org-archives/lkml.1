Return-Path: <linux-kernel-owner+w=401wt.eu-S1755308AbYLEDky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308AbYLEDky (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 22:40:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750980AbYLEDkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 22:40:46 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:33979 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787AbYLEDkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 22:40:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=YezxhiuvQBtP2dLprRproV17iIW9aIUp2atTzCNYMVRYjsi3JVBnyDn/GWsnMgfQSb
         zsrcJ0g34egNZePzbVGomo2cRUy8ZO0tor+WY5jMnCezuFTgleMWQqK5graE8xKqd4XR
         t7Sxz9eTiERoF3alBaACcd+hfu13AvidpnOZM=
Message-ID: <21d7e9970812041940h29994c60w3e7bcf20b96efe04@mail.gmail.com>
Date: Fri, 5 Dec 2008 13:40:43 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       libc-alpha@sources.redhat.com
Subject: IO space memcpy support for userspace.
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all (glibc + kernel folks).

So this isn't totally a kernel issue however I'm sure everyone who can
help is around here somewhere.

So in the kernel we have special memcpy_(from,to)io functions that are
used to copy data in out of PCI space,
however when we expose PCI device memory to userspace it has no way to
know the mapping it has been provided
is suitable for optimised userspace copy operations or not.

so eg. on certain IA64 platforms, doing a memcpy on a mmaped PCI
memory area can cause a hard lock.

Now I started to try and fix this in X but I'm wondering if this is
something glibc/kernel can solve between them.

I was firstly thinking about adding memcpy_io/memset_io/str*_io
options to glibc and just have userspace use them.
however this means code that operates on non-IO space objects gets
penalised in those cases. e.g. a sw renderer rendering
to a SW surface vs the same sw renderer rendering to a surface in
video memory. the renderer really doesn't know where the
surface is actually underneath the hood.

So further thinking about this it would be nice if the standard
memcpy/memset/str* realised, hey I'm working on a memory address or
VMA
that is a IO mapping, I really shouldn't do shiny prefetch stuff on
this. I'm not 100% sure how this could be implemented, some sort of
private
mmap return value or flag like MAP_NO_OPTIMISE (I realise this is
going the wrong way as the kernel should tell glibc it, do we even
have a channel for this info?).
Then when memory op is done it checks the memory dest/src to see if
the segment is allowed to optimise or not.

I'm sure this has come up before and I'm sure I'll either wish I never
posted this or someone will show me the crisp corpse of the last guy
who suggested it.

Dave.
