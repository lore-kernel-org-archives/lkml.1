Return-Path: <linux-kernel-owner+w=401wt.eu-S1756194AbYH3Tku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194AbYH3Tku (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 15:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752887AbYH3Tkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 15:40:36 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:48437 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752552AbYH3Tkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 15:40:35 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	b=Fb72TnmblBQt+1ml+LRApgtlCqX2yh6RoxmxpgakiLR+QDm6afrF8Bd29hvemrvuBw0NP2N96lOgcA2iYbBOfG3li9aWSEEyidUHoPeR8cuBkwbTSFRMnipoI2+ty6is;
Message-ID: <48B9A1F6.9030006@simon.arlott.org.uk>
Date: Sat, 30 Aug 2008 20:39:34 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.16 (X11/20080726)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Yinghai Lu <yhlu.kernel@gmail.com>, Jeff Garzik <jgarzik@redhat.com>,
       Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev <netdev@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] net: forcedeth use pci_choose_state instead of PCI_D3hot
 - v2
References: <1218954333-12819-1-git-send-email-yhlu.kernel@gmail.com> <200808191958.45886.rjw@sisk.pl> <48AB11E2.3040705@simon.arlott.org.uk> <200808192309.37317.rjw@sisk.pl>
In-Reply-To: <200808192309.37317.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/08/08 22:09, Rafael J. Wysocki wrote:
> On Tuesday, 19 of August 2008, Simon Arlott wrote:
>> On 19/08/08 18:58, Rafael J. Wysocki wrote:
>> > On Tuesday, 19 of August 2008, Simon Arlott wrote:
>> >> On 18/08/08 23:08, Rafael J. Wysocki wrote:
>> >> > On Monday, 18 of August 2008, Yinghai Lu wrote:
>> >> >> On Mon, Aug 18, 2008 at 3:22 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> >> >> 
>> >> >> >> > >  drivers/net/forcedeth.c |    8 +++++---
>> >> >> >> > >  1 file changed, 5 insertions(+), 3 deletions(-)
>> >> >> >> > >
>> >> >> >> > > Index: linux-2.6/drivers/net/forcedeth.c
>> >> >> >> > > ===================================================================
>> >> >> >> > > --- linux-2.6.orig/drivers/net/forcedeth.c
>> >> >> >> > > +++ linux-2.6/drivers/net/forcedeth.c
>> >> >> >> > > @@ -5975,10 +5975,12 @@ static void nv_shutdown(struct pci_dev *
>> >> >> >> > >        if (netif_running(dev))
>> >> >> >> > >                nv_close(dev);
>> >> >> >> > >
>> >> >> >> > > -       pci_enable_wake(pdev, PCI_D3hot, np->wolenabled);
>> >> >> >> > > -       pci_enable_wake(pdev, PCI_D3cold, np->wolenabled);
>> >> >> >> > >        pci_disable_device(pdev);
>> >> >> >> > > -       pci_set_power_state(pdev, PCI_D3hot);
>> >> >> >> > > +       if (system_state == SYSTEM_POWER_OFF) {
>> >> >> >> > > +               if (pci_enable_wake(pdev, PCI_D3cold, np->wolenabled))
>> >> >> >> > > +                       pci_enable_wake(pdev, PCI_D3hot, np->wolenabled);
>> >> >> >> > > +               pci_set_power_state(pdev, PCI_D3hot);
>> >> >> >> > > +       }
>> >> >> >> > >  }
>> >> >> >> > >  #else
>> >> >> >> > >  #define nv_suspend NULL
>> >> >> >> > >
>> >> >> >> >
>> >> >> 
>> >> >> > Does the last patch work for you BTW?
>> >> >> >
>> >> >> 
>> >> >> it works.
>> >> > 
>> >> > OK, thanks for testing.
>> >> > 
>> >> > I think we can use it as a quick fix for 2.6.27.  Do you agree?
>> >> > 
>> >> > Still, it would be helpful to verify if this is the same MSI issue reported by
>> >> > Simon.
>> >> 
>> >> I tried to test that patch but even without it standby/resume has stopped working:
>> > 
>> > Which kernel is this?
>> 
>> linus-2.6 a7f5aaf36ded825477c4d7167cc6eb1bcdc63191
>> 
>> I've reverted to 2b12a4c524812fb3f6ee590a02e65b95c8c32229 where standby/resume still 
>> works and applied the above patch plus the pci_enable_device patch. It still doesn't 
>> work after resume if MSI is enabled.
> 
> My patch only affects the shutdown code path and is not related to
> suspend/standby etc.
> 
> Could you identify the commit that broke standby/resume for you between
> 2b12a4c524812fb3f6ee590a02e65b95c8c32229 and
> a7f5aaf36ded825477c4d7167cc6eb1bcdc63191 ?  It looks like that should be
> bisectable.

It appears to be working again as of ee096f75b69913dbad0e6f7f2572513de5c90002.

-- 
Simon Arlott

