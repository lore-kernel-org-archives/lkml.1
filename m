Return-Path: <linux-kernel-owner+w=401wt.eu-S1756490AbXJCPVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756490AbXJCPVZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 11:21:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751615AbXJCPVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 11:21:17 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:22064 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbXJCPVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 11:21:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=IXx2YwLEryfm6KQAllJ5+ZBvDPrAU7STlkgiId2dZfCbu7kFSFu9k46EoDlDSIqssvPwRBxdNhnKXPXr5ce1c2PlrHfAOSMCkxrMfiyPJwngsjgwO0grQKV493jcQuIeRVFJEU38vlnpZR14DLRzzni3PbpF99SqWY5+Nv0tdFQ=
Message-ID: <64bb37e0710030821u56157ad1s6252ee01e050c7d5@mail.gmail.com>
Date: Wed, 3 Oct 2007 17:21:13 +0200
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: sata_sil24 broken since 2.6.23-rc4-mm1
Cc: "Jeff Garzik" <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <64bb37e0710011100t2cd81a32g501435b98f783ba9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <64bb37e0709261326h4890a07fx60c7d6772e4e63c4@mail.gmail.com>
	 <64bb37e0709271034h72b5eb9fy3aa7980cbc483f4f@mail.gmail.com>
	 <46FC1104.8080105@gmail.com>
	 <64bb37e0709272236g7da8f370lc7f737e908725e88@mail.gmail.com>
	 <64bb37e0709292300t39028029n2375899d7ba1e8ce@mail.gmail.com>
	 <46FFB412.20202@gmail.com>
	 <64bb37e0709300919w3e9db6aci4c0b9df43407fff3@mail.gmail.com>
	 <46FFDF64.1080005@gmail.com>
	 <64bb37e0709301139h456a82d6u98630a4d1503eaf@mail.gmail.com>
	 <64bb37e0710011100t2cd81a32g501435b98f783ba9@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/1/07, Torsten Kaiser <just.for.lkml@googlemail.com> wrote:
> On 9/30/07, Torsten Kaiser <just.for.lkml@googlemail.com> wrote:
> > On 9/30/07, Tejun Heo <htejun@gmail.com> wrote:
> > > Torsten Kaiser wrote:
> To make that comment "cmd part of the output was always the same" more
> clear: I did not only mean that the first (cmd-)byte was the same, but
> the whole line:
> cmd 61/08:00:09:d6:42/00:00:25:00:00/40 tag 0 cdb 0x0 data 4096 out
>
> I did find ATA_CMD_FPDMA_WRITE = 0x61in ata.h, but I don't find a good
> hint for the 08 that follows. The interpretation XFER_PIO_0 = 0x08
> seems wrong...

Even all of the last bisect steps still showed the same line...

> If I look at what patches remain, it seems that some other (earlier)
> patch that is new in 2.6.23-rc4-mm1 is the trigger, but it will only
> fail together with a second patch.

I'm now finished with bisecting, still 2 patches, but I don't want to
spend another two hours waiting...

And the winners are: (from broken-out patchset of 2.6.23-rc4-mm1)
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch

Before these patches I have never seen the bug, with these I only got
two good boots when trying to recreate the problem. But even the
kernels that did one good boot failed on the second try.

> > As for you printk:
>From the last testkernel (up to incl.
maps2-move-clear_refs-code-to-task_mmuc.patch)

Good:
Oct  3 15:50:39 treogen [    3.780000] XXX sil24 cb=ffff810005dd0000
cb_dma=5dd0000
Oct  3 15:50:39 treogen [    3.790000] XXX sil24 cb=ffff810005de0000
cb_dma=5de0000

Bad:
Oct  3 16:56:46 treogen [    3.750000] XXX sil24 cb=ffff810005de0000
cb_dma=5de0000
Oct  3 16:56:46 treogen [    3.760000] XXX sil24 cb=ffff810005df0000
cb_dma=5df0000

I have *NO* clue how these procfs changes can kill the sata_sil24
driver, but all bisect steps point to these two patches as cause or
trigger of the bug.

Torsten
