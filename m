Return-Path: <linux-kernel-owner+w=401wt.eu-S1753425AbXDKRhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425AbXDKRhU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 13:37:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753428AbXDKRhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 13:37:20 -0400
Received: from atlrel8.hp.com ([156.153.255.206]:43215 "EHLO atlrel8.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753425AbXDKRhT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 13:37:19 -0400
Message-ID: <461D1BA3.60903@hp.com>
Date: Wed, 11 Apr 2007 13:32:19 -0400
From: Jay Estabrook <jay.estabrook@hp.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070105)
MIME-Version: 1.0
To: rth@twiddle.net
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jay Estabrook <jay.estabrook@hp.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] ALPHA: support graphics on non-zero PCI domains
References: <20070411123048.H17547@jurassic.park.msu.ru> <20070411160520.GB12573@twiddle.net>
In-Reply-To: <20070411160520.GB12573@twiddle.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Henderson wrote:
> On Wed, Apr 11, 2007 at 12:30:48PM +0400, Ivan Kokshaysky wrote:
>   
>> +VGA_MAP_MEM(unsigned long xaddr, unsigned int size)
>> +{
>> +	/* Create a new VGA ioport resource WRT the hose it is on. */
>> +	if (pci_vga_hose && pci_vga_hose->index) {
>> +		static struct resource alpha_vga =
>> +		  { .name = "alpha-vga+", .start = 0x3C0, .end = 0x3DF };
>> +		struct resource new_vga = alpha_vga;
>> +
>> +		new_vga.start += pci_vga_hose->io_space->start;
>> +		new_vga.end   += pci_vga_hose->io_space->start;
>> +		request_resource(&ioport_resource, &new_vga);
>>     
>
> This leaks the local stack frame variable new_vga into the
> resource tree, does it not?  Shouldn't you be kmallocing this?
>
>
> r~
>   
Yes, it does leak, and yes, it should be kmalloced. Something like this?

        struct resource *new_vga;

        new_vga = kmalloc(sizeof(struct resource), GFP_ATOMIC);
        if (new_vga) {
            *new_vga = alpha_vga;
            new_vga->start += pci_vga_hose->io_space->start;
            new_vga->end   += pci_vga_hose->io_space->start;
            request_resource(&ioport_resource, new_vga);
        }

Thanks, Richard, I'll regenerate this one...

--Jay++

-- 
Jay A Estabrook                            HPTC - XC I & B
Hewlett-Packard Company - ZKO1-3/D-B.8     (603) 884-0301
110 Spit Brook Road, Nashua NH 03062       Jay.Estabrook@hp.com

