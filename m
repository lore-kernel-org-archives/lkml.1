Return-Path: <linux-kernel-owner+w=401wt.eu-S1761036AbZCXQch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761036AbZCXQch (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 12:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761895AbZCXQcB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 12:32:01 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:64306 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760802AbZCXQb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 12:31:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=oDV0NYOYI/nhDSY6M83O2OJiwW0eiJm4Bxb7+TyO9iKaqTG32qTMRZ6eF540mYqHzf
         1V6CIyP8bX23Hqynoepd+Vkccv9Kb6SsrAHf73u4EeTgNtmugQtN68zJXhClG+k7qDTi
         soHRrA1WNeOMY0O7iAUO3xrosBfLbNrgl2T4c=
Date: Tue, 24 Mar 2009 18:32:26 +0200
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kmemtrace: fix build breakage in befs
Message-ID: <20090324163226.GA5271@localhost>
References: <1237884230.25315.33.camel@penberg-laptop> <20090324085128.GF13016@elte.hu> <1237884846.25315.37.camel@penberg-laptop> <20090324085658.GG13016@elte.hu> <1237885074.25315.43.camel@penberg-laptop> <20090324090757.GH13016@elte.hu> <1237886113.25315.49.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237886113.25315.49.camel@penberg-laptop>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24, 2009 at 11:15:13AM +0200, Pekka Enberg wrote:
> On Tue, 2009-03-24 at 10:07 +0100, Ingo Molnar wrote:
> > * Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> > 
> > > On Tue, 2009-03-24 at 09:56 +0100, Ingo Molnar wrote:
> > > > * Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> > > > 
> > > > > On Tue, 2009-03-24 at 09:51 +0100, Ingo Molnar wrote:
> > > > > > there's another build problem as well, in squashfs, and in key.h:
> > > > > > 
> > > > > >  include/linux/key.h:128: error: field 'sem' has incomplete type
> > > > > >  fs/squashfs/export.c:133: error: implicit declaration of function 'kmalloc'
> > > > > >  fs/squashfs/export.c:143: error: implicit declaration of function 'kfree'
> > > > > > 
> > > > > > And i suspect there's more as well. Is there really no unintrusive 
> > > > > > way to solve this - or do you think the RCU change reduces the 
> > > > > > include file spaghetti?
> > > > > 
> > > > > I don't think there is and yes, I do think the RCU change cleans 
> > > > > up things as well.
> > > > 
> > > > Okay. Note, you'll have to test tip:tracing/kmemtrace explicitly as 
> > > > i had to exclude it from tip:master due to test failures. Will put 
> > > > it back in once fixes arrive :)
> > > 
> > > That's what I am testing right now. It's just that I am working on 
> > > an old laptop where building the kernel takes a looong time.... 
> > > :-)
> > 
> > ok - let me help then.
> > 
> > On (64-bit) allyesconfig there's 5 distinct build failures:
> >  
> > include/linux/key.h:128: error: field ???sem??? has incomplete type
> > distcc[22541] ERROR: compile security/keys/sysctl.c on a/16 failed
> > 
> > lib/decompress_bunzip2.c:636: error: implicit declaration of function ???kmalloc???
> > lib/decompress_bunzip2.c:726: error: implicit declaration of function ???kfree???
> > 
> > In file included from include/keys/user-type.h:16,
> >                  from fs/cifs/cifs_spnego.c:25:
> > include/linux/key.h:128: error: field ???sem??? has incomplete type
> > distcc[3226] ERROR: compile fs/cifs/cifs_spnego.c on ph/16 failed
> > 
> > lib/decompress_inflate.c:45: error: implicit declaration of function ???kmalloc???
> > lib/decompress_inflate.c:154: error: implicit declaration of function ???kfree???
> > 
> > lib/decompress_unlzma.c:122: error: implicit declaration of function ???kfree???
> > lib/decompress_unlzma.c:551: error: implicit declaration of function ???kmalloc???
> > 
> > You should be able to reproduce them (on 32-bit too) one by one via:
> > 
> >   make lib/decompress_unlzma.o
> > 
> > etc. - without having to redo the full allyesconfig. (i'll redo that 
> > after the fixes, to flush out remaining/dependent bugs)
> 
> OK, I think all of them are now fixed. I haven't yet been able to
> complete a build so help is still appreciated. ;-)
> 
> 			Pekka

Gosh, what have I done?! oO

As far as I can see (or I hope so), it isn't really my fault the
original authors didn't use headers in a semantically-consistent way.

Pekka, thanks a lot for helping with this.


	Eduard

