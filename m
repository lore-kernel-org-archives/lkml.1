Return-Path: <linux-kernel-owner+w=401wt.eu-S1764068AbXEWN0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764068AbXEWN0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 09:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755957AbXEWN0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 09:26:07 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:39224 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755773AbXEWN0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 09:26:04 -0400
Date: Wed, 23 May 2007 08:25:52 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Paul Dickson <paul@permanentmail.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>, bharata@linux.vnet.ibm.com,
       lkml <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Jan Blunck <j.blunck@tu-harburg.de>
Subject: Re: [RFC][PATCH  5/14] Introduce union stack
Message-ID: <20070523132552.GA10067@sergelap.austin.ibm.com>
References: <20070514093722.GB4139@in.ibm.com> <20070514094047.GG4139@in.ibm.com> <1179174187.2836.72.camel@dyn9047017100.beaverton.ibm.com> <20070519031836.f86e8981.paul@permanentmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070519031836.f86e8981.paul@permanentmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Paul Dickson (paul@permanentmail.com):
> On Mon, 14 May 2007 13:23:06 -0700, Badari Pulavarty wrote:
> 
> > > +	while (fs) {
> > > +		locked = union_trylock(fs->root);
> > > +		if (!locked)
> > > +			goto loop1;
> > > +		locked = union_trylock(fs->altroot);
> > > +		if (!locked)
> > > +			goto loop2;
> > > +		locked = union_trylock(fs->pwd);
> > > +		if (!locked)
> > > +			goto loop3;
> > > +		break;
> > > +	loop3:
> > > +		union_unlock(fs->altroot);
> > > +	loop2:
> > > +		union_unlock(fs->root);
> > > +	loop1:
> > > +		read_unlock(&fs->lock);
> > > +		UM_DEBUG_LOCK("Failed to get all semaphores in fs_struct!\n");
> > > +		cpu_relax();
> > > +		read_lock(&fs->lock);
> > > +		continue;
> > 
> > Nit.. why "continue" ?
> > 
> > > +	}
> > > +	BUG_ON(!fs);
> 
> How about getting rid of the gotos:
> 
> 	while (fs) {
> 		locked = union_trylock(fs->root);
> 		if (locked) {
> 			locked = union_trylock(fs->altroot);
> 			if (locked) {
> 				locked = union_trylock(fs->pwd);
> 				if (locked)
> 					break;
> 				else {
> 					union_unlock(fs->altroot);
> 					union_unlock(fs->root);
> 				}
> 			else
> 				union_unlock(fs->root);
> 			}
> 		}
> 		read_unlock(&fs->lock);
> 		UM_DEBUG_LOCK("Failed to get all semaphores in fs_struct!\n");
> 		cpu_relax();
> 		read_lock(&fs->lock);
> 	}
> 	BUG_ON(!fs);
> 
> It's the same number of lines.  Shorter if you get rid of the "locked"
> variable.

I dunno, I thought the goto versoin was cleaner and easier to tell that
the right locks are getting unlocked.  The worst part in the second
version is the break in the middle!

-serge
