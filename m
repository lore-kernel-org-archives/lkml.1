Return-Path: <linux-kernel-owner+w=401wt.eu-S1754647AbZF0Jcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647AbZF0Jcc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 05:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753317AbZF0JcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 05:32:23 -0400
Received: from mail.open.by ([193.232.92.17]:63078 "EHLO post.open.by"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753243AbZF0JcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 05:32:22 -0400
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
Date: Sat, 27 Jun 2009 12:33:59 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@mail.by>, Greg KH <gregkh@suse.de>,
       Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kobject_set_name_vargs memory leak
Message-ID: <20090627093359.GA3342@localdomain.by>
References: <20090626143652.GB6281@localdomain.by>
 <20090626144949.GA24173@suse.de>
 <20090626232339.GD3858@localdomain.by>
 <m18wjeqven.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m18wjeqven.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (06/26/09 19:10), Eric W. Biederman wrote:
> Date: Fri, 26 Jun 2009 19:10:08 -0700
> From: "Eric W. Biederman" <ebiederm@xmission.com>
> To: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
> Cc: Greg KH <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
> 	linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] kobject_set_name_vargs memory leak
> User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
> 
> Sergey Senozhatsky <sergey.senozhatsky@mail.by> writes:
> 
> > On (06/26/09 07:49), Greg KH wrote:
> >> We've been through this before (search lkml archives).  If kvasprintf
> >> fails, then we don't want to free old_name, as the caller might want to
> >> do something with it.
> >> 
> >> Or something along those lines, I can't remember the exact reasoning
> >> this early in the morning.
> >> 
> >> Kay, do you remember?
> >>
> > I found.
> > http://lkml.org/lkml/2009/5/11/11
> >
> >>kobject with name set before should not come into this function,
> >>kobject_rename should be used instead.
> >
> > It's just would be safer to kfree or restore I guess.
> 
> Yes.  There does seem to be a good point in there that the code should be:
> BUG_ON(kobj->name);
> 

> And otherwise simply not handle old_name at all.
> 

I run with:

	if (kobj->name) {
		printk(KERN_ERR "name:%s  fmt:%s\n", kobj->name, fmt);
		dump_stack();
	}

I seems ok not to handle old_name.

>Dave Young
>I rethought about this problem, does such issue exist really? I means
>that kobject->name != NULL scenario.
>
>there's following comments of this function:
>
> * This sets the name of the kobject.  If you have already added the
> * kobject to the system, you must call kobject_rename() in order to
> * change the name of the kobject


Greg, Kay, Eric, what do you think?


diff --git a/lib/kobject.c b/lib/kobject.c
index b512b74..fd1983a 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -215,7 +215,6 @@ static int kobject_add_internal(struct kobject *kobj)
 int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
 				  va_list vargs)
 {
-	const char *old_name = kobj->name;
 	char *s;
 
 	if (kobj->name && !fmt)


> Eric
> 

	Sergey
