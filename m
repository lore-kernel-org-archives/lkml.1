Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553Ab0BTU5m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 15:57:42 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52192
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756081Ab0BTU5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 15:57:41 -0500
Date: Sat, 20 Feb 2010 12:57:58 -0800 (PST)
Message-Id: <20100220.125758.174837163.davem@davemloft.net>
To: weigelt@metux.de
Cc: linux-kernel@vger.kernel.org
Subject: Re: Dynamic linking in the kernel
From: David Miller <davem@davemloft.net>
In-Reply-To: <4B802870.5030201@metux.de>
References: <4B802870.5030201@metux.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Enrico Weigelt <weigelt@metux.de>
Date: Sat, 20 Feb 2010 19:22:40 +0100

> Starting up an dynamically linked executable tends to need a lot
> of syscalls. A kernel-based dynamic linker could cache a lot of
> relocation data (eg. when the same binary is called many times),
> share pages even w/o mmap(), and the ldstub wouldnt be needed
> anymore.

This is not practical.

In order to implement this the kernel would have to also save a copy
of all pieces of the processes's environment and compare all of the
environment variable settings on every execution.  This would be
needed to handle things like LD_PRELOAD, LD_LIBRARY_PATH, and LD_DEBUG
as just three examples.

What's more, any filesystem change involved in the shared libraries,
the executable, or the dynamic linker would have to be monitored as
well.

Really, this is not a good idea, and the cost is only ~3 system calls
per shared library and considering the amount of flexibility we get in
return it's not that bad at all.

Actually, the more expensive part of shared libraries are the page
faults from filling in the relocations and we already have a mechanism
to save that cost, it's called 'prelink'.
