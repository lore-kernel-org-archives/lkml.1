Return-Path: <linux-kernel-owner+w=401wt.eu-S1754536AbZFZW2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536AbZFZW2R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 18:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751514AbZFZW2D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 18:28:03 -0400
Received: from mail.open.by ([193.232.92.17]:59932 "EHLO post.open.by"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295AbZFZW2C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 18:28:02 -0400
X-SpamTest-Envelope-From: sergey.senozhatsky@mail.by
X-SpamTest-Group-ID: 00000000
X-SpamTest-Info: Profiles 8849 [Jun 27 2009]
X-SpamTest-Info: helo_type=3
X-SpamTest-Info: {relay has no DNS name}
X-SpamTest-Method: none
X-SpamTest-Rate: 55
X-SpamTest-SPF: softfail
X-SpamTest-Status: Not detected
X-SpamTest-Status-Extended: not_detected
X-SpamTest-Version: SMTP-Filter Version 3.0.0 [0284], KAS30/Release
Date: Sat, 27 Jun 2009 01:29:37 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
To: Greg KH <gregkh@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kobject_set_name_vargs memory leak
Message-ID: <20090626222937.GA3858@localdomain.by>
References: <20090626143652.GB6281@localdomain.by>
 <20090626144949.GA24173@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090626144949.GA24173@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (06/26/09 07:49), Greg KH wrote:
> Date: Fri, 26 Jun 2009 07:49:49 -0700
> From: Greg KH <gregkh@suse.de>
> To: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
> Cc: Kay Sievers <kay.sievers@vrfy.org>,
> 	"Eric W. Biederman" <ebiederm@xmission.com>,
> 	linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] kobject_set_name_vargs memory leak
> User-Agent: Mutt/1.5.19 (2009-01-05)
> 
> On Fri, Jun 26, 2009 at 05:36:52PM +0300, Sergey Senozhatsky wrote:
> > Hello.
> > I suppose this patch fixes memory leak in kobject.c
> > Correct me if I'm wrong.
> > Thanks.
> > -----------
> > 
> > Fix memory leak when kobject_set_name_vargs returns -ENOMEM.
> > 
> > Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
> > ---
> > diff --git a/lib/kobject.c b/lib/kobject.c
> > index b512b74..922cd8c 100644
> > --- a/lib/kobject.c
> > +++ b/lib/kobject.c
> > @@ -222,8 +222,10 @@ int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
> >  		return 0;
> >  
> >  	kobj->name = kvasprintf(GFP_KERNEL, fmt, vargs);
> > -	if (!kobj->name)
> > +	if (!kobj->name) {
> > +		kfree(old_name);
> >  		return -ENOMEM;
> > +	}
> 
> We've been through this before (search lkml archives).  If kvasprintf
> fails, then we don't want to free old_name, as the caller might want to
> do something with it.
> 
Hello Greg,

int kobject_set_name_vargs.... {
	const char *old_name = kobj->name;

old_name is local variable.

In the following lines we overwrite kobject->name.

	kobj->name = kvasprintf(GFP_KERNEL, fmt, vargs);
	if (!kobj->name)
		return -ENOMEM;

It's not clear to me how we can do anything (including kfree) with old_name after 'return -ENOMEM'.

Well, I'll try to search lklm.
Thanks.


> Or something along those lines, I can't remember the exact reasoning
> this early in the morning.
> 
> Kay, do you remember?
> 
> thanks,
> 
> greg k-h
> 

	Sergey
