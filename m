Return-Path: <linux-kernel-owner+w=401wt.eu-S1755411AbXLRLqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411AbXLRLqi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 06:46:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752286AbXLRLqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 06:46:21 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:46447 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753886AbXLRLqT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 06:46:19 -0500
Message-ID: <397978379.15961@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Tue, 18 Dec 2007 19:46:09 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 0/9] mmap read-around and readahead
References: <397806667.28507@ustc.edu.cn> <alpine.LFD.0.9999.0712161535090.21557@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.9999.0712161535090.21557@woody.linux-foundation.org>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.17 (2007-11-01)
Message-Id: <E1J4atl-0000UI-4a@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 16, 2007 at 03:35:58PM -0800, Linus Torvalds wrote:
> 
> 
> On Sun, 16 Dec 2007, Fengguang Wu wrote:
> > 
> > Here are the mmap read-around related patches initiated by Linus.
> > They are for linux-2.6.24-rc4-mm1.  The one major new feature -
> > auto detection and early readahead for mmap sequential reads - runs
> > as expected on my desktop :-)
> 
> Just out of interest - did you check to see if it makes any difference to 
> any IO patterns (or even timings)?

No timings for now... but I wrote a debug patch(attached) and watched
it running for about a week.  Here are some interesting numbers:

% grep .so, /var/log/kern.log|grep init0|wc                   
   4085   60806  583895

% grep .so, /var/log/kern.log|grep around|wc
  14438  215265 2107308
% grep .so, /var/log/kern.log|grep around|grep '= 32' | wc    
   3133   46757  462446

% grep .so, /var/log/kern.log|grep interleaved|wc
    997   14866  148921
% grep .so, /var/log/kern.log|grep interleaved|grep '= 0'|wc  
    544    8089   79661
% grep .so, /var/log/kern.log|grep interleaved|grep '= 32'|wc
    179    2683   28233

% grep .so, /var/log/kern.log|grep sequential|wc 
   3499   52275  541319
% grep .so, /var/log/kern.log|grep sequential|grep '= 0' | wc
    915   13598  131953
% grep .so, /var/log/kern.log|grep sequential|grep '= 32' | wc
   1327   19880  212896

That says, there are
   4085 page faults on start-of-lib-file,
  14438 mmap read-around,       22% full ra size
   3499 mmap async readahead,   38% full ra size, or 51% if removing pure cache hits
    997 mmap sync readahead,    18% full ra size, or 40% if removing pure cache hits
That's good numbers: I/O sizes get larger, and possibly less I/O waits :-)

Sure it's rather coarse estimation, but there are some sequential mmap accesses.
E.g.

[11736.998347] readahead-init0(process: sh/23926, file: sda1/w3m, offset=0:-1, ra=0+4-3) = 4
[11737.014985] readahead-around(process: w3m/23926, file: sda1/w3m, offset=0:0, ra=290+32-0) = 17
[11737.019488] readahead-around(process: w3m/23926, file: sda1/w3m, offset=0:0, ra=118+32-0) = 32
[11737.024921] readahead-interleaved(process: w3m/23926, file: sda1/w3m, offset=0:2, ra=4+6-6) = 6
[11737.025726] readahead-sequential(process: w3m/23926, file: sda1/w3m, offset=0:3, ra=10+12-12) = 12
[11737.025794] readahead-around(process: w3m/23926, file: sda1/w3m, offset=0:4, ra=90+32-0) = 28
--- sequential begin ---
[11737.037893] readahead-init(process: w3m/23926, file: sda1/w3m, offset=0:149, ra=150+64-32) = 64
[11737.043928] readahead-sequential(process: w3m/23926, file: sda1/w3m, offset=0:181, ra=214+32-32) = 32
[11737.044086] readahead-sequential(process: w3m/23926, file: sda1/w3m, offset=0:213, ra=246+32-32) = 32
[11737.045633] readahead-sequential(process: w3m/23926, file: sda1/w3m, offset=0:245, ra=278+32-32) = 12
[11737.047321] readahead-sequential(process: w3m/23926, file: sda1/w3m, offset=0:277, ra=310+32-32) = 0
--- sequential end ---
[11737.048296] readahead-around(process: w3m/23926, file: sda1/w3m, offset=0:119, ra=48+32-0) = 32
[11737.066908] readahead-around(process: w3m/23926, file: sda1/w3m, offset=0:63, ra=73+32-0) = 10
[11737.136880] readahead-around(process: w3m/23926, file: sda1/w3m, offset=0:116, ra=30+32-0) = 18
[11737.166005] readahead-around(process: w3m/23926, file: sda1/w3m, offset=0:37, ra=6+32-0) = 8


But also there is one minor problem.

