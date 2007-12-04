Return-Path: <linux-kernel-owner+w=401wt.eu-S1751865AbXLDFEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865AbXLDFEo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 00:04:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750870AbXLDFEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 00:04:36 -0500
Received: from web36601.mail.mud.yahoo.com ([209.191.85.18]:47077 "HELO
	web36601.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750831AbXLDFEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 00:04:35 -0500
X-YMail-OSG: y4FhiwUVM1mmXNDkjUQNhyYfYUdiFGrV3rE8pLL8cRGQzLLJ
X-RocketYMMF: rancidfat
Date: Mon, 3 Dec 2007 21:04:34 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH] (2.6.24-rc3-mm2) -mm Smack mutex cleanup
To: Jiri Slaby <jirislaby@gmail.com>, casey@schaufler-ca.com
Cc: akpm@osdl.org, torvalds@osdl.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
In-Reply-To: <47548F40.8090309@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <267816.97172.qm@web36601.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Jiri Slaby <jirislaby@gmail.com> wrote:

> On 12/03/2007 07:39 PM, Casey Schaufler wrote:
> > From: Casey Schaufler <casey@schaufler-ca.com>
> > 
> > Clean out unnecessary mutex initializations for Smack list locks.
> > Once this is done, there is no need for them to be shared among
> > multiple files, so pull them out of the header file and put them
> > in the files where they belong.
> 
> Then it might be static.

Doh. Right you are.
 
> > Pull unnecessary locking from smack_inode_setsecurity, it used
> > to be required when the assignment was not guaranteed to be a
> > scalar value but isn't now.
> > 
> > Change uses of __capable(current,...) to capable(...).
> > Take out an inappropriate cast. Use container_of() instead
> > of doing the same calculation by hand.
> > Fix comment spelling errors.
> 
> Too many different changes according to the name of the patch.

OK, that's fair.
 
> > Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> > 
> > ---
> > 
> > Tested with stamp-2007-11-30-16-39
> > 
> >  security/smack/smack.h        |    3 --
> >  security/smack/smack_access.c |    3 ++
> >  security/smack/smack_lsm.c    |   34 +++++++++-----------------------
> >  security/smack/smackfs.c      |    6 +++++
> >  4 files changed, 19 insertions(+), 27 deletions(-)
> > 
> > diff -uprN -X linux-2.6.24-rc3-mm2-base/Documentation/dontdiff
> linux-2.6.24-rc3-mm2-base/security/smack/smack_lsm.c
> linux-2.6.24-rc3-mm2-smack/security/smack/smack_lsm.c
> > --- linux-2.6.24-rc3-mm2-base/security/smack/smack_lsm.c	2007-11-27
> 16:47:05.000000000 -0800
> > +++ linux-2.6.24-rc3-mm2-smack/security/smack/smack_lsm.c	2007-11-28
> 11:46:13.000000000 -0800
> [...]
> > @@ -748,9 +746,7 @@ static int smack_inode_setsecurity(struc
> >  		return -EINVAL;
> >  
> >  	if (strcmp(name, XATTR_SMACK_SUFFIX) == 0) {
> > -		mutex_lock(&nsp->smk_lock);
> >  		nsp->smk_inode = sp;
> > -		mutex_unlock(&nsp->smk_lock);
> >  		return 0;
> >  	}
> >  	/*
> 
> Ok, it still might be atomic as a variable change, but it will break
> scenarios
> such as
> 
> mutex_lock(&nsp->smk_lock);
> create(nsp->smk_inode);
> cook_a_dinner();
> get_info(nsp->smk_inode);
> mutex_unlock(&nsp->smk_lock);
> 
> While cook_a_dinner(), smack_inode_setsecurity() is called and the attribute
> changed...
> 
> Doesn't this matter?

The only place dinner can get cooked is during d_instantiate, and
you can't call inode_security until after that's finished. No,
it doesn't matter.


Casey Schaufler
casey@schaufler-ca.com
