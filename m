Return-Path: <linux-kernel-owner+w=401wt.eu-S1760640AbZJMROn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760640AbZJMROn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 13:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760444AbZJMROm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 13:14:42 -0400
Received: from lo.gmane.org ([80.91.229.12]:50779 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760425AbZJMROm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 13:14:42 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?UTF-8?B?VmVkcmFuIEZ1cmHEjQ==?= <vedranf@vedranf.mine.nu>
Subject: Re: Memory overcommit
Date: Tue, 13 Oct 2009 19:13:34 +0200
Message-ID: <hb2cfu$r08$2@ger.gmane.org>
References: <hav57c$rso$1@ger.gmane.org> <20091013120840.a844052d.kamezawa.hiroyu@jp.fujitsu.com>
Reply-To: vedran.furac@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 89-201-154-239.dsl.optinet.hr
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.22) Gecko/20090701 Thunderbird/2.0.0.22 Mnenhy/0.7.5.0
In-Reply-To: <20091013120840.a844052d.kamezawa.hiroyu@jp.fujitsu.com>
X-Age: 25
X-Location: Lovran, Croatia
X-OS: Debian GNU/Linux
X-Face: +Lg7^E:?#]P.Y{N@61yW{aY#>fRcOE6MMqgAM|Kwk"fK!y!i4+h6&?E`Jt@uame[-SLu#*<fGtMmVfh8qo,"kJ'ql^Ni?]l|ax{fvvmD<k:2w^e(y8J2YWO`M=u17OWli}Rf^e:|w2]LulgE(:u0|}mNBZFid[YEWAC>?k:)dZv<!'a)N0b=LFDZKY!!@[%mmVO-7y`Nkj?{<C6rm9Uz$EXu;0I<PubM.Po|vlT.2&vPkJG07G.l0Ty)B/dR0k:KU<;?+WAR\f_ms2b~i"g@e}a)i1N$WLBa{vBoDs4!}k\g?lItt=|]=M{Fm@ce|^6PXq&
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:

> On Mon, 12 Oct 2009 13:51:07 +0200 Vedran Furač
> <vedranf@vedranf.mine.nu> wrote:
>> /proc/meminfo MemTotal:        3542532 kB MemFree:          892972
>> kB Buffers:            2664 kB Cached:           130940 kB
>> 
>> ...that there is almost 900MB free memory. But OK, I can live with
>> it.
>> 
>> So, my question is: why today overcommit isn't turned off *by
>> default*? I have it turned off for a few years now and only side
>> effect is that I don't get processes killed randomly anymore, I
>> don't loose valuable time and data.
>> 
> "isn't turned off" means "vm.overcommit_memory==2" ?

Yes, "2: always check, never overcommit" as per proc(5)

> And...what's version your kernel is ?

Applies to every 2.6.

> oom-killer still finds "definitely-not-guilty" ones ?

Yes. It's always repeatable. Just compile and run that code. I'll
probably just file a bug report.

> I guess the reason of default value is that the kernel assume
> processes will not always use all mmaped range. There will be unused
> range in process's virtual memory and it can be big.
> 
> For example, typical case in a server, when you run multi-thread
> program (like java VM),
> 
> - stack per thread - malloc() arena per thread
> 
> can makes difference among size-of-mapped-range v.s. used-pages
> bigger. I saw Gigabytes of unused range on ia64 host,...statck size
> was big.

Yes, I noticed that JVM allocates gigabytes but then uses less than 10%
of that and, as a consequence, eclipse sometimes fails to start although
there's plenty of free memory. So overcommiting is some kind of a
workaround for broken software that allocate not what they need but what
they might need in some rare occurrences. I would rather like fixing
this userland software than risking OOM situations and random killing of
innocent processes.

> And if strict check(vm.ovecommit_memory=2) is used, mmap() return
> -ENOMEM whenever it hits limit.

% strace -f -e mmap java -version
[...]
mmap(NULL, 996147200, PROT_READ|PROT_WRITE|PROT_EXEC,
MAP_PRIVATE|MAP_ANONYMOUS|MAP_NORESERVE, -1, 0) = -1 ENOMEM (Cannot
allocate memory)

And that should be fine.

> Against random-kill, you may have 2 choices.
> 
> 1. use  /proc/<pid>/oom_adj 2. use  memory cgroup.
> 
> Something more easy-to-use method may be appriciated. We have above 2
> now.

These are just bad workarounds for bad OOM algorithm. I tested this
little program on multiple systems (including windows) without any
tweaking and linux behavior is, unfortunately *the worst*.  :/


Regards,

Vedran

