Return-Path: <linux-kernel-owner+w=401wt.eu-S932751AbZHZAs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932751AbZHZAs5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 20:48:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932720AbZHZAs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 20:48:56 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:58781 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932236AbZHZAsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 20:48:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=t63UW71jN6k5gZiH4O2byDbPw88TG1Gkagldq9qUabE0jhiNNB4nIP3Ud/Au7DvvWY
         6kQ0eyIXLNAjG/Z0kecmqOvsI+1W3DWN4RW05KmVPvvRBcMAw7mK/evBXwe92WRebhHj
         X5Fou+yTs8XBViS2Ivy3G1fyguYNeC/fyVxlw=
MIME-Version: 1.0
Date: Wed, 26 Aug 2009 02:48:55 +0200
Message-ID: <8a1bd2320908251748u324ae5e6g7015069180253db3@mail.gmail.com>
Subject: PROBLEM: Epoll frequently fails to notify connects at connect bursts
From: Will Brown <dr.hfuhruhurr@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PLEASE CC: ME ON ANY REPLIES, thank you.

*** 1. Epoll frequently fails to notify connects at connect bursts

*** 2. Sometimes, when several connects come in quickly, epoll
establishes tcp connections (according to 'netstat') but then fails to
notify the application by returning from epoll_wait(). In those cases
a subsequent connection or an EPOLLIN or EPOLLOUT event can cause a
return from epoll_wait(), which then causes the previously ignored
connection to be reported. But then the more recent event is not
notified, the whole sequence lags and everything gets out of whack.
The problems can easily be reproduced on my Ubuntu machine which runs
a kernel version 2.6.28 using supplied test program. I also have a
Ubuntu hosted in VMWare running a 2.6.27 version kernel, which appears
to NOT have the same problem.

*** 3. Keywords: epoll

*** 4.1 Kernel version:
Linux version 2.6.28-15-generic (buildd@palmer) (gcc version 4.3.3
(Ubuntu 4.3.3-5ubuntu4) ) #49-Ubuntu SMP Tue Aug 18 18:40:08 UTC 2009

*** 5. Most recent working kernel
A 2.6.27 version kernel running in Ubuntu on VMWare seems to be working fine:
Linux version 2.6.27-11-generic (buildd@rothera) (gcc version 4.3.2
(Ubuntu 4.3.2-1ubuntu11) ) #1 SMP Thu Jan 29 19:24:39 UTC 2009

*** 7. How to reproduce the problem.
In my broken environment the problem is easily (almost always)
reproduced by simply making a number of independent connects issuing
this compound statement
nc localhost 4712 & \
nc localhost 4712 & \
nc localhost 4712 & \
nc localhost 4712 &

In fact, if I try a few times, two 'nc' invocations suffice, but the
chance of triggering the problem increases with the number of
connects. Using four 'nc' invocations the problem occurs about 50
percent of the time. When issuing ten or more the problem appears
almost always. Issuing them one by one on the command line will not
trigger the problem, it has to be done in a rapid sequence.

An example of a "hang"

First issue the multiple connect statement and watch the jobs get created

$ nc localhost 4712 & nc localhost 4712 & nc localhost 4712 & nc
localhost 4712 &
[1] 4142
[2] 4143
[3] 4144
[4] 4145

To these connects, the test program this time responds that 3 connects
were made (not 4); they were accepted and assigned to sockets 5, 6,
and 7:
----------------------------
Listening for connections
Epoll returns 1
Events: 0x1
EPOLLIN(1): Accepted connection and assigned socket 5
Epoll returns 1
Events: 0x1
EPOLLIN(1): Accepted connection and assigned socket 6
Epoll returns 1
Events: 0x1
EPOLLIN(1): Accepted connection and assigned socket 7
----------------------------

However, netstat reports four (pairs of) established connections

$ netstat | grep 4712
tcp        0      0 localhost:53481         localhost:4712          ESTABLISHED
tcp        0      0 localhost:53484         localhost:4712          ESTABLISHED
tcp        0      0 localhost:4712          localhost:53482         ESTABLISHED
tcp        0      0 localhost:4712          localhost:53481         ESTABLISHED
tcp        0      0 localhost:53482         localhost:4712          ESTABLISHED
tcp        0      0 localhost:4712          localhost:53483         ESTABLISHED
tcp        0      0 localhost:53483         localhost:4712          ESTABLISHED
tcp        0      0 localhost:4712          localhost:53484         ESTABLISHED

