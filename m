Return-Path: <linux-kernel-owner+w=401wt.eu-S1753616AbZFZXNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616AbZFZXNV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 19:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752126AbZFZXNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 19:13:13 -0400
Received: from mail.open.by ([193.232.92.17]:54904 "EHLO post.open.by"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005AbZFZXNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 19:13:12 -0400
X-SpamTest-Envelope-From: sergey.senozhatsky@mail.by
X-SpamTest-Group-ID: 00000003
X-SpamTest-Info: Profiles 8849 [Jun 27 2009]
X-SpamTest-Info: helo_type=3
X-SpamTest-Info: {relay has no DNS name}
X-SpamTest-Method: none
X-SpamTest-Rate: 55
X-SpamTest-SPF: softfail
X-SpamTest-Status: Not detected
X-SpamTest-Status-Extended: not_detected
X-SpamTest-Version: SMTP-Filter Version 3.0.0 [0284], KAS30/Release
X-SpamTest-Group-ID: 00000000
Date: Sat, 27 Jun 2009 02:14:50 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@mail.by>, Greg KH <gregkh@suse.de>,
       Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kobject_set_name_vargs memory leak
Message-ID: <20090626231450.GC3858@localdomain.by>
References: <20090626143652.GB6281@localdomain.by>
 <20090626144949.GA24173@suse.de>
 <20090626222937.GA3858@localdomain.by>
 <m17hyyfvnv.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m17hyyfvnv.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (06/26/09 16:00), Eric W. Biederman wrote:
> >> > Fix memory leak when kobject_set_name_vargs returns -ENOMEM.
> >> > 
> >> > Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
> >> > ---
> >> > diff --git a/lib/kobject.c b/lib/kobject.c
> >> > index b512b74..922cd8c 100644
> >> > --- a/lib/kobject.c
> >> > +++ b/lib/kobject.c
> >> > @@ -222,8 +222,10 @@ int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
> >> >  		return 0;
> >> >  
> >> >  	kobj->name = kvasprintf(GFP_KERNEL, fmt, vargs);
> >> > -	if (!kobj->name)
> >> > +	if (!kobj->name) {
> >> > +		kfree(old_name);
> >> >  		return -ENOMEM;
> >> > +	}
> >> 
> >> We've been through this before (search lkml archives).  If kvasprintf
> >> fails, then we don't want to free old_name, as the caller might want to
> >> do something with it.
> >> 
> > Hello Greg,
> >
> > int kobject_set_name_vargs.... {
> > 	const char *old_name = kobj->name;
> >
> > old_name is local variable.
> >
> > In the following lines we overwrite kobject->name.
> >
> > 	kobj->name = kvasprintf(GFP_KERNEL, fmt, vargs);
> > 	if (!kobj->name)
> > 		return -ENOMEM;
> >
> > It's not clear to me how we can do anything (including kfree) with old_name after 'return -ENOMEM'.
> 
> My feel is that if we fail we should restore kobject->name to old_name.
> 
> That should also prevent the leak without getting us into trouble elsewhere.
> 
> Eric
> 
Or work with 'new_name' and overwrite kobject->name only 'if(new_name)'.
I thought about restoring. ( Blue or Red Pill? :) )

diff --git a/lib/kobject.c b/lib/kobject.c
index b512b74..d6b1502 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -222,8 +222,10 @@ int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
 		return 0;
 
 	kobj->name = kvasprintf(GFP_KERNEL, fmt, vargs);
-	if (!kobj->name)
+	if (!kobj->name) {
+		kobj->name = old_name;
 		return -ENOMEM;
+	}
 
 	/* ewww... some of these buggers have '/' in the name ... */
 	while ((s = strchr(kobj->name, '/')))


	Sergey
