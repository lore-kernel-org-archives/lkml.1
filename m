Return-Path: <linux-kernel-owner+w=401wt.eu-S1756302AbZBEXnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302AbZBEXnX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 18:43:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754590AbZBEXm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 18:42:57 -0500
Received: from el-out-1112.google.com ([209.85.162.176]:62957 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163AbZBEXm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 18:42:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=mXR5fv99znqZdkr+3wsDT4jYnnZGmXcWNLwyGk7Y3JHlg/W6fqBUd9gn0q+av+kWxv
         MQqGRYCHsrByps7Ec9JJkbt7xGA/VA1YxZpogHqD+9vEnJZsrNv+XyD6+JHgVt/skYq1
         lcHyWDhZOPPFXi6OcYMdke0HfSLcSwmu5BpJU=
Message-ID: <498B797C.4060202@gmail.com>
Date: Thu, 05 Feb 2009 17:42:52 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Floris Kraak <randakar@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Trivial Patch Monkey <trivial@kernel.org>,
       Andreas Schwab <schwab@suse.de>
Subject: Re: [PATCH]: Cleanup: Remove gcc format string warnings when compiling
  with -Wformat-security
References: <56e1b5710902050641l5ece10e5hedd11fb3f4292886@mail.gmail.com> <adak584jzw3.fsf@cisco.com>
In-Reply-To: <adak584jzw3.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
>  > Here's the patch that I get when I blindly patch every single location
>  > that emits this warning.
> 
> I would strongly prefer to do this with a little more care.  For example
> the b43/main.c change:
> 
>  > --- a/drivers/net/wireless/b43/main.c
>  > +++ b/drivers/net/wireless/b43/main.c
>  > @@ -2005,9 +2005,9 @@ static void b43_print_fw_helptext(struct b43_wl
>  > *wl, bool error)
>  >  	       "http://linuxwireless.org/en/users/Drivers/b43#devicefirmware "
>  >  	       "and download the latest firmware (version 4).\n";
>  >  	if (error)
>  > -		b43err(wl, text);
>  > +		b43err(wl, "%s", text);
>  >  	else
>  > -		b43warn(wl, text);
>  > +		b43warn(wl, "%s", text);
>  >  }
> would probably be better solved by doing
> 
> --- a/drivers/net/wireless/b43/main.c
> +++ b/drivers/net/wireless/b43/main.c
> @@ -1999,11 +1999,11 @@ static void b43_release_firmware(struct b43_wldev *dev)
>  
>  static void b43_print_fw_helptext(struct b43_wl *wl, bool error)
>  {
> -	const char *text;
> +	static const char text[] =
> +		"You must go to "
> +		"http://linuxwireless.org/en/users/Drivers/b43#devicefirmware "
> +		"and download the latest firmware (version 4).\n";
>  
> -	text = "You must go to "
> -	       "http://linuxwireless.org/en/users/Drivers/b43#devicefirmware "
> -	       "and download the latest firmware (version 4).\n";
>  	if (error)
>  		b43err(wl, text);
>  	else

"const char* const" text would likely work as well..

> 
> and in any case I'm not totally convinced that we want to add the bloat
> for trivial cases like
> 
> 	char *safe = "foo";
> 	printk(safe);

Well, in that case, printk("foo") would be the obvious solution :-)

> 
> Would be nice to think of a cleverer way to handle that...
> 
>  - R.