The test program is appended at the end of this message.

*** 8.1 ver_linux output:

Linux B17845-1 2.6.28-15-generic #49-Ubuntu SMP Tue Aug 18 18:40:08
UTC 2009 i686 GNU/Linux

Gnu C                  4.3.3
Gnu make               3.81
binutils               2.19.1
util-linux             2.14.2
mount                  support
module-init-tools      3.7-pre9
e2fsprogs              1.41.4
reiserfsprogs          3.6.19
Linux C Library        2.9
Dynamic linker (ldd)   2.9
Procps                 3.2.7
Net-tools              1.60
Kbd                    1.14.1
Sh-utils               6.10
Modules Loaded         authenc esp4 xfrm4_mode_tunnel video output
input_polldev deflate zlib_deflate ctr twofish twofish_common camellia
serpent blowfish des_generic cbc aes_i586 aes_generic xcbc rmd160
sha256_generic sha1_generic crypto_null af_key lp iTCO_wdt
iTCO_vendor_support i3000_edac ppdev edac_core serio_raw shpchp
parport_pc parport pcspkr e1000e floppy fbcon tileblit font bitblit
softcursor

*** 8.2 /proc/cpuinfo:

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 15
model name	: Intel(R) Core(TM)2 CPU          6300  @ 1.86GHz
stepping	: 6
cpu MHz		: 1862.137
cache size	: 2048 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 2
apicid		: 0
initial apicid	: 0
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm
constant_tsc arch_perfmon pebs bts pni dtes64 monitor ds_cpl vmx est
tm2 ssse3 cx16 xtpr pdcm lahf_lm tpr_shadow
bogomips	: 3724.27
clflush size	: 64
power management:

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model		: 15
model name	: Intel(R) Core(TM)2 CPU          6300  @ 1.86GHz
stepping	: 6
cpu MHz		: 1862.137
cache size	: 2048 KB
physical id	: 0
siblings	: 2
core id		: 1
cpu cores	: 2
apicid		: 1
initial apicid	: 1
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm
constant_tsc arch_perfmon pebs bts pni dtes64 monitor ds_cpl vmx est
tm2 ssse3 cx16 xtpr pdcm lahf_lm tpr_shadow
bogomips	: 3724.23
clflush size	: 64
power management:

*** 8.3 /proc/modules:

authenc 13696 2 - Live 0xf80f2000
esp4 14208 2 - Live 0xf80e2000
xfrm4_mode_tunnel 10368 4 - Live 0xf80d3000
video 25360 0 - Live 0xf80c1000
output 11008 1 video, Live 0xf80ae000
input_polldev 11912 0 - Live 0xf8090000
deflate 10880 0 - Live 0xf803e000
zlib_deflate 28312 1 deflate, Live 0xf802f000
ctr 12160 0 - Live 0xf801e000
twofish 15104 0 - Live 0xf800f000
twofish_common 22016 1 twofish, Live 0xf8000000
camellia 26752 0 - Live 0xf7feb000
serpent 27264 0 - Live 0xf7fd5000
blowfish 16256 0 - Live 0xf7fba000
des_generic 24832 2 - Live 0xf7fa7000
cbc 11648 2 - Live 0xf7f95000
aes_i586 15744 0 - Live 0xf7f77000
aes_generic 35880 1 aes_i586, Live 0xf7f61000
xcbc 12808 0 - Live 0xf7f4f000
rmd160 18944 0 - Live 0xf7f3f000
sha256_generic 20352 0 - Live 0xf7f1f000
sha1_generic 10368 0 - Live 0xf7f01000
crypto_null 11008 0 - Live 0xf7d70000
af_key 35860 2 - Live 0xf7d34000
lp 17156 0 - Live 0xf7cb4000
iTCO_wdt 19108 0 - Live 0xf7cc8000
iTCO_vendor_support 11652 1 iTCO_wdt, Live 0xf7c5f000
i3000_edac 12808 0 - Live 0xf7c71000
ppdev 15620 0 - Live 0xf7c46000
edac_core 47404 3 i3000_edac, Live 0xf7d74000
serio_raw 13444 0 - Live 0xf7d2e000
shpchp 40212 0 - Live 0xf7d22000
parport_pc 40100 1 - Live 0xf7c94000
parport 42220 3 lp,ppdev,parport_pc, Live 0xf7c87000
pcspkr 10496 0 - Live 0xf7c3a000
e1000e 121136 0 - Live 0xf7cdd000
floppy 64324 0 - Live 0xf7ca2000
fbcon 46112 0 - Live 0xf7c79000
tileblit 10752 1 fbcon, Live 0xf7c65000
font 16384 1 fbcon, Live 0xf7c59000
bitblit 13824 1 fbcon, Live 0xf7c4c000
softcursor 9984 1 bitblit, Live 0xf7c41000

