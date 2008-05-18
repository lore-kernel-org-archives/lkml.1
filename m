Return-Path: <linux-kernel-owner+w=401wt.eu-S1753110AbYERR5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110AbYERR5S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 13:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752393AbYERR5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 13:57:05 -0400
Received: from mailout04.t-online.de ([194.25.134.18]:57199 "EHLO
	mailout04.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250AbYERR5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 13:57:03 -0400
Message-ID: <48306DCA.9070108@t-online.de>
Date: Sun, 18 May 2008 19:56:26 +0200
From: Harald Dunkel <harald.dunkel@t-online.de>
User-Agent: Thunderbird 2.0.0.14 (X11/20080503)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25.3: su gets stuck for root
References: <4829326A.6060808@t-online.de>	<19f34abd0805122347x4d9c5d03m16679d724189790e@mail.gmail.com>	<4829D345.7020909@t-online.de>	<19f34abd0805140034j75d97ecbw5a03c200645768cb@mail.gmail.com>	<482B1BD2.8040400@t-online.de>	<19f34abd0805141017g26c13e96t2e7edc23bec263d0@mail.gmail.com> <20080514183558.40178fe5@core>
In-Reply-To: <20080514183558.40178fe5@core>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: ZASag-Z6ghkPNmQzUUaVd6wSgxu4Ed-5I3F2+dfRzYf64cngC96UzVrZ9KuuXoIg+v
X-TOI-MSGID: eb0c587a-bbb8-4ec2-b88b-6452f35e172a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> If I run "su someuser" as root, then it gets stuck. No prompt. I cannot
>> interrupt it with ^C or ^Z either. /var/log/auth.log says:
> 
> Is it then killable remotely, can you gdb it ?
> 

Attaching to the running stty failed:

# gdb stty 26465
GNU gdb 6.8-debian
Copyright (C) 2008 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
and "show warranty" for details.
This GDB was configured as "x86_64-linux-gnu"...
Attaching to program: /var/tmp/coreutils-6.10/coreutils-6.10/src/stty, process 26465
/tmp/buildd/gdb-6.8/gdb/linux-nat.c:988: internal-error: linux_nat_attach: Assertion `pid == GET_PID (inferior_ptid) && WIFSTOPPED (status) && WSTOPSIG (status) == SIGSTOP' failed.
A problem internal to GDB has been detected,
further debugging may prove unreliable.
:


I can kill it with -9, but INTR, SEGV, BUS, etc. don't interrupt
it. And if I run stty inside of the debugger (or on the command
line), then it doesn't get stuck.

I have changed stty.c to do some print statements, and changed
root's .bashrc to use it for "stty intr ^C": It gets stuck
inside tcsetattr():

       printf("here we are\n");
       if (tcsetattr (STDIN_FILENO, TCSADRAIN, &mode))
	error (EXIT_FAILURE, errno, "%s", device_name);
       printf("born to be kings\n");

The previous tcgetattr() to read the old terminal settings shows
no problem (AFAICS).

Replacing TCSADRAIN by 0 doesn't help.



Regards

Harri
