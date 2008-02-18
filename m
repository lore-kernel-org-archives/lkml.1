Return-Path: <linux-kernel-owner+w=401wt.eu-S1760662AbYBRUPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760662AbYBRUPc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 15:15:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753131AbYBRUPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 15:15:25 -0500
Received: from smtp-101-monday.nerim.net ([62.4.16.101]:63102 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752707AbYBRUPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 15:15:24 -0500
Date: Mon, 18 Feb 2008 21:15:19 +0100
From: Jean Delvare <khali@linux-fr.org>
To: benh@kernel.crashing.org
Cc: Christian Krafft <krafft@de.ibm.com>, linux-kernel@vger.kernel.org,
       parabelboi@bopserverein.de, linuxppc-dev@ozlabs.org
Subject: Re: [Patch 0/2] powerpc: avoid userspace poking to legacy ioports
Message-ID: <20080218211519.2b159ade@hyperion.delvare>
In-Reply-To: <1202935374.7296.44.camel@pasglop>
References: <20080213182800.5c6940a8@de.ibm.com>
	<20080213183506.7f3e3145@de.ibm.com>
	<1202935374.7296.44.camel@pasglop>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

On Thu, 14 Feb 2008 07:42:54 +1100, Benjamin Herrenschmidt wrote:
> 
> On Wed, 2008-02-13 at 18:35 +0100, Christian Krafft wrote:
> > sensors_detect crashes kernel on PowerPC, as it pokes directly to memory.

For the records, sensors-detect accesses I/O ports, not memory.

> > This patch adds a check_legacy_ioports to read_port and write_port.
> > It will now return ENXIO, instead of oopsing.
> > 
> > Signed-off-by: Christian Krafft <krafft@de.ibm.com>
> 
> The problem is that this prevents using /proc/ioports to access PCI
> IO space, which might be useful.

Maybe Christian's patch can be improved to not do the check on these?
As long as /dev/port exists, it seems reasonable that the kernel should
behave, no matter what I/O ports are accessed from user-space.

> I hate that sensors_detect.. or for that matter any other userland code
> that pokes random ports like that. It should die.

What do you propose as a replacement?

And how is userland code poking at random ports different from kernel
code poking at random ports? We could move sensors-detect inside the
kernel (and I have some plan to do that) but I fail to see how this
would solve this particular problem.

> > Index: linux.git/drivers/char/mem.c
> > ===================================================================
> > --- linux.git.orig/drivers/char/mem.c
> > +++ linux.git/drivers/char/mem.c
> > @@ -566,8 +566,13 @@ static ssize_t read_port(struct file * f
> >  	char __user *tmp = buf;
> >  
> >  	if (!access_ok(VERIFY_WRITE, buf, count))
> > -		return -EFAULT; 
> > +		return -EFAULT;
> > +
> >  	while (count-- > 0 && i < 65536) {
> > +#ifdef CONFIG_PPC_MERGE
> > +		if (check_legacy_ioport(i))
> > +			return -ENXIO;
> > +#endif
> >  		if (__put_user(inb(i),tmp) < 0) 
> >  			return -EFAULT;  
> >  		i++;
> > @@ -585,6 +590,7 @@ static ssize_t write_port(struct file * 
> >  
> >  	if (!access_ok(VERIFY_READ,buf,count))
> >  		return -EFAULT;
> > +
> >  	while (count-- > 0 && i < 65536) {
> >  		char c;
> >  		if (__get_user(c, tmp)) {
> > @@ -592,6 +598,10 @@ static ssize_t write_port(struct file * 
> >  				break;
> >  			return -EFAULT; 
> >  		}
> > +#ifdef CONFIG_PPC_MERGE
> > +		if (check_legacy_ioport(i))
> > +			return -ENXIO;
> > +#endif
> >  		outb(c,i);
> >  		i++;
> >  		tmp++;


-- 
Jean Delvare
