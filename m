Return-Path: <linux-kernel-owner+w=401wt.eu-S1758973AbYFLLwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758973AbYFLLwV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 07:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752214AbYFLLwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 07:52:09 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:55625 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077AbYFLLwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 07:52:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=SYhLXwV762lB5RpqODL0jdqUFpWER+Gm8uBG0uEXZA9HxC1yEAQuZkRLoRk0ZGbUOP
         WRuP0O0sipSrdsK37wdLLWIkUQaDEhT+ppASahn/QBRg21NQguCVuYFsvEZd0TXn4L0a
         DDIaBHiT7zFrS7kxpgaC4zrVZe1WU24LHbKjk=
Message-ID: <19f34abd0806120452w433e9763v2ee92e2f278ae988@mail.gmail.com>
Date: Thu, 12 Jun 2008 13:52:06 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Joe Peterson" <joe@skyrush.com>
Subject: Re: 2.6.25.3: su gets stuck for root
Cc: "Alan Cox" <alan@redhat.com>, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "David Newall" <davidn@davidnewall.com>, "Willy Tarreau" <w@1wt.eu>,
       "Harald Dunkel" <harald.dunkel@t-online.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <484FDB63.6050504@skyrush.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48438126.3080308@t-online.de> <20080602102033.63e4cd18@core>
	 <48441138.90503@skyrush.com>
	 <20080602155133.GC933@devserv.devel.redhat.com>
	 <4846A9F4.40003@skyrush.com>
	 <20080604151649.GB12625@devserv.devel.redhat.com>
	 <4846C85E.7080309@skyrush.com>
	 <20080604171056.GB17875@devserv.devel.redhat.com>
	 <4846FBF2.9010206@skyrush.com> <484FDB63.6050504@skyrush.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2008 at 4:04 PM, Joe Peterson <joe@skyrush.com> wrote:
> Joe Peterson wrote:
>> Anyway, here is more info:
>>
>> tty_check_change: current->signal->tty = f7880800
>> tty_check_change: tty = f7880800
>> tty_check_change: tty->pgrp = f7b99e40
>>   tty->pgrp->count = 5
>>   tty->pgrp->level = 0
>>   tty->pgrp->numbers[0].nr = 6951
>> tty_check_change: task_pgrp(current) = f7b99d40
>>   task_pgrp(current)->count = 1
>>   task_pgrp(current)->level = 0
>>   task_pgrp(current)->numbers[0].nr = 6952
>> tty_check_change: kill_pgrp called; returning -ERESTARTSYS
>> set_termios: error return value (-512) from tty_check_change
>> foo       6951  0.0  0.1   2332  1096 tty1     S+   14:18   0:00 su foo
>> foo       6952  0.0  0.1   2988  1464 tty1     S    14:18   0:00 bash
>>
>>
>> So, looks like the tty->pgrp's process is the "su" command itself, and
>> the task_pgrp(current)'s process is "bash" - the shell started by the su.
>
> If anyone has any tips for my further debugging of this, given the
> above, let me know.  I'd like to help resolve this.

I think knowing the pgrps of the above processes (there is possibly
one more involved, stty?) would be useful; try:

    $ ps -eo pid,pgrp,tpgid,user,args

..as this problem occurs because a process tries to change the
terminal settings (and subsequently gets suspended because of that)
while it's not the owner of the terminal.

This can happen if you fork something off to the background, e.g. like

    $ stty 9600 &

(which should immediately give you [1]+ Stopped stty 9600),

so can you please look for anything like that in your login scripts or
shell rc files?

I don't know any other way to debug this further, sorry :-(

Thanks.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
