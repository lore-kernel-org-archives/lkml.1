Return-Path: <linux-kernel-owner+w=401wt.eu-S1754683AbZJLMCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683AbZJLMCf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 08:02:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751790AbZJLMCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 08:02:34 -0400
Received: from lo.gmane.org ([80.91.229.12]:43571 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364AbZJLMCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 08:02:34 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?UTF-8?B?VmVkcmFuIEZ1cmHEjQ==?= <vedranf@vedranf.mine.nu>
Subject: Memory overcommit
Date: Mon, 12 Oct 2009 13:51:07 +0200
Message-ID: <hav57c$rso$1@ger.gmane.org>
Reply-To: vedran.furac@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 89-201-144-125.dsl.optinet.hr
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.22) Gecko/20090701 Thunderbird/2.0.0.22 Mnenhy/0.7.5.0
X-Age: 25
X-Location: Lovran, Croatia
X-OS: Debian GNU/Linux
X-Face: +Lg7^E:?#]P.Y{N@61yW{aY#>fRcOE6MMqgAM|Kwk"fK!y!i4+h6&?E`Jt@uame[-SLu#*<fGtMmVfh8qo,"kJ'ql^Ni?]l|ax{fvvmD<k:2w^e(y8J2YWO`M=u17OWli}Rf^e:|w2]LulgE(:u0|}mNBZFid[YEWAC>?k:)dZv<!'a)N0b=LFDZKY!!@[%mmVO-7y`Nkj?{<C6rm9Uz$EXu;0I<PubM.Po|vlT.2&vPkJG07G.l0Ty)B/dR0k:KU<;?+WAR\f_ms2b~i"g@e}a)i1N$WLBa{vBoDs4!}k\g?lItt=|]=M{Fm@ce|^6PXq&
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi! I don't know if this is appropriate place to ask such questions and
if not, please point me to such place.

Let's simulate a process gone berserk with this piece of code:

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>

int main()
{
  char *buf;
  while(1) {
    buf = malloc (1024*1024*100);
    if ( buf == NULL ) {
      perror("malloc");
      getchar();
      exit(EXIT_FAILURE);
    }
    sleep(1);
    memset(buf, 1, 1024*1024*100);
  }
  return 0;
}

# echo 0 > /proc/sys/vm/overcommit_memory

Compile, run and soon result is:
- System freezes for a second or two
- OOMK wakes up
- X crashes

Now, I'm back to VT1 and dmesg shows 8 process were killed by OOMK
(including X server and some long running daemons with small memory
footprint like automount) before the real culprit was killed. This
random killing spree *really* gives bad reputation to linux and people
usually point this out as an argument against it.

But, there is an easy fix:
# echo 2 > /proc/sys/vm/overcommit_memory
Run the program again and after a few seconds you'll get:

"malloc: Cannot allocate memory"

and that's all what happens. Nothing gets killed and one (and others
too) can continue to work without loosing time, data or both. Only
somewhat strange is that kernel contradicts itself when it says there is
no more and in the same time saying:

/proc/meminfo
MemTotal:        3542532 kB
MemFree:          892972 kB
Buffers:            2664 kB
Cached:           130940 kB

...that there is almost 900MB free memory. But OK, I can live with it.

So, my question is: why today overcommit isn't turned off *by default*?
I have it turned off for a few years now and only side effect is that I
don't get processes killed randomly anymore, I don't loose valuable time
and data.

Regards,

Vedran

