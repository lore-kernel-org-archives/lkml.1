Return-Path: <linux-kernel-owner+w=401wt.eu-S1759640AbXKPIab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759640AbXKPIab (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 03:30:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752432AbXKPIaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 03:30:15 -0500
Received: from py-out-1112.google.com ([64.233.166.179]:3861 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbXKPIaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 03:30:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=a5nBE4gl4GU7elZoXPwZAP2VGLiwxCg5OeBZFi/ruysBdey5uPjMid0ro9Il7JrYDtzgQiYE0LNvqfxCnQecM7xenq2KsKyEfKp4dp0ep3YouApwTLaSZHAzaaUsE97ZE6LLaMOKP0QRh93K2zHa7LrK8moIZ++M631rgN+SpQg=
Message-ID: <cac0ab7d0711160030w149c7a7s2db55ac56d0a05cc@mail.gmail.com>
Date: Fri, 16 Nov 2007 09:30:11 +0100
From: "Jonas Danielsson" <the.sator@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: [PATCH] net/ipv4/arp.c: Fix arp reply when sender ip 0
Cc: kuznet@ms2.inr.ac.ru, linux-kernel@vger.kernel.org, jmorris@namei.org,
       netdev@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <20071115.152813.89410917.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <cac0ab7d0711150340p58eda94ah92894072ba328205@mail.gmail.com>
	 <20071115154032.GA30391@ms2.inr.ac.ru>
	 <cac0ab7d0711151340l1cc91a2dw5ebf36e166d16d7a@mail.gmail.com>
	 <20071115.152813.89410917.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/11/16, David Miller <davem@davemloft.net>:
> From: "Jonas Danielsson" <the.sator@gmail.com>
> Date: Thu, 15 Nov 2007 22:40:13 +0100
>
> > Is there a reason that the target hardware address isn't the target
> > hardware address?
>


> Because of this, in cases where a choice can be made Linux will
> advertise what is most likely to result in successful communication.
>
> This is likely why we are changing that target address to the one of
> the interface actually sending back the reply rather than the zero
> value you used.
>
> In fact I think this information can be useful to the sender of
> the DAD request.
>

There seem to be some confusion about what my patch really does. It
does not set the hardware address to a zero value.

An example to illustrate:

We have two computers.
Computer A
IP: 192.168.0.1
HW: 00:AA:00:AA:00:AA

Computer B
IP: None
HW: 00:BB:00:BB:00:BB

Computer B want to find out if IP 192.168.0.1 is free for use. It
sends an arp-request.

Request:
Opcode: request (0x0001)
Sender HW: 00:BB:00:BB:00:BB
Sender IP:    0.0.0.0
Target HW:   00:00:00:00:00:00
Target IP:     192.168.0.1

The reply from the Linux kernel in computer A, before the patch would look like:

Reply:
Opcode: reply (0x0002)
Sender HW: 00:AA.00:AA:00:AA
Sender IP:   192.168.0.1
Target HW:  00:AA:00:AA:00:AA
Target IP:    192.168.0.1

And the reply from the Linux kernel, in computer A, after the patch
would look like:

Reply:
Opcode: reply (0x0002)
Sender HW: 00:AA.00:AA:00:AA
Sender IP:   192.168.0.1
Target HW:  00:BB:00:BB:00:BB
Target IP:    0.0.0.0

It is the fact that the Target HW  address is set to computer A and
not computer B that my patch wants to fix. And the Target IP: 0.0.0.0
is because OpenBSD and windows replied in that way.

I wanted to change this because, among other things, dhcpcd-2.0.3 has
the following code in its arpCheck-function:

if ( memcmp(ArpMsgRecv.tHaddr,ClientHwAddr,ETH_ALEN) )
if ( DebugFlag )
	    	syslog(LOG_DEBUG,
	    	"target hardware address mismatch:"  [...]

This check will always fail when replies come from Linux machines,
since the target hardware address will not match the client mac
address.


-Jonas
