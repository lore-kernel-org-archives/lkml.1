Return-Path: <linux-kernel-owner+w=401wt.eu-S1760685AbXJODI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760685AbXJODI2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 23:08:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755063AbXJODIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 23:08:21 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:32617 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752981AbXJODIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 23:08:20 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=xKF1FkgXsRY96YfUxZr7ltYC0DhyIKRUMAHLb+5p4/ZVgIxfuefTbMYRd5LOGlWgBTSKkbUswYPj4DO1mMQWBh3X9AZN7CQPqFo13eve8d+yI8m5r/S04Hh3dCwDxcPLWI0M4UwDDMv1bQUzSdyHS/hvebixP6S5E8+D4W0CfdA=  ;
X-YMail-OSG: lj0m2U8VM1kGZRJTV7P.N7Zm1iiq_yk8A2.eXO49qtKgd04Y1p4C5mKZhsmLSXK5QArKdSa37w--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [RFC] vivi, videobuf_to_vmalloc() and related breakage
Date: Mon, 15 Oct 2007 17:59:19 +1000
User-Agent: KMail/1.9.5
Cc: mchehab@infradead.org, linux-kernel@vger.kernel.org
References: <20071015020157.GC8181@ftp.linux.org.uk>
In-Reply-To: <20071015020157.GC8181@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710151759.19839.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 October 2007 12:01, Al Viro wrote:
> 	AFAICS, videobuf-vmalloc use of mem->vma and mem->vmalloc is
> bogus.
>
> You obtain the latter with vmalloc_user(); so far, so good.  Then you have
>         retval=remap_vmalloc_range(vma, mem->vmalloc,0);
> where vma is given to you by mmap(); again, fine - we get the memory
> pointed to be mem->vmalloc() mapped at vma->vm_start.
>
> Now we get the trouble: things like
>
> static void vivi_fillbuff(struct vivi_dev *dev,struct vivi_buffer *buf)
> {
> 	...
> 	void *vbuf=videobuf_to_vmalloc (&buf->vb);
> 	...
> 	copy_to_user(vbuf + ..., ..., ...)
>
> get vbuf equal to ->vmalloc of buf->vp.priv and that is _not_ a userland
> address.  Giving it to copy_to_user() is not going to do anything good.
> On some targets it'll fail, on some - write to unrelated user memory.
> What is going on there?  If that's an attempt to copy into that buffer
> allocated by vmalloc_user(), why are we doing copy_to_user() at all?

Right you are. remap_vmalloc_range doesn't turn the passed vmalloc
area into user memory (it creates a completely new mapping).

Presumably it either wants to copy_to_user to that new mapping, or
memcpy to ->vmalloc? Would the former be an attempt to avoid some
virtual aliasing issues?


> But there's more; we have made a copy of vma (kmalloc+memcpy), stored it in
> mem->vma and later we cheerfully do remap_vmalloc_range(mem->vma,....).
> And kfree that mem->vma immediately afterwards.  What the hell?  It might
> not break now, but that seems to be playing very fast and loose with the
> warranties provided by VM.

I don't know why one would be finding remap_vmalloc_range to fail
it mmap time but not later? Should just do it at mmap time and if
that is failing, then work out why (or ask linux-mm for help).
Actually there is probably a window where we can get subsequent
anonymous pages faulted into the empty vma there if we haven't
remapped it, then the subsequent attempt to remap will hit the
BUG_ON in remap_pte_range.

(that's aside from the big conceptual problem with passing in an
"invented" vma... don't do that! (: )
