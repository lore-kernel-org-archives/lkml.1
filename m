Return-Path: <linux-kernel-owner+w=401wt.eu-S1760416AbXJREyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760416AbXJREyg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 00:54:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752615AbXJREy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 00:54:27 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48852 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752246AbXJREy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 00:54:27 -0400
Date: Wed, 17 Oct 2007 21:53:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
cc: Mark Lord <lkml@rtr.ca>, David Miller <davem@davemloft.net>,
       fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk, tomof@acm.org
Subject: Re: [bug] ata subsystem related crash with latest -git
In-Reply-To: <4716E19F.1090201@garzik.org>
Message-ID: <alpine.LFD.0.999.0710172147300.26902@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0710171342550.26902@woody.linux-foundation.org>
 <20071018080048O.fujita.tomonori@lab.ntt.co.jp>
 <alpine.LFD.0.999.0710171801000.26902@woody.linux-foundation.org>
 <20071017.181907.63126798.davem@davemloft.net>
 <alpine.LFD.0.999.0710171834001.26902@woody.linux-foundation.org>
 <4716D6B1.8010309@rtr.ca> <alpine.LFD.0.999.0710172100420.26902@woody.linux-foundation.org>
 <4716DB9A.2060809@rtr.ca> <4716DE82.2050006@rtr.ca>
 <4716E19F.1090201@garzik.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 18 Oct 2007, Jeff Garzik wrote:
>
> Is this a sata_mv box?  If so, could you try this patch?

That could explain it: if the SG allocation is simply too small, the 
scatter-gather code will run off the end of the SG list, and encounter 
random uninitialized entries, and if any of those have the low bit set, 
they will be considered to be "link" entries, and the SG list goes wild.

That SG code is really pretty fragile. I don't see it *ever* checking that 
the SG allocation is large enough when it fills it in. And these things 
take the sizes from different places (ie "cmd->use_sg" bs 
"req->nr_phys_segments" vs God knows what else..)

		Linus
