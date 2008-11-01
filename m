Return-Path: <linux-kernel-owner+w=401wt.eu-S1753132AbYKAQim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132AbYKAQim (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 12:38:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751675AbYKAQid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 12:38:33 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:5580 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbYKAQic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 12:38:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=EcgEQG2lLjgAEgMm2kOQaWoiVV6Mx6TGce1BJ4d0XtJxdq6IRGQQPDjDCEY3WVpZfV
         TJqtVnPVY84DWp+rThnp6flnTweFOJLGUw8rrq4UkP/96OvcwpeNYnBX1Zbh4ChzX+3U
         hrnbffugxbaN5VIX2spAGbcJ9hQ/EzKJuTzic=
Message-ID: <b2cc26e40811010938k3864c48j45ce55af09516302@mail.gmail.com>
Date: Sat, 1 Nov 2008 17:38:30 +0100
From: "Olaf van der Spek" <olafvdspek@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: epoll behaviour after running out of descriptors
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I noticed some strange behaviour of epoll after running out of descriptors.
I've registered a listen socket to epoll with edge triggering. On the
client-side I use an app that simply keeps opening connections.
When accept returns EMFILE, I call epoll_wait and accept and it
returns with another EMFILE.
This happens 10 times or so, after that epoll_wait no longer returns
with the listen socket ready.
I then close all file descriptors, but epoll_wait will still not return.
So my question is, why does it 'only' happen 10 times and what is the
expected behaviour?
And how should an app handle this?

The example in the epoll man page doesn't seem to handle this.

An idea I had was for epoll_wait to only return with accept / EMFILE
once. Then after a descriptor becomes available, epoll_wait would
return again.

See http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=502901

Hi,

I've written a web app that should be able to handle a lot of new
connections per second (1000+). On multiple servers I've hit a bug.
After running out of descriptors, then closing descriptors, epoll_wait
doesn't return anymore for the listen socket.
I've attached code to reproduce the issue. And an strace log. Even
before closing the descriptors you see epoll_wait already stops returning.

On the other side, I used a self-written app that just opens tons of
connections. Is there a standard utility to do that?

#include <arpa/inet.h>
#include <cassert>
#include <ctime>
#include <errno.h>
#include <netinet/in.h>
#include <sys/epoll.h>
#include <sys/ioctl.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <vector>

using namespace std;

int main()
{
        int l = socket(AF_INET, SOCK_STREAM, 0);
        unsigned long p = true;
        ioctl(l, FIONBIO, &p);
        sockaddr_in a = {0};
        a.sin_family = AF_INET;
        a.sin_addr.s_addr = INADDR_ANY;
        a.sin_port = htons(2710);
        bind(l, reinterpret_cast<sockaddr*>(&a), sizeof(sockaddr_in));
        listen(l, SOMAXCONN);
        int fd = epoll_create(1 << 10);
        epoll_event e;
        e.data.fd = l;
        e.events = EPOLLIN | EPOLLOUT | EPOLLPRI | EPOLLERR | EPOLLHUP
| EPOLLET;
        epoll_ctl(fd, EPOLL_CTL_ADD, l, &e);
        const int c_events = 64;
        epoll_event events[c_events];
        typedef vector<int> sockets_t;
        sockets_t sockets;
        time_t t = time(NULL);
        while (1)
        {
                int r = epoll_wait(fd, events, c_events, 5000);
                if (r == -1)
                        continue;
                if (!r && time(NULL) - t > 30)
                {
                        for (int i = 0; i < sockets.size(); i++)
                                close(sockets[i]);
                        sockets.clear();
                        t = INT_MAX;
                }
                for (int i = 0; i < r; i++)
                {
                        if (events[i].data.fd == l)
                        {
                                while (1)
                                {
                                        int s = accept(l, NULL, NULL);
                                        if (s == -1)
                                        {
                                                if (errno == EAGAIN)
                                                        break;
                                                break; // continue;
                                        }
                                        sockets.push_back(s);
                                }
                        }
                        else
                                assert(false);
                }
        }
        return 0;
}

socket(PF_INET, SOCK_STREAM, IPPROTO_IP) = 3
ioctl(3, FIONBIO, [1])                  = 0
bind(3, {sa_family=AF_INET, sin_port=htons(2710),
sin_addr=inet_addr("0.0.0.0")}, 16) = 0
listen(3, 128)                          = 0
epoll_create(1024)                      = 4
epoll_ctl(4, EPOLL_CTL_ADD, 3,
{EPOLLIN|EPOLLPRI|EPOLLOUT|EPOLLERR|EPOLLHUP|EPOLLET, {u32=3,
u64=13806959039201935363}}) = 0
time(NULL)                              = 1224527442
epoll_wait(4, {}, 64, 5000)             = 0
time(NULL)                              = 1224527447
epoll_wait(4, {{EPOLLIN, {u32=3, u64=13806959039201935363}}}, 64, 5000) = 1
accept(3, 0, NULL)                      = 5
brk(0)                                  = 0x804c000
brk(0x806d000)                          = 0x806d000
accept(3, 0, NULL)                      = 6
accept(3, 0, NULL)                      = 7
accept(3, 0, NULL)                      = 8
accept(3, 0, NULL)                      = -1 EAGAIN (Resource
temporarily unavailable)
epoll_wait(4, {{EPOLLIN, {u32=3, u64=13806959039201935363}}}, 64, 5000) = 1
accept(3, 0, NULL)                      = 9
...
accept(3, 0, NULL)                      = 85
accept(3, 0, NULL)                      = -1 EAGAIN (Resource
temporarily unavailable)
epoll_wait(4, {{EPOLLIN, {u32=3, u64=13806959039201935363}}}, 64, 5000) = 1
accept(3, 0, NULL)                      = 86
...
accept(3, 0, NULL)                      = 1023
accept(3, 0, NULL)                      = -1 EMFILE (Too many open files)
epoll_wait(4, {{EPOLLIN, {u32=3, u64=13806959039201935363}}}, 64, 5000) = 1
accept(3, 0, NULL)                      = -1 EMFILE (Too many open files)
epoll_wait(4, {{EPOLLIN, {u32=3, u64=13806959039201935363}}}, 64, 5000) = 1
...
epoll_wait(4, {{EPOLLIN, {u32=3, u64=13806959039201935363}}}, 64, 5000) = 1
accept(3, 0, NULL)                      = -1 EMFILE (Too many open files)
epoll_wait(4, {}, 64, 5000)             = 0
time(NULL)                              = 1224527454
epoll_wait(4, {}, 64, 5000)             = 0
time(NULL)                              = 1224527459
epoll_wait(4, {}, 64, 5000)             = 0
time(NULL)                              = 1224527464
epoll_wait(4, {}, 64, 5000)             = 0
time(NULL)                              = 1224527469
epoll_wait(4, {}, 64, 5000)             = 0
time(NULL)                              = 1224527474
close(5)                                = 0
...
close(1023)                             = 0
epoll_wait(4, {}, 64, 5000)             = 0
time(NULL)                              = 1224527479
epoll_wait(4, {}, 64, 5000)             = 0
time(NULL)                              = 1224527484
epoll_wait(4, {}, 64, 5000)             = 0
time(NULL)                              = 1224527489
epoll_wait(4, {}, 64, 5000)             = 0
time(NULL)                              = 1224527494
epoll_wait(4, {}, 64, 5000)             = 0
time(NULL)                              = 1224527499
epoll_wait(4, {}, 64, 5000)             = 0
time(NULL)                              = 1224527504

-- Package-specific info:
** Version:
Linux version 2.6.24-etchnhalf.1-686 (Debian 2.6.24-6~etchnhalf.5)
(dannf@debian.org) (gcc version 4.1.2 20061115 (prerelease) (Debian
4.1.1-21)) #1 SMP Mon Sep 8 06:19:11 UTC 2008

** Command line:
root=/dev/sda1 ro

** Not tainted
