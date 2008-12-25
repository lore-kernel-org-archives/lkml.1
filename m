Return-Path: <linux-kernel-owner+w=401wt.eu-S1752174AbYLYPSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174AbYLYPSY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 10:18:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845AbYLYPSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 10:18:15 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46713 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751524AbYLYPSO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 10:18:14 -0500
Date: Thu, 25 Dec 2008 16:17:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joerg.roedel@amd.com>,
       Benjamin Serebrin <benjamin.serebrin@amd.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
       Alexander Graf <agraf@suse.de>
Subject: Re: kvm vmload/vmsave vs tss.ist
Message-ID: <20081225151757.GA25117@elte.hu>
References: <49539FD0.7070103@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49539FD0.7070103@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@redhat.com> wrote:

> I would like to remove this limitation.  I see several ways to go about 
> it:
>
> 1. Drop the use of IST
>
> This would reduce the (perceived) reliability of the kernel and would 
> probably not be welcomed.

> hpa/Ingo, any opinions?

i think we should actually do #1 unconditionally.

ISTs are bad for the native kernel too. They have various nasty 
complications in the stack walker (and hence they _reduce_ reliability in 
practice), and they are non-preemptible as well. Plus we have the 
maximum-stack-footprint ftrace plugin now, which can remove any perception 
about how bad the worst-case stack footprint is in practice.

If it ever becomes an issue we could also soft-switch to a larger (per 
CPU) exception stack from the exception handlers themselves. The 
architectural stack footprint of the various critical exceptions are 
calculatable and low - so we could switch away and get almost the kind of 
separation that ISTs give. There's no deep reason to actually make use of 
hw switched ISTs.

So feel free to send a patch that just standardizes the critical 
exceptions to use the regular kernel stack. (I havent actually tried this 
but it should be relatively simple to implement. Roadblocks are possible.)

	Ingo
