Return-Path: <linux-kernel-owner+w=401wt.eu-S1755468AbZKCIXJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468AbZKCIXJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 03:23:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751488AbZKCIXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 03:23:09 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:37585 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbZKCIXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 03:23:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=V5ZMP0NeH2IhmhjaHhSh9luKYfNAIkz/xhzQyXIoOwBNulE9eUX6Zz8pQqcMO/Ce1X
         /UZ5LwpFvpLQ5iL62mmp3Vub0NRiBcpWxcO9HnnqiG7SGj9x59pYOiZ/X6C7TS+/Siop
         vbKN25T9bJviH9jokQN0kF31raa6A739QYPkY=
Date: Tue, 3 Nov 2009 09:23:13 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Jason Baron <jbaron@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing: separate raw syscall from syscall tracer
Message-ID: <20091103082311.GA4815@nowhere>
References: <4AEFC37C.5080609@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AEFC37C.5080609@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 03, 2009 at 01:45:32PM +0800, Lai Jiangshan wrote:
> 
> current syscall tracer mixes raw syscalls and real syscalls.
> 
> echo 1 > events/syscalls/enable
> And we get these from the output:
> 
> (XXXX insteads "            grep-20914 [001] 588211.446347" .. etc)
> 
> XXXX: sys_read(fd: 3, buf: 80609a8, count: 7000)
> XXXX: sys_enter: NR 3 (3, 80609a8, 7000, a, 1000, bfce8ef8)
> XXXX: sys_read -> 0x138
> XXXX: sys_exit: NR 3 = 312
> XXXX: sys_read(fd: 3, buf: 8060ae0, count: 7000)
> XXXX: sys_enter: NR 3 (3, 8060ae0, 7000, a, 1000, bfce8ef8)
> XXXX: sys_read -> 0x138
> XXXX: sys_exit: NR 3 = 312
> 
> There are 2 drawbacks here.
> A) two almost identical records are saved in ringbuffer
>    when a syscall enters or exits. (4 records for every syscall)
>    it wastes too much.
> B) the lines include "sys_enter/sys_exit" makes
>    we hardly get the useful information for the output.
> 
> The user can use this method to prevent these drawbacks:
> echo 1 > events/syscalls/enable
> echo 0 > events/syscalls/sys_enter/enable
> echo 0 > events/syscalls/sys_exit/enable
> 
> But it's not friendly for users. So we separate raw syscall
> from syscall tracer.
> 
> After this fix applied:
> syscall tracer's output (echo 1 > events/syscalls/enable):
> 
> XXXX: sys_read(fd: 3, buf: bfe87d88, count: 200)
> XXXX: sys_read -> 0x200
> XXXX: sys_fstat64(fd: 3, statbuf: bfe87c98)
> XXXX: sys_fstat64 -> 0x0
> XXXX: sys_close(fd: 3)
> 
> raw syscall tracer's output (echo 1 > events/raw_syscalls/enable):
> 
> XXXX: sys_enter: NR 175 (0, bf92bf18, bf92bf98, 8, b748cff4, bf92bef8)
> XXXX: sys_exit: NR 175 = 0
> XXXX: sys_enter: NR 175 (2, bf92bf98, 0, 8, b748cff4, bf92bef8)
> XXXX: sys_exit: NR 175 = 0
> XXXX: sys_enter: NR 3 (9, bf927f9c, 4000, b77e2518, b77dce60, bf92bff8)
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---


Agreed, that's indeed not convenient.

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

