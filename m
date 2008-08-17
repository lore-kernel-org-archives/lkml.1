Return-Path: <linux-kernel-owner+w=401wt.eu-S1755489AbYHQU6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489AbYHQU6k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 16:58:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751967AbYHQU63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 16:58:29 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:7678 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbYHQU62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 16:58:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=VtgzZ9CXJyzuqR+OlPbLhdXvwHETp0ckqkmUcspSx/G4j23+UB6SJnhSv9mYpgOSPn
         jiu0cVwNxCj3pA0qn/5RztSXsF/t8Kh/+LXQkd3Bn6MROCvQholXmB7JoHPOcGwt7fuw
         CDKxOARm0WngNKQAhdjqiEDgAFn0YGaiG+oOE=
Message-ID: <86802c440808171358y55361a52pa6d0aacf44a1875f@mail.gmail.com>
Date: Sun, 17 Aug 2008 13:58:27 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] net: forcedeth use pci_choose_state instead of PCI_D3hot - v2
Cc: "Jeff Garzik" <jgarzik@redhat.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
In-Reply-To: <200808172134.20230.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1218954333-12819-1-git-send-email-yhlu.kernel@gmail.com>
	 <86802c440808171216s1d87c4e3t965b3a93bf4b87f4@mail.gmail.com>
	 <200808172129.02135.rjw@sisk.pl> <200808172134.20230.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 17, 2008 at 12:34 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Sunday, 17 of August 2008, Rafael J. Wysocki wrote:
