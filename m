Return-Path: <linux-kernel-owner+w=401wt.eu-S1758355AbYGQOgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758355AbYGQOgq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 10:36:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755640AbYGQOgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 10:36:37 -0400
Received: from p01c12o141.mxlogic.net ([208.65.145.64]:45215 "EHLO
	p01c12o141.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471AbYGQOgg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 10:36:36 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: why doesn't /proc/self/maps mtime change when memory's allocated?
Date: Thu, 17 Jul 2008 15:36:33 +0100
Message-ID: <0F10A59FDFFDFD4E9BEBD7365DE6725502007EFA@uk-email.terastack.bluearc.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: why doesn't /proc/self/maps mtime change when memory's allocated?
Thread-Index: AcjoGoKAoiDi7NPdQ7KoiGnqAhezDg==
From: "Andy Chittenden" <andyc@bluearc.com>
To: <linux-kernel@vger.kernel.org>
X-Spam: [F=0.1000000000; S=0.100(2008062001)]
X-MAIL-FROM: <andyc@bluearc.com>
X-SOURCE-IP: [62.190.48.218]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a ruby script that when run on 2.6.25 demonstrates that although
the contents of /proc/self/maps changes, its mtime doesn't.

--- start ruby script ---
#!/usr/bin/ruby -w

mapfile = "/proc/self/maps"

oldmtime = File.stat(mapfile).mtime
oldmaps = File.read(mapfile)

arr = Array.new()

for k in 1...10*1024*1024
    arr.push(k)
end

newmaps = File.read(mapfile)
newmtime = File.stat(mapfile).mtime

if (oldmaps != newmaps)
    if (oldmtime == newmtime)
        puts("oldmaps mtime = #{oldmtime}")
        puts(oldmaps)
        puts("newmaps mtime = #{newmtime}")
        puts(newmaps)
    end
end
--- end ruby script ---

When I run it, I get this output (the lines with the word [heap] against
them are different (along with others)):

# ./checkmaps.rb 
oldmaps mtime = Thu Jul 17 15:32:53 +0100 2008
00400000-00401000 r-xp 00000000 08:01 832446
/usr/bin/ruby1.8
00600000-00601000 rw-p 00000000 08:01 832446
/usr/bin/ruby1.8
00694000-006f7000 rw-p 00694000 00:00 0
[heap]
7f7f64de9000-7f7f64f33000 r-xp 00000000 08:01 57195
/lib/libc-2.7.so
7f7f64f33000-7f7f65133000 ---p 0014a000 08:01 57195
/lib/libc-2.7.so
7f7f65133000-7f7f65136000 r--p 0014a000 08:01 57195
/lib/libc-2.7.so
7f7f65136000-7f7f65138000 rw-p 0014d000 08:01 57195
/lib/libc-2.7.so
7f7f65138000-7f7f6513d000 rw-p 7f7f65138000 00:00 0 
7f7f6513d000-7f7f651bf000 r-xp 00000000 08:01 57184
/lib/libm-2.7.so
7f7f651bf000-7f7f653be000 ---p 00082000 08:01 57184
/lib/libm-2.7.so
7f7f653be000-7f7f653c0000 rw-p 00081000 08:01 57184
/lib/libm-2.7.so
7f7f653c0000-7f7f653c8000 r-xp 00000000 08:01 57196
/lib/libcrypt-2.7.so
7f7f653c8000-7f7f655c8000 ---p 00008000 08:01 57196
/lib/libcrypt-2.7.so
7f7f655c8000-7f7f655ca000 rw-p 00008000 08:01 57196
/lib/libcrypt-2.7.so
7f7f655ca000-7f7f655f8000 rw-p 7f7f655ca000 00:00 0 
7f7f655f8000-7f7f655fa000 r-xp 00000000 08:01 57197
/lib/libdl-2.7.so
7f7f655fa000-7f7f657fa000 ---p 00002000 08:01 57197
/lib/libdl-2.7.so
7f7f657fa000-7f7f657fc000 rw-p 00002000 08:01 57197
/lib/libdl-2.7.so
7f7f657fc000-7f7f65812000 r-xp 00000000 08:01 57199
/lib/libpthread-2.7.so
7f7f65812000-7f7f65a12000 ---p 00016000 08:01 57199
/lib/libpthread-2.7.so
7f7f65a12000-7f7f65a14000 rw-p 00016000 08:01 57199
/lib/libpthread-2.7.so
7f7f65a14000-7f7f65a18000 rw-p 7f7f65a14000 00:00 0 
7f7f65a18000-7f7f65afa000 r-xp 00000000 08:01 831874
/usr/lib/libruby1.8.so.1.8.7
7f7f65afa000-7f7f65cfa000 ---p 000e2000 08:01 831874
/usr/lib/libruby1.8.so.1.8.7
7f7f65cfa000-7f7f65cfe000 rw-p 000e2000 08:01 831874
/usr/lib/libruby1.8.so.1.8.7
7f7f65cfe000-7f7f65d1c000 rw-p 7f7f65cfe000 00:00 0 
7f7f65d1c000-7f7f65d38000 r-xp 00000000 08:01 57191
/lib/ld-2.7.so
7f7f65eb6000-7f7f65f1c000 rw-p 7f7f65eb6000 00:00 0 
7f7f65f33000-7f7f65f37000 rw-p 7f7f65f33000 00:00 0 
7f7f65f37000-7f7f65f39000 rw-p 0001b000 08:01 57191
/lib/ld-2.7.so
7fff6df23000-7fff6df39000 rw-p 7ffffffe9000 00:00 0
[stack]
7fff6dffe000-7fff6e000000 r-xp 7fff6dffe000 00:00 0
[vdso]
ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0
[vsyscall]
newmaps mtime = Thu Jul 17 15:32:53 +0100 2008
00400000-00401000 r-xp 00000000 08:01 832446
/usr/bin/ruby1.8
00600000-00601000 rw-p 00000000 08:01 832446
/usr/bin/ruby1.8
00694000-00714000 rw-p 00694000 00:00 0
[heap]
7f7f590e7000-7f7f5fa09000 rw-p 7f7f65e8d000 00:00 0 
7f7f64de9000-7f7f64f33000 r-xp 00000000 08:01 57195
/lib/libc-2.7.so
7f7f64f33000-7f7f65133000 ---p 0014a000 08:01 57195
/lib/libc-2.7.so
7f7f65133000-7f7f65136000 r--p 0014a000 08:01 57195
/lib/libc-2.7.so
7f7f65136000-7f7f65138000 rw-p 0014d000 08:01 57195
/lib/libc-2.7.so
7f7f65138000-7f7f6513d000 rw-p 7f7f65138000 00:00 0 
7f7f6513d000-7f7f651bf000 r-xp 00000000 08:01 57184
/lib/libm-2.7.so
7f7f651bf000-7f7f653be000 ---p 00082000 08:01 57184
/lib/libm-2.7.so
7f7f653be000-7f7f653c0000 rw-p 00081000 08:01 57184
/lib/libm-2.7.so
7f7f653c0000-7f7f653c8000 r-xp 00000000 08:01 57196
/lib/libcrypt-2.7.so
7f7f653c8000-7f7f655c8000 ---p 00008000 08:01 57196
/lib/libcrypt-2.7.so
7f7f655c8000-7f7f655ca000 rw-p 00008000 08:01 57196
/lib/libcrypt-2.7.so
7f7f655ca000-7f7f655f8000 rw-p 7f7f655ca000 00:00 0 
7f7f655f8000-7f7f655fa000 r-xp 00000000 08:01 57197
/lib/libdl-2.7.so
7f7f655fa000-7f7f657fa000 ---p 00002000 08:01 57197
/lib/libdl-2.7.so
7f7f657fa000-7f7f657fc000 rw-p 00002000 08:01 57197
/lib/libdl-2.7.so
7f7f657fc000-7f7f65812000 r-xp 00000000 08:01 57199
/lib/libpthread-2.7.so
7f7f65812000-7f7f65a12000 ---p 00016000 08:01 57199
/lib/libpthread-2.7.so
7f7f65a12000-7f7f65a14000 rw-p 00016000 08:01 57199
/lib/libpthread-2.7.so
7f7f65a14000-7f7f65a18000 rw-p 7f7f65a14000 00:00 0 
7f7f65a18000-7f7f65afa000 r-xp 00000000 08:01 831874
/usr/lib/libruby1.8.so.1.8.7
7f7f65afa000-7f7f65cfa000 ---p 000e2000 08:01 831874
/usr/lib/libruby1.8.so.1.8.7
7f7f65cfa000-7f7f65cfe000 rw-p 000e2000 08:01 831874
/usr/lib/libruby1.8.so.1.8.7
7f7f65cfe000-7f7f65d1c000 rw-p 7f7f65cfe000 00:00 0 
7f7f65d1c000-7f7f65d38000 r-xp 00000000 08:01 57191
/lib/ld-2.7.so
7f7f65eb6000-7f7f65f1c000 rw-p 7f7f65eb6000 00:00 0 
7f7f65f33000-7f7f65f37000 rw-p 7f7f65f33000 00:00 0 
7f7f65f37000-7f7f65f39000 rw-p 0001b000 08:01 57191
/lib/ld-2.7.so
7fff6df23000-7fff6df39000 rw-p 7ffffffe9000 00:00 0
[stack]
7fff6dffe000-7fff6e000000 r-xp 7fff6dffe000 00:00 0
[vdso]
ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0
[vsyscall]

-- 
Andy, BlueArc Engineering


