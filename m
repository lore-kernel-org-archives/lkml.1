Return-Path: <linux-kernel-owner+w=401wt.eu-S1761233AbYBRUQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761233AbYBRUQ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 15:16:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753176AbYBRUQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 15:16:18 -0500
Received: from wx-out-0506.google.com ([66.249.82.234]:29441 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131AbYBRUQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 15:16:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=K7NpneQp5GEoL2C0nTE2GoeQb7f2h5k0H3YGsZVxtsKUql3ULOn5inwpysJ5UHffFZ9cU1DdZcIjrkFRGb30f9JAhnKnxWmjD8wwtHxFllNhrGfA4pIEiZba5yDDEUoXKNPoEeHv0NlhI+7hs050ki08vk0Ctxe2m5IS+gjMghM=
Message-ID: <86802c440802181216n113a5e66j68d6c9cdd950836d@mail.gmail.com>
Date: Mon, 18 Feb 2008 12:16:14 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH] x86_64: remove never used nodenumer in pda
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Mike Travis" <travis@sgi.com>, lameter@sgi.com
In-Reply-To: <p73ve4mxxlc.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200802162302.04131.yinghai.lu@sun.com>
	 <p73ve4mxxlc.fsf@bingen.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 18, 2008 4:23 AM, Andi Kleen <andi@firstfloor.org> wrote:
> Yinghai Lu <Yinghai.Lu@Sun.COM> writes:
>
> > we don't need copy too. already have x86_cpu_to_node_map
>
> That's a regression (probably from Mike's patches?). Until recently it was
> used.
>
> The reason the node number was put in there is that it generates far
> shorter code to just fetch the local node number from the PDA than to
> first go through a array lookup from the cpu number. It also saves a
> costly cache line miss on the array if you're unlucky.
>
> It is far better to fix it than to remove it.
>
> I know Mike/Christoph want to get rid of the PDA and make per cpu data
> as efficient as the PDA. If that happens the right fix is to create
> a new per CPU data variable for the node number again.
>
> Here's a quick patch (tested on kvm with numa emulation only)
>
> It should be ok because PDA is set up early and
> the early node is always 0 and there is a 0 in there
> at early boot.
>
> Saves about 1.6k of text on a vmlinux here.

that is because of the inline...

static inline int early_cpu_to_node(int cpu)
{
        int *cpu_to_node_map = x86_cpu_to_node_map_early_ptr;

        if (cpu_to_node_map)
                return cpu_to_node_map[cpu];
        else if (per_cpu_offset(cpu))
                return per_cpu(x86_cpu_to_node_map, cpu);
        else
                return NUMA_NO_NODE;
}

should use per_cpu(x86_cpu_to_node_map, cpu) instead.
and limited using early_cpu_to_node etc.

YH
