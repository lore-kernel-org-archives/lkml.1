Return-Path: <linux-kernel-owner+w=401wt.eu-S1755277AbZFVXzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277AbZFVXzw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 19:55:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbZFVXzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 19:55:43 -0400
Received: from claw.goop.org ([74.207.240.146]:60429 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955AbZFVXzm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 19:55:42 -0400
Message-ID: <4A4019F9.4020702@goop.org>
Date: Mon, 22 Jun 2009 16:55:37 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Alex Chiang <achiang@hp.com>, jbarnes@virtuousgeek.org,
       linux-arch@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>,
       Tony Luck <tony.luck@intel.com>, Russell King <linux@arm.linux.org.uk>,
       Arnd Bergmann <arnd@arndb.de>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeff Dike <jdike@addtoit.com>, linux-kernel@vger.kernel.org,
       Ralf Baechle <ralf@linux-mips.org>, David Howells <dhowells@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Ingo Molnar <mingo@redhat.com>, "David S. Miller" <davem@davemloft.net>,
       Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH] PCI: remove pcibios_scan_all_fns()
References: <20090622140807.25509.54448.stgit@bob.kio> <20090622143431.GT19977@parisc-linux.org> <4A3FCB68.3030004@goop.org> <20090622183056.GY19977@parisc-linux.org>
In-Reply-To: <20090622183056.GY19977@parisc-linux.org>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/09 11:30, Matthew Wilcox wrote:
> On Mon, Jun 22, 2009 at 11:20:24AM -0700, Jeremy Fitzhardinge wrote:
>   
>>> I'd like to know what the KVM / Xen / ... people think about this.
>>> I don't know if they rely on function 5 being able to show up out of
>>> the blue.
>>>       
>> We want to be able to export specific functions to a particular domain,
>> so it might see a PCI device with only function 5.
>>
>> It looks like we lose that ability with this patch, is that right?
>>     
>
> That would be correct.  I'm guessing your out-of-tree code sets
> pcibios_scan_all_fns()?
>   

Yes.

> Now, there are various options.  One is that you could remap config
> space accesses -- domain:bus:dev.fn in the guest don't have to match
> domain:bus:dev.fn in the host.  That's a certain amount of overhead in
> every config space access, but it doesn't have to be a large one.
>   

I think the problem with that is that certain devices have fixed
functions at fixed function numbers, so the drivers just expect the
function to be there and nowhere else (AFAIK there's no way to do
discovery on functions).  Now perhaps you'd never export just some
functions to such devices, but that was the answer when I proposed doing
this.

And if we did want to do this, would it be acceptible to put config
space remapping in?  I presume that's something that would have to be in
the generic pci library?

> Another would be that you could create dummy devices in the guest at
> function 0, and then the guest would scan all the functions.  A little
> ugly, perhaps.
>   

I wonder if that would upset drivers.  Assuming they can cope with just
being given some functions, how could one generically make a function
look present-but-dummy enough to not upset the driver?

> A third would be for guests to not do this scanning at all.  You could
> present the devices through something like the openfirmware tree, and
> create them insteaqd of scanning for them.  If you care about startup
> time, this is probably the way to go.
>   

I don't think startup time is an overriding concern.

    J
