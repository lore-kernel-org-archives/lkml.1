Return-Path: <linux-kernel-owner+w=401wt.eu-S1758325AbZLGHNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758325AbZLGHNY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 02:13:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757527AbZLGHNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 02:13:23 -0500
Received: from mail-iw0-f197.google.com ([209.85.223.197]:43800 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757213AbZLGHNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 02:13:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=r9eH+O0HGv2xzc33ILQhmDy07TV8ulKZN0SJmjZZMvSHhMJFfMaarpYPTiW2LDVD+v
         dUXytSprBQSe1bdUy1G5aspFfPXE3ebL/jAo/Tc4DjKIsMrozz6ZIbC9Lyn1lW2s5MEB
         fEr7FyqULrMJYxPyAoHv2zW8D3wV4wPCQ2rIU=
Subject: Re: [PATCH 2/2] perf trace/scripting: Don't display 'scripting
 unsupported' msg unnecessarily
From: Tom Zanussi <tzanussi@gmail.com>
To: Wang Liming <liming.wang@windriver.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com,
       rostedt@goodmis.org, acme@ghostprotocols.net
In-Reply-To: <4B1CA15D.1000605@windriver.com>
References: <1260163919-6679-1-git-send-email-tzanussi@gmail.com>
	 <1260163919-6679-3-git-send-email-tzanussi@gmail.com>
	 <4B1CA15D.1000605@windriver.com>
Content-Type: text/plain
Date: Mon, 07 Dec 2009 01:13:26 -0600
Message-Id: <1260170006.6632.10.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 2009-12-07 at 14:31 +0800, Wang Liming wrote:
> Tom Zanussi wrote:
> > The 'scripting unsupported' message should only be displayed when the
> > -s or -g options are used, and not when they aren't, as the current
> > code does.
> > 
> > Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
> > ---
> >  tools/perf/util/trace-event-perl.c |   64 +++++++++++++++++++++++++++++++-----
> >  1 files changed, 55 insertions(+), 9 deletions(-)
> > 
> > diff --git a/tools/perf/util/trace-event-perl.c b/tools/perf/util/trace-event-perl.c
> > index 59564b2..a5ffe60 100644
> > --- a/tools/perf/util/trace-event-perl.c
> > +++ b/tools/perf/util/trace-event-perl.c
> > @@ -570,26 +570,72 @@ struct scripting_ops perl_scripting_ops = {
> >  	.generate_script = perl_generate_script,
> >  };
> >  
> > -#ifdef NO_LIBPERL
> > -void setup_perl_scripting(void)
> > +static void print_unsupported_msg(void)
> >  {
> >  	fprintf(stderr, "Perl scripting not supported."
> > -		"  Install libperl and rebuild perf to enable it.  e.g. "
> > -		"apt-get install libperl-dev (ubuntu), yum install "
> > -		"perl-ExtUtils-Embed (Fedora), etc.\n");
> > +		"  Install libperl and rebuild perf to enable it.\n"
> > +		"For example:\n  # apt-get install libperl-dev (ubuntu)"
> > +		"\n  # yum install perl-ExtUtils-Embed (Fedora)"
> > +		"\n  etc.\n");
> >  }
> 
> I have one question about how to compile c program that embedded perl function:
> 
> $cat foo.c
> #include <EXTERN.h>
> #include <perl.h>
> int main(void)
> {
>          perl_alloc();
>          return 0;
> }
> 
> $gcc  -x c foo.c `perl -MExtUtils::Embed -e ccopts 2>/dev/null`  -o foo `perl 
> -MExtUtils::Embed -e ldopts 2>/dev/null`
> /usr/lib/perl/5.8/auto/DynaLoader/DynaLoader.a:1: error: expected identifier or 
> '(' before '!' token
> /usr/lib/perl/5.8/auto/DynaLoader/DynaLoader.a:2: error: stray '`' in program
> ...
> 
> About thousand of error.
> I'm using ubuntu 8.04. Above error leads "tools/perl/Makefile" can't find the 
> libperl-dev and define "NO_LIBPERL", but I have installed "libperl-dev".
> 
> Did you ever encounter this error?
> Thanks.

No, I haven't seen it, but I'm using ubuntu 8.10, which has perl
v5.10.0.

ubuntu 8.04 uses what's apparently an ancient version of perl, 5.8,
which is I'm guessing where the problem is - I'll have to look into
getting things working with 5.8 in any case...

Tom

> 
> Liming Wang
> > -#else
> > -void setup_perl_scripting(void)
> > +
> > +static int perl_start_script_unsupported(const char *script __unused)
> > +{
> > +	print_unsupported_msg();
> > +
> > +	return -1;
> > +}
> > +
> > +static int perl_stop_script_unsupported(void)
> > +{
> > +	return 0;
> > +}
> > +
> > +static void perl_process_event_unsupported(int cpu __unused,
> > +					   void *data __unused,
> > +					   int size __unused,
> > +					   unsigned long long nsecs __unused,
> > +					   char *comm __unused)
> > +{
> > +}
> > +
> > +static int perl_generate_script_unsupported(const char *outfile __unused)
> > +{
> > +	print_unsupported_msg();
> > +
> > +	return -1;
> > +}
> > +
> > +struct scripting_ops perl_scripting_unsupported_ops = {
> > +	.name = "Perl",
> > +	.start_script = perl_start_script_unsupported,
> > +	.stop_script = perl_stop_script_unsupported,
> > +	.process_event = perl_process_event_unsupported,
> > +	.generate_script = perl_generate_script_unsupported,
> > +};
> > +
> > +static void register_perl_scripting(struct scripting_ops *scripting_ops)
> >  {
> >  	int err;
> > -	err = script_spec_register("Perl", &perl_scripting_ops);
> > +	err = script_spec_register("Perl", scripting_ops);
> >  	if (err)
> >  		die("error registering Perl script extension");
> >  
> > -	err = script_spec_register("pl", &perl_scripting_ops);
> > +	err = script_spec_register("pl", scripting_ops);
> >  	if (err)
> >  		die("error registering pl script extension");
> >  
> >  	scripting_context = malloc(sizeof(struct scripting_context));
> >  }
> > +
> > +#ifdef NO_LIBPERL
> > +void setup_perl_scripting(void)
> > +{
> > +	register_perl_scripting(&perl_scripting_unsupported_ops);
> > +}
> > +#else
> > +void setup_perl_scripting(void)
> > +{
> > +	register_perl_scripting(&perl_scripting_ops);
> > +}
> >  #endif
> 

