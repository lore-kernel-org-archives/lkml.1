Return-Path: <linux-kernel-owner+w=401wt.eu-S1753876AbZF0X5G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876AbZF0X5G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 19:57:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752693AbZF0X4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 19:56:54 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:50686 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbZF0X4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 19:56:54 -0400
Subject: Re: [PATCH] kobject_set_name_vargs memory leak
From: Kay Sievers <kay.sievers@vrfy.org>
To: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090627093932.GB3342@localdomain.by>
References: <20090626143652.GB6281@localdomain.by>
	 <20090626144949.GA24173@suse.de> <20090626232339.GD3858@localdomain.by>
	 <m18wjeqven.fsf@fess.ebiederm.org>  <20090627093932.GB3342@localdomain.by>
Content-Type: text/plain
Date: Sun, 28 Jun 2009 01:56:58 +0200
Message-Id: <1246147018.24693.97.camel@yio.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-06-27 at 12:39 +0300, Sergey Senozhatsky wrote:

> > >> Or something along those lines, I can't remember the exact reasoning
> > >> this early in the morning.
> > >> 
> > >> Kay, do you remember?

Hmm, yes, I think there was only something to work around during the
transition from the static name array, which is gone now. At least I
can't see anything we need to care about with the current code.

> Sorry, correct one.
> 
> diff --git a/lib/kobject.c b/lib/kobject.c
> index b512b74..3ab224b 100644
> --- a/lib/kobject.c
> +++ b/lib/kobject.c
> @@ -215,7 +215,6 @@ static int kobject_add_internal(struct kobject *kobj)
>  int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
>  				  va_list vargs)
>  {
> -	const char *old_name = kobj->name;

I guess, that would leak an allocated name, when it is set several times
in a row? Something like this?

Thanks,
Kay

diff --git a/lib/kobject.c b/lib/kobject.c
index b512b74..780e89f 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -215,21 +215,22 @@ static int kobject_add_internal(struct kobject *kobj)
 int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
 				  va_list vargs)
 {
-	const char *old_name = kobj->name;
+	const char *name = kobj->name;
 	char *s;
 
 	if (kobj->name && !fmt)
 		return 0;
 
-	kobj->name = kvasprintf(GFP_KERNEL, fmt, vargs);
-	if (!kobj->name)
+	name = kvasprintf(GFP_KERNEL, fmt, vargs);
+	if (!name)
 		return -ENOMEM;
 
 	/* ewww... some of these buggers have '/' in the name ... */
-	while ((s = strchr(kobj->name, '/')))
+	while ((s = strchr(name, '/')))
 		s[0] = '!';
 
-	kfree(old_name);
+	kfree(kobj->name);
+	kobj->name = name;
 	return 0;
 }
 


