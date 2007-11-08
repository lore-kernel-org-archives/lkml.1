Return-Path: <linux-kernel-owner+w=401wt.eu-S1758524AbXKHHp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758524AbXKHHp2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 02:45:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751012AbXKHHpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 02:45:15 -0500
Received: from [212.12.190.107] ([212.12.190.107]:40629 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750754AbXKHHpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 02:45:12 -0500
From: Al Boldi <a1426z@gawab.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Massive slowdown when re-querying large nfs dir
Date: Thu, 8 Nov 2007 10:44:35 +0300
User-Agent: KMail/1.5
Cc: neilb@suse.de, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200711050758.38090.a1426z@gawab.com> <200711071236.26780.a1426z@gawab.com> <20071107090529.f45626de.akpm@linux-foundation.org>
In-Reply-To: <20071107090529.f45626de.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711081044.35699.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> > > I would suggest getting a 'tcpdump -s0' trace and seeing (with
> > > wireshark) what is different between the various cases.
> >
> > Thanks Neil for looking into this.  Your suggestion has already been
> > answered in a previous post, where the difference has been attributed to
> > "ls -l" inducing lookup for the first try, which is fast, and getattr
> > for later tries, which is super-slow.
> >
> > Now it's easy to blame the userland rpc.nfs.V2 server for this, but
> > what's not clear is how come 2.4.31 handles getattr faster than 2.6.23?
>
> We broke 2.6?  It'd be interesting to run the ls in an infinite loop on
> the client them start poking at the server.  Is the 2.6 server doing
> physical IO?  Is the 2.6 server consuming more system time?  etc.  A basic
> `vmstat 1' trace for both 2.4 and 2.6 would be a starting point.
>
> Could be that there's some additional latency caused by networking
> changes, too.  I expect the tcpdump/wireshark/etc traces would have
> sufficient resolution for us to be able to see that.

The problem turns out to be "tune2fs -O dir_index".
Removing that feature resolves the big slowdown.

Does 2.4.31 support this feature?

Neil Brown wrote:
> Maybe an "strace -tt" of the nfs server might show some significant
> difference.

###############################################################################
# ls -l <3K dir entry> (first try after mount inducing lookup) in ~3sec
# strace -tt rpc.nfsd

08:28:14.668557 time([1194499694])      = 1194499694
08:28:14.669420 alarm(5)                = 2
08:28:14.669667 select(1024, [4 5], NULL, NULL, NULL) = 1 (in [4])
08:28:14.670142 recvfrom(4, "\275\3607{\0\0\0\0\0\0\0\2\0\1\206\243\0\0\0\2\0\0\0\4"..., 8800, 0, {sa_family=AF_INET, sin_port=htons(888), sin_addr=inet_addr("10.0.0.111")}, [16]) = 116
08:28:14.670554 time(NULL)              = 1194499694
08:28:14.670711 time([1194499694])      = 1194499694
08:28:14.670875 lstat("/a/x", {st_mode=S_IFDIR|0755, st_size=36864, ...}) = 0
08:28:14.671134 time([1194499694])      = 1194499694
08:28:14.671302 lstat("/a/x/3619", {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
08:28:14.671530 time([1194499694])      = 1194499694
08:28:14.671701 alarm(2)                = 5
08:28:14.671903 time([1194499694])      = 1194499694
08:28:14.672060 lstat("/a/x/3619", {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
08:28:14.672305 time([1194499694])      = 1194499694
08:28:14.672508 sendto(4, "\275\3607{\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 128, 0, {sa_family=AF_INET, sin_port=htons(888), sin_addr=inet_addr("10.0.0.111")}, 16) = 128
08:28:14.672909 time([1194499694])      = 1194499694
08:28:14.673869 alarm(5)                = 2
08:28:14.674145 select(1024, [4 5], NULL, NULL, NULL) = 1 (in [4])
08:28:14.674589 recvfrom(4, "\276\3607{\0\0\0\0\0\0\0\2\0\1\206\243\0\0\0\2\0\0\0\4"..., 8800, 0, {sa_family=AF_INET, sin_port=htons(888), sin_addr=inet_addr("10.0.0.111")}, [16]) = 116
08:28:14.675003 time(NULL)              = 1194499694
08:28:14.675160 time([1194499694])      = 1194499694
08:28:14.675321 lstat("/a/x", {st_mode=S_IFDIR|0755, st_size=36864, ...}) = 0
08:28:14.675581 time([1194499694])      = 1194499694
08:28:14.675749 lstat("/a/x/3631", {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
08:28:14.675979 time([1194499694])      = 1194499694
08:28:14.676150 alarm(2)                = 5
08:28:14.676348 time([1194499694])      = 1194499694
08:28:14.676505 lstat("/a/x/3631", {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
08:28:14.676746 time([1194499694])      = 1194499694
08:28:14.676952 sendto(4, "\276\3607{\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 128, 0, {sa_family=AF_INET, sin_port=htons(888), sin_addr=inet_addr("10.0.0.111")}, 16) = 128

##############################################################################
# ls -l <3K dir entry> (second try after mount inducing getattr) in ~11sec
# strace -tt rpc.nfsd

08:28:40.963668 time([1194499720])      = 1194499720
08:28:40.964525 alarm(5)                = 2
08:28:40.964772 select(1024, [4 5], NULL, NULL, NULL) = 1 (in [4])
08:28:40.965215 recvfrom(4, ",\3747{\0\0\0\0\0\0\0\2\0\1\206\243\0\0\0\2\0\0\0\1\0\0"..., 8800, 0, {sa_family=AF_INET, sin_port=htons(888), sin_addr=inet_addr("10.0.0.111")}, [16]) = 108
08:28:40.965609 time(NULL)              = 1194499720
08:28:40.965763 time([1194499720])      = 1194499720
08:28:40.965941 stat("/", {st_mode=S_IFDIR|0755, st_size=2048, ...}) = 0
08:28:40.966176 setfsuid(0)             = 0
08:28:40.966329 stat("/", {st_mode=S_IFDIR|0755, st_size=2048, ...}) = 0
08:28:40.966539 stat("/", {st_mode=S_IFDIR|0755, st_size=2048, ...}) = 0
08:28:40.966748 open("/", O_RDONLY|O_NONBLOCK) = 0
08:28:40.966919 fcntl(0, F_SETFD, FD_CLOEXEC) = 0
08:28:40.967084 lseek(0, 0, SEEK_CUR)   = 0
08:28:40.967240 getdents(0, /* 71 entries */, 3933) = 1220
08:28:40.968195 close(0)                = 0
08:28:40.968351 stat("/a/", {st_mode=S_IFDIR|0755, st_size=1024, ...}) = 0
08:28:40.968583 stat("/a/", {st_mode=S_IFDIR|0755, st_size=1024, ...}) = 0
08:28:40.968800 open("/a/", O_RDONLY|O_NONBLOCK) = 0
08:28:40.968969 fcntl(0, F_SETFD, FD_CLOEXEC) = 0
08:28:40.969129 lseek(0, 0, SEEK_CUR)   = 0
08:28:40.969283 getdents(0, /* 3 entries */, 3933) = 40
08:28:40.969497 close(0)                = 0
08:28:40.969646 stat("/a/x/", {st_mode=S_IFDIR|0755, st_size=36864, ...}) = 0
08:28:40.969870 stat("/a/x/", {st_mode=S_IFDIR|0755, st_size=36864, ...}) = 0
08:28:40.970155 open("/a/x/", O_RDONLY|O_NONBLOCK) = 0
08:28:40.970332 fcntl(0, F_SETFD, FD_CLOEXEC) = 0
08:28:40.970493 lseek(0, 0, SEEK_CUR)   = 0
08:28:40.970647 getdents(0, /* 85 entries */, 3933) = 1356
08:28:40.971701 close(0)                = 0
08:28:40.971858 setfsuid(0)             = 0
08:28:40.972007 lstat("/a/x/1795", {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
08:28:40.972249 alarm(2)                = 5
08:28:40.972419 lstat("/a/x/1795", {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
08:28:40.972695 sendto(4, ",\3747{\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 96, 0, {sa_family=AF_INET, sin_port=htons(888), sin_addr=inet_addr("10.0.0.111")}, 16) = 96
08:28:40.973182 time([1194499720])      = 1194499720
08:28:40.974084 alarm(5)                = 2
08:28:40.974356 select(1024, [4 5], NULL, NULL, NULL) = 1 (in [4])
08:28:40.974800 recvfrom(4, "-\3747{\0\0\0\0\0\0\0\2\0\1\206\243\0\0\0\2\0\0\0\1\0\0"..., 8800, 0, {sa_family=AF_INET, sin_port=htons(888), sin_addr=inet_addr("10.0.0.111")}, [16]) = 108
08:28:40.975194 time(NULL)              = 1194499720
08:28:40.975352 time([1194499720])      = 1194499720
08:28:40.975530 stat("/", {st_mode=S_IFDIR|0755, st_size=2048, ...}) = 0
08:28:40.975770 setfsuid(0)             = 0
08:28:40.975922 stat("/", {st_mode=S_IFDIR|0755, st_size=2048, ...}) = 0
08:28:40.976135 stat("/", {st_mode=S_IFDIR|0755, st_size=2048, ...}) = 0
08:28:40.976348 open("/", O_RDONLY|O_NONBLOCK) = 0
08:28:40.976524 fcntl(0, F_SETFD, FD_CLOEXEC) = 0
08:28:40.976694 lseek(0, 0, SEEK_CUR)   = 0
08:28:40.976851 getdents(0, /* 71 entries */, 3933) = 1220
08:28:40.977784 close(0)                = 0
08:28:40.977937 stat("/a/", {st_mode=S_IFDIR|0755, st_size=1024, ...}) = 0
08:28:40.978159 stat("/a/", {st_mode=S_IFDIR|0755, st_size=1024, ...}) = 0
08:28:40.978371 open("/a/", O_RDONLY|O_NONBLOCK) = 0
08:28:40.978535 fcntl(0, F_SETFD, FD_CLOEXEC) = 0
08:28:40.978773 lseek(0, 0, SEEK_CUR)   = 0
08:28:40.978934 getdents(0, /* 3 entries */, 3933) = 40
08:28:40.979144 close(0)                = 0
08:28:40.979296 stat("/a/x/", {st_mode=S_IFDIR|0755, st_size=36864, ...}) = 0
08:28:40.979534 stat("/a/x/", {st_mode=S_IFDIR|0755, st_size=36864, ...}) = 0
08:28:40.979754 open("/a/x/", O_RDONLY|O_NONBLOCK) = 0
08:28:40.979927 fcntl(0, F_SETFD, FD_CLOEXEC) = 0
08:28:40.980129 lseek(0, 0, SEEK_CUR)   = 0
08:28:40.980284 getdents(0, /* 85 entries */, 3933) = 1356
08:28:40.981324 close(0)                = 0
08:28:40.981482 setfsuid(0)             = 0
08:28:40.981631 lstat("/a/x/1803", {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
08:28:40.981874 alarm(2)                = 5
08:28:40.982046 lstat("/a/x/1803", {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
08:28:40.982325 sendto(4, "-\3747{\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 96, 0, {sa_family=AF_INET, sin_port=htons(888), sin_addr=inet_addr("10.0.0.111")}, 16) = 96
08:28:40.982727 time([1194499720])      = 1194499720
08:28:40.983701 alarm(5)                = 2
08:28:40.983972 select(1024, [4 5], NULL, NULL, NULL) = 1 (in [4])
08:28:40.984418 recvfrom(4, ".\3747{\0\0\0\0\0\0\0\2\0\1\206\243\0\0\0\2\0\0\0\1\0\0"..., 8800, 0, {sa_family=AF_INET, sin_port=htons(888), sin_addr=inet_addr("10.0.0.111")}, [16]) = 108
08:28:40.984809 time(NULL)              = 1194499720
08:28:40.984961 time([1194499720])      = 1194499720
08:28:40.985137 stat("/", {st_mode=S_IFDIR|0755, st_size=2048, ...}) = 0
08:28:40.985373 setfsuid(0)             = 0
08:28:40.985523 stat("/", {st_mode=S_IFDIR|0755, st_size=2048, ...}) = 0
08:28:40.985736 stat("/", {st_mode=S_IFDIR|0755, st_size=2048, ...}) = 0
08:28:40.985948 open("/", O_RDONLY|O_NONBLOCK) = 0
08:28:40.986124 fcntl(0, F_SETFD, FD_CLOEXEC) = 0
08:28:40.986290 lseek(0, 0, SEEK_CUR)   = 0
08:28:40.986446 getdents(0, /* 71 entries */, 3933) = 1220
08:28:40.987401 close(0)                = 0
08:28:40.987557 stat("/a/", {st_mode=S_IFDIR|0755, st_size=1024, ...}) = 0
08:28:40.987783 stat("/a/", {st_mode=S_IFDIR|0755, st_size=1024, ...}) = 0
08:28:40.987997 open("/a/", O_RDONLY|O_NONBLOCK) = 0
08:28:40.988163 fcntl(0, F_SETFD, FD_CLOEXEC) = 0
08:28:40.988321 lseek(0, 0, SEEK_CUR)   = 0
08:28:40.988475 getdents(0, /* 3 entries */, 3933) = 40
08:28:40.988691 close(0)                = 0
08:28:40.988845 stat("/a/x/", {st_mode=S_IFDIR|0755, st_size=36864, ...}) = 0
08:28:40.989074 stat("/a/x/", {st_mode=S_IFDIR|0755, st_size=36864, ...}) = 0
08:28:40.989297 open("/a/x/", O_RDONLY|O_NONBLOCK) = 0
08:28:40.989471 fcntl(0, F_SETFD, FD_CLOEXEC) = 0
08:28:40.989627 lseek(0, 0, SEEK_CUR)   = 0
08:28:40.989779 getdents(0, /* 85 entries */, 3933) = 1356
08:28:40.990926 close(0)                = 0
08:28:40.991087 setfsuid(0)             = 0
08:28:40.991236 lstat("/a/x/1815", {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
08:28:40.991486 alarm(2)                = 5
08:28:40.991660 lstat("/a/x/1815", {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
08:28:40.991936 sendto(4, ".\3747{\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 96, 0, {sa_family=AF_INET, sin_port=htons(888), sin_addr=inet_addr("10.0.0.111")}, 16) = 96

======= big snip =========

08:29:55.811644 time([1194499795])      = 1194499795
08:29:55.812622 alarm(5)                = 2
08:29:55.812891 select(1024, [4 5], NULL, NULL, NULL) = 1 (in [4])
08:29:55.813318 recvfrom(4, "v\0068{\0\0\0\0\0\0\0\2\0\1\206\243\0\0\0\2\0\0\0\1\0\0"..., 8800, 0, {sa_family=AF_INET, sin_port=htons(888), sin_addr=inet_addr("10.0.0.111")}, [16]) = 108
08:29:55.813701 time(NULL)              = 1194499795
08:29:55.813850 time([1194499795])      = 1194499795
08:29:55.814021 stat("/", {st_mode=S_IFDIR|0755, st_size=2048, ...}) = 0
08:29:55.814250 setfsuid(0)             = 0
08:29:55.814395 stat("/", {st_mode=S_IFDIR|0755, st_size=2048, ...}) = 0
08:29:55.814606 stat("/", {st_mode=S_IFDIR|0755, st_size=2048, ...}) = 0
08:29:55.814815 open("/", O_RDONLY|O_NONBLOCK) = 0
08:29:55.814986 fcntl(0, F_SETFD, FD_CLOEXEC) = 0
08:29:55.815153 lseek(0, 0, SEEK_CUR)   = 0
08:29:55.815308 getdents(0, /* 71 entries */, 3933) = 1220
08:29:55.816245 close(0)                = 0
08:29:55.816409 stat("/a/", {st_mode=S_IFDIR|0755, st_size=1024, ...}) = 0
08:29:55.816637 stat("/a/", {st_mode=S_IFDIR|0755, st_size=1024, ...}) = 0
08:29:55.816854 open("/a/", O_RDONLY|O_NONBLOCK) = 0
08:29:55.817019 fcntl(0, F_SETFD, FD_CLOEXEC) = 0
08:29:55.817177 lseek(0, 0, SEEK_CUR)   = 0
08:29:55.817329 getdents(0, /* 3 entries */, 3933) = 40
08:29:55.817542 close(0)                = 0
08:29:55.817694 stat("/a/x/", {st_mode=S_IFDIR|0755, st_size=36864, ...}) = 0
08:29:55.817921 stat("/a/x/", {st_mode=S_IFDIR|0755, st_size=36864, ...}) = 0
08:29:55.818140 open("/a/x/", O_RDONLY|O_NONBLOCK) = 0
08:29:55.818312 fcntl(0, F_SETFD, FD_CLOEXEC) = 0
08:29:55.818472 lseek(0, 0, SEEK_CUR)   = 0
08:29:55.818627 getdents(0, /* 85 entries */, 3933) = 1356
08:29:55.819685 lseek(0, 0, SEEK_CUR)   = 1024
08:29:55.819843 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.820933 lseek(0, 0, SEEK_CUR)   = 2048
08:29:55.821088 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.822134 lseek(0, 0, SEEK_CUR)   = 3072
08:29:55.822289 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.823320 lseek(0, 0, SEEK_CUR)   = 4096
08:29:55.823477 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.824509 lseek(0, 0, SEEK_CUR)   = 5120
08:29:55.824664 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.825694 lseek(0, 0, SEEK_CUR)   = 6144
08:29:55.825847 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.826879 lseek(0, 0, SEEK_CUR)   = 7168
08:29:55.827030 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.828054 lseek(0, 0, SEEK_CUR)   = 8192
08:29:55.828205 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.829228 lseek(0, 0, SEEK_CUR)   = 9216
08:29:55.829380 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.830439 lseek(0, 0, SEEK_CUR)   = 10240
08:29:55.830593 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.831627 lseek(0, 0, SEEK_CUR)   = 11264
08:29:55.831784 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.832816 lseek(0, 0, SEEK_CUR)   = 12288
08:29:55.832970 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.834017 lseek(0, 0, SEEK_CUR)   = 13312
08:29:55.834172 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.835209 lseek(0, 0, SEEK_CUR)   = 14336
08:29:55.835366 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.836403 lseek(0, 0, SEEK_CUR)   = 15360
08:29:55.836556 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.837607 lseek(0, 0, SEEK_CUR)   = 16384
08:29:55.837763 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.838797 lseek(0, 0, SEEK_CUR)   = 17408
08:29:55.838953 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.839991 lseek(0, 0, SEEK_CUR)   = 18432
08:29:55.840283 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.841338 lseek(0, 0, SEEK_CUR)   = 19456
08:29:55.841490 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.842533 lseek(0, 0, SEEK_CUR)   = 20480
08:29:55.842683 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.843729 lseek(0, 0, SEEK_CUR)   = 21504
08:29:55.843884 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.844937 lseek(0, 0, SEEK_CUR)   = 22528
08:29:55.845092 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.846147 lseek(0, 0, SEEK_CUR)   = 23552
08:29:55.846300 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.847352 lseek(0, 0, SEEK_CUR)   = 24576
08:29:55.847504 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.848558 lseek(0, 0, SEEK_CUR)   = 25600
08:29:55.848711 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.849765 lseek(0, 0, SEEK_CUR)   = 26624
08:29:55.849918 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.851010 lseek(0, 0, SEEK_CUR)   = 27648
08:29:55.851169 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.852220 lseek(0, 0, SEEK_CUR)   = 28672
08:29:55.852374 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.853424 lseek(0, 0, SEEK_CUR)   = 29696
08:29:55.853578 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.854628 lseek(0, 0, SEEK_CUR)   = 30720
08:29:55.854782 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.855824 lseek(0, 0, SEEK_CUR)   = 31744
08:29:55.855977 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.857011 close(0)                = 0
08:29:55.857164 setfsuid(0)             = 0
08:29:55.857316 lstat("/a/x/2404", {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
08:29:55.857575 alarm(2)                = 5
08:29:55.857750 lstat("/a/x/2404", {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
08:29:55.858033 sendto(4, "v\0068{\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 96, 0, {sa_family=AF_INET, sin_port=htons(888), sin_addr=inet_addr("10.0.0.111")}, 16) = 96
08:29:55.858527 time([1194499795])      = 1194499795
08:29:55.859426 alarm(5)                = 2
08:29:55.859700 select(1024, [4 5], NULL, NULL, NULL) = 1 (in [4])
08:29:55.860195 recvfrom(4, "w\0068{\0\0\0\0\0\0\0\2\0\1\206\243\0\0\0\2\0\0\0\1\0\0"..., 8800, 0, {sa_family=AF_INET, sin_port=htons(888), sin_addr=inet_addr("10.0.0.111")}, [16]) = 108
08:29:55.860598 time(NULL)              = 1194499795
08:29:55.860750 time([1194499795])      = 1194499795
08:29:55.860934 stat("/", {st_mode=S_IFDIR|0755, st_size=2048, ...}) = 0
08:29:55.861172 setfsuid(0)             = 0
08:29:55.861320 stat("/", {st_mode=S_IFDIR|0755, st_size=2048, ...}) = 0
08:29:55.861533 stat("/", {st_mode=S_IFDIR|0755, st_size=2048, ...}) = 0
08:29:55.861744 open("/", O_RDONLY|O_NONBLOCK) = 0
08:29:55.861917 fcntl(0, F_SETFD, FD_CLOEXEC) = 0
08:29:55.862089 lseek(0, 0, SEEK_CUR)   = 0
08:29:55.862245 getdents(0, /* 71 entries */, 3933) = 1220
08:29:55.863201 close(0)                = 0
08:29:55.863366 stat("/a/", {st_mode=S_IFDIR|0755, st_size=1024, ...}) = 0
08:29:55.863599 stat("/a/", {st_mode=S_IFDIR|0755, st_size=1024, ...}) = 0
08:29:55.863815 open("/a/", O_RDONLY|O_NONBLOCK) = 0
08:29:55.863983 fcntl(0, F_SETFD, FD_CLOEXEC) = 0
08:29:55.864146 lseek(0, 0, SEEK_CUR)   = 0
08:29:55.864300 getdents(0, /* 3 entries */, 3933) = 40
08:29:55.864519 close(0)                = 0
08:29:55.864673 stat("/a/x/", {st_mode=S_IFDIR|0755, st_size=36864, ...}) = 0
08:29:55.864903 stat("/a/x/", {st_mode=S_IFDIR|0755, st_size=36864, ...}) = 0
08:29:55.865125 open("/a/x/", O_RDONLY|O_NONBLOCK) = 0
08:29:55.865298 fcntl(0, F_SETFD, FD_CLOEXEC) = 0
08:29:55.865456 lseek(0, 0, SEEK_CUR)   = 0
08:29:55.865608 getdents(0, /* 85 entries */, 3933) = 1356
08:29:55.866666 lseek(0, 0, SEEK_CUR)   = 1024
08:29:55.866825 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.867874 lseek(0, 0, SEEK_CUR)   = 2048
08:29:55.868028 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.869072 lseek(0, 0, SEEK_CUR)   = 3072
08:29:55.869228 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.870304 lseek(0, 0, SEEK_CUR)   = 4096
08:29:55.870460 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.871596 lseek(0, 0, SEEK_CUR)   = 5120
08:29:55.871764 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.872820 lseek(0, 0, SEEK_CUR)   = 6144
08:29:55.872974 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.874011 lseek(0, 0, SEEK_CUR)   = 7168
08:29:55.874162 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.875193 lseek(0, 0, SEEK_CUR)   = 8192
08:29:55.875349 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.876381 lseek(0, 0, SEEK_CUR)   = 9216
08:29:55.876532 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.877582 lseek(0, 0, SEEK_CUR)   = 10240
08:29:55.877734 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.878780 lseek(0, 0, SEEK_CUR)   = 11264
08:29:55.878937 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.879972 lseek(0, 0, SEEK_CUR)   = 12288
08:29:55.880302 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.881367 lseek(0, 0, SEEK_CUR)   = 13312
08:29:55.881523 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.882561 lseek(0, 0, SEEK_CUR)   = 14336
08:29:55.882718 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.883757 lseek(0, 0, SEEK_CUR)   = 15360
08:29:55.883910 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.884958 lseek(0, 0, SEEK_CUR)   = 16384
08:29:55.885109 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.886137 lseek(0, 0, SEEK_CUR)   = 17408
08:29:55.886291 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.887343 lseek(0, 0, SEEK_CUR)   = 18432
08:29:55.887498 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.888531 lseek(0, 0, SEEK_CUR)   = 19456
08:29:55.888689 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.889743 lseek(0, 0, SEEK_CUR)   = 20480
08:29:55.889897 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.890967 lseek(0, 0, SEEK_CUR)   = 21504
08:29:55.891123 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.892160 lseek(0, 0, SEEK_CUR)   = 22528
08:29:55.892316 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.893355 lseek(0, 0, SEEK_CUR)   = 23552
08:29:55.893508 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.894544 lseek(0, 0, SEEK_CUR)   = 24576
08:29:55.894699 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.895732 lseek(0, 0, SEEK_CUR)   = 25600
08:29:55.895883 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.896921 lseek(0, 0, SEEK_CUR)   = 26624
08:29:55.897076 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.898110 lseek(0, 0, SEEK_CUR)   = 27648
08:29:55.898265 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.899310 lseek(0, 0, SEEK_CUR)   = 28672
08:29:55.899459 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.900529 lseek(0, 0, SEEK_CUR)   = 29696
08:29:55.900682 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.901734 lseek(0, 0, SEEK_CUR)   = 30720
08:29:55.901889 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.902936 lseek(0, 0, SEEK_CUR)   = 31744
08:29:55.903091 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.904139 close(0)                = 0
08:29:55.904295 setfsuid(0)             = 0
08:29:55.904445 lstat("/a/x/2747", {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
08:29:55.904704 alarm(2)                = 5
08:29:55.904883 lstat("/a/x/2747", {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
08:29:55.905166 sendto(4, "w\0068{\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 96, 0, {sa_family=AF_INET, sin_port=htons(888), sin_addr=inet_addr("10.0.0.111")}, 16) = 96
08:29:55.905586 time([1194499795])      = 1194499795
08:29:55.906565 alarm(5)                = 2
08:29:55.906839 select(1024, [4 5], NULL, NULL, NULL) = 1 (in [4])
08:29:55.907285 recvfrom(4, "x\0068{\0\0\0\0\0\0\0\2\0\1\206\243\0\0\0\2\0\0\0\1\0\0"..., 8800, 0, {sa_family=AF_INET, sin_port=htons(888), sin_addr=inet_addr("10.0.0.111")}, [16]) = 108
08:29:55.907683 time(NULL)              = 1194499795
08:29:55.907840 time([1194499795])      = 1194499795
08:29:55.908021 stat("/", {st_mode=S_IFDIR|0755, st_size=2048, ...}) = 0
08:29:55.908260 setfsuid(0)             = 0
08:29:55.908412 stat("/", {st_mode=S_IFDIR|0755, st_size=2048, ...}) = 0
08:29:55.908625 stat("/", {st_mode=S_IFDIR|0755, st_size=2048, ...}) = 0
08:29:55.908834 open("/", O_RDONLY|O_NONBLOCK) = 0
08:29:55.909112 fcntl(0, F_SETFD, FD_CLOEXEC) = 0
08:29:55.909288 lseek(0, 0, SEEK_CUR)   = 0
08:29:55.909446 getdents(0, /* 71 entries */, 3933) = 1220
08:29:55.910425 close(0)                = 0
08:29:55.910592 stat("/a/", {st_mode=S_IFDIR|0755, st_size=1024, ...}) = 0
08:29:55.910829 stat("/a/", {st_mode=S_IFDIR|0755, st_size=1024, ...}) = 0
08:29:55.911049 open("/a/", O_RDONLY|O_NONBLOCK) = 0
08:29:55.911217 fcntl(0, F_SETFD, FD_CLOEXEC) = 0
08:29:55.911375 lseek(0, 0, SEEK_CUR)   = 0
08:29:55.911527 getdents(0, /* 3 entries */, 3933) = 40
08:29:55.911741 close(0)                = 0
08:29:55.911894 stat("/a/x/", {st_mode=S_IFDIR|0755, st_size=36864, ...}) = 0
08:29:55.912127 stat("/a/x/", {st_mode=S_IFDIR|0755, st_size=36864, ...}) = 0
08:29:55.912351 open("/a/x/", O_RDONLY|O_NONBLOCK) = 0
08:29:55.912522 fcntl(0, F_SETFD, FD_CLOEXEC) = 0
08:29:55.912677 lseek(0, 0, SEEK_CUR)   = 0
08:29:55.912828 getdents(0, /* 85 entries */, 3933) = 1356
08:29:55.913860 lseek(0, 0, SEEK_CUR)   = 1024
08:29:55.914014 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.915057 lseek(0, 0, SEEK_CUR)   = 2048
08:29:55.915212 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.916258 lseek(0, 0, SEEK_CUR)   = 3072
08:29:55.916415 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.917464 lseek(0, 0, SEEK_CUR)   = 4096
08:29:55.917621 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.918671 lseek(0, 0, SEEK_CUR)   = 5120
08:29:55.918826 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.919874 lseek(0, 0, SEEK_CUR)   = 6144
08:29:55.920055 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.921092 lseek(0, 0, SEEK_CUR)   = 7168
08:29:55.921250 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.922282 lseek(0, 0, SEEK_CUR)   = 8192
08:29:55.922436 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.923466 lseek(0, 0, SEEK_CUR)   = 9216
08:29:55.923621 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.924672 lseek(0, 0, SEEK_CUR)   = 10240
08:29:55.924829 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.925861 lseek(0, 0, SEEK_CUR)   = 11264
08:29:55.926016 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.927046 lseek(0, 0, SEEK_CUR)   = 12288
08:29:55.927197 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.928224 lseek(0, 0, SEEK_CUR)   = 13312
08:29:55.928375 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.929413 lseek(0, 0, SEEK_CUR)   = 14336
08:29:55.929568 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.930636 lseek(0, 0, SEEK_CUR)   = 15360
08:29:55.930793 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.931848 lseek(0, 0, SEEK_CUR)   = 16384
08:29:55.932001 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.933038 lseek(0, 0, SEEK_CUR)   = 17408
08:29:55.933193 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.934232 lseek(0, 0, SEEK_CUR)   = 18432
08:29:55.934390 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.935425 lseek(0, 0, SEEK_CUR)   = 19456
08:29:55.935578 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.936631 lseek(0, 0, SEEK_CUR)   = 20480
08:29:55.936784 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.937817 lseek(0, 0, SEEK_CUR)   = 21504
08:29:55.937972 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.939011 lseek(0, 0, SEEK_CUR)   = 22528
08:29:55.939167 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.940231 lseek(0, 0, SEEK_CUR)   = 23552
08:29:55.940386 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.941419 lseek(0, 0, SEEK_CUR)   = 24576
08:29:55.941569 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.942595 lseek(0, 0, SEEK_CUR)   = 25600
08:29:55.942745 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.943781 lseek(0, 0, SEEK_CUR)   = 26624
08:29:55.943936 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.944972 lseek(0, 0, SEEK_CUR)   = 27648
08:29:55.945128 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.946161 lseek(0, 0, SEEK_CUR)   = 28672
08:29:55.946316 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.947349 lseek(0, 0, SEEK_CUR)   = 29696
08:29:55.947505 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.948556 lseek(0, 0, SEEK_CUR)   = 30720
08:29:55.948812 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.949875 lseek(0, 0, SEEK_CUR)   = 31744
08:29:55.950083 getdents(0, /* 85 entries */, 3933) = 1360
08:29:55.951137 close(0)                = 0
08:29:55.951297 setfsuid(0)             = 0
08:29:55.951448 lstat("/a/x/2283", {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
08:29:55.951708 alarm(2)                = 5
08:29:55.951885 lstat("/a/x/2283", {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
08:29:55.952164 sendto(4, "x\0068{\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 96, 0, {sa_family=AF_INET, sin_port=htons(888), sin_addr=inet_addr("10.0.0.111")}, 16) = 96


What does the 2.6 ext3 dir_index feature not like here?


Thanks!

--
Al

