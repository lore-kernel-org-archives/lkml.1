Return-Path: <linux-kernel-owner+w=401wt.eu-S1753253AbYHWFlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253AbYHWFlq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 01:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752054AbYHWFli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 01:41:38 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:54667 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbYHWFlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 01:41:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=fs+cvaE/knQ75g74AzcUwp5L2KASbVALWP62G9DbTaKT1T7hKsLJNYq2Bybj/3mnk4
         dQnKWqDKqsRnJZO/jOuLIQB0av0pcrci/0yWHtT4ciQpqKlgDMLwn/DEn1XzXRdznx7a
         omIsUcnCXMgAzcFQBfQkQjiOBccMgjbK6BpbY=
Message-ID: <86802c440808222241k36c95cd2h8e24031be1dc7b8@mail.gmail.com>
Date: Fri, 22 Aug 2008 22:41:36 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "David Witbrodt" <dawitbro@sbcglobal.net>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25 -- found another user with the same regression
Cc: "Ingo Molnar" <mingo@elte.hu>, "Vivek Goyal" <vgoyal@redhat.com>,
       "Bill Fink" <billfink@mindspring.com>, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "Peter Zijlstra" <peterz@infradead.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, netdev <netdev@vger.kernel.org>
In-Reply-To: <773466.71707.qm@web82102.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <773466.71707.qm@web82102.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2008 at 7:25 PM, David Witbrodt <dawitbro@sbcglobal.net> wrote:
>
> Yinghai,
>
> I finally found time to try to get some output using your patch for
> resource.c on a kernel that hangs.
>
> Some really good advice came in earlier today:  I can use "vga=1" to
> get 80x50 mode during the early boot sequence.  I used that, and made
> some alterations to the changes in your patch to squeeze more info
> onto the screen.  I also changed KERN_DEBUG to KERN_ERR in your
> printk's so that I could decrease the other output by using
> "loglevel=4".
>
> While I cannot see the entire set of output from your debug printk's,
> I can see the last 45+ lines that appear before the hang.  The results
> were the same as when I used "hpet=disable":  the only difference
> between the working 2.6.25 kernel and the hanging 2.6.27 kernel was
> that the resource named "0000:00:14.0" (fed00000-fed003ff) switched
> from "conflict=0" to "conflict=1".
>
> The output from 'cat /proc/iomem' on a non-hanging kernel included
> these two lines:
>
> fed00000-fed003ff : HPET 0
>  fed00000-fed003ff : 0000:00:14.0
that mean is hpet using insert_resource.


pnp 00:0d: mem resource (0xfed00000-0xfed000ff) overlaps 0000:00:14.0
BAR 1 (0xfed00000-0xfed003ff), disabling
request_resource: root: (PCI IO) [0, ffff], new: (0000:00:14.0) [fa00,
fa0f] conflict 0
request_resource: root: (PCI mem) [0, ffffffffffffffff], new:
(0000:00:14.0) [fed00000, fed003ff] conflict 1
pci 0000:00:14.0: BAR 1: can't allocate resource
piix4_smbus 0000:00:14.0: SMBus Host Controller at 0xfa00, revision 0


because  (0000:00:14.0) [fed00000, fed003ff]  conflicts to (reserved)
[fec00000, ffffffff] from e820.


kernel:
insert_resource: parent: (PCI mem) [0, ffffffffffffffff], new: (Kernel
code) [200000, 56ce41]
   insert_resource: good with request direct parent: (PCI mem) [0,
ffffffffffffffff], new: (Kernel code) [200000, 56ce41]
insert_resource: parent: (PCI mem) [0, ffffffffffffffff], new: (Kernel
data) [56ce42, 6d5f3f]
   insert_resource: good with request direct parent: (PCI mem) [0,
ffffffffffffffff], new: (Kernel data) [56ce42, 6d5f3f]
insert_resource: parent: (PCI mem) [0, ffffffffffffffff], new: (Kernel
bss) [773000, 7b7647]
   insert_resource: good with request direct parent: (PCI mem) [0,
ffffffffffffffff], new: (Kernel bss) [773000, 7b7647]

E820:
insert_resource: parent: (PCI mem) [0, ffffffffffffffff], new: (System
RAM) [0, 9f3ff]
   insert_resource: good with request direct parent: (PCI mem) [0,
ffffffffffffffff], new: (System RAM) [0, 9f3ff]
insert_resource: parent: (PCI mem) [0, ffffffffffffffff], new:
(reserved) [9f400, 9ffff]
   insert_resource: good with request direct parent: (PCI mem) [0,
ffffffffffffffff], new: (reserved) [9f400, 9ffff]
insert_resource: parent: (PCI mem) [0, ffffffffffffffff], new:
(reserved) [f0000, fffff]
   insert_resource: good with request direct parent: (PCI mem) [0,
ffffffffffffffff], new: (reserved) [f0000, fffff]
insert_resource: parent: (PCI mem) [0, ffffffffffffffff], new: (System
RAM) [100000, 77fdffff]
 insert_resource: first: (Kernel code) [200000, 56ce41], new: (System
RAM) [100000, 77fdffff]
 insert_resource: direct parent: (PCI mem) [0, ffffffffffffffff], new:
(System RAM) [100000, 77fdffff]
   insert_resource: child: (Kernel code) [200000, 56ce41], new:
(System RAM) [100000, 77fdffff]
   insert_resource: child: (Kernel data) [56ce42, 6d5f3f], new:
(System RAM) [100000, 77fdffff]
   insert_resource: child: (Kernel bss) [773000, 7b7647], new: (System
RAM) [100000, 77fdffff]
insert_resource: parent: (PCI mem) [0, ffffffffffffffff], new: (ACPI
Non-volatile Storage) [77fe0000, 77fe2fff]
   insert_resource: good with request direct parent: (PCI mem) [0,
ffffffffffffffff], new: (ACPI Non-volatile Storage) [77fe0000,
77fe2fff]
insert_resource: parent: (PCI mem) [0, ffffffffffffffff], new: (ACPI
Tables) [77fe3000, 77feffff]
   insert_resource: good with request direct parent: (PCI mem) [0,
ffffffffffffffff], new: (ACPI Tables) [77fe3000, 77feffff]
insert_resource: parent: (PCI mem) [0, ffffffffffffffff], new:
(reserved) [77ff0000, 77ffffff]
   insert_resource: good with request direct parent: (PCI mem) [0,
ffffffffffffffff], new: (reserved) [77ff0000, 77ffffff]
insert_resource: parent: (PCI mem) [0, ffffffffffffffff], new:
(reserved) [e0000000, efffffff]
   insert_resource: good with request direct parent: (PCI mem) [0,
ffffffffffffffff], new: (reserved) [e0000000, efffffff]
insert_resource: parent: (PCI mem) [0, ffffffffffffffff], new:
(reserved) [fec00000, ffffffff]
   insert_resource: good with request direct parent: (PCI mem) [0,
ffffffffffffffff], new: (reserved) [fec00000, ffffffff]



so old kernel lapic 0xfee0000, is insert at first, it will prevent
0xfec, ... 0xfffffff from e820 to be registered,
then (0000:00:14.0) [fed00000, fed003ff] got chance to be
registered..., timer will work...


root cause could be the chipset BAR1
request_resource: root: (PCI mem) [0, ffffffffffffffff], new:
(0000:00:14.0) [fed00000, fed003ff] conflict 1
is not handled properly...

guess when it can not get request_resource, it could clear that
BAR1...may need one quirk to save that.
just like we trust IO APIC addr in BAR for some devices.

YH
