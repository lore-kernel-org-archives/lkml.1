Return-Path: <linux-kernel-owner+w=401wt.eu-S1752219AbZDTVYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219AbZDTVYl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 17:24:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757407AbZDTVXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 17:23:55 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:57579 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757716AbZDTVXs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 17:23:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=f47e5EH9ocCxgyaWNi3C+HdP/F68EJgV0trQFP1/mZQRvvbf0wlISxyIpnL9zGOdYt
         FEjFarijYu1kWqvcAWG/fIlPhpddlNnQObH6wX8/eJhc7tBh4wSNNMuDC4ZpC6q/Yiwz
         Sx5SbXtwWZdiaOMUvNTjtYnCrK3HTrwutCV4k=
MIME-Version: 1.0
In-Reply-To: <20090420084747.GA7286@alberich.amd.com>
References: <20090417100155.GE16198@alberich.amd.com>
	 <20090417162115.GF8253@elte.hu>
	 <86802c440904171226g520e3b67h7318ff0f80f1e782@mail.gmail.com>
	 <20090420084747.GA7286@alberich.amd.com>
Date: Mon, 20 Apr 2009 14:23:47 -0700
Message-ID: <86802c440904201423y7d1290e5m5b0e2529f3a81fc3@mail.gmail.com>
Subject: Re: [PATCH] pci: derive nearby CPUs from device's instead of bus' 
	NUMA information
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, jbarnes@virtuousgeek.org,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 20, 2009 at 1:47 AM, Andreas Herrmann
<andreas.herrmann3@amd.com> wrote:
> On Fri, Apr 17, 2009 at 12:26:54PM -0700, Yinghai Lu wrote:
>> On Fri, Apr 17, 2009 at 9:21 AM, Ingo Molnar <mingo@elte.hu> wrote:
>> > const struct cpumask * cpumask_of_pcidev(struct pci_dev *dev)
>> > {
>> >        if (dev->numa_node == -1)
>> >                return cpumask_of_pcibus(to_pci_dev(dev)->bus);
>> >
>> >        return cpumask_of_node(dev_to_node(dev));
>> > }
>> >
>> > ? This would work fine in all cases.
>
> Yes, I think so. That's the general solution w/o additional
> "ifdefing".
>
>> you are right, dev_to_node(dev) could return -1 on 64bit, if there is
>> no memory on that node.
>
> Hmm, I thought just in the CONFIG_NUMA=n case -1 is returned.
>
> During initialization the struct device's numa_node is set to -1 and
> later on the information is inherited from the parent numa_node.
>
parent numa_node could be -1 too.

in amd_bus.c
int get_mp_bus_to_node(int busnum)
{
        int node = -1;

        if (busnum < 0 || busnum > (BUS_NR - 1))
                return node;

        node = mp_bus_to_node[busnum];

        /*
         * let numa_node_id to decide it later in dma_alloc_pages
         * if there is no ram on that node
         */
        if (node != -1 && !node_online(node))
                node = -1;

        return node;
}


YH