>> On Sunday, 17 of August 2008, Yinghai Lu wrote:
>> > On Sun, Aug 17, 2008 at 9:55 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > > On Sunday, 17 of August 2008, Rafael J. Wysocki wrote:
>> > >> On Sunday, 17 of August 2008, Yinghai Lu wrote:
>> > >> > after
>> > >> >
>> > >> > | commit f735a2a1a4f2a0f5cd823ce323e82675990469e2
>> > >> > | Author: Tobias Diedrich <ranma+kernel@tdiedrich.de>
>> > >> > | Date:   Sun May 18 15:02:37 2008 +0200
>> > >> > |
>> > >> > |    [netdrvr] forcedeth: setup wake-on-lan before shutting down
>> > >> > |
>> > >> > |    When hibernating in 'shutdown' mode, after saving the image the suspend hook
>> > >> > |    is not called again.
>> > >> > |    However, if the device is in promiscous mode, wake-on-lan will not work.
>> > >> > |    This adds a shutdown hook to setup wake-on-lan before the final shutdown.
>> > >> > |
>> > >> > |    Signed-off-by: Tobias Diedrich <ranma+kernel@tdiedrich.de>
>> > >> > |    Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
>> > >> >
>> > >> > my servers with nvidia mcp55 nic doesn't work with msi in second kernel by kexec
>> > >> >
>> > >> > after remove pci_set_power_state(, PCI_D3hot) that nic/msi will work again.
>> > >> >
>> > >> > check with e1000 is using pci_choose_state in _shutdown.
>> > >
>> > > This is wrong.
>> > >
>> > >> > So change that pci_choose_state(pdev, ...), and it works.
>> > >>
>> > >> Well, this doesn't look like a good solution to me, because you're putting
>> > >> PMSG_SUSPEND in there, which is not correct for shutdown.  The right thing to
>> > >> do would be to avoid changing the device power state if nv_shutdown() is
>> > >> used for kexec or to rework the initialization of the adapter to handle the
>> > >> case when it's initially in D3.
>> > >>
>> > >> Does it help if you just remove the pci_set_power_state(pdev, PCI_D3hot)
>> > >> altogether?
>> > >
>> > > Ah, sorry.  I see it does.
>> > >
>> > > Actually, I think you can use pci_prepare_to_sleep() instead of
>> > > pci_enable_wake() / pci_set_power_state() combo.  It wasn't designed for this
>> > > purpose, but should work nevertheless.
>> > >
>> > > Can you please check if the appended patch works instead of your one?
>> > >
>> > > Rafael
>> > >
>> > > ---
>> > > Fix the problem that boxes with NVidia MCP55 don't work with MSI
>> > > in a kexeced kernel.
>> > >
>> > > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
>> > > ---
>> > >  drivers/net/forcedeth.c |    4 +---
>> > >  1 file changed, 1 insertion(+), 3 deletions(-)
>> > >
>> > > Index: linux-2.6/drivers/net/forcedeth.c
>> > > ===================================================================
>> > > --- linux-2.6.orig/drivers/net/forcedeth.c
>> > > +++ linux-2.6/drivers/net/forcedeth.c
>> > > @@ -5975,10 +5975,8 @@ static void nv_shutdown(struct pci_dev *
>> > >        if (netif_running(dev))
>> > >                nv_close(dev);
>> > >
>> > > -       pci_enable_wake(pdev, PCI_D3hot, np->wolenabled);
>> > > -       pci_enable_wake(pdev, PCI_D3cold, np->wolenabled);
>> > >        pci_disable_device(pdev);
>> > > -       pci_set_power_state(pdev, PCI_D3hot);
>> > > +       pci_prepare_to_sleep(pdev);
>> > >  }
>> > >  #else
>> > >  #define nv_suspend NULL
>> > >
>> > >
>> >
>> > your patch doesn't work...  it seems that silicon has problem with D3Hot
>>
>> Okay, so perhaps it's better to do something like this:
>>
>> ---
>>  drivers/net/forcedeth.c |    8 +++++---
>>  1 file changed, 5 insertions(+), 3 deletions(-)
>>
>> Index: linux-2.6/drivers/net/forcedeth.c
>> ===================================================================
>> --- linux-2.6.orig/drivers/net/forcedeth.c
>> +++ linux-2.6/drivers/net/forcedeth.c
>> @@ -5975,10 +5975,12 @@ static void nv_shutdown(struct pci_dev *
>>       if (netif_running(dev))
>>               nv_close(dev);
>>
>> -     pci_enable_wake(pdev, PCI_D3hot, np->wolenabled);
>> -     pci_enable_wake(pdev, PCI_D3cold, np->wolenabled);
>>       pci_disable_device(pdev);
>> -     pci_set_power_state(pdev, PCI_D3hot);
>> +     if (system_state == SYS_POWER_OFF) {
>
> Sorry, it should be SYSTEM_POWER_OFF here.  Corrected patch is appended.
>
>> +             if (pci_enable_wake(pdev, PCI_D3cold, np->wolenabled))
>> +                     pci_enable_wake(pdev, PCI_D3hot, np->wolenabled);
>> +             pci_set_power_state(pdev, PCI_D3hot);
>> +     }
>>  }
>>  #else
>>  #define nv_suspend NULL
>> --
>
> ---
>  drivers/net/forcedeth.c |    8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>
> Index: linux-2.6/drivers/net/forcedeth.c
> ===================================================================
> --- linux-2.6.orig/drivers/net/forcedeth.c
> +++ linux-2.6/drivers/net/forcedeth.c
> @@ -5975,10 +5975,12 @@ static void nv_shutdown(struct pci_dev *
>        if (netif_running(dev))
>                nv_close(dev);
>
> -       pci_enable_wake(pdev, PCI_D3hot, np->wolenabled);
> -       pci_enable_wake(pdev, PCI_D3cold, np->wolenabled);
>        pci_disable_device(pdev);
> -       pci_set_power_state(pdev, PCI_D3hot);
> +       if (system_state == SYSTEM_POWER_OFF) {
> +               if (pci_enable_wake(pdev, PCI_D3cold, np->wolenabled))
> +                       pci_enable_wake(pdev, PCI_D3hot, np->wolenabled);
> +               pci_set_power_state(pdev, PCI_D3hot);
> +       }
>  }
>  #else
>  #define nv_suspend NULL
>

why not like e1000 to
pci_set_power_state(pdev, pci_choose_state(pdev, PMSG_SUSPEND));

pci_choose_state would check if platform support those state...

YH
