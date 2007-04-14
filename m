Return-Path: <linux-kernel-owner+w=401wt.eu-S1753888AbXDNJlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888AbXDNJlT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 05:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754198AbXDNJlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 05:41:19 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:14213 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888AbXDNJlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 05:41:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=e1PlOOFxdyKwAMomi1YrOaDGJ0Xs6Q9/urhFgDq5etNuKKJdtHURKhKhp1lfyXj5rcAUpezu+8QIcniYw0YrXWJy2vBY/1M4Cmz/Pj4CTrFhMiyHB4ICn1LzHSl1ulIINr/p+DkOP3R2BQc9buyMY0kTLKrvyiyu9XbJQ725Xnk=
Date: Sat, 14 Apr 2007 13:42:15 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.13.4 kernel Oops - proc related
Message-ID: <20070414094215.GA5840@martell.zuzino.mipt.ru>
References: <9a8748490704120101o7ae2645ei12bb096971da6dfe@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a8748490704120101o7ae2645ei12bb096971da6dfe@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2007 at 10:01:07AM +0200, Jesper Juhl wrote:
> Yesterday one of my servers Oops'ed on me :-(
> The server was running an old 2.6.13.4 kernel.
> I got a screenshot of the Oops which is available here :
> http://www.kernel.org/pub/linux/kernel/people/juhl/images/2.6.13.4-crash.png
>
> Even though this is a rather old kernel, I wanted to report the crash
> just in case it's not a known bug. If it is already known and fixed,
> then just ignore this mail.

It seems task->signal->tty->driver pointer got borken. It's 0x03200005!

c0181920 <do_task_stat>:

c0181ad8:	call   c011d440 <next_thread>
c0181add:	cmp    %esi,%eax			# } while (t != task)
c0181adf:	jne    c0181ab0 <do_task_stat+0x190>
c0181ae1:	mov    0x460(%esi),%eax
c0181ae7:	add    $0x504,%eax
c0181aec:	call   c036f160 <_spin_unlock_irq>	# spin_unlock_irq(&task->sighand->siglock);
c0181af1:	mov    0x45c(%esi),%ecx
c0181af7:	test   %ecx,%ecx			# if (task->signal)
c0181af9:	je     c0181bc3 <do_task_stat+0x2a3>
c0181aff:	mov    0x88(%ecx),%ebx			# ebx = task->signal->tty
c0181b05:	test   %ebx,%ebx			# if (task->signal->tty)
c0181b07:	je     c0181b46 <do_task_stat+0x226>
c0181b09:	mov    0xb4(%ebx),%eax
c0181b0f:	mov    %eax,0x50(%esp,1)		# tty_pgrp = task->signal->tty->pgrp
c0181b13:	mov    0x4(%ebx),%eax			# eax = task->signal->tty->driver
c0181b16: ===>	mov    0x64(%eax),%edx			# task->signal->tty->driver->major
c0181b19:	mov    0x68(%eax),%ebp			# task->signal->tty->driver->minor_start
c0181b1c:	mov    0x8(%ebx),%eax			# task->signel->tty->index

