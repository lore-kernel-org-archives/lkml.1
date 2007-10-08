Return-Path: <linux-kernel-owner+w=401wt.eu-S1753989AbXJHXSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989AbXJHXSz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 19:18:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752214AbXJHXSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 19:18:45 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:22687 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751732AbXJHXSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 19:18:44 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=p+WiApG0ha5ty6qAeNQuzafnf+8Eiozw9uaP4NcANQzBerPlDRFrckGDPoWrUWq8bU78fwlJIz89DzZZVCIV7gNTlulJhs/Aw8Q9Lm2BdLXeaM2/OroUupVs8t6hIwgFkoAIVbz0HyaaRlhFDpJyApm8T6FCLlsyfZNCe2pphPE=  ;
X-YMail-OSG: HEf7Mc4VM1nevQtB1eNjZeUxAQCISif5hyY_6zcwFrB49K8r6dugEiih2l9rivpPjeOkxFlzHD3yBMjH_oF0JgsBNj319L4Nim9be1s2MoSaDvXBZY0-
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH]fix VM_CAN_NONLINEAR check in sys_remap_file_pages
Date: Mon, 8 Oct 2007 16:47:04 +1000
User-Agent: KMail/1.9.5
Cc: Yan Zheng <yanzheng@21cn.com>, Miklos Szeredi <miklos@szeredi.hu>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
References: <3d0408630710080445j4dea115emdfe29aac26814536@mail.gmail.com> <Pine.LNX.4.64.0710081418140.8640@blonde.wat.veritas.com>
In-Reply-To: <Pine.LNX.4.64.0710081418140.8640@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710081647.04399.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 October 2007 23:37, Hugh Dickins wrote:
> On Mon, 8 Oct 2007, Yan Zheng wrote:
> > The test for VM_CAN_NONLINEAR always fails
>
> Good catch indeed.  Though I was puzzled how we do nonlinear at all,
> until I realized it's "The test for not VM_CAN_NONLINEAR always fails".
>
> It's not as serious as it appears, since code further down has been
> added more recently to simulate nonlinear on non-RAM-backed filesystems,
> instead of going the real nonlinear way; so most filesystems are now not
> required to do what VM_CAN_NONLINEAR was put in to ensure they could do.

Well, I think all filesystems can do VM_CAN_NONLINEAR anyway. Device
drivers and "weird" things tend to have trouble...


> I'm confused as to where that leaves us: is this actually a fix that
> needs to go into 2.6.23?  or will it suddenly disable a system call
> which has been silently working fine on various filesystems which did
> not add VM_CAN_NONLINEAR?  could we just rip out VM_CAN_NONLINEAR?

We probably should keep VM_CAN_NONLINEAR for the moment, I think.
But now that we have the fallback path, we _could_ use that instead of
failing. I doubt anybody will be using nonlinear mappings on anything but
regular files for the time being, but as a trivial fix, I think this probably
should go into 2.6.23.

Thanks for spotting this problem
Acked-by: Nick Piggin <npiggin@suse.de>

> I hope Nick or Miklos is clearer on what the risks are.
>
> (Apologies for all the "not"s and "non"s here, I'm embarrassed
> after just criticizing Ingo's SCHED_NO_NO_OMIT_FRAME_POINTER!)
>
> Hugh
>
> > Signed-off-by: Yan Zheng<yanzheng@21cn.com>
> > ----
> > diff -ur linux-2.6.23-rc9/mm/fremap.c linux/mm/fremap.c
> > --- linux-2.6.23-rc9/mm/fremap.c	2007-10-07 15:03:33.000000000 +0800
> > +++ linux/mm/fremap.c	2007-10-08 19:33:44.000000000 +0800
> > @@ -160,7 +160,7 @@
> >  	if (vma->vm_private_data && !(vma->vm_flags & VM_NONLINEAR))
> >  		goto out;
> >
> > -	if (!vma->vm_flags & VM_CAN_NONLINEAR)
> > +	if (!(vma->vm_flags & VM_CAN_NONLINEAR))
> >  		goto out;
> >
> >  	if (end <= start || start < vma->vm_start || end > vma->vm_end)
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel"
> > in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
