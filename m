Return-Path: <linux-kernel-owner+w=401wt.eu-S1757431AbYLPTpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431AbYLPTpY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 14:45:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751329AbYLPTpD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 14:45:03 -0500
Received: from an-out-0708.google.com ([209.85.132.247]:52800 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235AbYLPTpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 14:45:01 -0500
Message-ID: <154e089b0812161144x3c9579f5g8731b616fde6484c@mail.gmail.com>
Date: Tue, 16 Dec 2008 20:44:56 +0100
From: "Hannes Eder" <hannes@hanneseder.net>
To: "Ben Dooks" <ben-linux@fluff.org>
Subject: Re: [PATCH] HID: avoid sparse warning in HID_COMPAT_LOAD_DRIVER
Cc: "Jiri Kosina" <jkosina@suse.cz>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <20081216194113.GF12431@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4947a48f.08b6660a.34ca.ffffa1e8@mx.google.com>
	 <20081216155822.GD12431@fluff.org.uk>
	 <alpine.LNX.1.10.0812161659580.21089@jikos.suse.cz>
	 <20081216194113.GF12431@fluff.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2008 at 5:01 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Tue, 16 Dec 2008, Ben Dooks wrote:
>
>> >  #ifdef CONFIG_HID_COMPAT
>> >  #define HID_COMPAT_LOAD_DRIVER(name)       \
>> > +/* prototype to avoid sparse warning */    \
>> > +extern void hid_compat_##name(void);       \
>> >  void hid_compat_##name(void) { }   \
>> surely this could simply be changed to 'static void
>> hid_compat_##name(void)' if it is only being defined to be an empty
>
> This will cause gcc emit warnings about unused symbols.

The real problem is that the symbol (in that case the function) is not
exported if defined static.

e.g.:

$ cat >foobar.c <<EOF
> static void foo(void) {}
> extern void foo(void);
>
> void bar(void) {}
> EOF
$ gcc -c foobar.c
$ nm foobar.o
00000005 T bar
00000000 t foo

from the nm manpage:
The  symbol  type. ... If lowercase, the symbol is local; if
uppercase, the symbol is global (external)

i.e. foo is local

see http://lkml.org/lkml/2008/9/4/495 for what ANSI C Std has to say
about that and about the proposed change.

But, don't ask my why the void functions with empty function bodies
are exported.

On Tue, Dec 16, 2008 at 8:41 PM, Ben Dooks <ben-linux@fluff.org> wrote:
> sorry, 'static inline void' then.

in that case the symbol would not even be local as it is not used with
the translation unit.

$ nm
00000005 T bar

-Hannes
