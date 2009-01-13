Return-Path: <linux-kernel-owner+w=401wt.eu-S1758056AbZAMM2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758056AbZAMM2w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 07:28:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753594AbZAMM2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 07:28:43 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37983 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753322AbZAMM2m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 07:28:42 -0500
Date: Tue, 13 Jan 2009 13:28:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Frederik Deweerdt <frederik.deweerdt@xprog.eu>, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [patch] tlb flush_data: replace per_cpu with an array
Message-ID: <20090113122831.GB29149@elte.hu>
References: <20090112213539.GA10720@gambetta> <20090112215701.GH23848@one.firstfloor.org> <20090112224037.GA16585@elte.hu> <20090113024337.GL23848@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090113024337.GL23848@one.firstfloor.org>
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


* Andi Kleen <andi@firstfloor.org> wrote:

> > No distro kernel will build with less than 8 CPUs anyway so this point 
> > is moot.
> 
> It has nothing to do with what the distro kernel builds with. As I 
> stated clearly in my review the per cpu data is sized based on the 
> possible map, which is discovered from the BIOS at runtime.  So if your 
> system has two cores only you will only have two copies of per cpu data.

You ignored my observation that by the time this hits distro kernels the 
usual SMP hw size will be 8 or more cores.

> With this patch on the other hand you will always have 8 copies of this 
> data; aka 1K no matter how many CPUs you have.

Firstly, it's 512 bytes (see below), secondly, with the percpu approach we 
waste far more total memory as time goes on and the average core count 
increases.

> So the description that it saves memory is flat out wrong on any system 
> with less than 8 threads (which is by far the biggest majority of 
> systems currently and in the forseeable future)
> 
> > > You would need to cache line pad each entry then, otherwise you risk 
> > > false sharing. [...]
> > 
> > They are already cache line padded.
> 
> Yes that's the problem here. 

I fail to see a problem. It has to be padded and aligned no matter where 
it is - and it is padded and aligned both before and after the patch. I 
dont know why you keep insisting that there's a problem where there is 
none.

> > > [...] That would make the array 1K on 128 bytes cache line system.
> > 
> > 512 bytes.
> 
> 8 * 128 = 1024

The default cacheline size in the x86 tree (for generic cpus) is 64 bytes, 
not 128 bytes - so the default size of the array is 512 bytes, not 1024 
bytes. (This is a change we made yesterday, so you can not have known 
about it unless you follow the x86 tree closely.)

	Ingo
