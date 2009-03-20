Return-Path: <linux-kernel-owner+w=401wt.eu-S1757207AbZCTIe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757207AbZCTIe6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 04:34:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756924AbZCTIek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 04:34:40 -0400
Received: from webbox687.server-home.net ([195.149.74.151]:38720 "EHLO
	webbox687.server-home.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757080AbZCTIeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 04:34:36 -0400
Message-ID: <49C35515.8050808@systec-electronic.com>
Date: Fri, 20 Mar 2009 09:34:29 +0100
From: =?ISO-8859-1?Q?Daniel_Kr=FCger?= 
	<daniel.krueger@systec-electronic.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
Cc: Robert Schwebel <r.schwebel@pengutronix.de>, linux-kernel@vger.kernel.org,
       Michael Olbrich <mol@pengutronix.de>, Wolfram Sang <wsa@pengutronix.de>,
       Marc Kleine-Budde <mkl@pengutronix.de>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: The Linux Staging tree, what it is and is not.
References: <20090318183232.GA11594@kroah.com> <20090320005808.GM5367@pengutronix.de> <20090320024816.GA20213@kroah.com>
In-Reply-To: <20090320024816.GA20213@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH schrieb:
> On Fri, Mar 20, 2009 at 01:58:08AM +0100, Robert Schwebel wrote:
>> Greg,
>>
>> On Wed, Mar 18, 2009 at 11:32:32AM -0700, Greg KH wrote:
>>> If anyone has any questions that this summary doesn't answer, please let me
>>> know.
>> Let me take this as an opportunity to discuss the epl (Ethernet
>> Powerlink) driver in staging. Taken aside the eye-cancer thing while
>> looking at the code (this could be fixed in the staging model), I
>> suppose the whole design is questionable.
> 
> Sure it's questionable, and it's horrid code, but it is being used by
> people and is the only public implementation of EPL on Linux that I can
> find.

BTW, the implementation does not follow the kernel style guide, because 
our company has its own code style guide. But what is that you don't like?

>> We have ported similar commercial EPL stacks to linux-rt in the past,
>> and what we simply did is to implement the code completely in userspace,
>> ontop of a raw socket. It worked out pretty well and with reasonable
>> realtime performance. For the high level API, we used the process data
>> model provided by libpv [1], which gives you an abstraction that follows
>> both, automation-people's "process variable" concept and a modern object
>> oriented desing (in C, modeled after the POSIX object model for example
>> like pthread_create() & friends).
>>
>> Doing this kind of network protocols in kernel space may be possible in
>> general, but IMHO the first thing that has to be done for a sane design
>> is:
>>
>> 	"Invent proper APIs and abstractions"
> 
> Agreed.

I can only second that. But it is no easy task to find a common API for 
all field busses.

>> Unfortunately, industry people have somehow missed the last 10 years of
>> software engineering, so even recent ethernet fieldbus designs like
>> PowerLink or EtherCAT use the CANopen Object Dictionary [1] as their
>> "abstraction" between the stack and the application. So writing
>> applications in the EPL/CANopen/EtherCAT world works by PEEK and POKE on
>> a variable-length global variable array. Welcome to software design of
>> the 80es. Nevertheless, "Object Dictionary" is a standard API for
>> industry people which cannot be discussed away, because automation
>> people are used to this terminology.
>>
>> So if we want to do any kind of EPL/CANopen/EtherCAT work in the kernel,
>> let's start with the question what it buys us in comparism with a pure
>> userspace solution like outlined above.
> 
> Are userspace solutions for this opensource today?

No. But openPOWERLINK can be ported to userspace.

I would propose another solution.
Just leave the high priority tasks in the kernel which directly deal 
with the Ethernet frames and implement all other modules in userspace. 
Maybe we can enhance the standard network driver interface and directly 
connect the data link layer of POWERLINK to it. Additionally I would put 
the core NMT state machine and the PDO processing (encode and decode the 
frames with the process data from and into the process image) into the 
kernel. The process image can be accessed via mmap from userspace. All 
other modules like the object dictionary, SDO module, network management 
of the MN, etc can be put in userspace. I think the described kernel 
part can be done without the knowledge of an object dictionary at all. 
It's just a matter of "proper APIs".

> <snip>
> 
>> What do others think? Is it worth the effort to invent a proper objdict
>> API for linux?
> 
> I suggest discussing this on netdev, that's the proper place for network
> protocol discussions like this, right?

Ok, I will subscribe it.

cu,
   Daniel

--
SYS TEC electronic GmbH
August-Bebel-Str. 29
D-07973 Greiz

Telefon  : +49 (0) 3661 6279 0
Fax      : +49 (0) 3661 6279 99
Email    : daniel.krueger@systec-electronic.com
Internet : http://www.systec-electronic.com

Managing Director   : Dipl.-Phys. Siegmar Schmidt
Commercial registry : Amtsgericht Jena, HRB 205563
