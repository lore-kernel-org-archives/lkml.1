Return-Path: <linux-kernel-owner+w=401wt.eu-S966647AbXFGW42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966647AbXFGW42 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 18:56:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966199AbXFGWz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 18:55:56 -0400
Received: from raven.upol.cz ([158.194.120.4]:60809 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966048AbXFGWzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 18:55:51 -0400
Date: Fri, 8 Jun 2007 01:06:57 +0200
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Sam Ravnborg <sam@ravnborg.org>, Andrew Morton <akpm@linux-foundation.org>,
       kbuild-devel@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Another version of cleanfile/cleanpatch
Message-ID: <20070607230657.GV7266@flower.upol.cz>
References: <20070605073335.GM7266@flower.upol.cz> <20070605081959.GB21991@uranus.ravnborg.org> <20070605133834.GO7266@flower.upol.cz> <20070605141254.GA24722@uranus.ravnborg.org> <20070605145759.GP7266@flower.upol.cz> <20070605151101.GQ7266@flower.upol.cz> <20070606174556.GS7266@flower.upol.cz> <20070606175026.GA6303@uranus.ravnborg.org> <20070606191426.GT7266@flower.upol.cz> <Pine.LNX.4.64.0706071634470.8762@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706071634470.8762@fbirervta.pbzchgretzou.qr>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2007 at 04:36:33PM +0200, Jan Engelhardt wrote:
> 
> On Jun 6 2007 21:14, Oleg Verych wrote:
> >[]
> >> > Many things in XXI century still can be done by tools founded 20-30
> >> > years ago. Why not try to?
> >> 
> >> Because your shell script is unreadable by normal human beings[*]
> >> while the perl script for people with a bit of perl fu can read it
> >> and fix/modify it.

Actually, unreadable and challenging were first messages, where i just
tried to show different point of view. After new subject and attached
working commented script with test case, i hope it's not.

> And because at the end of the day, the perl script might be faster
> than the shell script.
(ran by bash ;)

If fact, when i applied same solution and logic as in those scripts,
performance was very poor even with dash. But lets think for a moment
about, what must be done and then how. Meaningful whitespace damage is:

- trailing whitespace everywhere;
- x*(eight spaces) on line start;
- spaces between tabs near line start, before code;
- empty lines in the end of file (patches can't be handled, or can? :).

Finally what patches, i've replied on, done was, notifying user about
long visual lines.

So, script is interactive, isn't it? And that means:

- you have human as user;
- user knows, what script can possibly do.

Because of that, i think, following is redundant:

- to check for binary files
- scan whole file for long lines, with useless bunch of messages about
  ones. Useless, because script doesn't fix that, it can't do that!

Thus, going from the end of my version, you see one-shoot check for
long line with (i hope) user-friendly message.

Then, there's no check for binary file at all.

Body -- is a commented sed script with shell variables for source/patch
handling switch and compatibility with other versions of sed, not only GNU.
If you like more tabs, then i stated in whitespace damage, just use
"unexpand".

As result there's one small (maintaining[1]), hopefully smart and fast
script.

> Yes, UNIX was designed to handle fork-exec efficiently, thank God. But
> still.
[]
> >    efforts to remove bashizms...
> 
> I prefer bashisms over using a shell [referring to original sh or ksh]
> that can't do a sane thing.

I would like to know cases. Just to try to solve them.

Two from my head are:

- `set pipefail' option -- not problem at all [0]
- arrays.

Arrays. Well, that depends. My option is as follows.

If you really need some kind of indexed data, create array via line by
line reading of file, storing data in variables with numbers, like

while :
do eval read -r $PREFIX_$i || break
   i=$(($i + 1))
done
(stdin redirection is shown in [0]) thus you have it.

OK, to not to go offtopic, i would say here, that if that temp file on the
tmpfs, then Linux directly helps you with its efficient memory
management, not libc (good addition to fork/clone-execve, isn't it? ;)

Anything else may require not shell as solution.

> 
> 	Jan
> -- 

[0] 47.2.1.4 More Elaborate Combinations (UNIX Power Tools)
    <http://unix.org.ua/orelly/unix/upt/ch47_02.htm>

[1] Just two maitaining patches: usability and bugfix, as example:

|processing_based_on_patch_file_names.patch, not script name:

--- clean-whitespace.sh~v.00	2007-06-07 23:53:00.099249000 +0200
+++ clean-whitespace.sh	2007-06-07 23:54:43.025681500 +0200
@@ -7,5 +7,5 @@
 not_patch_line='/^+[^+]/'
 
-case $0 in *diff* | *patch*)
+case $1 in *[.]diff | *[.]patch)
 	file=patch ; sp='+[!+]' ; p='+' ; addr="$not_patch_line" ;;
 esac

|correctly_handle_lines_after_append_command.patch
|(and more visible resulting message):

--- clean-whitespace.sh~v.01	2007-06-07 23:54:43.025681500 +0200
+++ clean-whitespace.sh	2007-06-07 23:57:34.120374250 +0200
@@ -14,8 +14,8 @@
 s|[$t$s]*$||; # trailing whitespace,
 :next;        # x*8 spaces on the line start -> x*tabs
-s|^$p\($t*\)$s4$s4|$p\1$t|;t next;
-s|^$p\($t*\)$s*$t|$p\1$t|g; # strip spaces between tabs
-};p" -- "$i" >"$o" &&
-echo "please, see clean ${file:=source} file: $o
+s|^\([\n]*\)$p\($t*\)$s4$s4|\1$p\2$t|;t next; # \n is needed after N command
+s|^\([\n]*\)$p\($t*\)$s*$t|\1$p\2$t|g; # strip spaces between tabs
+};p" -- "$i" >"$o" && echo "
+please, see clean ${file:=source} file: $o
 "
 exec expand $i | while read -r line # check for long line

____
