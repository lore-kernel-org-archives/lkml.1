Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759305Ab0CMPPp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 10:15:45 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:54318 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759298Ab0CMPPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 10:15:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=HLU9b02NEnEnuN1KY/X+WbDzKr5OaEuCJOSUAPrq5FXi20dLQSt/29n9VMEP/TzN0F
         idtRHPFjZvV0vGbnVnDRDAIyWPnS7RZdbKSClP6DPV9hSuwGTx4+WcIgtg/NjQn3Ui9x
         3fIXz9T6ewI+VMjgJXx7f5gzlFriK58LPnnkQ=
Subject: Re: [PATCH kobjects] Fix a rare memory leak in
 kobject_set_name_vargs
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Philippe De Muyter <phdm@macqel.be>, gregkh@suse.de,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.2.00.1003130752001.8523@localhost>
References: <20100313124324.GA15244@frolo.macqel>
	 <alpine.LFD.2.00.1003130752001.8523@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 13 Mar 2010 16:15:36 +0100
Message-ID: <1268493336.2947.52.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 13 mars 2010 à 07:53 -0500, Robert P. J. Day a écrit :
> On Sat, 13 Mar 2010, Philippe De Muyter wrote:
> 
> > Hello Greg,
> >
> > This is a possible memory leak that I discovered only by accidental code
> > reading.
> >
> > --
> >
> > If kvasprintf fails in kobject_set_name_vargs, the memory used by
> > the original kobj->name is leaked.  Fix that.  I also avoid useless
> > memory accesses to kobj->name by using the local variables old_name
> > and new_name instead.
> >
> > Signed-off-by: Philippe De Muyter <phdm@macqel.be>
> >
> > diff -r 373fdd3df333 linux-2.6.x/lib/kobject.c
> > --- a/linux-2.6.x/lib/kobject.c	Wed Aug 19 23:26:44 2009 +0200
> > +++ b/linux-2.6.x/lib/kobject.c	Sat Mar 13 13:35:43 2010 +0100
> > @@ -216,20 +216,22 @@ int kobject_set_name_vargs(struct kobjec
> >  				  va_list vargs)
> >  {
> >  	const char *old_name = kobj->name;
> > +	char *new_name;
> >  	char *s;
> >
> > -	if (kobj->name && !fmt)
> > +	if (old_name && !fmt)
> >  		return 0;
> >
> > -	kobj->name = kvasprintf(GFP_KERNEL, fmt, vargs);
> > -	if (!kobj->name)
> > +	new_name = kvasprintf(GFP_KERNEL, fmt, vargs);
> > +	if (!new_name)
> >  		return -ENOMEM;
> >
> >  	/* ewww... some of these buggers have '/' in the name ... */
> > -	while ((s = strchr(kobj->name, '/')))
> > +	while ((s = strchr(new_name, '/')))
> >  		s[0] = '!';
> >
> >  	kfree(old_name);
> > +	kobj->name = new_name;
> >  	return 0;
> >  }
> 
>   the routine kobject_set_name_vargs() is described in
> Documentation/kobject.txt as "legacy cruft" to be removed at some
> point, so it's not clear there's any value in "fixing" it.
> 

Given I submitted a similar patch two days before, I guess a fix would
be welcome or else we might see one or two attempts per week from
various people.

http://lkml.org/lkml/2010/3/11/438

Legacy or not, this code looks wrong. I caught it while looking for
kmemleaks reports on my dev machine, that were triggered by
CONFIG_NO_BOOTMEM use.


