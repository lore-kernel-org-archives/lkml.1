Return-Path: <linux-kernel-owner+w=401wt.eu-S1760554AbXHQUCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760554AbXHQUCm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 16:02:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752901AbXHQUCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 16:02:34 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:29528 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460AbXHQUCd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 16:02:33 -0400
X-IronPort-AV: i="4.19,277,1183348800"; 
   d="scan'208"; a="48684845:sNHT31524829"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 01/12] Blackfin arch: add peripheral resource allocation support
Date: Fri, 17 Aug 2007 21:02:27 +0100
Message-ID: <600D5CB4DFD93545BF61FF01473D11AC0D87BD9F@limkexm2.ad.analog.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 01/12] Blackfin arch: add peripheral resource allocation support
Thread-Index: Acfg/Ey/MEikX4ArTxqUWKeLmfk20wAAyjAQ
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: "David Brownell" <david-b@pacbell.net>, "Bryan Wu" <bryan.wu@analog.com>
Cc: <torvalds@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
       <akpm@linux-foundation.org>,
       "Michael Hennerich" <michael.hennerich@analog.com>
X-OriginalArrivalTime: 17 Aug 2007 20:02:30.0891 (UTC) FILETIME=[8B2743B0:01C7E109]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

>-----Original Message-----
>From: David Brownell [mailto:david-b@pacbell.net]
>Sent: Freitag, 17. August 2007 20:12
>To: Bryan Wu
>Cc: torvalds@linux-foundation.org; linux-kernel@vger.kernel.org;
>akpm@linux-foundation.org; Michael Hennerich
>Subject: Re: [PATCH 01/12] Blackfin arch: add peripheral resource
>allocation support
>
>On Tuesday 07 August 2007, Bryan Wu wrote:
>> From: Michael Hennerich <michael.hennerich@analog.com>
>
>The patch description here is IMO misleading, and is clearly
>weak-to-nonexistent ...  what this patch does is
>
> * Start tracking the label strings provided by gpio_request()
> * Provide a new portmux mechanisms
> * Start using those in the serial support code
>

Right - our patch descriptions needs to be worked on.  


>When I read "resource allocation" I think of "struct resource"
>from <linux/ioport.h>, allocate_resource(), and so on.  So while
>it's true there are other kinds of driver resource, it's rather
>unnatural for me to think about pin mux and gpio issues in any
>terms other than chip and board setup.

Let me explain a bit. On some Blackfin derivatives almost all PINs can
be GPIOs besides up to 4 alternative functions. For a well experienced
systems engineer being the same time the same guy who does the Hardware
and the Software this is not an issue. 
We provide all kind of drivers utilizing almost any peripheral on
Blackfin. 
While potentially causing conflicting usage, for someone without
detailed hardware knowledge. The platform device board file is a good
thing to track conflicting memory or IO space resources as well as IRQs.
We also utilize platform device files for exactly these purposes.

The dynamic resource allocation for pinmux and gpio seems to us the best
way to handle things. The "resource allocation" mechanism will spill an
error and dump in case conflicting usage is detected. It'll also tell
you who is causing the conflicting usage.       

>
>
>> +static int cmp_label(unsigned short ident, const char *label)
>> +{
>> +	if (label && str_ident)
>> +		return strncmp(str_ident + ident * RESOURCE_LABEL_SIZE,
>> +				 label, strlen(label));
>> +	else
>> +		return -EINVAL;
>> +}
>
>GRPIO labels are purely for diagnostics.  There's no reason to
>compare one to another.  You seem to be using these for purposes
>in addition to GPIOs though ... probably worth commenting on that
>unusual scheme.

You are right - diagnostics:
Telling who claimed my resource.
In addition getting a signature, allowing double allocation.

Some drives provide the option for a simple callback function exported
though the platform device file, in order to toggle a GPIO powering up
some external device. Without some additional global external flag it's
pretty had to maintain whether this gpio was allocated before.
In this case I prefer to allow double allocation, for the same purpose. 
  

>
>
>> +int peripheral_request(unsigned short per, const char *label)
>> +{
>> +	...
>> +
>> +	if (unlikely(reserved_peri_map[gpio_bank(ident)] &
gpio_bit(ident)))
>{
>> +
>> +	/*
>> +	 * Pin functions like AMC address strobes my
>> +	 * be requested and used by several drivers
>> +	 */
>> +
>> +	if (!(per & P_MAYSHARE)) {
>
>Goofy indentation.  And as a rule, drivers have been kept out of
>the business of configuring pin usage.  It's simpler that way;
>they don't need to try coping with configuration errors like two
>drivers wanting conflicting usage ... or as you say above, needing
>some explicit sharing mechanism ...


We define some PINs or better single PIN functions to be may shared.
This is only for PINs where the sharing of the function is in nature.
Think about an address strobe or a bus (Busy/Wait) signal, used by
several
drivers/devices sharing the same bus.


>
>
>> +
>> +	/*
>> +	 * Allow that the identical pin function can
>> +	 * be requested from the same driver twice
>> +	 */
>
>... or as you say here, needing to structure themselves so they
>don't configure the same usage more than once ...


Same as explained above - this is only for these spots where the
request/free scheme doesn't work. 

>
>
>That said, how you handle pinmux on Blackfin is your business.
>
>But you should know that this approach seems idiosyncratic and
>more complex than needed:  when pin config is done early and as
>part of board setup, drivers don't need to care about it or to
>handle any pinmux errors.  And heck, products can sometimes be
>shipped with the bootloader having done all pinmux setup, so
>Linux won't need to worry about it at all.  That can help ship
>multiple board revisions using the same kernel.

This works for fixed function boards. But not for development boards
where we provide lego like add on cards, and allow people to connect
their homebrewn hardware.  

Most people/customers I cope with, use the boot loader to only boot the
Linux kernel. The hardware setup we default the processor in the boot
loader might not fit their applications needs.   

-Michael

>
>- Dave
>
