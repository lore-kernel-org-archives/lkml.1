Return-Path: <linux-kernel-owner+w=401wt.eu-S1759194AbZFWLmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759194AbZFWLmt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 07:42:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754116AbZFWLmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 07:42:42 -0400
Received: from mail-yx0-f178.google.com ([209.85.210.178]:48607 "EHLO
	mail-yx0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464AbZFWLmm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 07:42:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=InVlGYq0+aPtKEZmWss3nLJEB1nyBfKJaErzshjLe2r6ExCsrP25kMCusoce4nC7LE
         3hMhLi/0H0kwOfnoo6wLE1TtLVgvX3EGAGc5et03+ptHnmKYP6qbO5UKGv1YPvSMxe50
         I2UuOrDZA8cSvgGJp3KdfOVh5g222qIHLPpEc=
MIME-Version: 1.0
In-Reply-To: <1245756936.19816.1652.camel@twins>
References: <1245691561-15336-1-git-send-email-jglisse@redhat.com>
	 <1245756936.19816.1652.camel@twins>
Date: Tue, 23 Jun 2009 21:42:30 +1000
Message-ID: <21d7e9970906230442n3dcfeff8le0ffc3b8ea0c3bd0@mail.gmail.com>
Subject: Re: [PATCH] radeon: use vmalloc instead of kmalloc
From: Dave Airlie <airlied@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jerome Glisse <jglisse@redhat.com>, dri-devel@lists.sf.net,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 9:35 PM, Peter Zijlstra<peterz@infradead.org> wrote:
> On Mon, 2009-06-22 at 19:26 +0200, Jerome Glisse wrote:
>> We don't need to allocated contiguous pages in cs codepath
>> so use vmalloc instead.
>
> Best would be to not require >PAGE_SIZE allocations at all of course.

It gets messy when you have copy from user and spinlocks, it would be nice
to just parse the userspace PAGE_SIZE at a time, but it would mean dropping
a lock we probably need to hold.

> But barring that, it would be great to have something like:
>
>  ptr = kmalloc(size, GFP_KERNEL | __GFP_NOWARN);
>  if (!ptr)
>    ptr = vmalloc(size);

we have a drm_calloc_large workaround already for the Intel driver which also
need this.
>
> Also, how long do these allocations live? vmalloc space can be quite
> limited (i386) and it can fragment too.

Only an ioctl lifetime so they aren't that bad. We however do have some vmaps
that might be quite large, mainly the fbcon framebuffer (up to 8MB in
some cases)

Dave.
