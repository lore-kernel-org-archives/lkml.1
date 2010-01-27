Return-Path: <linux-kernel-owner+w=401wt.eu-S1753492Ab0A0JeG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492Ab0A0JeG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 04:34:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752588Ab0A0JeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 04:34:04 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:39485 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab0A0JeB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 04:34:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OmaRTt4CfPHTqbu9moS/QzIcT5RaodbY8oQ8fOy/I5lbuqA7FIcXSzcA4plSa5jV0N
         09ji1ZtsEUIM9ncs0/hdbC9dG+ULiyRhY/xfsINMzses98o/YUHyfv5szu8Gs4rZFWqx
         FwedNCn6VoVUVyE0jEQaI7DCla+dI+r1TDEE0=
MIME-Version: 1.0
In-Reply-To: <20100127085239.GA27660@sepie.suse.cz>
References: <d65b1b151001191029o66794c24t228177a8ca544e44@mail.gmail.com>
	 <2375c9f91001191926hc80dc50mb264f757295c1337@mail.gmail.com>
	 <d65b1b151001200706k7a60eaf9le2a6cf4e1227bdad@mail.gmail.com>
	 <2375c9f91001251955s1dfc70f9p94054b7824a4c4b7@mail.gmail.com>
	 <4B5F0452.1080306@suse.cz>
	 <d65b1b151001261110j6c0561a1ifba2da0077698e54@mail.gmail.com>
	 <2375c9f91001261844q474b05a2k6d96237fc925b706@mail.gmail.com>
	 <20100127085239.GA27660@sepie.suse.cz>
Date: Wed, 27 Jan 2010 17:34:00 +0800
Message-ID: <2375c9f91001270134s76e6c668k13a6634b8d2fb09a@mail.gmail.com>
Subject: Re: [PATCH] Use full path to dnsdomainname and domainname in 
	scripts/mkcompile_h
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Glenn Sommer <glemsom@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 27, 2010 at 4:52 PM, Michal Marek <mmarek@suse.cz> wrote:
> On Wed, Jan 27, 2010 at 10:44:29AM +0800, Américo Wang wrote:
>> On Wed, Jan 27, 2010 at 3:10 AM, Glenn Sommer <glemsom@gmail.com> wrote:
>> > --- scripts/mkcompile_h.orig    2010-01-26 18:59:37.000000000 +0100
>> > +++ scripts/mkcompile_h 2010-01-26 20:03:42.000000000 +0100
>> > @@ -67,9 +67,9 @@
>> >   echo \#define LINUX_COMPILE_BY \"`whoami`\"
>> >   echo \#define LINUX_COMPILE_HOST \"`hostname | $UTS_TRUNCATE`\"
>> >
>> > -  if [ -x /bin/dnsdomainname ]; then
>> > +  if [ `command -v dnsdomainname 2> /dev/null` ]; then
>> >     domain=`dnsdomainname 2> /dev/null`
>> > -  elif [ -x /bin/domainname ]; then
>> > +  elif [ `command -v domainname 2> /dev/null` ]; then
>> >     domain=`domainname 2> /dev/null`
>> >   fi
>> >
>>
>> No, this doesn't look good.
>>
>> First, you don't need to redirect stderr for 'command'.
>>
>> Second, 'command' also searches in shell built-in commands, aliases,
>> so I prefer 'whereis -b'.
>
>
> Well, 'command -v domainname' returns success iff 'domainname' can be
> executed (be it an external command, builtin, function, whatever), which
> is exactly what we do on the next line. But, there is no need to capture
> the output of 'command -v domainname' and pass it to [ ... ], just test
> the return code.
>
> ... crap, now I learned that busybox doesn't support 'command' :-(
> So what about simply trying 'dnsdomainname' and falling back to
> domainname if it fails? Like this:
>
>
> Subject: [PATCH] scripts/mkcompile_h: don't test for hardcoded paths
>
> Don't test for /bin/{dnsdomainname,domainname}, simply try to execute
> the command and check if it returned something.

Good!

>
> Reported-by: Glenn Sommer <glemsom@gmail.com>
> Signed-off-by: Michal Marek <mmarek@suse.cz>

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

> ---
>  scripts/mkcompile_h |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/scripts/mkcompile_h b/scripts/mkcompile_h
> index 23dbad8..50ad317 100755
> --- a/scripts/mkcompile_h
> +++ b/scripts/mkcompile_h
> @@ -67,9 +67,8 @@ UTS_TRUNCATE="cut -b -$UTS_LEN"
>   echo \#define LINUX_COMPILE_BY \"`whoami`\"
>   echo \#define LINUX_COMPILE_HOST \"`hostname | $UTS_TRUNCATE`\"
>
> -  if [ -x /bin/dnsdomainname ]; then
> -    domain=`dnsdomainname 2> /dev/null`
> -  elif [ -x /bin/domainname ]; then
> +  domain=`dnsdomainname 2> /dev/null`
> +  if [ -z "$domain" ]; then
>     domain=`domainname 2> /dev/null`
>   fi
>
> --
> 1.6.5.3
>
>
