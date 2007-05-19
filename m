Return-Path: <linux-kernel-owner+w=401wt.eu-S1763710AbXESKdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763710AbXESKdv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 06:33:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756749AbXESKdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 06:33:43 -0400
Received: from lollipop.listbox.com ([208.210.124.78]:58396 "EHLO
	lollipop.listbox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756649AbXESKdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 06:33:41 -0400
X-Greylist: delayed 893 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 May 2007 06:33:41 EDT
Date: Sat, 19 May 2007 03:18:36 -0700
From: Paul Dickson <paul@permanentmail.com>
To: Badari Pulavarty <pbadari@us.ibm.com>
Cc: bharata@linux.vnet.ibm.com, lkml <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Jan Blunck <j.blunck@tu-harburg.de>
Subject: Re: [RFC][PATCH  5/14] Introduce union stack
Message-Id: <20070519031836.f86e8981.paul@permanentmail.com>
In-Reply-To: <1179174187.2836.72.camel@dyn9047017100.beaverton.ibm.com>
References: <20070514093722.GB4139@in.ibm.com>
	<20070514094047.GG4139@in.ibm.com>
	<1179174187.2836.72.camel@dyn9047017100.beaverton.ibm.com>
X-Mailer: Sylpheed 2.4.0 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 May 2007 13:23:06 -0700, Badari Pulavarty wrote:

> > +	while (fs) {
> > +		locked = union_trylock(fs->root);
> > +		if (!locked)
> > +			goto loop1;
> > +		locked = union_trylock(fs->altroot);
> > +		if (!locked)
> > +			goto loop2;
> > +		locked = union_trylock(fs->pwd);
> > +		if (!locked)
> > +			goto loop3;
> > +		break;
> > +	loop3:
> > +		union_unlock(fs->altroot);
> > +	loop2:
> > +		union_unlock(fs->root);
> > +	loop1:
> > +		read_unlock(&fs->lock);
> > +		UM_DEBUG_LOCK("Failed to get all semaphores in fs_struct!\n");
> > +		cpu_relax();
> > +		read_lock(&fs->lock);
> > +		continue;
> 
> Nit.. why "continue" ?
> 
> > +	}
> > +	BUG_ON(!fs);

How about getting rid of the gotos:

	while (fs) {
		locked = union_trylock(fs->root);
		if (locked) {
			locked = union_trylock(fs->altroot);
			if (locked) {
				locked = union_trylock(fs->pwd);
				if (locked)
					break;
				else {
					union_unlock(fs->altroot);
					union_unlock(fs->root);
				}
			else
				union_unlock(fs->root);
			}
		}
		read_unlock(&fs->lock);
		UM_DEBUG_LOCK("Failed to get all semaphores in fs_struct!\n");
		cpu_relax();
		read_lock(&fs->lock);
	}
	BUG_ON(!fs);

It's the same number of lines.  Shorter if you get rid of the "locked"
variable.

	-Paul

