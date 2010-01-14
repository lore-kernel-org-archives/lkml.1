Return-Path: <linux-kernel-owner+w=401wt.eu-S1754191Ab0ANSYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191Ab0ANSYU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 13:24:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753960Ab0ANSYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 13:24:19 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:39092 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825Ab0ANSYS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 13:24:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZarY1wLLPpD1San2w+jm+by0z8KbfLEDFRC9aNSpxE1b0wfazsrpma+eyxXxIBiEaD
         mGRDFXvlPCqe9gcnVwwnEKPfsREkEpizJaDZBGOh2uyqvszXmouNljfMw768jrIc9/LM
         htGwWKpyPL4HU+MfiJa1t+65TczjB7YIyCovQ=
MIME-Version: 1.0
In-Reply-To: <20100106045524.959942683@samba.org>
References: <20100106045509.245662398@samba.org>
	 <20100106045524.959942683@samba.org>
Date: Thu, 14 Jan 2010 13:24:15 -0500
Message-ID: <b4198de61001141024p4d21bbb6i6e24aa55c1876239@mail.gmail.com>
Subject: Re: [patch 2/6] alpha: cpumask_of_node() should handle -1 as a node
From: Matt Turner <mattst88@gmail.com>
To: Anton Blanchard <anton@samba.org>
Cc: Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, linux-alpha@vger.kernel.org,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 5, 2010 at 11:55 PM, Anton Blanchard <anton@samba.org> wrote:
> pcibus_to_node can return -1 if we cannot determine which node a pci bus
> is on. If passed -1, cpumask_of_node will negatively index the lookup array
> and pull in random data:
>
> # cat /sys/devices/pci0000:00/0000:00:01.0/local_cpus
> 00000000,00000003,00000000,00000000
> # cat /sys/devices/pci0000:00/0000:00:01.0/local_cpulist
> 64-65
>
> Change cpumask_of_node to check for -1 and return cpu_all_mask in this
> case:
>
> # cat /sys/devices/pci0000:00/0000:00:01.0/local_cpus
> ffffffff,ffffffff,ffffffff,ffffffff
> # cat /sys/devices/pci0000:00/0000:00:01.0/local_cpulist
> 0-127
>
> Signed-off-by: Anton Blanchard <anton@samba.org>
> ---
>
> Index: linux-cpumask/arch/alpha/include/asm/topology.h
> ===================================================================
> --- linux-cpumask.orig/arch/alpha/include/asm/topology.h        2010-01-06 15:20:22.952583839 +1100
> +++ linux-cpumask/arch/alpha/include/asm/topology.h     2010-01-06 15:20:46.610083557 +1100
> @@ -28,6 +28,9 @@ static const struct cpumask *cpumask_of_
>  {
>        int cpu;
>
> +       if (node == -1)
> +               return cpu_all_mask;
> +
>        cpumask_clear(&node_to_cpumask_map[node]);
>
>        for_each_online_cpu(cpu) {
>
> --

Thanks! I've added this to alpha-2.6.

Matt
