Return-Path: <linux-kernel-owner+w=401wt.eu-S1755237AbZFZAAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237AbZFZAAk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 20:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbZFZAAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 20:00:31 -0400
Received: from mail-gx0-f226.google.com ([209.85.217.226]:57154 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699AbZFZAAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 20:00:30 -0400
X-Greylist: delayed 1730 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Jun 2009 20:00:30 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cLdsw/v6ah0GAPDaXV1ObGqLS1mXgWQ+u8/H3V7yBsRtp/R4XgoT9j0+oWq8EVSHQ7
         UxDYMEcHGhG8ndAMxPnY9AV49AAG7oWKTa9YrAKxQCn/JziIn2J+O3CcgFqbd+zFITP4
         YKmpYVr+WmDKssxoPaWtP0gn8QvIZ6YiomRZU=
MIME-Version: 1.0
In-Reply-To: <1245931298.13359.8.camel@localhost.localdomain>
References: <1245931298.13359.8.camel@localhost.localdomain>
Date: Fri, 26 Jun 2009 10:00:32 +1000
Message-ID: <21d7e9970906251700n5f5fbd07ke24022b576b1770b@mail.gmail.com>
Subject: Re: TTM page pool allocator
From: Dave Airlie <airlied@gmail.com>
To: Jerome Glisse <glisse@freedesktop.org>
Cc: thomas@shipmail.org, linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 25, 2009 at 10:01 PM, Jerome Glisse<glisse@freedesktop.org> wrote:
> Hi,
>
> Thomas i attach a reworked page pool allocator based on Dave works,
> this one should be ok with ttm cache status tracking. It definitely
> helps on AGP system, now the bottleneck is in mesa vertex's dma
> allocation.
>

My original version kept a list of wb pages as well, this proved to be
quite a useful
optimisation on my test systems when I implemented it, without it I
was spending ~20%
of my CPU in getting free pages, granted I always used WB pages on
PCIE/IGP systems.

Another optimisation I made at the time was around the populate call,
(not sure if this
is what still happens):

Allocate a 64K local BO for DMA object.
Write into the first 5 pages from userspace - get WB pages.
Bind to GART, swap those 5 pages to WC + flush.
Then populate the rest with WC pages from the list.

Granted I think allocating WC in the first place from the pool might
work just as well since most of the DMA buffers are write only.

Dave.