*** X. TEST code

(Simply compile with gcc and run ./a.out)

/**** Test program *************************************************/

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <sys/epoll.h>
#include <fcntl.h>
#include <unistd.h>
#include <arpa/inet.h>

int main(int argc, char **argv)
{
    /**
    * Set up a listener socket
    */

    int listener = socket(PF_INET, SOCK_STREAM, 0);
    if (listener < 0) {
        perror("socket");
        exit(EXIT_FAILURE);
    }

    /**
    * Make listener non-blocking
    */

    int rc = fcntl(listener, F_GETFL);
    if (rc < 0) {
        perror("fcntl(F_GETFL)");
        exit(EXIT_FAILURE);
    }
    rc = fcntl(listener, F_SETFL, rc | O_NONBLOCK);
    if (rc < 0) {
        perror("fcntl(F_SETFL)");
        exit(EXIT_FAILURE);
    }

    /**
    * Bind listener to port 4712
    */

    struct sockaddr_in sa;
    socklen_t size_sa = sizeof sa;
    memset(&sa, 0, size_sa);

    sa.sin_family = AF_INET;
    sa.sin_addr.s_addr = htonl(INADDR_LOOPBACK);    /* Listen on
localhost only */
    sa.sin_port = htons(4712);          /* Using specified port */
    if (bind(listener, (struct sockaddr *) &sa, size_sa) < 0) {
        perror("bind");
        exit(EXIT_FAILURE);
    }

    /**
    * Create epoll file descriptor.
    * Explain this size value 20 ...
    */

    int epollfd = epoll_create(20);
    if (epollfd < 0) {
        perror("epoll_create");
        exit(EXIT_FAILURE);
    }

    /**
    * Add listener to epoll set, trigger by incoming data (EDGE mode)
    */

    struct epoll_event event_config;
    event_config.events = EPOLLET | EPOLLIN;
    event_config.data.ptr = NULL;
    rc = epoll_ctl(epollfd, EPOLL_CTL_ADD, listener, &event_config);
    if (rc < 0) {
        perror("epoll_ctl");
        exit(EXIT_FAILURE);
    }

    /**
    * Start listening, queue length 20
    */

    if (listen(listener, 20) < 0) {
        perror("listen");
        exit(EXIT_FAILURE);
    }

    printf("Listening for connections\n");

    struct epoll_event event_list[50];
    struct epoll_event *ev;

    while (1) {
        rc = epoll_wait(epollfd, event_list, 50, -1);
        if (rc < 0) {
            perror("epoll_wait rc<0");
            exit(EXIT_FAILURE);
        }
        printf("Epoll returns %d\n", rc);

        int i;
        for (i = 0; i < rc; i++) {
            ev = event_list + i;

            printf("Events: 0x%x\n",  ev->events);

            if (ev->events &   EPOLLHUP) {
                printf("EPOLLHUP: ");
                ev->events &= ~EPOLLHUP;
            }

            if (ev->events &   EPOLLIN) {
                printf("EPOLLIN(1): ");
                ev->events &= ~EPOLLIN;

                struct sockaddr_in sa;
                socklen_t size_sa = sizeof sa;
                memset(&sa, 0, size_sa);

                int connection_sock = accept(listener, (struct
sockaddr *) &sa, &size_sa);
                if (connection_sock < 0) {
                    perror("accept");
                    exit(EXIT_FAILURE);
                }

                printf("Accepted connection and assigned socket %d\n",
connection_sock);
            }

            if (ev->events &   EPOLLOUT) {
                printf("EPOLLOUT(4): ");
                ev->events &= ~EPOLLOUT;
            }

            if (ev->events) {
                printf("*** Other events");
            }
        }
    }
}
