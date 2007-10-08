Return-Path: <linux-kernel-owner+w=401wt.eu-S1753772AbXJHTNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772AbXJHTNT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 15:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751469AbXJHTNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 15:13:09 -0400
Received: from barikada.upol.cz ([158.194.242.200]:50315 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbXJHTNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 15:13:06 -0400
Date: Mon, 8 Oct 2007 21:27:15 +0200
To: Willy Tarreau <w@1wt.eu>
Cc: Rene Herman <rene.herman@keyaccess.nl>, Ingo Molnar <mingo@elte.hu>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Medve Emilian-EMMEDVE1 <Emilian.Medve@freescale.com>,
       Helge Deller <deller@gmx.de>
Subject: initramfs: coloring in userspace, "[PATCH 0/2] Colored kernel output (run2)"
Message-ID: <20071008192715.GX22435@flower.upol.cz>
References: <20071006195105.GE22435@flower.upol.cz> <20071006194820.GA30579@elte.hu> <20071006210349.GG22435@flower.upol.cz> <20071007060706.GA18768@elte.hu> <20071007111035.GO22435@flower.upol.cz> <20071007161255.GA22102@elte.hu> <470929D8.80003@keyaccess.nl> <20071007191309.GS10199@1wt.eu> <20071007194725.GS22435@flower.upol.cz> <20071008032305.GA28755@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071008032305.GA28755@1wt.eu>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2007 at 05:23:05AM +0200, Willy Tarreau wrote:
> On Sun, Oct 07, 2007 at 09:47:25PM +0200, Oleg Verych wrote:
> > > For instance, anyone who has experienced read errors on and IDE disk
> > > knows that it can literally take hours/days to boot, after displaying
> > > thousands of messages. Here, having the ability to see that no IRQ was
> > > assigned or something like this could help.
> > 
> > As i'm pretty much in all that text(tty)-mode stuff anyway, maybe after
> > some time i will propose something klibc/tty based. Mainly a bit of user
> > interface: split scrolling regions for errors and notifications; flexible
> > color schemas (keyword highlighting); keyboard events. Of course it will
> > work in such IDE cases, only if driver is a module.
> 
> But what I cannot understand is how you expect userspace to work while
> the lines are being displayed.

With `quiet' boot option no message bloat is flowing. I have on debian's
2.6.18 only two error message about PCI remaing error and if by buggy
grub didn't read initrd image correctly, so ungziping fails.

> If this is just to repaint the screen once everything is up, it is 100%
> useless. I'm interested in seeing errors _while_ they are happening.
> Basically, I need no color if the machine boots correctly.

OK. I don't know what somebody think it is like, let me show,
especially for our famous kernel developer.

In flower ftp upload adopted "init" script for initramfs can be found.
I took standard debian's and added  my stuff on head.

With quiet option kernel (should) very quickly reach initramfs/init.
Even 4M gzipped image (14M unpacked) on my laptop loads pretty quickly.

All is nice looking and scrollable (a bit). I didn't tried to do
separate scrolling regions for info and errors, because back scrolling
would be dead. But if somebody will fix this kernel feature, things
can be done easily then. Or file backup can used instead, early dmesg
available as a side effect.

So, i let see colored messages even for very old kernels, if this head
is added to initramfs/init. If it doesn't work for you, let's make it
work!

(sh: `sleep` must not be from busybox, because it has no seconds
fractions, which is kind of stupid, but POSIX compatible. My proposition
about select() like tool for shell can be found in google:
'olecom select sh')

== Script makes basic fs setup: ==============================

#!/bin/sh
# NOTE: pipefs (in <2.6.2?) isn't up yet
set +e

test  -e null || mknod null c 1 3
{
mkdir -m 0755 /dev
mkdir -m 1777 /tmp
mkdir -m 0555 /proc
cd /dev
mknod null c 1 3
mknod kmsg c 1 11
mknod tty  c 5 0
mknod console c 5 1
} 2>null

umask 077
mount -t proc proc /proc


== then TERM=linux tty loglevel attributes setup: ============

DEF='\033[0m'
EMERG='\033[1;5;37;41m' # bold blink white fore- on red background
ALERT='\033[1;37;41m'
CRIT='\033[1;5;31;40m'	# bold blink red on black
ERR='\033[1;31;40m'
WARN='\033[1;33;40m'	# bold yellow,
NOTICE='\033[1;36;40m'	# cyan
INFO='\033[1;32;40m'	# green
DBG='\033[1;34;40m'	# blue
q='\033[1;35m`'
b="\033[1;35m'"


== polling/printing daemon setup ================================

kttylog() {
# in case of rootfs change die
# (rerun manually in the end of the init script with new rootfs)
set -e
trap '
echo "reloading kttylogd, new pid=$!" >/dev/kmsg
exit
' EXIT HUP

while read -r LINE
   do case  "$LINE" in
    '<0'*) COLOR=EMERG;;
    '<1'*) COLOR=ALERT;;
    '<2'*) COLOR=CRIT;;
    '<3'*) COLOR=ERR;;
    '<4'*) COLOR=WARN;;
    '<5'*) COLOR=NOTICE;;
    '<7'*) COLOR=DBG;;
    esac
    # turn name to value
    eval 'printf "$'"${COLOR=INFO}"'"'
    # print raw content
    printf %s "${LINE#???}"
    # finish line output
    printf "$DEF\n\r"
