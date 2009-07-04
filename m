Return-Path: <linux-kernel-owner+w=401wt.eu-S1759272AbZGDAYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759272AbZGDAYT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 20:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758176AbZGDAYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 20:24:09 -0400
Received: from mx.treblig.org ([80.68.94.177]:59792 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757898AbZGDAYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 20:24:08 -0400
Date: Sat, 4 Jul 2009 02:24:03 +0100
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: Re: 2.6.{28,30} Keyboard not working on oldish machine
Message-ID: <20090704012403.GA31026@gallifrey>
References: <alpine.LNX.2.00.0906291103140.18021@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.0906291103140.18021@wotan.suse.de>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/2.6.29.2-bytemark-kvm-tickless-2009-05-05 (i686)
X-Uptime: 02:05:49 up 38 days, 18:27,  2 users,  load average: 0.06, 0.03, 0.00
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jiri Kosina (jkosina@suse.cz) wrote:
> On Sun, 28 Jun 2009, Dr. David Alan Gilbert wrote:
> 
> > Apologies for the delay; attached is the dmesg from the Debian 2.6.18
> > in which keyboard works as previously described.
> 
> So the main difference is here:
> 
> 	drivers/input/serio/i8042.c: 20 -> i8042 (command) [3]
> 	drivers/input/serio/i8042.c: 65 <- i8042 (return) [3]
> 	drivers/input/serio/i8042.c: 60 -> i8042 (command) [3]
> 	drivers/input/serio/i8042.c: 74 -> i8042 (parameter) [3]
> 	drivers/input/serio/i8042.c: Interrupt 1, without any data [3]
> 
> compared to
> 
> 	drivers/input/serio/i8042.c: 20 -> i8042 (command) [1]
> 	drivers/input/serio/i8042.c: 65 <- i8042 (return) [1]
> 	drivers/input/serio/i8042.c: 60 -> i8042 (command) [2]
> 	drivers/input/serio/i8042.c: 74 -> i8042 (parameter) [2]
> 	drivers/input/serio/i8042.c: d3 -> i8042 (command) [2]
> 
> So it looks like it is really affected by the polling timer removal/early 
> IRQ registration.

While that is different it does carry on; and, if I'm reading it
right, the last thing it does in my 2.6.30 logs is enable the keyboard
and then prod the mouse:

[    2.814817] drivers/input/serio/i8042.c: f4 -> i8042 (kbd-data) [13]
[    2.817615] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [14]
[    2.823470] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    2.827716] evbug.c: Connected device: input1 (AT Translated Set 2 keyboard at isa0060/serio0/input0)
[    2.828278] drivers/input/serio/i8042.c: d4 -> i8042 (command) [17]
[    2.828427] drivers/input/serio/i8042.c: f2 -> i8042 (parameter) [17]

The 'ack' to the f4 presumably means the keyboard is reasonably happy?

That 'd4, f2' write-to-mouse times out on the 2.6.18 version, but no other 8042 debug
comes out on the 2.6.30. Here's the matching 2.6.18:

drivers/input/serio/i8042.c: d4 -> i8042 (command) [7]
drivers/input/serio/i8042.c: f2 -> i8042 (parameter) [7]
EISA: Probing bus 0 at eisa.0
EISA: Detected 0 cards.
TCP bic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
NET: Registered protocol family 8
NET: Registered protocol family 20
Using IPI Shortcut mode
Time: tsc clocksource has been installed.
Freeing unused kernel memory: 256k freed
drivers/input/serio/i8042.c: fe <- i8042 (interrupt, AUX, 0, timeout) [19]
drivers/input/serio/i8042.c: d4 -> i8042 (command) [19]
drivers/input/serio/i8042.c: ed -> i8042 (parameter) [19]
drivers/input/serio/i8042.c: fe <- i8042 (interrupt, AUX, 0, timeout) [31]
drivers/input/serio/i8042.c: 60 -> i8042 (command) [31]
drivers/input/serio/i8042.c: 44 -> i8042 (parameter) [31]

(Although it's a bit difficult to compare since it seems 2.6.18 tends to do
mouse first and only keyboard after the mouse times out).

Dave
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    | Running GNU/Linux on Alpha,68K| Happy  \ 
\ gro.gilbert @ treblig.org | MIPS,x86,ARM,SPARC,PPC & HPPA | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
