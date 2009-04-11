Return-Path: <linux-kernel-owner+w=401wt.eu-S1755572AbZDKPqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572AbZDKPqW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 11:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752301AbZDKPqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 11:46:05 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:62984 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbZDKPqC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 11:46:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=n/St7UaLNyCLFkPLEIATSKFF0mBpdYd7jZtT9OT1UU8x1/ftFv7wh2dO/6BTk79NAF
         gXFwxm1GF9VtEZvaEKk76pHDdaaMc7brLrdYkUjrDrhtdRVHxRHcQPXjmGbj/2umInjZ
         8247iJg85bYkCjSRJ0hhdOAEsE9HfkDu0VOZo=
MIME-Version: 1.0
In-Reply-To: <alpine.WNT.2.00.0904091128270.6048@jbrandeb-desk1.amr.corp.intel.com>
References: <cb0375e10904010840n1543a890w9039465d0f80ffcc@mail.gmail.com>
	 <20090404.170539.148727646.davem@davemloft.net>
	 <cb0375e10904042100o1a203512l593021ee66cb591d@mail.gmail.com>
	 <alpine.WNT.2.00.0904091128270.6048@jbrandeb-desk1.amr.corp.intel.com>
Date: Sat, 11 Apr 2009 11:46:00 -0400
Message-ID: <cb0375e10904110846k53bd5edbvb9fc9f6ff43bc97c@mail.gmail.com>
Subject: Re: [PATCH 1/1] Tell linkwatch about new interfaces
From: Andrew Lutomirski <amluto@gmail.com>
To: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
Cc: David Miller <davem@davemloft.net>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 9, 2009 at 8:48 PM, Brandeburg, Jesse
<jesse.brandeburg@intel.com> wrote:
>
> does this patch also fix the issue?

Yes.

2: eth0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc pfifo_fast
state DOWN qlen 1000

Tested-by: Andy Lutomirski <amluto@gmail.com>

The link operational states are still funny, though:

1: lo: <LOOPBACK,UP,LOWER_UP> mtu 16436 qdisc noqueue state UNKNOWN
3: wmaster0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc
pfifo_fast state UNKNOWN qlen 1000

It looks like all interfaces that don't call netif_carrier_down after
registration end up in UNKNOWN until something happens.  The case of
carrier_on but UNKNOWN doesn't seem to confuse my userspace, but it's
still odd.

--Andy

>
> ===== begin =====
>
> e1000e: indicate link down at load
>
> From: Jesse Brandeburg <jesse.brandeburg@intel.com>
>
> same kind of patch as e1000, let driver explicitly push link state
> once link comes up.
>
> Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> ---
>
>  drivers/net/e1000e/netdev.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/e1000e/netdev.c b/drivers/net/e1000e/netdev.c
> index fb78278..6a0411e 100644
> --- a/drivers/net/e1000e/netdev.c
> +++ b/drivers/net/e1000e/netdev.c
> @@ -3072,6 +3072,8 @@ static int e1000_open(struct net_device *netdev)
>        if (test_bit(__E1000_TESTING, &adapter->state))
>                return -EBUSY;
>
> +       netif_carrier_off(netdev);
> +
>        /* allocate transmit descriptors */
>        err = e1000e_setup_tx_resources(adapter);
>        if (err)
> @@ -5006,10 +5008,6 @@ static int __devinit e1000_probe(struct pci_dev *pdev,
>        if (!(adapter->flags & FLAG_HAS_AMT))
>                e1000_get_hw_control(adapter);
>
> -       /* tell the stack to leave us alone until e1000_open() is called */
> -       netif_carrier_off(netdev);
> -       netif_tx_stop_all_queues(netdev);
> -
>        strcpy(netdev->name, "eth%d");
>        err = register_netdev(netdev);
>        if (err)
>
