Return-Path: <linux-kernel-owner+w=401wt.eu-S1762192AbYHEAEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762192AbYHEAEW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 20:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757298AbYHEAEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 20:04:13 -0400
Received: from web82103.mail.mud.yahoo.com ([209.191.84.216]:32218 "HELO
	web82103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756031AbYHEAEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 20:04:11 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Aug 2008 20:04:10 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Message-ID;
  b=6M0Tx4gNYM74gvKOjKkeCxXQNxggBoHNtlsM9Go21qJnMyrEg71TCx8occ7ZeEJa5DPaPTw3CD4eQmz00xQ4zxxevz/Vw4Up91bWBKSfvh0UkXQvKkfHboLfDM90s8juhSsGPakufUNKo9775vS/rq6mZytX53VHqGyuzSslXXg=;
X-Mailer: YahooMailRC/1042.40 YahooMailWebService/0.7.218
Date: Mon, 4 Aug 2008 16:57:29 -0700 (PDT)
From: David Witbrodt <dawitbro@sbcglobal.net>
Subject: HPET regression in 2.6.26 versus 2.6.25
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <631258.35580.qm@web82103.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

[Please CC me if you reply, for I am not subscribed to LKML.]

This is my first time posting to LKML.

I am a Debian user.  The sources for 2.6.26 recently became available
in the Debian unstable repositories.  Trying them out by building
custom kernels (think 'make oldconfig'), I found that one machine 
worked while another froze early in boot.  No oops, no error msg of
any kind, just a hard freeze without even Magic SysRq working!

I suspected a dumb config error on my part, but found that the Debian
stock kernel exhibited the same problem.  So I filed a bug report in
the Debian BTS:

http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=493479

There is much info about my hardware and configs there, but I can
repost them here if that is helpful.  The machine that works with
2.6.26 has a Gigabyte GA-M59SLI-S5 mboard; the broken machine has an
ECS AMD690GM-M2 mboard.

After much experimenting with various configs and rebuilds, I was
finally able to discover that a kernel boot parameter,
"hpet=disabled", allowed me to boot on the troublesome machine.  
Both custom and Debian stock kernels of version 2.6.25 (most recently
based on 2.6.25.10) work fine on this machine, no problem with HPET.

A member of the Debian kernel team (Bastian Blank) tried to help, but
ended up suggesting bisecting using 'git'.  I am not (yet) a developer
so I was not really thinking of getting that deeply involved, but I
spent so much time trying to track this problem on Saturday night and
all day Sunday, that I decided to give it a try!

Starting with Linus' instructions here,
  http://lkml.org/lkml/2007/7/10/248

I ran: 
  git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6

and:
  git checkout v2.6.25

I built a kernel on the ECS machine and it worked (as expected), so I ran:
  git bisect good

then:
  git checkout v2.6.26-rc4

hoping maybe to save some iterations by not starting with the 2.6.26 release.
This 2.6.26-rc4 kernel froze early in boot, so I ran:
  git bisect bad

Here is a summary of my first git bisecting experiment:
======================================================

Iteration  ID                                        status
---------  ----------                                ------
1          2.6.25                                    good
2          2.6.26-rc4                                bad
3          10c993a6b5418cb1026775765ba4c70ffb70853d  bad
4          334d094504c2fe1c44211ecb49146ae6bca8c321  bad
5          eddeb0e2d863e3941d8768e70cb50c6120e61fa0  bad
6          77ad386e596c6b0930cc2e09e3cce485e3ee7f72  bad
7          ede1389f8ab4f3a1343e567133fa9720a054a3aa  bad
8          c048fdfe6178e082be918d4062c86d9764979112  bad
9          f73920cd63d316008738427a0df2caab6cc88ad7  bad
10         04aaa7ba096c707a8df337b29303f1a5a65f0462  good
11         8fa6878ffc6366f490e99a1ab31127fb599657c9  good
12         1180e01de50c0c7683c6648251f32957bc2d7850  good
13         1e934dda0c77c8ad13fdda02074f2cfcea118a56  bad
14         322850af8d93735f67b8ebf84bb1350639be3f34  good
15         3def3d6ddf43dbe20c00c3cbc38dfacc8586998f  bad
16         700efc1b9f6afe34caae231b87d129ad8ffb559f  good

First commit causing failure:

commit 3def3d6ddf43dbe20c00c3cbc38dfacc8586998f
Author: Yinghai Lu <Yinghai.Lu@Sun.COM>
Date:   Fri Feb 22 17:07:16 2008 -0800

    x86: clean up e820_reserve_resources on 64-bit
    
    e820_resource_resources could use insert_resource instead of request_resource
    also move code_resource, data_resource, bss_resource, and crashk_res
    out of e820_reserve_resources.
    
    Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
======================================================

So, it seems that this commit made a change that works on some
(most?) systems, like my Gigabyte mboard machine, but causes
others, like my ECS mboard machine, to freeze early in boot
unless HPET is disabled.

I don't know how important the High Precision Event Timer really 
is to the health of my machine, but for the sake of principle I 
would really like to see it working again, like with 2.6.25 and 
before!  ;)

For me this is a "regression," but I have found a workaround.  I'm 
not sure what sort of problem is important enough to Linux kernel
developers to qualify as a true regression, so I brought my problem
here in case its something that should be reported and/or fixed.

I work as a programming tutor at a community college, so I'm willing
to make code changes and build test kernels, if anyone can make
suggestions.  I looked at the diff between the last working commit
and the first broken (for me) commit, and found that I did not have
a clue about the hardware issues involved:

git diff 700efc1b9f6afe34caae231b87d129ad8ffb559f 3def3d6ddf43dbe20c00c3cbc38dfacc8586998f

There are only 3 files involved,
  arch/x86/kernel/e820_64.c
  arch/x86/kernel/setup_64.c
  include/asm-x86/e820_64.h

and I could see that 'setup_64.c' is not implicated in my freeze
because the code change is in an #ifdef block depending on 
CONFIG_KEXEC, which is not enabled in my custom kernels (though it
is in the Debian stock kernels).

If what I am describing is considered a regression bug, as I do, then I
am willing to try code changes to get 2.6.26 working on BOTH of my 
machines.


Thx (and please CC replies to me),
Dave Witbrodt
