Return-Path: <linux-kernel-owner+w=401wt.eu-S1753938Ab0A0KOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938Ab0A0KOv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 05:14:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753369Ab0A0KOu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 05:14:50 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:61354 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149Ab0A0KOt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 05:14:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Qg5WDaW8E5OfBAYcT4SA6Cds06hzaV3TTnTzr0kUlbtYe405zt/7TNApEvqx3L6XzM
         ddmFd/1xbjAEhVybxxL6QKBmvzPwYot0aowFCCog3ein+Me4p/xskL6Vcg3vpTfmniyN
         CotV2JF70vIzp6mGFV1ZNN+RNktm5jyH7Fcaw=
MIME-Version: 1.0
In-Reply-To: <d65b1b151001270212q737706f1md00953155135b271@mail.gmail.com>
References: <d65b1b151001191029o66794c24t228177a8ca544e44@mail.gmail.com>
	 <2375c9f91001191926hc80dc50mb264f757295c1337@mail.gmail.com>
	 <d65b1b151001200706k7a60eaf9le2a6cf4e1227bdad@mail.gmail.com>
	 <2375c9f91001251955s1dfc70f9p94054b7824a4c4b7@mail.gmail.com>
	 <4B5F0452.1080306@suse.cz>
	 <d65b1b151001261110j6c0561a1ifba2da0077698e54@mail.gmail.com>
	 <2375c9f91001261844q474b05a2k6d96237fc925b706@mail.gmail.com>
	 <20100127085239.GA27660@sepie.suse.cz>
	 <d65b1b151001270212q737706f1md00953155135b271@mail.gmail.com>
Date: Wed, 27 Jan 2010 11:14:47 +0100
Message-ID: <d65b1b151001270214p6abb10e6l6d4a562f94e37db5@mail.gmail.com>
Subject: Re: [PATCH] Use full path to dnsdomainname and domainname in 
	scripts/mkcompile_h
From: Glenn Sommer <glemsom@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/1/27 Michal Marek <mmarek@suse.cz>:
> On Wed, Jan 27, 2010 at 10:44:29AM +0800, Américo Wang wrote:
>> On Wed, Jan 27, 2010 at 3:10 AM, Glenn Sommer <glemsom@gmail.com> wrote:
>> > --- scripts/mkcompile_h.orig    2010-01-26 18:59:37.000000000 +0100
>> > +++ scripts/mkcompile_h 2010-01-26 20:03:42.000000000 +0100
>> > @@ -67,9 +67,9 @@
>> >   echo \#define LINUX_COMPILE_BY \"`whoami`\"
>> >   echo \#define LINUX_COMPILE_HOST \"`hostname | $UTS_TRUNCATE`\"
>> >
>> > -  if [ -x /bin/dnsdomainname ]; then
>> > +  if [ `command -v dnsdomainname 2> /dev/null` ]; then
>> >     domain=`dnsdomainname 2> /dev/null`
>> > -  elif [ -x /bin/domainname ]; then
>> > +  elif [ `command -v domainname 2> /dev/null` ]; then
>> >     domain=`domainname 2> /dev/null`
>> >   fi
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

> ... crap, now I learned that busybox doesn't support 'command' :-(
> So what about simply trying 'dnsdomainname' and falling back to
> domainname if it fails? Like this:


Ohh, I didn't know that! We DO need to be compatible with busybox! :/


>
> Subject: [PATCH] scripts/mkcompile_h: don't test for hardcoded paths
>
> Don't test for /bin/{dnsdomainname,domainname}, simply try to execute
> the command and check if it returned something.
>
> Reported-by: Glenn Sommer <glemsom@gmail.com>
> Signed-off-by: Michal Marek <mmarek@suse.cz>
> ---
>  scripts/mkcompile_h |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/scripts/mkcompile_h b/scripts/mkcompile_h
> index 23dbad8..50ad317 100755
> --- a/scripts/mkcompile_h
> +++ b/scripts/mkcompile_h
> @@ -67,9 +67,8 @@ UTS_TRUNCATE="cut -b -$UTS_LEN"
>   echo \#define LINUX_COMPILE_BY \"`whoami`\"
>   echo \#define LINUX_COMPILE_HOST \"`hostname | $UTS_TRUNCATE`\"
>
> -  if [ -x /bin/dnsdomainname ]; then
> -    domain=`dnsdomainname 2> /dev/null`
> -  elif [ -x /bin/domainname ]; then
> +  domain=`dnsdomainname 2> /dev/null`
> +  if [ -z "$domain" ]; then
>     domain=`domainname 2> /dev/null`
>   fi
>
> --
> 1.6.5.3
>
>

I tested above patch, and it seems to work fine.
Though, by looking a bit closer at the source - I found we actually
NEVER need to use 2> /dev/null.
We capture the output using ") > .tmpcompile", meaning we only capture
stdout _NOT_ stderr.
One could argue that we should remove the redirection of stderr for
debugging purposes. (In really rare cases where both dnsdomianname and
domainname are missing)
Though, I do NOT see the need for that!

I'm completely satisfied with the above patch! It does the job I
initially requested - which was to either use a complete path at all
times, or never use a complete path. :)
