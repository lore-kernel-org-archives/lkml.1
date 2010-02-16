Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672Ab0BPMoK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 07:44:10 -0500
Received: from mail1.radix.net ([207.192.128.31]:53900 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754102Ab0BPMoI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 07:44:08 -0500
Subject: Re: msgmnb limits?
From: Andy Walls <awalls@radix.net>
To: Troels Arvin <troels.arvin@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4B7A7A7A.1000805@gmail.com>
References: <4B7A7A7A.1000805@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Feb 2010 07:43:09 -0500
Message-Id: <1266324189.3069.16.camel@palomino.walls.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-02-16 at 11:59 +0100, Troels Arvin wrote:
> Hello,
> 
> On a server with lots of RAM (192GB), I ran into an application (DB2) 
> which applies the following sysctl changes when it's started, if the 
> values haven't already been set to - at least - the stated values:
> 
>   - kernel.msgmax = 65535
>   - kernel.msgmnb = 65536
> 
> However, that doesn't work: Certain operations (LOAD and 
> backups/restores) will fail with the following messages, unless 
> kernel.msgmnb is increased:
> 
> DIA8557C No message was sent using the message queue.
> CALLED  : OS, -, msgsnd                           OSERR: EAGAIN (11)
> DATA #1 : system V message queue identifier., PD_TYPE_SYSV_QUEUE_ID


Well, one app filled up a System V(-ish) message queue because another
app is not reading messages off fast enough, or the message queue is too
small to handle the burst.  The EAGAIN indicates the message queue was
full.

Looking at man msgsnd :

	[...]
       EAGAIN The  message  can’t  be sent due to the msg_qbytes limit for the
              queue and IPC_NOWAIT was specified in msgflg.

	[...]
       The  following  limits  on  message queue resources affect the msgsnd()
       call:

       MSGMAX Maximum size for a message text:  8192  bytes  (on  Linux,  this
              limit can be read and modified via /proc/sys/kernel/msgmax).

       MSGMNB Default  maximum  size  in bytes of a message queue: 16384 bytes
              (on  Linux,  this  limit  can   be   read   and   modified   via
              /proc/sys/kernel/msgmnb).   The  superuser can increase the size
              of a message queue beyond MSGMNB by a msgctl(2) system call.


> I tried setting kernel.msgmnb to 524288, and then things work. This 
> value was chosen out of the blue, and I'd like to make a more informed 
> choice:

HP-UX 10.20 had a utility called "ipcstat" that allowed one to monitor
the usage of System V message queues.  I would guess there is something
similar under Linux or a maybe this file in /proc:

	cat /proc/sysvipc/msg

see man msg_ctl or man svipc for an explanation of the fields.

You can make the most informed decision by periodically collecting
statistics on the message queue usage in your running system and
monitoring the applications' needs.  Then set your message queue
parameters based on that data with some additional headroom.


I hope that helps.

Regards,
Andy

>   - Is there a limit to the size of msgmnb?
>   - Can I expect the system to start thrashing if msgmnb is
>     increased beyond a certain value?
>   - Is my understanding correkt: msgmnb should always be at least
>     as large as msgmax?
> 
> Thanks in advance.


