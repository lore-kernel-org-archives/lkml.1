Return-Path: <linux-kernel-owner+w=401wt.eu-S1946076AbXBBVG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946076AbXBBVG0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 16:06:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946077AbXBBVG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 16:06:26 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:2765 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946076AbXBBVGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 16:06:25 -0500
X-Greylist: delayed 488 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Feb 2007 16:06:25 EST
X-AuthUser: davidel@xmailserver.org
Date: Fri, 2 Feb 2007 12:58:09 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Alan <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Zach Brown <zach.brown@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
In-Reply-To: <Pine.LNX.4.64.0702021155460.15057@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0702021244250.5219@alien.or.mcafeemobile.com>
References: <patchbomb.1170193181@tetsuo.zabbo.net>
 <df7bc026d50ec5bbdd8e.1170193183@tetsuo.zabbo.net> <20070201083611.GC18233@elte.hu>
 <Pine.LNX.4.64.0702011154110.3632@woody.linux-foundation.org>
 <20070202104900.GA13941@elte.hu> <Pine.LNX.4.64.0702020738500.15057@woody.linux-foundation.org>
 <20070202195932.15b9b4ed@localhost.localdomain>
 <Pine.LNX.4.64.0702021155460.15057@woody.linux-foundation.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1795850513-519671827-1170449889=:5219"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1795850513-519671827-1170449889=:5219
Content-Type: TEXT/PLAIN; charset=US-ASCII

On Fri, 2 Feb 2007, Linus Torvalds wrote:

> > You get some other funny things from co-routines which are very powerful,
> > very dangerous, or plain insane
> 
> You forgot "very hard to think about". 
> 
> We DO NOT want coroutines in general. It's clever, but it's
>  (a) impossible to do without language support that C doesn't have, or 
>      some really really horrid macro constructs that really only work for 
>      very specific and simple cases.
>  (b) very non-intuitive unless you've worked with coroutines a lot (and 
>      almost nobody has)

