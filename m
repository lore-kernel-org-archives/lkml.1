Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735Ab0CDDdW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 22:33:22 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51405 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753953Ab0CDDdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 22:33:16 -0500
Date: Thu, 4 Mar 2010 14:33:12 +1100
From: Nick Piggin <npiggin@suse.de>
To: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>,
       Clark Williams <williams@redhat.com>, John Kacur <jkacur@redhat.com>
Subject: Re: Nick's vfs-scalability patches ported to 2.6.33-rt
Message-ID: <20100304033312.GO8653@laptop>
References: <1267163608.2002.9.camel@work-vm>
 <20100226060109.GH9738@laptop>
 <1267659090.4317.67.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267659090.4317.67.camel@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 03, 2010 at 03:31:30PM -0800, john stultz wrote:
> On Fri, 2010-02-26 at 17:01 +1100, Nick Piggin wrote:
> > On Thu, Feb 25, 2010 at 09:53:28PM -0800, john stultz wrote:
> > > Hey Thomas, Nick,
> > > 	I just wanted to let you know I've just finished forward porting Nick's
> > > patches to 2.6.33-rc8-rt2.  Luckily my forward port of Nick's patches to
> > > 2.6.33 applies on top of the -rt tree without any collisions, and I've
> > > added a handful of maybe sketchy fixups to get it working with -rt.
> > > 
> > > You can find the patchset here:
> > > http://sr71.net/~jstultz/dbench-scalability/patches/2.6.33-rc8-rt2/vfs-scale.33-rt.tar.bz2
> > > 
> > > Here's a chart showing how much these patches help dbench numbers on
> > > ramfs:
> > > http://sr71.net/~jstultz/dbench-scalability/graphs/2.6.33/ramfs-dbench.png
> > > 
> > > I've not done any serious stress testing with the patchset yet, but
> > > wanted to post it for your review.
> > > 
> > > Nick: I'd appreciate any feedback as to if any of my forward porting has
> > > gone awry. I'm still very green with respect to the vfs, so I don't
> > > doubt there are some issues hiding here.
> > 
> > BTW there are a few issues Al pointed out. We have to synchronize RCU
> > after unregistering a filesystem so d_ops/i_ops doesn't go away, and
> > mntput can sleep so we can't do it under RCU read lock.
> 
> Does the following address this issue properly?

As far as I could tell, yes that should solve the code reference
problem. I don't see a problem with synchronizing RCU here.

> 
> Signed-off-by: John Stultz <johnstul@us.ibm.com>
> 
> diff --git a/fs/filesystems.c b/fs/filesystems.c
> index a24c58e..3448e7c 100644
> --- a/fs/filesystems.c
> +++ b/fs/filesystems.c
> @@ -110,6 +110,7 @@ int unregister_filesystem(struct file_system_type * fs)
>  			*tmp = fs->next;
>  			fs->next = NULL;
>  			write_unlock(&file_systems_lock);
> +			synchronize_rcu();
>  			return 0;
>  		}
>  		tmp = &(*tmp)->next;
> 
