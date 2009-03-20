Return-Path: <linux-kernel-owner+w=401wt.eu-S1757950AbZCTA6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950AbZCTA6Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 20:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752865AbZCTA6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 20:58:14 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44723 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbZCTA6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 20:58:13 -0400
Date: Fri, 20 Mar 2009 01:58:08 +0100
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, daniel.krueger@systec-electronic.com,
       Michael Olbrich <mol@pengutronix.de>, Wolfram Sang <wsa@pengutronix.de>,
       Marc Kleine-Budde <mkl@pengutronix.de>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: The Linux Staging tree, what it is and is not.
Message-ID: <20090320005808.GM5367@pengutronix.de>
References: <20090318183232.GA11594@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090318183232.GA11594@kroah.com>
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Linux Solutions for Science and Industry
	Handelsregister:  Amtsgericht Hildesheim, HRA 2686 Peiner Strasse
	6-8, 31137 Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax:
	+49-5121-206917-5555 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 01:05:26 up 29 days, 15:58, 29 users,  load average: 0.02, 0.10,
	0.05
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: rsc@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

On Wed, Mar 18, 2009 at 11:32:32AM -0700, Greg KH wrote:
> If anyone has any questions that this summary doesn't answer, please let me
> know.

Let me take this as an opportunity to discuss the epl (Ethernet
Powerlink) driver in staging. Taken aside the eye-cancer thing while
looking at the code (this could be fixed in the staging model), I
suppose the whole design is questionable.

We have ported similar commercial EPL stacks to linux-rt in the past,
and what we simply did is to implement the code completely in userspace,
ontop of a raw socket. It worked out pretty well and with reasonable
realtime performance. For the high level API, we used the process data
model provided by libpv [1], which gives you an abstraction that follows
both, automation-people's "process variable" concept and a modern object
oriented desing (in C, modeled after the POSIX object model for example
like pthread_create() & friends).

Doing this kind of network protocols in kernel space may be possible in
general, but IMHO the first thing that has to be done for a sane design
is:

	"Invent proper APIs and abstractions"

Unfortunately, industry people have somehow missed the last 10 years of
software engineering, so even recent ethernet fieldbus designs like
PowerLink or EtherCAT use the CANopen Object Dictionary [1] as their
"abstraction" between the stack and the application. So writing
applications in the EPL/CANopen/EtherCAT world works by PEEK and POKE on
a variable-length global variable array. Welcome to software design of
the 80es. Nevertheless, "Object Dictionary" is a standard API for
industry people which cannot be discussed away, because automation
people are used to this terminology.

So if we want to do any kind of EPL/CANopen/EtherCAT work in the kernel,
let's start with the question what it buys us in comparism with a pure
userspace solution like outlined above.

One interesting thing could be shared APIs among this group of
fieldbusses, for example one ObjectDictionary API that works for
CANopen, EPL and EtherCAT. If we put that into the kernel, I'm wondering
how this API could look like; the problem with objdict is that it is
variable length, here's an example:

  /-------------> 16 bit index
 /    /---------> length
/--\ /  /--/----> data, addressed with 8 bit subindex
0000 02 aa bb
0001 00
0002 05 aa bb cc dd ee
....
FFFF ..

Using that "API" more or less works by poking the right magic bits to
several locations and things start happening.

So what would be the right kernel-userspace API for that? mmap() on a
device node does not work because of the variable length nature. On the
other hand, accessing the objdict shall be fast, because it will happen
in the fast path of a control application. Another possibility could be
sysfs, with the indices being the file names. That could at least be
used for manual access (development, debugging) or initial setup. Is
that fast enough? I don't know. Usually the initial objdict is worked
out once during the design phase of an application, so you'll be able to
load a whole objdict into the system on boot time. Later on, during
operational phase of the stack, netlink may be used to propagate events
and changes, at least until somebody is brave enough to write an
in-kernel dbus server :-)

The objdict is IMHO the most complicated part, because other
interactions like NMT, PDO and SDO could be easily done with sysfs +
netlink.

However, I'm still not convinced that this is the right way to go. What
you want to do for the main APIs is provide some nice userspace library
API for your applications. Why not put the whole "stack" into userspace
then and connect it to the kernel only via raw socket.

What do others think? Is it worth the effort to invent a proper objdict
API for linux?

rsc

[1] http://www.pengutronix.de/software/libpv/index_en.html
[2] http://en.wikipedia.org/wiki/CANopen#Object_dictionary
-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
