Return-Path: <linux-kernel-owner+w=401wt.eu-S1754007AbYKBTKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007AbYKBTKy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 14:10:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751982AbYKBTKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 14:10:47 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:42959 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbYKBTKq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 14:10:46 -0500
Message-ID: <490DFB2D.3090906@cosmosbay.com>
Date: Sun, 02 Nov 2008 20:10:37 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Olaf van der Spek <olafvdspek@gmail.com>
CC: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: epoll behaviour after running out of descriptors
References: <b2cc26e40811010938k3864c48j45ce55af09516302@mail.gmail.com>	 <Pine.LNX.4.64.0811021022120.9451@alien.or.mcafeemobile.com>	 <b2cc26e40811021033r115225e2x4747a17fc2b30256@mail.gmail.com>	 <Pine.LNX.4.64.0811021047300.9451@alien.or.mcafeemobile.com> <b2cc26e40811021051kc748db3x44231dc0c085a8d6@mail.gmail.com>
In-Reply-To: <b2cc26e40811021051kc748db3x44231dc0c085a8d6@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Sun, 02 Nov 2008 20:10:43 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Olaf van der Spek a écrit :
> On Sun, Nov 2, 2008 at 7:48 PM, Davide Libenzi <davidel@xmailserver.org> wrote:
>> Why don't you grep for TIME_WAIT?
> 
> Because I don't have access to the test environment at the moment.

Hello Olaf

If your application calls accept() and accept() returns EMFILE, its a nullop.

On listen queue, socket is still ready for an accept().


Since you use edge trigered epoll, you'll only reveive new notification.

You probably had in you app a : listen(sock, 10), so after 10 notifications,
your listen queue is full and TCP stack refuses to handle new connections.

In order to cope with this kind of thing the trick I personnally use is to always keep
around a *free* fd, that is :

At start of program, reserve an "emergency fd"
free_fd = open("/dev/null", O_RDONLY)

Then later :

newfd = accept(...)
if (newfd == -1 && errno == EMFILE) {
   /* emergency action : clean listen queue */
   close(free_fd);
   newfd = accept(...);
   close(newfd); /* forget this incoming connection, we dont have enough fd */
   free_fd = open("/dev/null"; O_RDONLY);
}

Of course, if your application is multi-threaded, you might adapt (and eventually reserve
one emergency fd per thread)


