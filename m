Return-Path: <linux-kernel-owner+w=401wt.eu-S1757395AbXLWURV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395AbXLWURV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 15:17:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755013AbXLWURO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 15:17:14 -0500
Received: from mailbox2.myri.com ([64.172.73.26]:1943 "EHLO myri.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754919AbXLWURN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 15:17:13 -0500
Message-ID: <476EC218.6030000@myri.com>
Date: Sun, 23 Dec 2007 15:16:24 -0500
From: Loic Prylli <loic@myri.com>
User-Agent: Thunderbird/2.0.0.4 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Tony Camuso <tcamuso@redhat.com>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [Fwd: Re: [PATCH 0/5]PCI: x86 MMCONFIG]
References: <476A5FD0.4010804@redhat.com> <20071220172205.GB5636@suse.de> <20071220173528.GE29690@parisc-linux.org> <476AAE99.7090301@redhat.com> <20071220181603.GF29690@parisc-linux.org>
In-Reply-To: <20071220181603.GF29690@parisc-linux.org>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/20/2007 1:16 PM, Matthew Wilcox wrote:
> Oh, that's the same bug others (including me) have been complaining
> about.
>
> http://marc.info/?l=linux-kernel&m=118809338631160&w=2
>
>   
>> It hangs in exactly the same place every time.
>>
>> I am surmising that the write to that BAR is causing a MCE.
>>     
>
> Bad deduction.  What's happening is that the write to the BAR is causing
> it to overlap the decode for mmconfig space.  So the mmconfig write to
> set the BAR back never gets through.
>
> I have a different idea to fix this problem.  Instead of writing
> 0xffffffff, we could look for an unused bit of space in the E820 map and
> write, say, 0xdfffffff to the low 32-bits of a BAR.  Then it wouldn't
> overlap, and we could find its size using MMCONFIG.
>
> Does anyone know how Windows handles these machines? 



I just realized one thing: the bar sizing code in pci_read_bases() (that
writes 0xffffffff in the bars) does not seem to disable the
PCI_COMMAND_MEM/PCI_COMMAND_IO bits in the cmd register before
manipulating the BARs. And it seems nobody else ensures they are
disabled at this point either (or am I missing something?).


Touching the bars while they are enabled would be buggy behaviour from
our part, and something trivial to fix. And it might well fix that
particular problem (it's fair play from the machine to crash if we
create a decoding conflict, simply disabling the cmd bits in
pci_read_bases() should remove that conflict).

FWIW, to partially answer your last question, Windows does disable
mem-space and/or IO-space when sizing the bars of a device (I have some
traces of configuration-space-access taken on a window machine for one
of the PCI busses).



Loic






