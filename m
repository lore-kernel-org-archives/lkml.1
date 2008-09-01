Return-Path: <linux-kernel-owner+w=401wt.eu-S1758526AbYIARyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758526AbYIARyp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 13:54:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751302AbYIARyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 13:54:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52249 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751163AbYIARyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 13:54:35 -0400
Date: Mon, 1 Sep 2008 10:53:04 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, David Witbrodt <dawitbro@sbcglobal.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers <kernel-testers@vger.kernel.org>
Subject: Re: Linux 2.6.27-rc5: System boot regression caused by commit
 a2bd7274b47124d2fc4dfdb8c0591f545ba749dd
In-Reply-To: <86802c440808311403y57ba050q223fbe370d2c7675@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0809011047530.12958@nehalem.linux-foundation.org>
References: <alpine.LFD.1.10.0808281555230.3300@nehalem.linux-foundation.org>  <200808302334.29156.rjw@sisk.pl>  <86802c440808301810r17657f3fnb3c8af5496955e0d@mail.gmail.com>  <200808311427.19369.rjw@sisk.pl>  <alpine.LFD.1.10.0808311039330.12958@nehalem.linux-foundation.org>
  <86802c440808311054q4b8e8921qa9f090527b456e34@mail.gmail.com>  <alpine.LFD.1.10.0808311100520.12958@nehalem.linux-foundation.org> <86802c440808311403y57ba050q223fbe370d2c7675@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 31 Aug 2008, Yinghai Lu wrote:
> 
> how about
> 
> 
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index cce2f4c..3b5269a 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -240,6 +240,11 @@ static int __pci_read_base(struct pci_dev *dev,
> enum pci_bar_type type,
>         pci_read_config_dword(dev, pos, &l);
>         pci_write_config_dword(dev, pos, mask);
>         pci_read_config_dword(dev, pos, &sz);
> +
> +       /* sticky and non changable */
> +       if (sz == l)
> +               goto fail;

No, because a resource really _can_ be at the end. It's perfectly ok to 
have something like a memory resource at 0xff000000-0xffffffff, and then 
the BAR register would always read 0xff000000 (or 0x...4 for a 64-bit 
resource).

So calling that a failure case would be wrong.

		Linus
