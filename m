Return-Path: <linux-kernel-owner+w=401wt.eu-S1755980AbZJZTek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980AbZJZTek (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 15:34:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751246AbZJZTej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 15:34:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52756 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755090AbZJZTei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 15:34:38 -0400
Subject: Re: [PATCH RFC] tracing: Improve recordmcount.pl in a simpler and
 cleaner way
From: Steven Rostedt <srostedt@redhat.com>
To: Li Hong <lihong.hi@gmail.com>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <20091025120250.GA9845@uhli>
References: <20091025120250.GA9845@uhli>
Content-Type: text/plain
Organization: Red Hat
Date: Mon, 26 Oct 2009 15:34:38 -0400
Message-Id: <1256585678.2756.42.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

BTW, please send to my rostedt@goodmis.org account. My Red Hat mail has
horrible spam filters, and I almost deleted this because it was in
between 40 spam emails. I just noticed "tracing" in the subject, and had
to undelete this email.

On Sun, 2009-10-25 at 20:02 +0800, Li Hong wrote:
> Now the implementation of recordmcount.pl have several problems:

Heh, one problem people have told me is that it is written in perl ;-)

> 
>   * This tool is not implemented as the documentation (the block comment at
>     the head of the file) says. It will not always choose the first function
>     as offset reference. e.g.
> 
>       .section ".sched.text", "ax"
>             [...]
>       func1:
>             [...]
>             call mcount  (offset: 0x10)
>             [...]
>             ret
>       .globl fun2
>       func2:             (offset: 0x20)
>             [...]
>             [...]
>             ret
>       func3:
>             [...]
>             call mcount (offset: 0x30)
>             [...]
> 
>     First we will select func1, but we forget to set $read_function = 0 here
>     (Line 410 - 423). When we meet func2, we will replace $ref_func to func2
>     and finally set $read_function = 0 at Line 412.


read_function means that we want to still check for functions. If we
don't have a global yet, then we want to still check for functions, so
we do not want to stop read_function. But if you look at the code, it
does exactly what I want.

$read_function set to 1 when we have a proper section.

We see func1 which is local, so we record it and continue. If func2 was
still local, we would not record it because we already have a ref
function...

< $read_function is set to 1 when we found a section to parse >

    } elsif ($read_function && /$function_regex/) {
	$text_found = 1;
	$text = $2;

	# if this is either a local function or a weak function
	# keep looking for functions that are global that
	# we can use safely.
	if (!defined($locals{$text}) && !defined($weak{$text})) {

< if this is global and not weak, we use it and stop our search>

	    $ref_func = $text;
	    $read_function = 0;
	    $offset = hex $1;
	} else {

< the current text is not global, or is weak >

	    # if we already have a function, and this is weak, skip it
	    if (!defined($ref_func) && !defined($weak{$text}) &&

< note the !defined($ref_func)  this means we only go in the if, if we have
  not hit any function yet. >

		 # PPC64 can have symbols that start with .L and
		 # gcc considers these special. Don't use them!
		 $text !~ /^\.L/) {
		$ref_func = $text;
		$offset = hex $1;
	    }
	}

> 
>     Luckily, this 'wrongly' implementation accidently makes the result same to
>     the documentation. Because we use $ref_func + (call offset - ref_func offset)
>     in tmp.s, here any ref func can give a right address finally.

Correct, but as I shown above, there was no bug to begin with.

> 
>   * The algorithm and implementation is a little complex. As above shows, we
>     can use any function in this section as a reference, not just the first
>     one. This will simplify the code much. A reasonable method is: choose the
>     first global function we meet as a reference. If there is none, choose the
>     first local one.

The code already does that.

> 
>   * mcount section check is wrong. If the mcount section is not the first
>     section, we will never find it.

Wrong, we do a header check, not a section check. One of the options I
pass into objdump is "-h" which dumps the headers. I search all headers
for __mcount_loc before we start looking at sections. When we go into
the while loop, I have $read_headers = 1. Which means we are reading the
headers and that's the only place I look. When we hit our first section,
the $read_headers turns to 0, and we are done looking at them.


> 
>   * Find objcopy version is wrong. If objcopy has a version but is less than
>     2.17, we will still disable local function reference. $found_version can't
>     be used to determine the show of the warning message.

Ouch, that is a bug. $find_version should not be used, but $use_locals
should. Hmm, and the initialization of that is also wrong. Ug, that
whole logic needs to be fixed. Thanks!


> 
>   * Argment number check is wrong. Should be 10.

Ah, we keep adding arguments, and forgetting to update the counter.
Thanks.

> 
>   * .L check path is partial, not on all run path.

It only matters on local symbols, and it is checked there.

> 
>   * If there is no global and local symbols, return early. If there are only
>     locals and can't use local reference, return early.

Not sure what you mean by the above.

> 
>   * input file can be absolute path?

Hmm, is this about the ftrace.c check. Not sure if full path is passed
in.

> 
>   * Some documenation and in-line comment is wrong.

I'm sure it is ;-)

> 
>   * Code deals with weak functions will not be called. Remove it.

Eek!!! No!!!! This will cause a bug!  If we pick a weak function as a
reference and use it, and that weak function is overridden by another
function, we will be pointing to all wrong locations. That weak code
must stay!

> 
> To resolve all these problems, I rewrite some part of the code and make the
> algorithm and code simpler and cleaner.
> 
> Two pending issues:
> 
>   * I ignore all the weak functions now. Is that a big impact?

Yep, as mentioned above.

> 
>   * I just make some simple tests. Steven, are there some ways to do a full
>     and strong verification? Also I will very appreciate if some guys can help
>     me do some tests on other arches except x86.

I mostly did hand inspections of code. As well as testing the final
results. The ftrace code should test to make sure things work on bootup.
There's lots of self tests that it runs.

Also you can cat out debugfs/tracing/available_filter_functions into a
temp file, before and after your changes and make sure they are
identical. If not, you must understand fully why they are not.


> 
> As the change is large, except the patch, I also put the new version file in
> the attchment.

Changes like this should be broken up into several patches. One for
every point. Only a few of the above I would accept. Namely the objdump
version thing and perhaps some comments.

As for the other changes, I'm not sure. As I've said, there was nothing
broken to start with for a lot of those points. If you make it cleaner,
I'm fine with that. But it must maintain functionality. Another test is
to do a objdump of the mcount_loc before and after your changes to make
sure they are still the same.

Also, I'm going to start working on converting this to C. There will be
a check to see if the build machine has libelf installed, and if so, it
will compile a C program to do these changes, and if not, it will fall
back to the perl script.

Thanks,

-- Steve


