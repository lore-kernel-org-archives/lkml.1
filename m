Return-Path: <linux-kernel-owner+w=401wt.eu-S1753230AbYKZJ7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230AbYKZJ7Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 04:59:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751858AbYKZJ7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 04:59:17 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:62609 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbYKZJ7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 04:59:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=decDhjM5lxqxCf6PDsDbvf/JwCgQx0d6/e1UZcblR2tf+r7bK5gvJUi7W76C7fqivD
         iQTWkd9kV7j0hHo721weZvrjcWgqp8kkMNK0omA/4J09Z1qyK3gZv0n6EmrzVNVqalX3
         16u47XB+1q2jPIZ6nSYAYyQYgT2c6fsghm9+I=
Message-ID: <492D1DED.8060703@gmail.com>
Date: Wed, 26 Nov 2008 11:59:09 +0200
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: "Frank Ch. Eigler" <fche@redhat.com>
CC: mingo@elte.hu, srostedt@redhat.com, a.p.zijlstra@chello.nl,
       sandmann@daimi.au.dk, linux-kernel@vger.kernel.org,
       viro@ZenIV.linux.org.uk
Subject: Re: [PATCH 2/2] tracing: identify which executable object the userspace
 address belongs to
References: <1227353328-16104-1-git-send-email-edwintorok@gmail.com>	<1227353328-16104-3-git-send-email-edwintorok@gmail.com> <y0my6z798de.fsf@ton.toronto.redhat.com>
In-Reply-To: <y0my6z798de.fsf@ton.toronto.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008-11-25 16:40, Frank Ch. Eigler wrote:
> =?utf-8?q?T=C3=B6r=C3=B6k=20Edwin?= <edwintorok@gmail.com> writes:
>
>   
>> Impact: modify+improve the userstacktrace tracing visualization feature
>> [...]
>> You'll see stack entries like:
>>    /lib/libpthread-2.7.so[+0xd370]
>> [...]
>>     
>
> Can you suggest an actual distribution & architecture where this
> facility may be tested/used? 

Debian unstable, x86-32 (I tested on Intel Core Duo).
Out of the box, no rebuild of glibc needed.

Here is a sample output:

# echo sched_switch >current_tracer
# echo userstacktrace >trace_options
# echo sym-userobj >trace_options
# echo 1>tracing_enabled
# cat trace_pipe >/tmp/test&
$ ~/a.out
# echo 0 >tracing_enabled

(You can also use other tracers besides sched_switch.)

           bash-6554  [000]   377.837014:   6554:120:S   + [001]  6216:120:S
            bash-6554  [000]   377.837015:  <b7f40424> <-
/lib/i686/cmov/libc-2.7.so[+0x6af77] <-
/lib/i686/cmov/libc-2.7.so[+0x6a81a] <-
/lib/i686/cmov/libc-2.7.so[+0x5e7e9] <- /bin/bash[+0x5f955] <-
/bin/bash[+0x2822a] <- /bin/bash[+0x2bf21] <- /bin/bash[+0x2a403]
....
a.out-7442  [000]   386.221719:   7442:120:R ==> [000]  1344:115:R
           a.out-7442  [000]   386.221720: /lib/ld-2.7.so[+0xbed09631]
<- /lib/ld-2.7.so[+0xbecd4f28] <- /lib/ld-2.7.so[+0xbece9c36] <-
/lib/ld-2.7.so[+0xbeca5603] <- /lib/ld-2.7.so[+0xbeca3403] <-
/lib/ld-2.7.so[+0xbeca1983] <- /lib/ld-2.7.so[+0xbec93fab] <-
/lib/ld-2.7.so[+0xbec93aa5]
a.out-7442  [000]   386.224544:   7442:120:R   + [000]     1:120:S
           a.out-7442  [000]   386.224545: /home/edwin/a.out[+0x377] <-
/home/edwin/a.out[+0x38f] <- /lib/i686/cmov/libc-2.7.so[+0x16455] <-
/home/edwin/a.out[+0x2e1]
           a.out-7442  [000]   386.224562:   7442:120:R ==> [000]    
1:120:R
...
           a.out-7442  [000]   386.224562: /home/edwin/a.out[+0x377] <-
/home/edwin/a.out[+0x38f] <- /lib/i686/cmov/libc-2.7.so[+0x16455] <-
/home/edwin/a.out[+0x2e1]
Xorg-5895  [001]   388.180034:   5895:120:R   + [001]  6214:120:S
            Xorg-5895  [001]   388.180035:  <b805f424> <-
/usr/bin/Xorg[+0x17addf] <- /usr/bin/Xorg[+0x1768cb] <-
/usr/bin/Xorg[+0x46e10] <- /usr/bin/Xorg[+0x2d795] <-
/lib/i686/cmov/libc-2.7.so[+0x16455] <- /usr/bin/Xorg[+0x2ca81]

If I run the little (and inefficient) perl script below I get:
            bash-6554  [000]   377.837015 
