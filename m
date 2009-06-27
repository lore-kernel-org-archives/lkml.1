Return-Path: <linux-kernel-owner+w=401wt.eu-S1753394AbZF0JiF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbZF0JiF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 05:38:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750757AbZF0Jhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 05:37:55 -0400
Received: from mail.open.by ([193.232.92.17]:58538 "EHLO post.open.by"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750730AbZF0Jhy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 05:37:54 -0400
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
Date: Sat, 27 Jun 2009 12:39:32 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg KH <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kobject_set_name_vargs memory leak
Message-ID: <20090627093932.GB3342@localdomain.by>
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

Sorry, correct one.

diff --git a/lib/kobject.c b/lib/kobject.c
index b512b74..3ab224b 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -215,7 +215,6 @@ static int kobject_add_internal(struct kobject *kobj)
 int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
 				  va_list vargs)
 {
-	const char *old_name = kobj->name;
 	char *s;
 
 	if (kobj->name && !fmt)
@@ -229,7 +228,6 @@ int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
 	while ((s = strchr(kobj->name, '/')))
 		s[0] = '!';
 
-	kfree(old_name);
 	return 0;
 }
 

> Eric
> 

	Sergey
