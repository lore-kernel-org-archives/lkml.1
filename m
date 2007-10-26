Return-Path: <linux-kernel-owner+w=401wt.eu-S1757783AbXJZKtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757783AbXJZKtZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 06:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756644AbXJZKtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 06:49:07 -0400
Received: from 242.235.97-84.rev.gaoland.net ([84.97.235.242]:55075 "EHLO
	cerbere.dyndns.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756486AbXJZKtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 06:49:04 -0400
X-Greylist: delayed 482 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Oct 2007 06:49:03 EDT
From: Samir Bellabes <sam@synack.fr>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andreas Gruenbacher <agruen@suse.de>,
       Bernd Petrovitsch <bernd@firmix.at>,
       Casey Schaufler <casey@schaufler-ca.com>,
       Chris Wright <chrisw@sous-sol.org>,
       Crispin Cowan <crispin@crispincowan.com>,
       Giacomo Catenazzi <cate@debian.org>, James Morris <jmorris@namei.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-security-module@vger.kernel.org, Ray Lee <ray-lk@madrabbit.org>,
       Simon Arlott <simon@fire.lp0.eu>,
       Thomas Fricaccia <thomas_fricacci@yahoo.com>
Subject: Re: LSM conversion to static interface
References: <Pine.LNX.4.64.0710251328150.17781@fbirervta.pbzchgretzou.qr>
Date: Fri, 26 Oct 2007 12:40:58 +0200
In-Reply-To: <Pine.LNX.4.64.0710251328150.17781@fbirervta.pbzchgretzou.qr>
	(Jan Engelhardt's message of "Thu, 25 Oct 2007 13:33:58 +0200 (CEST)")
Message-ID: <m2sl3ydupx.fsf@synack.fr>
User-Agent: Gnus/5.110003 (No Gnus v0.3) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt <jengelh@computergmbh.de> writes:

> Which reminded me of the TuxGuardian LSM[1] - another of the real-world 
> uses to meet Linus's criteria? ("had examples of their real-world use to 
> step forward and explain their use")
>
> In this specific project, LSM is used to collect up calls to bind() and 
> connect() and pass them to userspace, e.g. do it ZoneAlarm-style and 
> display a dialog window. Its codebase is probably not too up-to-date 
> (website says last change last April - but I guess that's a no-brainer 
> to update it).
>
> [1] http://tuxguardian.sf.net/

It's not exactly true, tuxguardian is only dealing with .socket_create
and .socket_listen from the struct security_operations, and not
socket_bind

I have done some work in this area since last year, and mailed the
netdev list about it. [1]

the project is 'network events connector' [2]. It's using the LSM
hooks to get interesting informations from syscalls, to push them to
userpace. So differences between projects will be on features and the
code itself.

Before getting a more infos on the project, as a 'LSM user', my main
concern is not that we can unload/load dynamically the security modules,
or have to reboot to do that. I don't have any point on this.

My point is more that the 'user' have to be able to choose which system
is better for him, and by 'user' we can hear linux distros. If
security's modules don't do the same thing, we have to accept to have
multiple modules, ie for example 'the 'network event connector' as a
personnal firewall, and why not another security module for checking 
filesystem. Whitout this approach, tools like mine are pointless for 
linux distros, because there are already working on SELinux, Appamor,
etc.. Not thinking this, is to think that on day, we will have the
perfect and standard security module, but this won't happen, because
users don't want the same thing: "I only want a personnal firewall at
first place, and not a entire role based model".

Now here is more infos on the project, so if not interested so you can
escape now :)

A/ for features:
1/ more hooks
static struct security_operations snet_security_ops = {
        .socket_create          = snet_socket_create,
        .socket_bind            = snet_socket_bind,
        .socket_connect         = snet_socket_connect,
        .socket_listen          = snet_socket_listen,
        .socket_accept          = snet_socket_accept,     
        .socket_post_accept     = snet_socket_post_accept,
        .socket_sendmsg         = snet_socket_sendmsg,
        .socket_recvmsg         = snet_socket_recvmsg,     
        .socket_sock_rcv_skb    = snet_socket_sock_rcv_skb,
};

2/ global control
the main idea behind tuxguardian is preventing rootkit applications 
to execute listen(), so it's warning userspace.

This is really interesting, but I think we can do more than just
that. We can allow in a simple/dynamical way such iptables rules :

iptables -A INPUT -i ppp0 -p tcp -m tcp --dport 22 --syn -m state --state NEW -j ACCEPT 

just by detecting the sys_listen() call which has been execute by sshd,
and for example only by /usr/bin/sshd (path name based) or 'sshd' role
group (ie SELinux approach), and let packets coming from the network for
this socket to bypass the firewall (of course the user/admin is
controlling it from the userspace).

But we also can control the sys_connect() dynamically from userspace for
example, and prevent application using connect(), regarding the
destination IP address/port, protocol, uid, application (and why not
time, etc).

The main problem and interesting part is the sys_accept(), because only
the LSM hook socket_accept can make the syscall failling. But what
could be interesting is to block/accept the syscall regarding the
remote socket informations (ie which IP address is connecting ?). And
this approch is not possible with the socket_accept hook (it comes too
early) 

Tomoyo tried to solve this by moving the security_socket_post_accept()
before the fd_install() [3]. This is bad for at least two reasons: 
 - this hook was historically not added for this kind of filtering [4]
 - we already have a netfilter tool to help us: libnetfilter_queue [5]

The idea is to send informations about the sys_listen() syscall,
so inform the userspace that a application is maybe waiting for
packets, then using libnetfilter_queue, check packets that match the
socket involved on the sys_listen(). If we have such packet, we can ask
the user to accept or deny this packets.
This approach don't require a modification in the LSM architecture, and 
it's better to use netfilter to deal with packets.

B/ for the code itself:
1/
I'm moving the code from the netlink connector to use generic
netlink/libnl. Tuxguardian is using sock_sendmsg/sock_recvmsg directly

2/
for receiving answers from userspace (I call that "verdict"),
tuxguardian is using sock_recvmsg(), so there is no timeout. I'm using
waitqueue and timers for each "events" sent and "verdict". I'm calling a
event the couple (protocol, syscall) for example (TCP, connect).

there is a documentation/information here [2]. I'm planning to release
next version with genetlink and updated docs on the next week.

thanks,
sam

[1] http://www.spinics.net/lists/netdev/msg24437.html
[2] http://www.synack.fr/project/cn_net/cn_net.html

[3] http://www.mail-archive.com/linux-security-module@vger.kernel.org/msg01393.html

--- linux-2.6.orig/net/socket.c 2007-10-02 11:11:51.000000000 +0900
+++ linux-2.6/net/socket.c      2007-10-02 11:26:23.000000000 +0900
@@ -1434,13 +1434,16 @@ asmlinkage long sys_accept(int fd, struc
                        goto out_fd;
        }
 
+       /* Filter connections from unwanted peers like TCP Wrapper. */
+       err = security_socket_post_accept(sock, newsock);
+       if (err)
+               goto out_fd;
+
        /* File flags are not inherited via accept() unlike another
        OSes. */
 
        fd_install(newfd, newfile);
        err = newfd;
 
-       security_socket_post_accept(sock, newsock);
-
 out_put:
        fput_light(sock->file, fput_needed);
 out:

[4] http://copilotconsulting.com/mail-archives/security-module.2002/msg00186.html
[5] http://www.netfilter.org/projects/libnetfilter_queue/index.html
