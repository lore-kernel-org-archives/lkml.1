Return-Path: <linux-kernel-owner+w=401wt.eu-S1753648AbYLTIwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648AbYLTIwW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 03:52:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751168AbYLTIwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 03:52:14 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:49566 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbYLTIwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 03:52:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=J0JHhxbow71EXGKk5csps7mgYegBGSajh8AO4vCcQkvnKAaI6veFEGavpvvcBnM+3e
         tZZElkSw3mLi4HeQY8ie0G2Bx3Xevux3G+tvp9CcGIu0RoMNIOpuYrITSoNjoUbFhtdt
         T0qT5yf+0jS5ukjcFvPdYQbtoPy4/aFjrXjQM=
Message-ID: <19f34abd0812200052g50067413t398eb7d67213371@mail.gmail.com>
Date: Sat, 20 Dec 2008 09:52:10 +0100
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: v2.6.28-rc7: error in panic code? (NULL pointer dereference at 0000004c)
Cc: "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20081220004606.GA608@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0812181406n48712c81j41a560aaf6ba6cd8@mail.gmail.com>
	 <19f34abd0812190919g348b581ex9ebb2e83701899c7@mail.gmail.com>
	 <20081219173946.GA18240@suse.de>
	 <84144f020812191235u4106766bhee28134632c302e2@mail.gmail.com>
	 <20081220004606.GA608@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 20, 2008 at 1:46 AM, Greg KH <gregkh@suse.de> wrote:
> On Fri, Dec 19, 2008 at 10:35:57PM +0200, Pekka Enberg wrote:
>> Hi Greg,
>>
>> On Fri, Dec 19, 2008 at 06:19:43PM +0100, Vegard Nossum wrote:
>> > Fixes what?  It might be quite difficult to revert that patch now, as
>> > the infrastructure is no longer in place to use a private pci device
>> > list, that code is long gone.
>>
>> Vegard forced one oops but got two! The first one is expected and but
>> the second one shouldn't probably be there:
>
> "Second" oopses are known to not be reliable, I wouldn't count it as a
> real problem unless it happens on its own.

Yes, because usually it's a process that BUGed and was killed --
perhaps with locks held or in the middle of some transaction that will
never complete. But this one happens in the panic code itself...

>
>> >> > [    0.040993] EIP: [<c13b41dc>] klist_next+0x10/0x8d SS:ESP 0068:c165dd48
>>
>> Looks like the patch Vegard identified breaks something in the oops path?
>
> Very wierd, I also don't understand how reverting the specific patch
> would even make a buildable system.

It was an unclean revert, here's the relevant resultant hunk:

diff --cc drivers/pci/probe.c
index 003a9b3,2db2e4b..0000000
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@@ -32,16 -29,55 +28,11 @@@ LIST_HEAD(pci_devices)
   */
  int no_pci_devices(void)
  {
-       struct device *dev;
-       int no_devices;
-
-       dev = bus_find_device(&pci_bus_type, NULL, NULL, find_anything);
-       no_devices = (dev == NULL);
-       put_device(dev);
-       return no_devices;
+       return list_empty(&pci_devices);
  }
+
  EXPORT_SYMBOL(no_pci_devices);


...and this builds.

The problem seems to be that pci_bus_type.p->klist_devices is NULL. Because:

Oops happens here:

struct klist_node *klist_next(struct klist_iter *i)
{
        void (*put)(struct klist_node *) = i->i_klist->put;

So either i == NULL or i->i_klist == NULL. But i->i_klist was just
before set here:

void klist_iter_init_node(struct klist *k, struct klist_iter *i,
                          struct klist_node *n)
{
        i->i_klist = k;
        i->i_cur = n;
        if (n)
                kref_get(&n->n_ref);
}

so the klist passed must have been NULL, it came from bus_find_device():

        klist_iter_init_node(&bus->p->klist_devices, &i,
                             (start ? &start->knode_bus : NULL));

...and indeed, printing bus->p here yields 00000000. This function was
called from no_pci_devices(), so the bus variable was initialized from
&pci_bus_type. So pci_bus_type.p == NULL.

This should be initialized in bus_register() called from
pci_driver_init(). Aha, this never gets called because initcalls did
not yet run.

A summary of the bug:

1. Sending panic=1 wants to reboot on panic.
2. If panic occurs before initcalls ran, pci_bus_type.p is not initialized.
3. mach_reboot_fixups() in x86 code calls pci_get_device()
4. New oops

Maybe mach_reboot_fixups() should check to see if PCI bus is
initialized before calling pci_get_device(), since obviously it can be
called before it has been initialized too.

The funny thing is that no_pci_devices() is what _used_ to guard
against using pci_bus_type too early:

/*
 * Some device drivers need know if pci is initiated.
 * Basically, we think pci is not initiated when there
 * is no device to be found on the pci_bus_type.
 */
int no_pci_devices(void)

...and now it uses pci_bus_type itself. That is what makes commit
70308923d317f2ad4973c30d90bb48ae38761317 wrong, because there might be
other users of no_pci_devices() too, which would now almost certainly
result in an Oops if the pci bus hasn't been initialized.

Please tell if any of the above is unclear, and I will try to explain
more. Thanks,


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