done
}

== wait to see all "quiet" messages ==========================

printf "
After you've seen errors, even with $q\033[33mquiet$b$DEF option,
to see other (usual) printk() stuff and continue to boot,
please, hurry to press $q\033[0;1mEnter$b$DEF
"
fancy_read() {
TIMEOUT=7  # bash has seconds-only there, but we can have all,
	   # that (klibc's) `sleep' can (it has useful fractions, POSIX hasn't)
	   # Peter (hpa) did bash-incomatible change in klibc's `read`,
	   # added `-t', added with second fractions :(
	   # this functions is an example to show, that by means of `sh`
	   # it's possible to have *fancy* read (i.e. nice and flexible

POLLTIME=5 # tenths of seconds
TIMEOUT=${TIMEOUT}0
PROMPT="("
G=$((${#PROMPT} + 1))
PROMPT="$PROMPT$TIMEOUT): "

echo -n "$PROMPT"
exec 4<&0 # /dev/tty isn't working early, thus do dup of stdin for `read' job
( read LAMER_LEVEL || echo "Read Error" ) <&4 &
exec 4<&-

INPUT_PID=$!

while /bin/sleep 0.$POLLTIME && test -e "/proc/$INPUT_PID/exe"
do
   TIMEOUT=$((${TIMEOUT} - $POLLTIME))

   if test "$TIMEOUT" -gt 0
   then printf "\0337\033[${G}G$TIMEOUT): \0338"
   else printf "\033[${G}Gtime is out)"
        test -e "/proc/$INPUT_PID/exe" && kill $INPUT_PID
	break
   fi
done
}

fancy_read
unset fancy_read


== run printing daemon ==========================================

kttylog < /proc/kmsg >console &
KTTYLOG_PID=$!

cd /

== after flow of all pending messages, print this stuff==========

echo "<0>EMERG message (kmsg)..." >/dev/kmsg
echo "<1>ALERT message (kmsg)..." >/dev/kmsg
echo "<2>CRIT message (kmsg)..." >/dev/kmsg
echo "<3>ERR message (kmsg)..."  >/dev/kmsg
echo "<4>WARN message (kmsg)..." >/dev/kmsg
echo "<5>NOTICE message (kmsg)..." >/dev/kmsg
echo "<6>INFO message (kmsg)..." >/dev/kmsg
echo "<7>DBG message (kmsg)..." >/dev/kmsg
echo "
interactive shell (type exit to continue)

" >/dev/kmsg

== shell to have a bit of the rest =============================

sh -i

echo "Loading Debian..."

== continue booting ============================================

--- stuff ---

> Willy
> 
