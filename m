Return-Path: <linux-kernel-owner+w=401wt.eu-S1757186AbXINUC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186AbXINUC0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 16:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756889AbXINUCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 16:02:18 -0400
Received: from smtp111.sbc.mail.re2.yahoo.com ([68.142.229.94]:24293 "HELO
	smtp111.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754872AbXINUCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 16:02:17 -0400
X-YMail-OSG: qUX9jncVM1mNAJJFhtEVly5xE__wSeqDkhZNPWMTEvhKR_JECv2Z_z7xPOCkFgFvbrfTw9EqLSe0aEBa6yC48CbYDUi5XQTuXPbODXknjjUweO3U.ExuKMSctvpUdUbcr2yJLaNACoAuRmw-
Date: Fri, 14 Sep 2007 15:02:15 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, devel@openvz.org
Subject: Re: [PATCH] Fix UTS corruption during clone(CLONE_NEWUTS)
Message-ID: <20070914200215.GA25105@vino.hallyn.com>
References: <20070914145730.GB27986@localhost.sw.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070914145730.GB27986@localhost.sw.ru>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Alexey Dobriyan (adobriyan@sw.ru):
> struct utsname is copied from master one without any exclusion.
> 
> Here is sample output from one proggie doing
> 
> 	sethostname("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
> 	sethostname("bbbbbbbbbbbbbbbbbbbbbbbbbbbbbb");
> 
> and another
> 
> 	clone(,, CLONE_NEWUTS, ...)
> 	uname()
> 
> 
> 	hostname = 'aaaaaaaaaaaaaaaaaaaaaaaaabbbbb'
> 	hostname = 'bbbaaaaaaaaaaaaaaaaaaaaaaaaaaa'
> 	hostname = 'aaaaaaaabbbbbbbbbbbbbbbbbbbbbb'
> 	hostname = 'aaaaaaaaaaaaaaaaaaaaaaaaaabbbb'
> 	hostname = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaabb'
> 	hostname = 'aaabbbbbbbbbbbbbbbbbbbbbbbbbbb'
> 	hostname = 'bbbbbbbbbbbbbbbbaaaaaaaaaaaaaa'
> 
> Hostname is sometimes corrupted.
> 
> Yes, even _the_ simplest namespace activity had bug in it. :-(
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>

picking my jaw up off the floor just long enough to type

Signed-off-by: Serge Hallyn <serue@us.ibm.com>

and limp away in shame

thanks Alexey,
-serge

> ---
> 
>  kernel/utsname.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> --- a/kernel/utsname.c
> +++ b/kernel/utsname.c
> @@ -28,7 +28,9 @@ static struct uts_namespace *clone_uts_ns(struct uts_namespace *old_ns)
>  	if (!ns)
>  		return ERR_PTR(-ENOMEM);
>  
> +	down_read(&uts_sem);
>  	memcpy(&ns->name, &old_ns->name, sizeof(ns->name));
> +	up_read(&uts_sem);
>  	kref_init(&ns->kref);
>  	return ns;
>  }
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