[16416.600720] readahead-init0(process: zsh/30490, file: sda1/bc, offset=0:-1, ra=0+4-3) = 4
[16416.607967] readahead-around(process: bc/30490, file: sda1/bc, offset=0:0, ra=1+32-0) = 14

The 4-page readahead-init0() hurts performance. It occurs before every initial mmap reads.
A longer example:

wfg ~% dmesg|grep mplayer
[ 1221.454230] readahead-init0(process: mutt/7131, file: md0/mplayer-devel, offset=0:-1, ra=0+4-3) = 4
[ 1378.667305] readahead-init0(process: strace/7352, file: sda1/mplayer, offset=0:-1, ra=0+4-3) = 4
[ 1378.692389] readahead-around(process: mplayer/7352, file: sda1/mplayer, offset=0:0, ra=2212+32-0) = 17
[ 1378.703656] readahead-around(process: mplayer/7352, file: sda1/mplayer, offset=0:0, ra=2061+32-0) = 32
[ 1378.715537] readahead-around(process: mplayer/7352, file: sda1/mplayer, offset=0:2077, ra=0+32-0) = 28
[ 1378.716261] readahead-around(process: mplayer/7352, file: sda1/mplayer, offset=0:10, ra=44+32-0) = 32
[ 1378.727570] readahead-init0(process: mplayer/7352, file: sda1/libdirectfb-0.9.so.25.0.0, offset=0:-1, ra=0+4-3) = 4
[ 1378.740579] readahead-around(process: mplayer/7352, file: sda1/libdirectfb-0.9.so.25.0.0, offset=0:0, ra=79+32-0) = 17
[ 1378.744826] readahead-around(process: mplayer/7352, file: sda1/libdirectfb-0.9.so.25.0.0, offset=0:1, ra=0+32-0) = 28
[ 1378.749882] readahead-init0(process: mplayer/7352, file: sda1/libXv.so.1.0.0, offset=0:-1, ra=0+4-3) = 4
[ 1378.754546] readahead-around(process: mplayer/7352, file: sda1/libXv.so.1.0.0, offset=0:0, ra=0+32-0) = 1
[ 1378.758057] readahead-init0(process: mplayer/7352, file: sda1/libXvMC.so.1.0.0, offset=0:-1, ra=0+4-3) = 4
[ 1378.759566] readahead-init0(process: mplayer/7352, file: sda1/libXvMCW.so.1.0.0, offset=0:-1, ra=0+4-3) = 4
[ 1378.764991] readahead-init0(process: mplayer/7352, file: sda1/libXxf86dga.so.1.0.0, offset=0:-1, ra=0+4-3) = 4
[ 1378.766036] readahead-around(process: mplayer/7352, file: sda1/libXxf86dga.so.1.0.0, offset=0:0, ra=0+32-0) = 2
[ 1378.766887] readahead-init0(process: mplayer/7352, file: sda1/libGL.so.1.2, offset=0:-1, ra=0+4-3) = 4
[ 1378.778437] readahead-around(process: mplayer/7352, file: sda1/libGL.so.1.2, offset=0:0, ra=109+32-0) = 17
[ 1378.782107] readahead-around(process: mplayer/7352, file: sda1/libGL.so.1.2, offset=0:2, ra=1+32-0) = 29
[ 1378.792935] readahead-init0(process: mplayer/7352, file: sda1/libggi.so.2.0.2, offset=0:-1, ra=0+4-3) = 4
[ 1378.799236] readahead-around(process: mplayer/7352, file: sda1/libggi.so.2.0.2, offset=0:0, ra=132+32-0) = 18
[ 1378.808167] readahead-around(process: mplayer/7352, file: sda1/libggi.so.2.0.2, offset=0:0, ra=0+32-0) = 28
[ 1378.808759] readahead-init0(process: mplayer/7352, file: sda1/libaa.so.1.0.4, offset=0:-1, ra=0+4-3) = 4
[ 1378.818428] readahead-around(process: mplayer/7352, file: sda1/libaa.so.1.0.4, offset=0:0, ra=12+32-0) = 18
[ 1378.830829] readahead-init0(process: mplayer/7352, file: sda1/libcaca.so.0.99.0, offset=0:-1, ra=0+4-3) = 4
[ 1378.832195] readahead-around(process: mplayer/7352, file: sda1/libcaca.so.0.99.0, offset=0:0, ra=0+32-0) = 6
[ 1378.832945] readahead-init0(process: mplayer/7352, file: sda1/libcucul.so.0.99.0, offset=0:-1, ra=0+4-3) = 4
[ 1378.837474] readahead-around(process: mplayer/7352, file: sda1/libcucul.so.0.99.0, offset=0:0, ra=135+32-0) = 18
[ 1378.844951] readahead-around(process: mplayer/7352, file: sda1/libcucul.so.0.99.0, offset=0:151, ra=1+32-0) = 29
[ 1378.845851] readahead-init0(process: mplayer/7352, file: sda1/libSDL-1.2.so.0.11.0, offset=0:-1, ra=0+4-3) = 4
[ 1378.867151] readahead-around(process: mplayer/7352, file: sda1/libSDL-1.2.so.0.11.0, offset=0:0, ra=88+32-0) = 18
[ 1378.871796] readahead-around(process: mplayer/7352, file: sda1/libSDL-1.2.so.0.11.0, offset=0:0, ra=0+32-0) = 28
[ 1378.873248] readahead-init0(process: mplayer/7352, file: sda1/libartsc.so.0.0.0, offset=0:-1, ra=0+4-3) = 4
[ 1378.885419] readahead-around(process: mplayer/7352, file: sda1/libartsc.so.0.0.0, offset=0:0, ra=0+32-0) = 2
[ 1378.892469] readahead-init0(process: mplayer/7352, file: sda1/libpulse.so.0.2.0, offset=0:-1, ra=0+4-3) = 4
[ 1378.903642] readahead-around(process: mplayer/7352, file: sda1/libpulse.so.0.2.0, offset=0:0, ra=43+32-0) = 17
[ 1378.907206] readahead-around(process: mplayer/7352, file: sda1/libpulse.so.0.2.0, offset=0:1, ra=0+32-0) = 28
[ 1378.918549] readahead-init0(process: mplayer/7352, file: sda1/libjack.so.0.0.23, offset=0:-1, ra=0+4-3) = 4
[ 1378.928575] readahead-around(process: mplayer/7352, file: sda1/libjack.so.0.0.23, offset=0:0, ra=2+32-0) = 16
[ 1378.940046] readahead-init0(process: mplayer/7352, file: sda1/libopenal.so.0.0.0, offset=0:-1, ra=0+4-3) = 4
[ 1378.963093] readahead-around(process: mplayer/7352, file: sda1/libopenal.so.0.0.0, offset=0:0, ra=42+32-0) = 17
[ 1378.981748] readahead-init0(process: mplayer/7352, file: sda1/libfaac.so.0.0.0, offset=0:-1, ra=0+4-3) = 4
[ 1378.993281] readahead-around(process: mplayer/7352, file: sda1/libfaac.so.0.0.0, offset=0:0, ra=0+32-0) = 14
[ 1378.994296] readahead-init0(process: mplayer/7352, file: sda1/libx264.so.55, offset=0:-1, ra=0+4-3) = 4
[ 1379.004907] readahead-around(process: mplayer/7352, file: sda1/libx264.so.55, offset=0:0, ra=112+32-0) = 18
[ 1379.010374] readahead-around(process: mplayer/7352, file: sda1/libx264.so.55, offset=0:0, ra=0+32-0) = 28
[ 1379.025175] readahead-init0(process: mplayer/7352, file: sda1/libsmbclient.so.0.1, offset=0:-1, ra=0+4-3) = 4
[ 1379.040139] readahead-around(process: mplayer/7352, file: sda1/libsmbclient.so.0.1, offset=0:0, ra=530+32-0) = 17
[ 1379.043905] readahead-around(process: mplayer/7352, file: sda1/libsmbclient.so.0.1, offset=0:535, ra=0+32-0) = 28
[ 1379.044276] readahead-around(process: mplayer/7352, file: sda1/libsmbclient.so.0.1, offset=0:8, ra=49+32-0) = 32
[ 1379.083560] readahead-init0(process: mplayer/7352, file: sda1/libungif.so.4.1.4, offset=0:-1, ra=0+4-3) = 4
[ 1379.088050] readahead-around(process: mplayer/7352, file: sda1/libungif.so.4.1.4, offset=0:0, ra=0+32-0) = 4
[ 1379.095605] readahead-init0(process: mplayer/7352, file: sda1/libcdda_interface.so.0.10.0, offset=0:-1, ra=0+4-3) = 4
[ 1379.100462] readahead-around(process: mplayer/7352, file: sda1/libcdda_interface.so.0.10.0, offset=0:0, ra=0+32-0) = 12
[ 1379.100889] readahead-init0(process: mplayer/7352, file: sda1/libcdda_paranoia.so.0.10.0, offset=0:-1, ra=0+4-3) = 4
[ 1379.108911] readahead-around(process: mplayer/7352, file: sda1/libcdda_paranoia.so.0.10.0, offset=0:0, ra=0+32-0) = 4
[ 1379.110094] readahead-init0(process: mplayer/7352, file: sda1/libfribidi.so.0.0.0, offset=0:-1, ra=0+4-3) = 4
[ 1379.111707] readahead-around(process: mplayer/7352, file: sda1/libfribidi.so.0.0.0, offset=0:0, ra=0+32-0) = 11
[ 1379.116159] readahead-init0(process: mplayer/7352, file: sda1/libspeex.so.1.2.0, offset=0:-1, ra=0+4-3) = 4
[ 1379.134065] readahead-around(process: mplayer/7352, file: sda1/libspeex.so.1.2.0, offset=0:0, ra=18+32-0) = 17
[ 1379.137322] readahead-init0(process: mplayer/7352, file: sda1/libtheora.so.0.2.0, offset=0:-1, ra=0+4-3) = 4
[ 1379.137976] readahead-around(process: mplayer/7352, file: sda1/libtheora.so.0.2.0, offset=0:0, ra=33+32-0) = 18
[ 1379.141476] readahead-init0(process: mplayer/7352, file: sda1/libmpcdec.so.3.1.1, offset=0:-1, ra=0+4-3) = 4
[ 1379.150304] readahead-around(process: mplayer/7352, file: sda1/libmpcdec.so.3.1.1, offset=0:0, ra=0+32-0) = 10
[ 1379.151400] readahead-init0(process: mplayer/7352, file: sda1/libamrnb.so.2.0.0, offset=0:-1, ra=0+4-3) = 4
[ 1379.169518] readahead-around(process: mplayer/7352, file: sda1/libamrnb.so.2.0.0, offset=0:0, ra=44+32-0) = 17
[ 1379.171870] readahead-init0(process: mplayer/7352, file: sda1/libamrwb.so.2.0.0, offset=0:-1, ra=0+4-3) = 4
[ 1379.172558] readahead-around(process: mplayer/7352, file: sda1/libamrwb.so.2.0.0, offset=0:0, ra=28+32-0) = 17
[ 1379.179794] readahead-init0(process: mplayer/7352, file: sda1/libdv.so.4.0.3, offset=0:-1, ra=0+4-3) = 4
[ 1379.196072] readahead-around(process: mplayer/7352, file: sda1/libdv.so.4.0.3, offset=0:0, ra=13+32-0) = 17
[ 1379.209467] readahead-init0(process: mplayer/7352, file: sda1/libxvidcore.so.4.1, offset=0:-1, ra=0+4-3) = 4
[ 1379.210581] readahead-around(process: mplayer/7352, file: sda1/libxvidcore.so.4.1, offset=0:0, ra=115+32-0) = 18
[ 1379.225045] readahead-init0(process: mplayer/7352, file: sda1/liblirc_client.so.0.1.0, offset=0:-1, ra=0+4-3) = 4
[ 1379.229523] readahead-around(process: mplayer/7352, file: sda1/liblirc_client.so.0.1.0, offset=0:0, ra=0+32-0) = 2
[ 1379.230907] readahead-init0(process: mplayer/7352, file: sda1/libdirect-0.9.so.25.0.0, offset=0:-1, ra=0+4-3) = 4
[ 1379.237679] readahead-around(process: mplayer/7352, file: sda1/libdirect-0.9.so.25.0.0, offset=0:0, ra=0+32-0) = 12
[ 1379.238163] readahead-init0(process: mplayer/7352, file: sda1/libfusion-0.9.so.25.0.0, offset=0:-1, ra=0+4-3) = 4
[ 1379.245010] readahead-around(process: mplayer/7352, file: sda1/libfusion-0.9.so.25.0.0, offset=0:0, ra=0+32-0) = 3
[ 1379.246950] readahead-init0(process: mplayer/7352, file: sda1/libXxf86vm.so.1.0.0, offset=0:-1, ra=0+4-3) = 4
[ 1379.255703] readahead-around(process: mplayer/7352, file: sda1/libXxf86vm.so.1.0.0, offset=0:0, ra=0+32-0) = 1

There are so many readahead-init0() calls... because ld-linux.so will
do a read(0+832) before doing mmap(in L1):

L0: open("/lib/libc.so.6", O_RDONLY)        = 3
L1: read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\340\342"..., 832) = 832
L2: fstat(3, {st_mode=S_IFREG|0755, st_size=1420624, ...}) = 0
L3: mmap(NULL, 3527256, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fac6e51d000
L4: mprotect(0x7fac6e671000, 2097152, PROT_NONE) = 0
L5: mmap(0x7fac6e871000, 20480, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x154000) = 0x7fac6e871000
L6: mmap(0x7fac6e876000, 16984, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7fac6e876000
L7: close(3)                                = 0


I cannot think of a good solution to it. Teaching ld-linux.so to blindly
do a fadvise(128KB) looks bad. And the kernel can do little about it.

This is also the major reason I disabled the interleaved readahead
support for mmap reads. Otherwise the PG_readahead flag leaved by
ld-linux.so will trigger _small_ interleaved readahead like this:

readahead-interleaved(process: firefox-bin/4596, file: sda1/libmozjs.so, offset=0, ra=4+6-6) = 6

It would be a much larger read-around if we don't do that readahead ;-)

Fengguang