Actually, coroutines are not too bad to program once you have a 
total-coverage async scheduler to run them. The attached (very sketchy) 
example uses libpcl ( http://www.xmailserver.org/libpcl.html ) and epoll 
as scheduler (but here you can really use anything). You can implement 
coroutines in many way, from C preprocessor macros up to anything, but in 
the libpcl case they are simply switched stacks. Like fibrils are supposed 
to be. The problem is that in order to make a real-life example of 
coroutine-based application work, you need everything that can put you at 
sleep (syscalls or any external library call you have no control on) 
implemented in an async way. And what I ended up doing is exactly what Zab 
did inside the kernel. In my case a dynamic pool of (userspace) threads 
servicing any non-native potentially pre-emptive call, and signaling the 
result to a pollable fd (pipe in my case) that is integrated in the epoll 
(poll/select whatever) scheduler.
I personally find Zab idea a really good one, since it allows for generic 
kernel async implementation, w/out the burden of dirtying kernel code 
paths with AIO knowledge. Being it fibrils or real kthreads, it is IMO 
definitely worth a very close look.




- Davide


--1795850513-519671827-1170449889=:5219
Content-Type: TEXT/x-csrc; charset=US-ASCII; name=cotest.c
Content-Transfer-Encoding: BASE64
Content-Description: 
Content-Disposition: attachment; filename=cotest.c

DQpzdHJ1Y3QgZXBoX2Nvbm4gew0KCWludCBzZmQ7DQoJdW5zaWduZWQgaW50
IGV2ZW50cywgcmV2ZW50czsNCgljb3JvdXRpbmVfdCBjbzsNCn07DQoNCg0K
DQppbnQgZXBoX25ld19jb25uKGludCBzZmQsIHZvaWQgKmZ1bmMpIHsNCglz
dHJ1Y3QgZXBoX2Nvbm4gKmNvbm47DQoJc3RydWN0IGVwb2xsX2V2ZW50IGV2
Ow0KDQoJY29ubiA9IChzdHJ1Y3QgZXBoX2Nvbm4gKikgbWFsbG9jKHNpemVv
ZihzdHJ1Y3QgZXBoX2Nvbm4pKTsNCg0KCWNvbm4tPnNmZCA9IHNmZDsNCglj
b25uLT5jbyA9IGNvX2NyZWF0ZShmdW5jLCBjb25uLCBOVUxMLCBTVEFDS1NJ
WkUpOw0KDQoJZXYuZXZlbnRzID0gMDsNCglldi5kYXRhLnB0ciA9IGNvbm47
DQoJZXBvbGxfY3RsKGtkcGZkLCBFUE9MTF9DVExfQURELCBzZmQsICZldik7
DQoNCgljb19jYWxsKGNvbm4tPmNvKTsNCg0KCXJldHVybiAwOw0KfQ0KDQp2
b2lkIGVwaF9leGl0X2Nvbm4oc3RydWN0IGVwaF9jb25uICpjb25uKSB7DQoJ
c3RydWN0IGVwb2xsX2V2ZW50IGV2Ow0KDQoJZXBvbGxfY3RsKGtkcGZkLCBF
UE9MTF9DVExfREVMLCBjb25uLT5zZmQsICZldik7DQoJY29fZXhpdCgpOw0K
fQ0KDQppbnQgZXBoX2Nvbm5lY3Qoc3RydWN0IGVwaF9jb25uICpjb25uLCBj
b25zdCBzdHJ1Y3Qgc29ja2FkZHIgKnNlcnZfYWRkciwgc29ja2xlbl90IGFk
ZHJsZW4pIHsNCg0KCWlmIChjb25uZWN0KGNvbm4tPnNmZCwgc2Vydl9hZGRy
LCBhZGRybGVuKSA9PSAtMSkgew0KCQlpZiAoZXJybm8gIT0gRVdPVUxEQkxP
Q0sgJiYgZXJybm8gIT0gRUlOUFJPR1JFU1MpDQoJCQlyZXR1cm4gLTE7DQoJ
CWNvX3Jlc3VtZSgpOw0KCQlpZiAoY29ubi0+cmV2ZW50cyAmIChFUE9MTEVS
UiB8IEVQT0xMSFVQKSkNCgkJCXJldHVybiAtMTsNCgl9DQoJcmV0dXJuIDA7
DQp9DQoNCmludCBlcGhfcmVhZChzdHJ1Y3QgZXBoX2Nvbm4gKmNvbm4sIHZv
aWQgKmJ1ZiwgaW50IG5ieXRlKSB7DQoJaW50IG47DQoNCgl3aGlsZSAoKG4g
PSByZWFkKGNvbm4tPnNmZCwgYnVmLCBuYnl0ZSkpIDwgMCkgew0KCQlpZiAo
ZXJybm8gPT0gRUlOVFIpDQoJCQljb250aW51ZTsNCgkJaWYgKGVycm5vICE9
IEVBR0FJTiAmJiBlcnJubyAhPSBFV09VTERCTE9DSykNCgkJCXJldHVybiAt
MTsNCgkJY29fcmVzdW1lKCk7DQoJfQ0KCXJldHVybiBuOw0KfQ0KDQppbnQg
ZXBoX3dyaXRlKHN0cnVjdCBlcGhfY29ubiAqY29ubiwgdm9pZCBjb25zdCAq
YnVmLCBpbnQgbmJ5dGUpIHsNCglpbnQgbjsNCg0KCXdoaWxlICgobiA9IHdy
aXRlKGNvbm4tPnNmZCwgYnVmLCBuYnl0ZSkpIDwgMCkgew0KCQlpZiAoZXJy
bm8gPT0gRUlOVFIpDQoJCQljb250aW51ZTsNCgkJaWYgKGVycm5vICE9IEVB
R0FJTiAmJiBlcnJubyAhPSBFV09VTERCTE9DSykNCgkJCXJldHVybiAtMTsN
CgkJY29fcmVzdW1lKCk7DQoJfQ0KCXJldHVybiBuOw0KfQ0KDQppbnQgZXBo
X2FjY2VwdChzdHJ1Y3QgZXBoX2Nvbm4gKmNvbm4sIHN0cnVjdCBzb2NrYWRk
ciAqYWRkciwgaW50ICphZGRybGVuKSB7DQoJaW50IHNmZDsNCg0KCXdoaWxl
ICgoc2ZkID0gYWNjZXB0KGNvbm4tPnNmZCwgYWRkciwgKHNvY2tsZW5fdCAq
KSBhZGRybGVuKSkgPCAwKSB7DQoJCWlmIChlcnJubyA9PSBFSU5UUikNCgkJ
CWNvbnRpbnVlOw0KCQlpZiAoZXJybm8gIT0gRUFHQUlOICYmIGVycm5vICE9
IEVXT1VMREJMT0NLKQ0KCQkJcmV0dXJuIC0xOw0KCQljb19yZXN1bWUoKTsN
Cgl9DQoJcmV0dXJuIHNmZDsNCn0NCg0KaW50IGVwaF9zY2hlZHVsZXIoaW50
IGxvb3AsIGxvbmcgdGltZW91dCkgew0KCWludCBpLCBuZmRzOw0KCXN0cnVj
dCBlcGhfY29ubiAqY29ubjsNCglzdHJ1Y3QgZXBvbGxfZXZlbnQgKmNldmVu
dHM7DQoNCglkbyB7DQoJCW5mZHMgPSBlcG9sbF93YWl0KGtkcGZkLCBldmVu
dHMsIG1heGZkcywgdGltZW91dCk7DQoNCgkJZm9yIChpID0gMCwgY2V2ZW50
cyA9IGV2ZW50czsgaSA8IG5mZHM7IGkrKywgY2V2ZW50cysrKSB7DQoJCQlj
b25uID0gY2V2ZW50cy0+ZGF0YS5wdHI7DQoJCQljb25uLT5yZXZlbnRzID0g
Y2V2ZW50cy0+ZXZlbnRzOw0KCQkJaWYgKGNvbm4tPnJldmVudHMgJiBjb25u
LT5ldmVudHMpDQoJCQkJY29fY2FsbChjb25uLT5jbyk7DQoJCX0NCgl9IHdo
aWxlIChsb29wKTsNCg0KCXJldHVybiAwOw0KfQ0KDQo=

--1795850513-519671827-1170449889=:5219--
