Return-Path: <linux-kernel-owner+w=401wt.eu-S1755834AbZESJU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834AbZESJU3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 05:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751792AbZESJUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 05:20:22 -0400
Received: from web32601.mail.mud.yahoo.com ([68.142.207.228]:40014 "HELO
	web32601.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751070AbZESJUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 05:20:21 -0400
Message-ID: <231530.33013.qm@web32601.mail.mud.yahoo.com>
X-YMail-OSG: ej09Pw0VM1kRbZQcCKPdg9DB6dcpc0owh5XezCjdUlXahd3oVSvaFFgOvPeGGO8hLf7Nu0rXoYlDg7GEDjf8MKk3lKe9V3kdkRsWQxAPB_8fI9M9Mi0V8DnTQE8PsNbvrK9NZUkHVnNpE5l6jMNsV.KHBarlOf5Mhc6MXaReoPp4C3Oyod4Cu5T6Em_CRYA2yvidwirMuNqNqavG_ipH1R_hEeKwDDNf6K02iSN0cFvSQHMyXD9ke2DqGCmkhYOp88Yc1Fok3L7qZxAoWBetXiOHLG3Ei__YW6SxKfU.cYUo2qZtadUaD4IWzMMy.BFFi1BoX164rbnfXBvdock-
X-RocketYMMF: knobi.rm
X-Mailer: YahooMailRC/1277.43 YahooMailWebService/0.7.289.10
References: <688406.16641.qm@web32603.mail.mud.yahoo.com> <20090518203420.GF2658@calx> <alpine.LFD.2.01.0905181506550.3301@localhost.localdomain>
Date: Tue, 19 May 2009 02:20:21 -0700 (PDT)
From: Martin Knoblauch <spamtrap@knobisoft.de>
Subject: Re: Rgeression: 2.6.30-rc6-git3 build error - ICE from drivers/char/random.c
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>, Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.01.0905181506550.3301@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- Original Message ----

> From: Linus Torvalds <torvalds@linux-foundation.org>
> To: Matt Mackall <mpm@selenic.com>; Ingo Molnar <mingo@elte.hu>
> Cc: Martin Knoblauch <spamtrap@knobisoft.de>; Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
> Sent: Tuesday, May 19, 2009 12:29:22 AM
> Subject: Re: Rgeression: 2.6.30-rc6-git3 build error - ICE from drivers/char/random.c
> 
> 
> 
> On Mon, 18 May 2009, Matt Mackall wrote:
> 
> > On Mon, May 18, 2009 at 06:29:13AM -0700, Martin Knoblauch wrote:
> > > 
> > > CC Maintainer.
> > 
> > Bizarre. I bet Linus has an opinion about your compiler.
> 
> I have opinions about a lot of things ;)
>

 who hasn't :-)
 
> > > > drivers/char/random.c: In function `get_random_int':
> > > > drivers/char/random.c:1672: error: unrecognizable insn:
> > > > (insn 202 148 150 0 
> /scratch/build/linux-2.6.30-rc6-git3/arch/x86/include/asm/tsc.h:23 (set (reg:SI 
> 0 ax [91])
> > > >         (subreg:SI (plus:DI (plus:DI (reg:DI 0 ax [88])
> > > >                     (subreg:DI (reg:SI 6 bp) 0))
> > > >                 (const_int -4 [0xfffffffffffffffc])) 0)) -1 (nil)
> > > >     (nil))
> > > > drivers/char/random.c:1672: internal compiler error: in extract_insn, at 
> recog.c:2083
> 
> Oh wow. We seldom hit these things. Internal gcc compiler errors do 
> happen, but it tends to be _very_ rare. And it's almost always some subtle 
> use of inline asm that gets gcc's knickers all twisted up. Often due to 
> the double register usage of 64-bit long long arithmetic.
> 
> That error report seems to be a bit confused about exactly what triggered 
> it: it points to both "get_cycles()" (arch/x86/include/asm/tsc.h:23) and 
> to the get_cpu_var() asm code (drivers/char/random.c:1672).
> 
> Martin - Is this a 32-bit compile? In particular, does the problem go away 
> if you remove the " + get_cycles() "  part (which is three lines down from 
> what that error case reports, but with code movement and combining, who 
> can tell which one it is?)
> 

 sorry, if I was unclear. 64-bit build.

> Usually the only way to get gcc to calm down when it gets into a tizzy 
> like this is to rewrite the thing in some way that gcc has a harder time 
> screwing up. In particular, asking gcc to handle a 64-bit value (inside 
> get_cycles()) while it's busy doing a lot of other things may have just 
> fused the compilers poor little brain.
> 
> So the fix _may_ be as simple as just something like the appended. It 
> doesn't change anything, but it rewrites things so that it doesn't do that 
> "rdtsc" while a lot of other things are also "in flight" at the same time.
> 
>         Linus
> 
> ---
> drivers/char/random.c |    7 +++++--
> 1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/char/random.c b/drivers/char/random.c
> index b2ced39..68120e5 100644
> --- a/drivers/char/random.c
> +++ b/drivers/char/random.c
> @@ -1669,11 +1669,14 @@ DEFINE_PER_CPU(__u32 [4], get_random_int_hash);
> unsigned int get_random_int(void)
> {
>     struct keydata *keyptr;
> -    __u32 *hash = get_cpu_var(get_random_int_hash);
> +    __u32 *hash, garbage;
>     int ret;
> 
> +    garbage = get_cycles() + (long)&ret;
> +    hash = get_cpu_var(get_random_int_hash);
> +
>     keyptr = get_keyptr();
> -    hash[0] += current->pid + jiffies + get_cycles() + (int)(long)&ret;
> +    hash[0] += current->pid + jiffies + garbage;
> 
>     ret = half_md4_transform(hash, keyptr->secret);
>     put_cpu_var(get_random_int_hash);

 With your patch, the problem still remains. Line 1685 is the end of the patched routine now.

[root@lpsdm52 linux-2.6.30-rc6-git3]# make CONFIG_DEBUG_SECTION_MISMATCH=y
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  SYMLINK include/asm -> include/asm-x86
  CALL    scripts/checksyscalls.sh
  CHK     include/linux/compile.h
  CC      drivers/char/random.o
drivers/char/random.c: In function `get_random_int':
drivers/char/random.c:1685: error: unrecognizable insn:
(insn 202 44 46 0 /scratch/build/linux-2.6.30-rc6-git3/arch/x86/include/asm/tsc.h:23 (set (reg:SI 2 cx [72])
        (subreg:SI (plus:DI (subreg:DI (reg:SI 6 bp) 0)
                (const_int -4 [0xfffffffffffffffc])) 0)) -1 (nil)
    (nil))
drivers/char/random.c:1685: internal compiler error: in extract_insn, at recog.c:2083
Please submit a full bug report,
with preprocessed source if appropriate.
See <URL:http://bugzilla.redhat.com/bugzilla> for instructions.
Preprocessed source stored into /tmp/ccFsBjvb.out file, please attach this to your bugreport.
make[2]: *** [drivers/char/random.o] Error 1
make[1]: *** [drivers/char] Error 2
make: *** [drivers] Error 2

Cheers
Martin
