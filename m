Return-Path: <linux-kernel-owner+w=401wt.eu-S1761139AbZE0KgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761139AbZE0KgZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 06:36:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758333AbZE0KgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 06:36:15 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:61836 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756207AbZE0KgO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 06:36:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=xBRLNggpP5wyghUBneOD8c3Xq68LBxhcC6kYSHcVet1M7gwiqYhmaZLV1mrrbYZNGA
         HQ25juhA+r8h3Z1sTjPDzpsBkwgjAagaabJqRjaA8bTnDqCKkDAFVsAfaspXxbsRBWew
         oH3ErpfxDkX4jUPZ+G4qhDs5ipltZdsOnX2PY=
MIME-Version: 1.0
In-Reply-To: <D7CCA83BB0796C49BC0BB53B6AB1208934920A@zch01exm21.fsl.freescale.net>
References: <D7CCA83BB0796C49BC0BB53B6AB1208934920A@zch01exm21.fsl.freescale.net>
Date: Wed, 27 May 2009 18:36:14 +0800
X-Google-Sender-Auth: 96926e714120ca32
Message-ID: <2a27d3730905270336n120f7652yad269858ff456c64@mail.gmail.com>
Subject: Re: Net: ucc_geth ethernet driver optimization space
From: Li Yang <leoli@freescale.com>
To: Liu Dave-R63238 <DaveLiu@freescale.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 1:08 PM, Liu Dave-R63238 <DaveLiu@freescale.com> wrote:
> Guys,
>
> The ucc_geth ethernet driver have dozens of strong sync read/write
> operation, such as in_be32/16/8, out_be32/16/8.
>
> all of them is sync read/write, it is very expensive for performance.
>

Totally agree.  That's one of my concerns right from the beginning.

> For the critical patch, we can remove some unnecessary in_be(x),
> out_be(x) with normal memory operation, and keep some necessary
> memory barrier.
>
> eg: BD access in the interrupt handler and start_xmit.
>
> The BD operation only need the memory barrier between length/buffer
> and status.
>
> struct buffer descriptor {
>        u16 status;
>        u16 length;
>        u32 buffer;
> } __attribute__ ((packed));
>
> struct buffer descriptor *BD;
>
> BD->length = xxxx;
> BD->buffer = yyyy;
> wmb();
> BD->status = zzzz;

The BD can reside either in memory or memory mapped region, which
makes the case more complex.

MMIO accesses need to use IO accessors for the sparse checking.  We
might make use of the __raw_*() accessors, but I'm not sure if it's
suitable for non-PCI buses on powerpc.  And also we need to pay
special attention to the problem described here:
http://lwn.net/Articles/198988/

- Leo