<b7f40424>/lib/i686/cmov/libc-2.7.so[+0x6af77] <-
/lib/i686/cmov/libc-2.7.so[+0x6a81a] <-
/lib/i686/cmov/libc-2.7.so[+0x5e7e9] <- /bin/bash[+0x5f955] <-
/bin/bash[+0x2822a] <- /bin/bash[+0x2bf21] <- /bin/bash[+0x2a403]
 <-            a.out-7442  [000]   386.221720
/lib/ld-2.7.so[+0xbed09631] <- /lib/ld-2.7.so[+0xbecd4f28] <-
/lib/ld-2.7.so[+0xbece9c36] <- /lib/ld-2.7.so[+0xbeca5603] <-
/lib/ld-2.7.so[+0xbeca3403] <- /lib/ld-2.7.so[+0xbeca1983] <-
/lib/ld-2.7.so[+0xbec93fab] <- /lib/ld-2.7.so[+0xbec93aa5]
 <-            a.out-7442  [000]   386.224545/home/edwin/ll.c:2 <-
/home/edwin/ll.c:9 <- /lib/i686/cmov/libc-2.7.so[+0x16455] <-
/home/edwin/a.out[+0x2e1]
<-            a.out-7442  [000]   386.224562/home/edwin/ll.c:2 <-
/home/edwin/ll.c:9 <- /lib/i686/cmov/libc-2.7.so[+0x16455] <-
/home/edwin/a.out[+0x2e1]
<-             Xorg-5895  [001]   388.180035 
<b805f424>/usr/bin/Xorg[+0x17addf] <- /usr/bin/Xorg[+0x1768cb] <-
/usr/bin/Xorg[+0x46e10] <- /usr/bin/Xorg[+0x2d795] <-
/lib/i686/cmov/libc-2.7.so[+0x16455] <- /usr/bin/Xorg[+0x2ca81]

If I use a glibc with debug symbols (by installing the distro package
libc6-dbg, and using LD_LIBRARY_PATH=/usr/lib/debug), I can even get
libc line numbers:

           a.out-18077 [001] 4154503532.435531:  18077:120:S ==>
[001]     0:140:R
           a.out-18077 [001] 4154503532.435532:
/usr/lib/debug/libc-2.7.so[+0x35424] <- /lib/ld-2.7.so[+0xbeca5186] <-
/lib/ld-2.7.so[+0xbeca3403] <- /lib/ld-2.7.so[+0xbeca1983] <-
/lib/ld-2.7.so[+0xbec93fab] <- /lib/ld-2.7.so[+0xbec93aa5] <- 
<49406455> <- /lib/ld-2.7.so[+0xbec91521]
           a.out-18077 [001] 4154503532.481759:  18077:120:R   + [001] 
6214:120:S
           a.out-18077 [001] 4154503532.481760:
/usr/lib/debug/libpthread-2.7.so[+0x72f5] <- /home/edwin/a.out[+0x456]
<- /home/edwin/a.out[+0x47a] <- /usr/lib/debug/libc-2.7.so[+0x16455] <-
/home/edwin/a.out[+0x3b1]

 a.out-18077 [001]
4154503532.435532/build/buildd/glibc-2.7/build-tree/glibc-2.7/stdlib/../stdlib/strtod_l.c:375
<- /lib/ld-2.7.so[+0xbeca5186] <- /lib/ld-2.7.so[+0xbeca3403] <-
/lib/ld-2.7.so[+0xbeca1983] <- /lib/ld-2.7.so[+0xbec93fab] <-
/lib/ld-2.7.so[+0xbec93aa5] <-  <49406455>/lib/ld-2.7.so[+0xbec91521]
 <-            a.out-18077 [001]
4154503532.481760/build/buildd/glibc-2.7/build-tree/glibc-2.7/nptl/pthread_mutex_lock.c:87
<- /home/edwin/ll.c:7 <- /home/edwin/ll.c:14 <-
/build/buildd/glibc-2.7/build-tree/glibc-2.7/csu/libc-start.c:254 <-
/home/edwin/a.out[+0x3b1]


>  It appears to require frame-pointer
> stuff that AFAIK is not generally turned on for user-space.

It is not turned on for glibc on x86_64, but even there you can at least
get the return address to user-space
(which in case of a system call is not very useful since it is inside
libc, but could be useful for pagefault tracing for example).

#!/usr/bin/perl
my %cache;
while (<>) {
        next unless / <- /;
        my @list = split(/:| <- /);
        foreach my $entry (@list) {
                if ($entry =~ /(\/[^[]+)\[\+0x([a-f0-9]+)\]/) {
                        if (defined $cache{$entry}) {
                                print $cache{$entry};
                        } else {
                                my $file = $1;
                                my $addr = hex $2;
                                if (not ($file =~ /.so/)) {
                                        $addr = 0x8048000 + $addr;
                                }
                                $addr = sprintf "0x%x", $addr;
                                $res = `addr2line -e $file $addr`;
                                $res =~ s/\n//;
                                if ($res =~ /\?\?/) {
                                        $res = $entry;
                                }
                                $cache{$entry} = $res;
                                print $res;
                        }
                        print " <- "
                } else {
                        print $entry;
                }
        }
}

Best regards,
--Edwin
