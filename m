Return-Path: <linux-kernel-owner+w=401wt.eu-S1753490AbZI3Hy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490AbZI3Hy5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 03:54:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752926AbZI3Hy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 03:54:57 -0400
Received: from mail.perches.com ([173.55.12.10]:1445 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873AbZI3Hy4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 03:54:56 -0400
Subject: Re: [RFC] move #define pr_fmt KBUILD_MODNAME and KMSG_COMPONENT to
 Makefiles?
From: Joe Perches <joe@perches.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
In-Reply-To: <20090930065533.GB13850@merkur.ravnborg.org>
References: <1254248104.28232.447.camel@Joe-Laptop.home>
	 <20090930065533.GB13850@merkur.ravnborg.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Sep 2009 00:54:59 -0700
Message-Id: <1254297299.2960.55.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-30 at 08:55 +0200, Sam Ravnborg wrote:
> On Tue, Sep 29, 2009 at 11:15:04AM -0700, Joe Perches wrote:
> > There are starting to be more uses of
> > #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > and
> > #define KMSG_COMPONENT "foo"
> > #define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
> > in kernel sources.
> > 
> > Perhaps it would be better to put these
> > defines in the appropriate Makefile and not
> > sprinkle the sources with them multiple times?
> 
> Maybe I'm a bit dense but I do not quite follow you
> here. What is it you want moved to kbuild here?
> 
> To me it looks more like a logical extension to the
> pr_* macros based on info we already have available.

Hi Sam.

I agree it's a logical extension to what exists
already, unfortunately there are already many
uses of pr_<level> calls, some that use pr_fmt(),
some that use an embedded constant string,
and some with nothing.  Using a predeclared
standardized pr_fmt would be a problem for
those calls that use embedded constant strings.

So today, every file in a module that uses
pr_fmt #defines pr_fmt before the #includes.

#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

There are starting to be a lot of these and
likely there will be a lot more unless the
defines are standardized somehow.

Per Makefile ccflags would allow a gradual
conversion of the many pr_<level> calls that
are already prefixed with nothing, or constant
strings, or already use pr_fmt with either
KBUILD_MODNAME, KMSG_COMPONENT, or some
other fixed string.

If something like were added to a module Makefile:

	ccflags-y += -D "pr_fmt(fmt)=KBUILD_MODNAME \": \" fmt"

or if necessary a per-file entry in the Makefile:

	CFLAGS_foo.o += -D "pr_fmt(fmt)=KBUILD_MODNAME \": \" fmt"

the number of these #defines pr_fmt in source could be
reduced.

These new Makefiles -D entries could later be stripped
and the pr_fmt define standardized perhaps in the top
level Makefile after the existing pr_<level> calls with
embedded prefix strings in source are modified as necessary.

Something similar could be done in the Makefiles for
KMSG_COMPONENT uses as well.

cheers, Joe

