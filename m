Return-Path: <linux-kernel-owner+w=401wt.eu-S1762745AbZLPSUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762745AbZLPSUW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 13:20:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762729AbZLPSUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 13:20:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21373 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760191AbZLPSUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 13:20:13 -0500
Message-ID: <4B2924E0.9000301@redhat.com>
Date: Wed, 16 Dec 2009 13:20:16 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Borislav Petkov <borislav.petkov@amd.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: perf and libdwarf on debian
References: <20091216135448.GD11618@aftab>
In-Reply-To: <20091216135448.GD11618@aftab>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Borislav,

Borislav Petkov wrote:
> Hi,
> 
> even after installing libdwarf-dev on my debian box here, make in tools/perf/
> still complains that it cannot find libdwarf:
> 
> Makefile:491: No libdwarf.h found or old libdwarf.h found, disables dwarf support. Please install libdwarf-dev/libdwarf-devel >= 20081231
> 
> The problem is that the include path on debian is not
> /usr/include/libdwarf/ but simply /usr/include because the debian
> package libdwarf-dev puts the headers straight into /usr/include.

Thank you for reporting that :-)

> 
> Now, fixing this in the build system could get ugly and too much (see
> below), IMHO, so how about adding a README file in <tools/perf/>
> which explains that on Debian-like systems, one should mkdir
> /usr/include/libdwarf/ and symlink libdwarf.h and dwarf.h into it?
> 
> There could be a better solution though...?

Yeah, I'd like to update Makefile rather than updating document...

> 
> ---
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index 4069996..5b48ce2 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -161,6 +161,7 @@ uname_O := $(shell sh -c 'uname -o 2>/dev/null || echo not')
>  uname_R := $(shell sh -c 'uname -r 2>/dev/null || echo not')
>  uname_P := $(shell sh -c 'uname -p 2>/dev/null || echo not')
>  uname_V := $(shell sh -c 'uname -v 2>/dev/null || echo not')
> +uname_D := $(shell sh -c "lsb_release -a 2>/dev/null | awk '/ID/ { print \$$3 }'")
>  
>  # CFLAGS and LDFLAGS are for the users to override from the command line.
>  
> @@ -475,6 +476,14 @@ ifeq ($(uname_S),Darwin)
>  	PTHREAD_LIBS =
>  endif
>  
> +ifeq ($(uname_D),Debian)
> +	LIBDWARF_PREFIX =
> +	BASIC_CFLAGS += -DDEBIAN
> +else
> +	LIBDWARF_PREFIX = libdwarf/
> +endif

Hmm, I think such Distro-checking code is ugly and very specific.
Instead of that, it would be better to use -I option to search
libdwarf.
e.g.

ifeq ($(shell sh -c "(test -d /usr/include/libdwarf/ && echo y)", y)
	BASIC_CFLAGS += -I /usr/include/libdwarf 
endif

And including just libdwarf.h and dwarf.h.

Thank you again,


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

