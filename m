Return-Path: <linux-kernel-owner+w=401wt.eu-S1760221AbXHBWoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760221AbXHBWoP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 18:44:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755617AbXHBWn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 18:43:56 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:2164 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754983AbXHBWny (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 18:43:54 -0400
X-Server-Uuid: 6B5CFB92-F616-4477-B110-55F967A57302
Subject: Re: [REGRESSION] tg3 dead after s2ram
From: "Michael Chan" <mchan@broadcom.com>
To: "David Miller" <davem@davemloft.net>
cc: joachim.deguara@amd.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, michal.k.k.piotrowski@gmail.com,
       "netdev" <netdev@vger.kernel.org>, linux-acpi@vger.kernel.org
In-Reply-To: <20070802.150636.77057800.davem@davemloft.net>
References: <200708021115.10812.joachim.deguara@amd.com>
 <20070802.022317.66176729.davem@davemloft.net>
 <1186081829.18322.20.camel@dell>
 <20070802.150636.77057800.davem@davemloft.net>
Date: Thu, 02 Aug 2007 16:38:00 -0700
Message-ID: <1186097880.18322.73.camel@dell>
MIME-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-8)
X-WSS-ID: 6AAC81AA35W1368972-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-02 at 15:06 -0700, David Miller wrote:
> From: "Michael Chan" <mchan@broadcom.com>
> Date: Thu, 02 Aug 2007 12:10:29 -0700
>
> > Alternatively, we can also fix it by calling pci_enable_device() again
> > in tg3_open().  But I think it is better to just always save and restore
> > in suspend/resume.  bnx2.c will also require the same fix.
> 
> We could do it that way.  But don't you think it's more reliable to
> save and restore around the event we know will be what clobbers the
> PCI config space on us? :-)
> 

Yes for sure when netif state is running and we were already doing that.

> Other things might happen between ->resume() and ->open() that could
> modify PCI config space, and we could overwrite such changes if we do
> the PCI restore in ->open().

I suggested calling pci_enable_device() in ->open(), not calling
pci_restore_state() in ->open().  I ultimately decided against it
because some devices do not enable memory as a workaround and it would
be messy to deal with it again in tg3_open().

I definitely agree that calling PCI restore in ->open() is a bad idea.
We used to save PCI state in ->probe() once and restore PCI state after
every chip reset.  This sequence caused many subtle problems.

