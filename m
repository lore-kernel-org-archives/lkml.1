Return-Path: <linux-kernel-owner+w=401wt.eu-S1757918AbXENSK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757918AbXENSK2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 14:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756183AbXENSKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 14:10:22 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:2264 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755707AbXENSKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 14:10:21 -0400
Date: Mon, 14 May 2007 19:10:08 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       bjorn.helgaas@hp.com, Randy Dunlap <randy.dunlap@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] serial: set RTS and DTR if flow is 'r'  --- resend
Message-ID: <20070514181007.GA29682@flint.arm.linux.org.uk>
Mail-Followup-To: Yinghai Lu <Yinghai.Lu@Sun.COM>,
	Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
	bjorn.helgaas@hp.com, Randy Dunlap <randy.dunlap@oracle.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <86802c440705122233y327756e7te534199f46b2059d@mail.gmail.com> <m1ejllqmo8.fsf@ebiederm.dsl.xmission.com> <46489BC2.6040403@sun.com> <4648A310.1050908@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4648A310.1050908@sun.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2007 at 10:57:36AM -0700, Yinghai Lu wrote:
> [PATCH] serial: set RTS and DTR if flow is 'r'
> 
> if the serial console flow is set to 'r', We need to set RTS and DTR.
> Some UARTs on other side need these bit set, otherwise will not send 
> char to or
> receive char from the host that kernel is runing esp for kernel boot stage.

Patch is still broken.  Patch is completely wrong as well - we do _not_
want to set the RTS and DTR bits here, and is in fact undoing a fix I
put in over the 2.4 drivers.

If CRTSCTS is enabled via userspace, and the port is not being used
as a console, we do not want to raise RTS _until_ we are ready to
receive characters.  Your patch breaks this.

Moreover, I question the reasoning.  RTS is normally raised to allow
the remote end to send characters.  Since the kernel console is
output _only_, until userspace opens it, there's little point in
raising RTS.  RTS will be raised when userspace opens it.

There may be some sense, however, in allowing DTR to be permanently
raised for serial consoles.  However, I would err on caution since
DTR is used to reliably instruct modems to drop the line, so making
such a change would be undesirable for those folk.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
