Return-Path: <linux-kernel-owner+w=401wt.eu-S933977AbYCFOfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933977AbYCFOfn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 09:35:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757999AbYCFOfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 09:35:34 -0500
Received: from barikada.upol.cz ([158.194.242.200]:58421 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbYCFOfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 09:35:33 -0500
To: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
Cc: "Matthew Wilcox" <matthew@wil.cx>, "Andi Kleen" <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, gorcunov@gmail.com,
       kernelnewbies@nl.linux.org
Subject: supervising, text processing, semantic "patching" (Re: [JANITOR PROPOSAL] Switch ioctl functions to ->unlocked_ioctl)
In-Reply-To: <4d8e3fd30801081203l636c5923j7965efaa9c121c56@mail.gmail.com>
References: <20080108164015.GC31504@one.firstfloor.org> <4d8e3fd30801081158j3e7292d0i939776342015b12d@mail.gmail.com> <20080108200044.GI16309@parisc-linux.org> <4d8e3fd30801081203l636c5923j7965efaa9c121c56@mail.gmail.com>
User-Agent: slrn + jed (x86_64-pc-linux-glibc-debian)
Date: Thu, 6 Mar 2008 15:54:32 +0100
Message-Id: <E1JXHUO-0008Eh-E4@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nice start, Paolo, really!

I'd recommend to start supervising all this effort, if you wish to
participate. This doesn't require C knowledge at all, not every sw
manager shall have lang:c [+]. But you will save other's valuable time
and effort spent. Also you will eliminate rude and sucking comments like
<20080111223651.GA5942@kroah.com>.

If you know how to make simple "unlocked_ioctl progress" web page for that
on wiki, and to look after it, please do so on kernelnewbies.org site.

For now i see on the list following:

Mathieu Segaud, Sergio Luis:
  'PCI: change procfs'

Andre Noll:
  'drivers/scsi/sg.c to unlocked_ioctl'

Kevin Winchester:
  'drivers/char/drm to use .unlocked_ioctl'

Nikanth Karthikesan:
  'drm_ioctl as an unlocked_ioctl'
  'x86 Machine check handler to use unlocked_iocl'
  'paride driver to use unlocked_ioctl'
  'Random number driver: make random_ioctl as an unlocked_ioctl'


Also you can make a "Tools" section there, where experience and tools
may be presented. This knowledge may improve future source tree
processing efforts, and save one's time and bandwidth (searching
archives, wrong patches, etc.) as well.

I refer to the _text_ processing tools and techniques, i'm going to
present below (skip it guys, if you don't like it).

== Tools ==

As discussions show, knowledge of C doesn't mean solving this task at
all. Even worse, one may re-factor/change functions in the way they like,
but maintainers don't. Compile-time "testing" is a distraction from the
cause. Note, however, that my vision of the root also may have some flaws.


Documentation and tutorials. While i'm willing to help in any technical
things, i know, please look at this first:

http://unix.org.ua/orelly/unix/

"UNIX Power Tools" is a must (without perl part).
Keywords: kernel, shell, BRE, sed.


So, expressions. Let's see on the error you've made. This is not a C
error at first, this is an expression error:

Paolo Ciarrocchi @ Tue, 8 Jan 2008 21:03:13 +0100:

>> > -static const struct file_operations rtc_fops = {
>> > +static long rtc_fioctl(struct file_operations rtc_fops)
>> > +{
>> > +     lock_kernel();
>> >       .owner          = THIS_MODULE,
>>
>> You should probably restrict yourself to files that you can at least
>> compile ...
>
> Yes of course, I've been silly in didn't verify whether the file compile
> but I would appreciate to know whether I'm on the right track or not.

what you've did is introducing more special symbols, to say least.
This often leads to definition and meaning changes, rather than
execution (locks, flow) ones.

While C is not easy to understand generally, basic things, like functions
and structs with good coding style, as Linux has, are quite
distinguishable.

So what key thing(s) that can make expression of a function? This are
braces '(', ')', but see [0] for more.

[0] http://www.mers.byu.edu/docs/standardC/declare.html#Reading%20Declarations

Based on that one can `grep` for functions easily[1] (kind of).

[1] http://article.gmane.org/gmane.linux.kernel/120209

Globally defined structs OTOH are storage things, and usually they are
initialized with '='. What make expression for them easy is that block
('{', '}') is usually started inline with declaration, while it is
accepted coding style for Linux, that functions have blocks started
from the new line.

Thus, it's obvious that special symbols are key things in building of
expressions and recognizing constructs.

Let's consider [1].

1) multiline declarations/definitions are not easy to `grep`
2) proposed method have problems with all things, that can appear from
   the start of the string to the '(', i.e. returing of pointers '*',
   __attiributes__ '((', '"', etc. (you never now).
3) similar patterns can be inside
   3.1) multiline comment blocks
   3.2) multiline macro definitions
*) add yours

= c_func.sh =
#!/bin/sh
# find linux-style function definitions (lang:C)
# Time-stamp: "Thu Mar  6 12:59:10 CET 2008 olecom@flower"

sed -n '
# 3.1: /* skip one line comment (for multiline to work) */
/^\/\*.*\*\/$/b

# 3.1: /* skip multiline comment
#         inside can be anything, that match a function */
/^\/\*/,/\*\/$/b

# 3.2: skip multiline macros (they generate noise)
# TODO: find function-generating macros
/^[[:blank:]]*#/{
 :_macro
 /\\$/{
  N
  b_macro
 }
b
}

# function definition; ends with ")", "," or is like
# "int foo(int pabar) { return 0; }"
/^[^[:blank:]{].*[),}]$/{ # 2: look at the end of the line
 /,$/{ # 1: multiline param. block
 :_start
   N
   /;$/b; # skip declarations (ends with ";")
   s=[)}]$=&= ; t_end ; b_start
 :_end
# post-processing
## make inline
 /\n/s-\n[[:blank:]]*- -g
 }
## remove inline body
/}$/s- *{.*--
p}' "$@"

This script addresses all cases, but not a returning type, if it is on
prev. line.

== semantic buzzwords ==

I saw a [C]"semantic patch" in the janitor list. Don't know if `sed` can
beat it, but at least, it's not a x86 3M binary blob and without any
configuration files. But i'm sure, that sooner or later, scripting or
semantic source code precessing on the git's side will be inevitable
(automatic audit, yet another check-style, *switch imagination*).

With some kind of special web site or effort to have reviewed regular
expressions, IMHO it will be much more easier to move forward, than to
invent `perl` stuff over and over again (cleanpatch, cleanfile,
checkpatch.pl, unifdef.c, etc.).

Syntax is hard, yes, especially without syntax highlighting even in
cool 20 years old GNU Emacs. But it is like assembly, and assembly is
language of The Kernel Hackers[3].

[3] http://kerneltrap.org/Linux/Decoding_Oops

> Switching to a different file now...

Hope you like this start. Maybe i will do all additional stuff for
"unlocked_ioctl" case:

* identifying need of the change,
* lock / unlock in all return variants,
* changing in-kernel users of the changed functions,
* testing with existing manual patches.

But this is very unlikely in case of lack of conversations and curiosity
(at least).

p.s.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

We still (after 13 years) don't know how to use mailng lists, do we?
--
-o--=O`C
 #oo'L O
<___=E M
